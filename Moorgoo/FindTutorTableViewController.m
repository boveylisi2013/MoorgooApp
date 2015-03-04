//
//  FindTutorTableViewController.m
//  Moorgoo
//
//  Created by SI  on 3/2/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "FindTutorTableViewController.h"
#import "CollegeClassTutor.h"

@interface FindTutorTableViewController ()

@end

@implementation FindTutorTableViewController

@synthesize tutorSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tutorSource = [[NSMutableArray alloc] init];
    
    /**************************************************************************************/
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchAllCollegeClassTutors)
                  forControlEvents:UIControlEventValueChanged];
    /**************************************************************************************/
    
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    [self fetchAllCollegeClassTutors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**************************************************************************************/
- (void)fetchAllCollegeClassTutors {
    [tutorSource removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"CollegeClassTutor"];
    [query includeKey:@"userId"];
    [query includeKey:@"departmentId"];
    [query includeKey:@"schoolId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for (PFObject *object in objects) {
                PFUser *user = [object objectForKey:@"userId"];
                PFObject *department = [object objectForKey:@"departmentId"];
                PFObject *school = [object objectForKey:@"schoolId"];

                CollegeClassTutor *tutor = [[CollegeClassTutor alloc] init];
                tutor.firstName = [user objectForKey:@"firstName"];
                tutor.lastName = [user objectForKey:@"lastName"];
                tutor.userId = user.objectId;
                tutor.courses = [user objectForKey:@"courses"];
                tutor.availableDays = [user objectForKey:@"availableDays"];
                tutor.price = [object objectForKey:@"price"];
                tutor.department = [department objectForKey:@"department"];
                tutor.school = [school objectForKey:@"schoolName"];
                tutor.schoolAbbreviation = [object objectForKey:@"schoolAbbreviation"];
                tutor.goodRating = [object objectForKey:@"goodRating"];
                tutor.badRating = [object objectForKey:@"badRating"];
                [tutorSource addObject:tutor];
                
                [[user objectForKey:@"profilePicture"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    tutor.profileImage = [UIImage imageWithData:data];
                    [self.tableView reloadData];
                    [self.hud hide:YES];
                    [self.refreshControl endRefreshing];
                }];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}
/**************************************************************************************/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [tutorSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"tutorItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //set border
    //[cell.contentView.layer setBorderWidth:2.0f];
    //[cell.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
    
    //profile image
    UIImageView *profileImageView = (UIImageView *)[cell.contentView viewWithTag:100];
    profileImageView.layer.cornerRadius = 20.0f;
    profileImageView.clipsToBounds = YES;
    profileImageView.image = ((CollegeClassTutor *)[tutorSource objectAtIndex:indexPath.row]).profileImage;
    
    //full name
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:200];
    NSMutableString *fullName = [NSMutableString new];
    [fullName appendString:((CollegeClassTutor *)[tutorSource objectAtIndex:indexPath.row]).firstName];
    [fullName appendString:@" "];
    [fullName appendString:((CollegeClassTutor *)[tutorSource objectAtIndex:indexPath.row]).lastName];
    nameLabel.text = fullName;
    
    //school + department
    UILabel *departmentLabel = (UILabel *)[cell.contentView viewWithTag:300];
    NSMutableString *department = [NSMutableString new];
    [department appendString:((CollegeClassTutor *)[tutorSource objectAtIndex:indexPath.row]).schoolAbbreviation];
    [department appendString:@" "];
    [department appendString:((CollegeClassTutor *)[tutorSource objectAtIndex:indexPath.row]).department];
    departmentLabel.text = department;
    
    //price
    UILabel *priceLabel = (UILabel *)[cell.contentView viewWithTag:400];
    NSMutableString *price = [NSMutableString new];
    [price appendString:@"$"];
    [price appendString:((CollegeClassTutor *)[tutorSource objectAtIndex:indexPath.row]).price];
    [price appendString:@" per hour"];
    priceLabel.text = price;

    //rating
    UILabel *goodLabel = (UILabel *)[cell.contentView viewWithTag:500];
    NSMutableString *goodrating = [NSMutableString new];
    [goodrating appendString:((CollegeClassTutor *)[tutorSource objectAtIndex:indexPath.row]).goodRating];
    goodLabel.text = goodrating;
    
    UILabel *badLabel = (UILabel *)[cell.contentView viewWithTag:600];
    NSMutableString *badrating = [NSMutableString new];
    [badrating appendString:((CollegeClassTutor *)[tutorSource objectAtIndex:indexPath.row]).badRating];
    badLabel.text = badrating;
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)filterButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"goToFilterView" sender:self];
}

@end
