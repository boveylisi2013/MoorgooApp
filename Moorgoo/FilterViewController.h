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

@interface FilterViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>{
    id<FilterViewControllerDelegate> delegate;
}

@property (atomic, strong) SearchFilter *filter;
@property NSMutableArray *tutorArray;
@property id<FilterViewControllerDelegate> delegate;

@end
