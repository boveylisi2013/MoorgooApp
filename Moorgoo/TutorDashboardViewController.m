//
//  TutorDashboardViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 4/15/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "TutorDashboardViewController.h"

@interface TutorDashboardViewController ()
{
    UIScrollView *scrollView;
    
    UILabel *chooseClassLabel;
}
@end

@implementation TutorDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the current screen height and size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [self allocInitAllSubviews];
    
    // Set up the scrollView
    scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight + 500);
    [self.view addSubview:scrollView];
    
    chooseClassLabel.frame = CGRectMake(10,40,300,100);
    [chooseClassLabel setText:@"Chose the class that you want to teach"];
    [chooseClassLabel setTextColor:[UIColor blackColor]];
    [scrollView addSubview:chooseClassLabel];
    
}

#pragma mark - layout encapsulation method
/************************************************************************************************/

-(void)allocInitAllSubviews
{
    // ScrollView
    scrollView = [[UIScrollView alloc] init];
    
    // Label
    chooseClassLabel = [[UILabel alloc] init];
}

-(void)addAllSubviews
{
    // ScrollView
    
}

@end
