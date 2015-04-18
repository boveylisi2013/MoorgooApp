//
//  StudentPostTableViewController.h
//  Moorgoo
//
//  Created by SI  on 4/18/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"

@interface StudentPostTableViewController : UITableViewController<CustomIOS7AlertViewDelegate>


@property NSMutableArray *postSource;

@property (nonatomic, strong) MBProgressHUD *hud;
@property CustomIOS7AlertView *IOS7AlertView;
@property BOOL isTutor;

@end
