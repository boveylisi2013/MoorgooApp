//
//  ChangeProfilePictureViewController.h
//  Moorgoo
//
//  Created by Xueyang Li on 3/23/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeProfilePictureViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic) UIImage *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (nonatomic, strong) MBProgressHUD *hud;


@end
