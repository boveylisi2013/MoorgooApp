//
//  FindTutorTableViewController.h
//  Moorgoo
//
//  Created by SI  on 3/2/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindTutorTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *tutorSource;

- (IBAction)filterButtonClicked:(id)sender;

@end
