//
//  AccountSettingViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 3/23/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "ChangeProfilePictureViewController.h"

@interface AccountSettingViewController ()
{
    UIImage *profileImage;
}
@end


@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchCurentUserInformation];
    
    //hide empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)fetchCurentUserInformation
{
    PFUser *currentUser = [PFUser currentUser];
    
    PFFile *imageFile = [currentUser objectForKey:@"profilePicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            profileImage = [UIImage imageWithData:data];
            NSLog(@"profileImage: %@",profileImage);
        }
        else{
            // Handle Error, don't forget!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            NSLog(@"error when loading image!!!!!");
        }
    }];
    
}

#pragma mark - Table view datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = @"Change profile picture";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else if(indexPath.section == 1) {
        cell.textLabel.text = @"Something else";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Do not let the cell stay selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        [self performSegueWithIdentifier:@"goToChangeProfilePicture" sender:self];
    }
    
}

#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToChangeProfilePicture"])
    {
        ChangeProfilePictureViewController *controller = (ChangeProfilePictureViewController *)segue.destinationViewController;
        controller.profileImage = profileImage;
    }
}

//- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}

@end
