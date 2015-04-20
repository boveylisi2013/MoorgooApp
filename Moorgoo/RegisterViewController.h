//
//  RegisterViewController.h
//  Moorgoo
//
//  Created by SI  on 12/26/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "CustomIOS7AlertView.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomIOS7AlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *firstRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneRegisterTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *pickImageButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNameVerticalLayout;

- (IBAction)pickImageButtonClicked:(id)sender;
@property CustomIOS7AlertView *IOS7AlertView;

@end
