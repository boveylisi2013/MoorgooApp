//
//  RegisterViewController.m
//  Moorgoo
//
//  Created by SI  on 12/26/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>
{
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.firstRegisterTextField.delegate = self;
    self.lastRegisterTextField.delegate = self;
    self.emailRegisterTextField.delegate = self;
    self.passwordRegisterTextField.delegate = self;
    self.phoneRegisterTextField.delegate = self;
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

-(IBAction)signUpUserPressed:(id)sender
{
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
        errorString = [errorString stringByAppendingString:@"Password has to be at least 4 digits long"];
    }
    
    PFUser *user = [PFUser user];
    [user setObject:self.firstRegisterTextField.text forKey:@"firstName"];
    [user setObject:self.lastRegisterTextField.text forKey:@"lastName"];
    user.email = self.emailRegisterTextField.text;
    user.username = self.emailRegisterTextField.text;  //use email as login username
    user.password = self.passwordRegisterTextField.text;
    [user setObject:self.phoneRegisterTextField.text forKey:@"phone"];
    [user setObject: [NSNumber numberWithBool:NO] forKey:@"isTutor"];
    
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
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];

}
@end
