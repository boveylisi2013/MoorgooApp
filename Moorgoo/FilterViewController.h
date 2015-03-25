//
//  FilterViewController.h
//  Moorgoo
//
//  Created by SI  on 3/3/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate <NSObject>
@required
- (void)applyFilterToFetchTutors:(SearchFilter *)filter;

@end

@interface FilterViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>{
    id<FilterViewControllerDelegate> delegate;
}

@property (atomic, strong) SearchFilter *filter;
@property NSMutableArray *tutorArray;
@property id<FilterViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *courseTableView;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *perhourVerticalSpaceLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxpriceVerticalSpaceLayout;

@end
