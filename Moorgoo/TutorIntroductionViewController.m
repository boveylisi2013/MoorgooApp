//
//  TutorIntroductionViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 4/15/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "TutorIntroductionViewController.h"

@interface TutorIntroductionViewController ()
{
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    UILabel *headLabel;
    UILabel *onepressLabel;
    UILabel *instructionLabel1;
    UILabel *instructionLabel2;
    UILabel *instructionLabel3;
    
    UIButton *applyButton;
}

@end

@implementation TutorIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get the current screen height and size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    headLabel = [[UILabel alloc] init];
    onepressLabel = [[UILabel alloc] init];
    instructionLabel1 = [[UILabel alloc] init];
    instructionLabel2 = [[UILabel alloc] init];
    instructionLabel3 = [[UILabel alloc] init];
    applyButton = [[UIButton alloc] init];
    
    [self.view addSubview:headLabel];
    [self.view addSubview:onepressLabel];
    [self.view addSubview:instructionLabel1];
    [self.view addSubview:instructionLabel2];
    [self.view addSubview:instructionLabel3];
    [self.view addSubview:applyButton];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:120.0/255.0 blue:180.0 alpha:1];
    
    [headLabel setText:@"Become a Moorgoo Tutor"];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [self centerSubview:headLabel withX:60 Y:screenHeight/6 height:30];
    headLabel.textColor = [UIColor whiteColor];
    headLabel.font = [headLabel.font fontWithSize:25];
    headLabel.adjustsFontSizeToFitWidth = YES;
    headLabel.minimumScaleFactor = 0.5;
    
    [onepressLabel setText:@"with ONE Press"];
    onepressLabel.textAlignment = NSTextAlignmentCenter;
    [self centerSubview:onepressLabel withX:100 Y:screenHeight/6 + 35 height:30];
    onepressLabel.textColor = [UIColor whiteColor];
    onepressLabel.font = [onepressLabel.font fontWithSize:25];
    onepressLabel.adjustsFontSizeToFitWidth = YES;
    onepressLabel.minimumScaleFactor = 0.5;
    
    
    [instructionLabel1 setText:@"Press the button below to send your request."];
    instructionLabel1.textAlignment = NSTextAlignmentCenter;
    [self centerSubview:instructionLabel1 withX:10 Y:screenHeight/2.5 height:20];
    instructionLabel1.textColor = [UIColor whiteColor];
    instructionLabel1.font = [instructionLabel1.font fontWithSize:15];
    instructionLabel1.adjustsFontSizeToFitWidth = YES;
    instructionLabel1.minimumScaleFactor = 0.5;
    
    [instructionLabel2 setText:@"You will receive an email within 24 hours with"];
    instructionLabel2.textAlignment = NSTextAlignmentCenter;
    [self centerSubview:instructionLabel2 withX:10 Y:screenHeight/2.5 + 25 height:20];
    instructionLabel2.textColor = [UIColor whiteColor];
    instructionLabel2.font = [instructionLabel2.font fontWithSize:15];
    instructionLabel2.adjustsFontSizeToFitWidth = YES;
    instructionLabel2.minimumScaleFactor = 0.5;
    
    [instructionLabel3 setText:@"further information about the application process."];
    instructionLabel3.textAlignment = NSTextAlignmentCenter;
    [self centerSubview:instructionLabel3 withX:10 Y:screenHeight/2.5 + 50 height:20];
    instructionLabel3.textColor = [UIColor whiteColor];
    instructionLabel3.font = [instructionLabel3.font fontWithSize:15];
    instructionLabel3.adjustsFontSizeToFitWidth = YES;
    instructionLabel3.minimumScaleFactor = 0.5;
    
    
    [applyButton setTitle:@"APPLY" forState:UIControlStateNormal];
    [self centerSubview:applyButton withX:110 Y:(screenHeight/6) * 4 height:40];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[applyButton layer] setBorderWidth:1.0f];
    [[applyButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [applyButton addTarget:self action:@selector(applyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    
}

-(void)applyButtonPressed
{
    [self.hud show:YES];
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"applied"];

    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error)
        {
            [self.hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!"
                                                            message:@"We will get in touch with you soon!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        else
        {
            [self.hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please check your network setting and try again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
    
}


-(void)centerSubview:(UIView *)subView withX:(CGFloat)xCoordinate Y:(CGFloat)yCoordinate height:(CGFloat)height
{
    CGFloat width = screenWidth - 2*xCoordinate;
    subView.frame = CGRectMake(xCoordinate,yCoordinate,width,height);
}


@end
