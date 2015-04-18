//
//  ViewController.m
//  Moorgoo
//
//  Created by SI  on 12/25/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginbutton;

@end

@implementation LoginViewController
@synthesize emailResetTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    /************************************************************************************/
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"TutorBackground"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor *color = [[UIColor colorWithPatternImage:image] colorWithAlphaComponent:0.5f];
    self.view.backgroundColor = color;
    /************************************************************************************/
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    /************************************************************************************/
    [self.userTextField becomeFirstResponder];
    
    self.loginbutton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.loginbutton.layer.borderWidth = 2.0f;
    [self.view addSubview:self.loginbutton];
    
    self.userTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

-(IBAction)logInPressed:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            /************************************************************************/
            KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainTest" accessGroup:nil];
            [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            [keychain setObject:self.userTextField.text forKey:(__bridge id)(kSecAttrAccount)];
            [keychain setObject:self.passwordTextField.text forKey:(__bridge id)(kSecValueData)];
            /************************************************************************/

            [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (IBAction)backButtonClosed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordTextField)
    {
        [self.userTextField becomeFirstResponder];
    }
    else if (textField == self.userTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}


- (IBAction)forgetButtonClicked:(id)sender {
    
    self.IOS7AlertView = [[CustomIOS7AlertView alloc] init];
    UIView *basicView = [[UIView alloc] init];
    basicView.frame = CGRectMake(0, 0, 300, 100);
    
    emailResetTextField = [[UITextField alloc] init];
    emailResetTextField.frame = CGRectMake(10, 40, basicView.frame.size.width - 20, 45);
    emailResetTextField.placeholder = @"Input your email address";
    emailResetTextField.backgroundColor = [UIColor whiteColor];
    emailResetTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [basicView addSubview:emailResetTextField];
    
    [self.IOS7AlertView setContainerView:basicView];
    [self.IOS7AlertView setDelegate:self];
    [self.IOS7AlertView setButtonTitles:@[@"Cancel", @"Reset"]];
    [self.IOS7AlertView show];
}

#pragma mark - <customerAlertViewDelegate>
- (void)customIOS7dialogButtonTouchUpInside:(CustomIOS7AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.IOS7AlertView close];
    
    if(buttonIndex == 1) {
        [PFUser requestPasswordResetForEmailInBackground:emailResetTextField.text];
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"An password reset link has been sent to your email address."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
