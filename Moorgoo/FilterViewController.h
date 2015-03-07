//
//  FilterViewController.h
//  Moorgoo
//
//  Created by SI  on 3/3/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property SearchFilter *filter;
@property NSMutableArray *tutorArray;

@end
