//
//  RegisterViewController.m
//  Moorgoo
//
//  Created by SI  on 12/26/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UIAlertViewDelegate>
{
    NSData *imageData;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /************************************************************************************/
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"TutorBackground"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor *color = [[UIColor colorWithPatternImage:image] colorWithAlphaComponent:0.4f];
    self.view.backgroundColor = color;
    
    /************************************************************************************/
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    /************************************************************************************/
    self.firstRegisterTextField.delegate = self;
    self.lastRegisterTextField.delegate = self;
    self.emailRegisterTextField.delegate = self;
    self.passwordRegisterTextField.delegate = self;
    self.phoneRegisterTextField.delegate = self;
    
    /************************************************************************************/
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
}

// When hit return key, go to "next line" --- next textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstRegisterTextField)
    {
        [self.lastRegisterTextField becomeFirstResponder];
    }
    else if (textField == self.lastRegisterTextField)
    {
        [self.emailRegisterTextField becomeFirstResponder];
    }
    else if (textField == self.emailRegisterTextField)
    {
        [self.passwordRegisterTextField becomeFirstResponder];
    }
    else if (textField == self.passwordRegisterTextField)
    {
        [self.phoneRegisterTextField becomeFirstResponder];
    }
    
    return YES;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"backToEntranceView" sender:nil];
}

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    // The string contains all possible errors
    NSString *errorString = @"";
    
    if (self.firstRegisterTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input your first name\n"];
    }
    if (self.lastRegisterTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input your last name\n"];
    }
    if (self.phoneRegisterTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input your phone number\n"];
    }
    if (self.passwordRegisterTextField.text.length < 4){
        errorString = [errorString stringByAppendingString:@"Password has to be at least 4 digits long\n"];
    }
    if (imageData == nil){
        errorString = [errorString stringByAppendingString:@"Please choose your profile picture"];
    }
    
    PFUser *user = [PFUser user];
    [user setObject:self.firstRegisterTextField.text forKey:@"firstName"];
    [user setObject:self.lastRegisterTextField.text forKey:@"lastName"];
    user.email = self.emailRegisterTextField.text;
    user.username = self.emailRegisterTextField.text;  //use email as login username
    user.password = self.passwordRegisterTextField.text;
    [user setObject:self.phoneRegisterTextField.text forKey:@"phone"];
    
    // Check whether the user inputs their information correctly or not
    if ([errorString length] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.hud show:YES];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            /************************************************************************/
            PFFile *imageFile = [PFFile fileWithName:@"Profileimage.png" data:imageData];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    PFUser *user = [PFUser currentUser];
                    user[@"profilePicture"] = imageFile;
                    
                    [user saveInBackground];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                    message:@"You have signed up successfully"
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
            
            /************************************************************************/
            KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainTest" accessGroup:nil];
            [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            [keychain setObject:self.emailRegisterTextField.text forKey:(__bridge id)(kSecAttrAccount)];
            [keychain setObject:self.passwordRegisterTextField.text forKey:(__bridge id)(kSecValueData)];
            /************************************************************************/
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            [self.hud hide:YES];
            
        }
    }];
}


- (IBAction)pickImageButtonClicked:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma uiimagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    image = [self imageWithImage:image scaledToSize:CGSizeMake(200, 200)];
    imageData = UIImagePNGRepresentation(image);
    [picker dismissViewControllerAnimated:YES completion:^{
        self.profileImageView.image = image;
        [self.pickImageButton setTitle:@"Change Picture" forState:UIControlStateNormal];
    }];
}

#pragma alertViewClicked Response
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
    }
    
}

@end
