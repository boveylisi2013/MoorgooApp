//
//  FindTutorTableViewController.m
//  Moorgoo
//
//  Created by SI  on 3/2/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "FindTutorTableViewController.h"

@interface FindTutorTableViewController ()
- (void)networkChanged2:(NSNotification *)notification;

@end

@implementation FindTutorTableViewController

@synthesize tutorSource, searchFilter;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.hud show:YES];
    
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
    /**************************************************************************************/
    searchFilter = [[SearchFilter alloc] init];
    searchFilter.collegeClassTutorSchool = @"";
    searchFilter.collegeClassTutorCourse = @"";
    searchFilter.collegeClassTutorPrice = @"";
    
    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    /**************************************************************************************/
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged2:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    /**************************************************************************************/
    tutorSource = [[NSMutableArray alloc] init];
    Reachability *reachability2 = [Reachability reachabilityForInternetConnection];
    [reachability2 startNotifier];
    
    if([reachability2 currentReachabilityStatus] != NotReachable){
        KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainTest" accessGroup:nil];
        [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
        NSString *username = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
        NSString *password = [keychain objectForKey:(__bridge id)(kSecValueData)];
        keychain = nil;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (user) {
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
        
        /**************************************************************************************/
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(fetchAllCollegeClassTutors) userInfo:nil repeats:NO];
        /**************************************************************************************/
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchAllCollegeClassTutors];
}
/**************************************************************************************/
- (void)fetchAllCollegeClassTutors{
    //searchFilter = [[SearchFilter alloc] init];
    
    [self.hud show:YES];
    
    [tutorSource removeAllObjects];
    
    /**************************************************************************************/
    for (CollegeClassTutor *tutor in allTutorFromParse) {
        if(([searchFilter.collegeClassTutorSchool isEqual: @""] || [searchFilter.collegeClassTutorSchool isEqualToString:tutor.school])
           && ([searchFilter.collegeClassTutorCourse isEqual: @""] || [tutor.courses containsObject:searchFilter.collegeClassTutorCourse])
           && ([searchFilter.collegeClassTutorPrice isEqual: @""] || [tutor.price intValue] <= [searchFilter.collegeClassTutorPrice intValue])){
            [tutorSource addObject:tutor];
        }
    }
    
    [self.tableView reloadData];
    
    [self.hud hide:YES afterDelay:2.0f];
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToFilterView"]){
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        FilterViewController *dest = (FilterViewController *)navController.topViewController;
        dest.filter = searchFilter;
        dest.tutorArray = allTutorFromParse;
        dest.delegate = self;
    }
}


- (IBAction)filterButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"goToFilterView" sender:nil];
}

- (void)networkChanged2:(NSNotification *)notification{
    
    Reachability * reachability = [notification object];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus != NotReachable)
    {
        if([PFUser currentUser] == nil) {
            KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainTest" accessGroup:nil];
            [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            NSString *username = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
            NSString *password = [keychain objectForKey:(__bridge id)(kSecValueData)];
            keychain = nil;
            
            [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
                if (user) {
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedFailureReason] delegate:nil    cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }];
        }
        
        if([tutorSource count] == 0) {
            [self fetchAllCollegeClassTutors];
        }
    }
}

#pragma filterViewProtocol
- (void)applyFilterToFetchTutors:(SearchFilter *)filter{
    self.searchFilter = filter;
    
    NSLog(@"protocol works");
    NSLog(@"%@", searchFilter.collegeClassTutorSchool);
    NSLog(@"%@", searchFilter.collegeClassTutorCourse);
    NSLog(@"%@", searchFilter.collegeClassTutorPrice);
    [self fetchAllCollegeClassTutors];
}

@end
