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
        [self.userTextField resignFirstResponder];
    }
    else if (textField == self.userTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}

@end
