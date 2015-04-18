//
//  ViewController.h
//  Moorgoo
//
//  Created by SI  on 12/25/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "CustomIOS7AlertView.h"

@interface LoginViewController : UIViewController<CustomIOS7AlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *userTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property CustomIOS7AlertView *IOS7AlertView;
@property UITextField *emailResetTextField;

-(IBAction)logInPressed:(id)sender;

@end

