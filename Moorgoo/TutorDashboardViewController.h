//
//  TutorDashboardViewController.h
//  Moorgoo
//
//  Created by Xueyang Li on 4/15/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorDashboardViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;

@end
