//
//  ChangeProfilePictureViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 3/23/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "ChangeProfilePictureViewController.h"

@interface ChangeProfilePictureViewController ()
{
    NSData *imageData;

}
@end

@implementation ChangeProfilePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.profileImageView.image = self.profileImage;
    
    /************************************************************************************/
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
}

- (IBAction)pickImageButtonPressed:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)submitButtonPressed:(UIButton *)sender
{
    [self.hud show:NO];
    PFFile *imageFile = [PFFile fileWithName:@"Profileimage.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFUser *user = [PFUser currentUser];
            user[@"profilePicture"] = imageFile;
                
            [user saveInBackground];
                
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"You have changed your profile picture successfully!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
                
            [self.hud hide:YES];
                
            } else {
                // Handle error
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
                [self.hud hide:YES];
            }
        }];
    
}



// Helper method to scale the image
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - uiimagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    image = [self imageWithImage:image scaledToSize:CGSizeMake(200, 200)];
    imageData = UIImagePNGRepresentation(image);
    [picker dismissViewControllerAnimated:YES completion:^{
        self.profileImageView.image = image;
    }];
}





@end
