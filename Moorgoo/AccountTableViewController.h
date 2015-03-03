//
//  AccountTableViewController.h
//  Moorgoo
//
//  Created by SI  on 3/2/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *tableData;

@end
