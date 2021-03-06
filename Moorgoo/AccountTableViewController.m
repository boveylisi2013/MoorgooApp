//
//  AccountTableViewController.m
//  Moorgoo
//
//  Created by SI  on 3/2/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "AccountTableViewController.h"
#import "ChangeProfilePictureViewController.h"
#import "ChangePhoneNumberViewController.h"


@interface AccountTableViewController () <UIAlertViewDelegate>
{
    UIImage *profileImage;
    NSString *phoneNumber;
}
@end

@implementation AccountTableViewController

@synthesize tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableData = [[NSMutableArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",@"Five",nil];

    //hide empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /************************************************************************************/
    [self fetchCurentUserInformation];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchCurentUserInformation];
}

-(void)fetchCurentUserInformation
{
    PFUser *currentUser = [PFUser currentUser];
    
    phoneNumber = [currentUser objectForKey:@"phone"];
    
    PFFile *imageFile = [currentUser objectForKey:@"profilePicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            profileImage = [UIImage imageWithData:data];
        }
        else{
            // Handle Error, don't forget!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            NSLog(@"error when loading image!!!!!");
        }
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(section == 0) return 3;
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) return 0;
    else return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Change Profile Picture";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = @"Change Phone Number";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            cell.textLabel.text = @"Change Password";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if(indexPath.section == 1) {
        cell.textLabel.text = @"Empty All of my Student Posts";
        [cell setBackgroundColor:[UIColor colorWithRed:135.0/255.0
                                                 green:206.0/255.0
                                                  blue:250.0/255.0
                                                 alpha:1]];
        [cell setTintColor:[UIColor whiteColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    else if(indexPath.section == 2) {
        PFObject *userPointer = [PFObject objectWithoutDataWithClassName:@"_User" objectId:([PFUser currentUser]).objectId];
        PFQuery *query = [PFQuery queryWithClassName:@"CollegeClassTutor"];
        [query whereKey:@"userId" equalTo:userPointer];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error)
            {
                // If curent user is tutor
                if([objects count] == 1)
                    cell.textLabel.text = @"Tutor DashBoard";
                // If current user is not tutor
                else
                    cell.textLabel.text = @"Apply to be a Moorgoo Tutor";
            }
        }];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section == 3){
        cell.textLabel.text = @"Log Out";
        [cell setBackgroundColor:[UIColor redColor]];
        [cell setTintColor:[UIColor whiteColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Do not let the cell stay selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"goToChangeProfilePicture" sender:self];
        }
        else if(indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"goToChangePhoneNumber" sender:self];
        }
        else if(indexPath.row == 2)
        {
            [self performSegueWithIdentifier:@"goToChangePassword" sender:self];
        }
    }
    else if(indexPath.section == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Halo"
                                                        message:@"Do you want to delete all of your help posts?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];

    }
    else if(indexPath.section == 2)
    {
        PFObject *userPointer = [PFObject objectWithoutDataWithClassName:@"_User" objectId:([PFUser currentUser]).objectId];
        PFQuery *query = [PFQuery queryWithClassName:@"CollegeClassTutor"];
        [query whereKey:@"userId" equalTo:userPointer];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error)
            {
                // If curent user is tutor
                if([objects count] == 1)
                    [self performSegueWithIdentifier:@"goToTutorDashboard" sender:self];
                // If current user is not tutor
                else
                    [self performSegueWithIdentifier:@"goToTutorIntroduction" sender:self];
            }
        }];
    }
    else if(indexPath.section == 3)
    {
        // Logout confirmation
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dear"
                                                        message:@"Do you want to logout?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

# pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if([alertView.title isEqualToString:@"Dear"]) {
        
        if(buttonIndex == 1) {
            [PFUser logOut];
        
            /******************************************************/
            KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainTest" accessGroup:nil];
            [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked)
                         forKey:(__bridge id)(kSecAttrAccessible)];
            [keychain resetKeychainItem];
            /******************************************************/
        
            [self performSegueWithIdentifier:@"LogoutSuccessful" sender:self];
        }
    }
    else if([alertView.title isEqualToString:@"Halo"]) {
        if(buttonIndex == 1) {
            PFObject *userPointer = [PFObject objectWithoutDataWithClassName:@"_User"
                                                                    objectId:([PFUser currentUser]).objectId];
            PFQuery *query = [PFQuery queryWithClassName:@"StudentPost"];
            [query whereKey:@"userId" equalTo:userPointer];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error) {
                    for(PFObject *object in objects) {
                        [object deleteInBackground];
                    }
                }
                else {
                    
                }
                
                [[[UIAlertView alloc] initWithTitle:nil message:@"Your posts have been deleted" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil] show];
            }];
        }
    }
}

#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToChangeProfilePicture"])
    {
        ChangeProfilePictureViewController *controller = (ChangeProfilePictureViewController *)segue.destinationViewController;
        controller.profileImage = profileImage;
    }
    else if([segue.identifier isEqualToString:@"goToChangePhoneNumber"])
    {
        ChangePhoneNumberViewController *controller = (ChangePhoneNumberViewController *)segue.destinationViewController;
        controller.phoneNumber = phoneNumber;
    }
}
@end
