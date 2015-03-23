//
//  ChangePhoneNumberViewController.h
//  Moorgoo
//
//  Created by Xueyang Li on 3/23/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePhoneNumberViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (strong,nonatomic) NSString *phoneNumber;

@property (nonatomic, strong) MBProgressHUD *hud;

@end
