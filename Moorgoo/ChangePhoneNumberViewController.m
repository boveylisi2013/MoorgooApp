//
//  ChangePhoneNumberViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 3/23/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "ChangePhoneNumberViewController.h"

@interface ChangePhoneNumberViewController ()

@end

@implementation ChangePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.phoneNumberTextField.text = self.phoneNumber;

    /************************************************************************************/
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
}

- (IBAction)changeNumberTextField:(UIButton *)sender {
    if(self.phoneNumberTextField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Phone Number Field is blank!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:self.phoneNumberTextField.text forKey:@"phone"];
    
    [self.hud show:YES];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(!error){
            [self.hud hide:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"You have changed your phone number successfully!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    


}

@end
