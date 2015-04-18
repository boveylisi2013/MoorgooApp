//
//  NewPostViewController.h
//  Moorgoo
//
//  Created by Xueyang Li on 3/29/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPostViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
extern NSMutableArray *allCourseFromParse;


@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerYAlignment;
@property (weak, nonatomic) IBOutlet UIButton *dateSelectButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpTypeVerticalLayout;

@property (weak, nonatomic) IBOutlet UITextField *courseTextField;
@property (weak, nonatomic) IBOutlet UITextField *helptypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *hourTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel2;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel3;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel4;

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *perhourLabel;

@property (weak, nonatomic) IBOutlet UIButton *addADateButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton1;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton2;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton3;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton4;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) MBProgressHUD *hud;

@end
