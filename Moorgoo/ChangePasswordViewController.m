//
//  ChangePasswordViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 3/23/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController () <UITextFieldDelegate>

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    /************************************************************************************/
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];

    /************************************************************************************/    
    self.changedPasswordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
}

-(void)dismissKeyboard {
    [self.changedPasswordTextField endEditing:YES];
    [self.confirmPasswordTextField endEditing:YES];
}

- (IBAction)submitButtonPressed:(UIButton *)sender {
    if(self.changedPasswordTextField.text.length == 0 ||
       self.confirmPasswordTextField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Field should be blank!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if(![self.changedPasswordTextField.text isEqualToString:self.confirmPasswordTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"new password is different from the confirmed password, please make sure they are the same"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser.password = self.confirmPasswordTextField.text;
    
    [self.hud show:YES];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(!error){
            [self.hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"You have successfully reset your password"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else{
            // Handle error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.changedPasswordTextField)
    {
        [self.confirmPasswordTextField becomeFirstResponder];
    }
    else if (textField == self.confirmPasswordTextField)
    {
        [self.changedPasswordTextField becomeFirstResponder];
    }
    return YES;
}

@end
