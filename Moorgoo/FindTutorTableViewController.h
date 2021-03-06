//
//  FindTutorTableViewController.h
//  Moorgoo
//
//  Created by SI  on 3/2/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"
#import "tutorDetailTableViewController.h"

@interface FindTutorTableViewController : UITableViewController<FilterViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
}
extern NSMutableArray *allTutorFromParse;

@property NSMutableArray *tutorSource;
@property (nonatomic, strong) SearchFilter *searchFilter;
@property (nonatomic, strong) MBProgressHUD *hud;

- (IBAction)filterButtonClicked:(id)sender;

@end
