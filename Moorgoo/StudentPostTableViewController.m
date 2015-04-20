//
//  StudentPostTableViewController.m
//  Moorgoo
//
//  Created by SI  on 4/18/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "StudentPostTableViewController.h"

@interface StudentPostTableViewController ()

@end

@implementation StudentPostTableViewController
@synthesize hud, postSource, isTutor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    postSource = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"Student Posts";
    
    hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    
    [self fetchStudentPostings];
    
    
    PFObject *userPointer = [PFObject objectWithoutDataWithClassName:@"_User" objectId:([PFUser currentUser]).objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"CollegeClassTutor"];
    [query whereKey:@"userId" equalTo:userPointer];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            // If curent user is tutor
            if([objects count] == 1)
                isTutor = TRUE;
            // If current user is not tutor
            else
                isTutor = FALSE;
        }
    }];
    
    NSLog(@"in student post viewdid load");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchStudentPostings {
    [postSource removeAllObjects];
    [hud show:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"StudentPost"];
    [query setLimit:1000];
    [query includeKey:@"userId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            [postSource addObjectsFromArray:objects];
        }
        
        [self.tableView reloadData];
        [hud hide:true];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [postSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *course = [[postSource objectAtIndex:indexPath.section] objectForKey:@"course"];
    NSString *typeOfHelp = [[postSource objectAtIndex:indexPath.section] objectForKey:@"typeOfHelp"];
    NSString *numOfHours = [[postSource objectAtIndex:indexPath.section] objectForKey:@"numOfHour"];
    NSString *ratePerHours = [[postSource objectAtIndex:indexPath.section] objectForKey:@"ratePerHour"];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"postReuse"];

    
    if(indexPath.row == 0) {
        cell.textLabel.text = course;
        cell.detailTextLabel.text = @"Course";
        cell.imageView.image = [UIImage imageNamed:@"Course"];
        
    }
    else if(indexPath.row == 1) {
        cell.textLabel.text = typeOfHelp;
        cell.detailTextLabel.text = @"Type of Help";
        cell.imageView.image = [UIImage imageNamed:@"TypeOfHelp"];

    }
    else if(indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ h", numOfHours];
        cell.detailTextLabel.text = @"Number of Hours";
        cell.imageView.image = [UIImage imageNamed:@"NumberOfHour"];

    }
    else if(indexPath.row == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"$%@", ratePerHours];;
        cell.detailTextLabel.text = @"Rate per Hour";
        cell.imageView.image = [UIImage imageNamed:@"RatePerHour"];

    }
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30);
    header.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = header.frame = CGRectMake(10, 0, [[UIScreen mainScreen] bounds].size.width, 30);
    label.text = [NSString stringWithFormat:@"%@%ld", @"Post #", 1 + (long)section];
    label.textColor = [UIColor whiteColor];
    [header addSubview:label];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(isTutor) {
        self.IOS7AlertView = [[CustomIOS7AlertView alloc] init];
        UIView *basicView = [[UIView alloc] init];
        basicView.frame = CGRectMake(0, 0, 300, 300);
        
        UITextView *detailTextView = [[UITextView alloc] init];
        detailTextView.frame = CGRectMake(5, 5, 290, 290);
        
        NSMutableString *string = [[NSMutableString alloc] init];
        PFUser *user = [postSource[indexPath.section] objectForKey:@"userId"];
        [string appendString:[NSString stringWithFormat:@"Post #%ld\n\nPhone: %@\nEmail: %@\n\nPreferred Tutoring Time:", (long)indexPath.section+1,[user objectForKey:@"phone"], [user objectForKey:@"email"]]];
        
        for(NSString *date in [postSource[indexPath.section] objectForKey:@"datePicked"]) {
            [string appendString:[NSString stringWithFormat:@"%@\n", date]];
        }
        detailTextView.text = string;
        detailTextView.font = [UIFont boldSystemFontOfSize:18];
        
        [basicView addSubview:detailTextView];
        
        [self.IOS7AlertView setContainerView:basicView];
        [self.IOS7AlertView setDelegate:self];
        [self.IOS7AlertView setButtonTitles:@[@"Okay"]];
        [self.IOS7AlertView show];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Only Moorgoo Tutor can view student's post in details. Please Apply" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil] show];
    }
}
- (void)customIOS7dialogButtonTouchUpInside:(CustomIOS7AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.IOS7AlertView close];
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

- (IBAction)refreshButtonClicked:(id)sender {
    [self fetchStudentPostings];
    
}

@end
