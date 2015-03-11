//
//  FindTutorTableViewController.h
//  Moorgoo
//
//  Created by SI  on 3/2/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

@interface FindTutorTableViewController : UITableViewController<FilterViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
}

@property NSMutableArray *tutorSource;
@property SearchFilter *searchFilter;
@property (nonatomic, strong)UIRefreshControl *refreshControl;
@property (nonatomic, strong) MBProgressHUD *hud;

- (IBAction)filterButtonClicked:(id)sender;

@end
