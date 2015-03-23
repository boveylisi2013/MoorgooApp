//
//  TestTextFieldViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 3/21/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "TestTextFieldViewController.h"
#define kOFFSET_FOR_KEYBOARD 160.0

@interface TestTextFieldViewController () <UITextFieldDelegate>
{
    BOOL finishInput;
}
@end

@implementation TestTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.phoneTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.firstNameTextField endEditing:YES];
    [self.lastNameTextField endEditing:YES];
    [self.emailTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
    [self.phoneTextField endEditing:YES];
    
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.4];
    
    self.view.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:1.0f];
    self.profileImage.alpha = 1.0f;
    self.pickImageButton.alpha = 1.0f;
    self.signUpButton.alpha = 1.0f;
    self.closeButton.alpha = 1.0f;
 
    [UIView commitAnimations];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.4];
    
    if (up)
    {
        self.verticalSpaceLayout.constant += kOFFSET_FOR_KEYBOARD;
        
        [self.firstNameTextField layoutIfNeeded];
        [self.lastNameTextField layoutIfNeeded];
        [self.emailTextField layoutIfNeeded];
        [self.passwordTextField layoutIfNeeded];
        [self.phoneTextField layoutIfNeeded];
        
        self.view.backgroundColor = [UIColor colorWithRed:10.0f green:10.0f blue:10.0f alpha:0.3f];
        self.profileImage.alpha = 0.3f;
        self.pickImageButton.alpha = 0.3f;
        self.signUpButton.alpha = 0.3f;
        self.closeButton.alpha = 0.3f;
    }
    else
    {
        // revert back to the normal state.
        self.verticalSpaceLayout.constant -= kOFFSET_FOR_KEYBOARD;
        
        [self.firstNameTextField layoutIfNeeded];
        [self.lastNameTextField layoutIfNeeded];
        [self.emailTextField layoutIfNeeded];
        [self.passwordTextField layoutIfNeeded];
        [self.phoneTextField layoutIfNeeded];
    
    }
    
    [UIView commitAnimations];
}



@end
