//
//  RegisterViewController.m
//  Moorgoo
//
//  Created by SI  on 12/26/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "RegisterViewController.h"
#define kOFFSET_FOR_KEYBOARD 160.0
#define DARK_ALPHA 0.3f


@interface RegisterViewController () <UIAlertViewDelegate>
{
    NSData *imageData;
    UIImage *backgroundImage;
}

@end

@implementation RegisterViewController
@synthesize IOS7AlertView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    backgroundImage = [UIImage imageNamed:@"TutorBackground"];
    
    [self fillBackgroundWithImage:backgroundImage withAlpha: DARK_ALPHA];
    
    /************************************************************************************/
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    /************************************************************************************/
    self.firstRegisterTextField.delegate = self;
    self.lastRegisterTextField.delegate = self;
    self.emailRegisterTextField.delegate = self;
    self.passwordRegisterTextField.delegate = self;
    self.phoneRegisterTextField.delegate = self;
    
    /************************************************************************************/
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
}

// When hit return key, go to "next line" --- next textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstRegisterTextField)
    {
        [self.lastRegisterTextField becomeFirstResponder];
    }
    else if (textField == self.lastRegisterTextField)
    {
        [self.emailRegisterTextField becomeFirstResponder];
    }
    else if (textField == self.emailRegisterTextField)
    {
        [self.passwordRegisterTextField becomeFirstResponder];
    }
    else if (textField == self.passwordRegisterTextField)
    {
        [self.phoneRegisterTextField becomeFirstResponder];
    }
    
    return YES;
}

// Helper method encapsulates the background drawing code
-(void)fillBackgroundWithImage:(UIImage *)image withAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [image drawInRect:self.view.bounds];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor *color = [[UIColor colorWithPatternImage:theImage] colorWithAlphaComponent:alpha];
    self.view.backgroundColor = color;
}

#pragma mark - TextFields animation
-(void)dismissKeyboard {
    [self.firstRegisterTextField endEditing:YES];
    [self.lastRegisterTextField endEditing:YES];
    [self.emailRegisterTextField endEditing:YES];
    [self.passwordRegisterTextField endEditing:YES];
    [self.phoneRegisterTextField endEditing:YES];
    
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.4];
    
    self.profileImageView.alpha = 1.0f;
    self.pickImageButton.alpha = 1.0f;
    self.signUpButton.alpha = 1.0f;
    self.backButton.alpha = 1.0f;
    
    [self fillBackgroundWithImage:backgroundImage withAlpha: DARK_ALPHA];
    
    self.pickImageButton.enabled = true;
    self.signUpButton.enabled = true;
    self.backButton.enabled = true;
    
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.4];
    
    if (up)
    {
        self.firstNameVerticalLayout.constant += kOFFSET_FOR_KEYBOARD;
        
        [self.firstRegisterTextField layoutIfNeeded];
        [self.lastRegisterTextField layoutIfNeeded];
        [self.emailRegisterTextField layoutIfNeeded];
        [self.passwordRegisterTextField layoutIfNeeded];
        [self.phoneRegisterTextField layoutIfNeeded];
        
        self.view.backgroundColor = [UIColor colorWithRed:10.0f green:10.0f blue:10.0f alpha:0.3f];
        self.profileImageView.alpha = 0.3f;
        self.pickImageButton.alpha = 0.3f;
        self.signUpButton.alpha = 0.3f;
        self.backButton.alpha = 0.3f;
        
        self.pickImageButton.enabled = false;
        self.signUpButton.enabled = false;
        self.backButton.enabled = false;
        
        [self fillBackgroundWithImage:backgroundImage withAlpha: DARK_ALPHA];
    }
    else
    {
        // revert back to the normal state.
        self.firstNameVerticalLayout.constant -= kOFFSET_FOR_KEYBOARD;
        
        [self.firstRegisterTextField layoutIfNeeded];
        [self.lastRegisterTextField layoutIfNeeded];
        [self.emailRegisterTextField layoutIfNeeded];
        [self.passwordRegisterTextField layoutIfNeeded];
        [self.phoneRegisterTextField layoutIfNeeded];
        
        self.pickImageButton.enabled = true;
        self.signUpButton.enabled = true;
        self.backButton.enabled = true;
        
    }
    
    [UIView commitAnimations];
}

#pragma mark - Button clicked methods
- (IBAction)backButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"backToEntranceView" sender:nil];
}

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    // The string contains all possible errors
    NSString *errorString = @"";
    
    if (self.firstRegisterTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input your first name\n"];
    }
    if (self.lastRegisterTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input your last name\n"];
    }
    if (self.phoneRegisterTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input your phone number\n"];
    }
    if (self.passwordRegisterTextField.text.length < 4){
        errorString = [errorString stringByAppendingString:@"Password has to be at least 4 digits long\n"];
    }
    if (imageData == nil){
        errorString = [errorString stringByAppendingString:@"Please choose your profile picture"];
    }
    
    // Check whether the user inputs their information correctly or not
    if ([errorString length] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        IOS7AlertView = [[CustomIOS7AlertView alloc] init];
        UIView *basicView = [[UIView alloc] init];
        basicView.frame = CGRectMake(0, 0, 300, 450);
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, 300, 450);
        scrollView.contentSize = CGSizeMake(300, 1500);
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(0, 0, 300, 450);
        textView.text = [self getTOUText];
        [scrollView addSubview:textView];
        [basicView addSubview:scrollView];
        
        [IOS7AlertView setContainerView:basicView];
        [IOS7AlertView setDelegate:self];
        [IOS7AlertView setButtonTitles:@[@"Agree"]];
        [IOS7AlertView show];
    }
}

- (NSString *)getTOUText {
    NSString *TOUText = @"Terms and Conditions:\nLast updated: April 18, 2015\nDear users , thank you for using Moorgoo Tutorial app which is determined to help to fit students’ needs on their courses’ tutorials on both tutor and tutee sides. Before officially using the Moorgoo Tutor mobile app which is owned by the Moorgoo Educational Corporation, please read the following Terms and Conditions (“Terms”, “Terms and Conditions”) carefully.\nYour access to and use of the service is conditioned on you acceptance of and compliance with these terms. These Terms apply to all visitors, users and others who access or use the service. By downloading, installing or using the App, you indicate that you accept these Terms of Use and that you agree to abide by them. Your download, installation or use of the App constitutes your acceptance of these Terms of Use which takes effect on the date on which you download, install or use the app. By accessing or using the service you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the service.\nThe App is operated by Moorgoo Educational Corporation, a San Diego corporation with an office at 4341 Nobel Drive Unit 114, San Diego, CA 92122 (and we refer to ourselves-Moorgoo Educational Corporation as “we”, “us” or “our”). We own and operate the App on our own behalf.\nWe reserve the right to change these Terms of Use at any time without notice to you by posting changes on the www.moorgoo.com (the “website”) or by updating the App to incorporate the new terms of use. You are responsible for regularly reviewing information posted online to obtain timely notice of such changes. Your continued use of the App after changes are posted constitutes your acceptance of amended Terms of Use.\nTo download, install, access or use the App, you should obey the Moorgoo Tutor App’s rules. It is dedicated to help to fit students’ needs on their courses’ tutorials on both tutor and tutee sides; however, it does not allow any person to copy other people’s homework, to help other people with exams, to do homework or to write paper for other people. All tutors should bring their own personal notes for classes to teach students. They are not allowed to use other people’s materials and if they violate the rules, they need to be responsible for their own behavior and Moorgoo Educational Incorporation highly encourage tutors to prepare their own tutorial materials.Any misconduct that violates the Academic Integrity will be prohibited by Moorgoo Corporation’s all products forever. All users should be responsible for their own behaviors through the Moorgoo Tutor App and this App should only be used as a platform for improving your knowledge or grades through legal method. Any violation or misconduct will be charged by the official institutions and Moorgoo Tutor App or Moorgoo Educational Corporation will not be responsible for all these issues.\nAll versions designed and uploaded by personnel from Moorgoo Educational Incorporation will be reserve as the company’s asset. If any other companies or organizations use Moorgoo Tutorial App for their own business, we reserve the rights for any further actions.\nWe operate the software underlying and required for your use of the App from the United States and it is possible that some downloads from the United States of America and it is possible that some downloads from the subject to government export controls or other restrictions. If you download anything from or use the App, you represent that you are not subject to such country restrictions. We make no representation that anything is appropriate, permissible or available for use outside the United States, and using such use or the information available form such use is illegal, restricted or not permitted, is expressly prohibited.\nEnsuring that what you are doing in that country is legal; and\nThe consequences and compliance by you with all applicable laws, regulations, codes of practice, licenses, registrations, permits and authorizations (include laws that relate to businesses providing services)\nAll access to the App through your mobile device and for bringing these Terms of Use to the attention of all such persons.\nUse of the App does not include the provision of a mobile device or other necessary equipment to access it. To use the App, you need appropriate telecommunication links. We shall not have any responsibility for any telephone or other costs you make.\nAbout the Tutorial price: All tutors are allowed to select or make their own price on the Moorgoo Tutorial app, however, all the prices need to be reasonable. Moorgoo Educational Incorporation will reserve the rights to intervene the price making basket under emergency circumstance.\nYou shall not in any way use the App or submit to s or to the App or to any user of the App anything which in many respects:\nis in breach of any law, statute, regulation or byelaw of any applicable jurisdiction;\nis fraudulent, criminal or unlawful;\nis inaccurate or out of date\n•	may be obscene, indecent, pomographic, vulgar, profane, racist, sexist, discriminatory, offensive, derogatory, harmful, harassing, threatening, embarrassing, malicious, abusive, hateful, menacing, defamatory, untrue or political;\n•	impersonates any other person or body or misrepresents a relationship with any person or body;\n•	may infringe or breach the copyright or any intellectual property rights ( including without limitation copyright, trademark rights and broadcasting rights) or privacy or other rights of us or any third party.\n•	May be contrary to our interests;\n•	Is contrary to any specific rule or requirement that we stipulate on the App in relation to a particular part of the App or the App generally; or\n•	Involves your use, delivery or transmission of any viruses, unsolicited emails, Trojan horses, trap doors, back doors, easter eggs, worms, time bombs, cancelbots or computer programming routines that are intended to damage, detrimentally interfere with, surreptitious intercept or expropriate any system, data or personal information.\n•	You agree not to reproduce, duplicate, copy or re-sell the App or any part of the App save as may be permitted by these Term of Use.\n•	You agree not to access without authority, interfere with, damage or disrupt:\n•	Any part of the app;\n•	Any equipment or network on which the App is stored;\n•	Any software used in the provision of the App;\n•	Any equipment or network or software owned or used by any third party.\n•	You hereby grant to us an irrevocable, royalty-free, worldwide, assignable, sub-licensable license to use any material which you submit to us or the App for the purpose of use on the App or for generally marketing our service. You agree that you waive your moral rights to be identified as the author and we may modify your submission. (Personal identification and all your personal information shows in the app are authorized by yourself, if not, please do not accept the term of use).\n•	Commentary and other materials available on the App are not intended to amount to advice on which reliance should be placed. Subject to paragraph 32 and 33 below, we therefore disclaim all liability and responsibility arising form any reliance placed on such materials by any user of the App, or by anyone who may be informed of any of its contents.\n•	You assume sole responsibility for results obtained from the use of the App, and for conclusions drawn from such use. We shall have no liability for any damage caused by errors or omissions in any information, instructions or scripts provided to us by you in connection with the App, or any actions taken by us at your direction.\n•	You personally agree to comply at all times with any instructions for use of the App which we make from time to time.\n•	If you choose, or you are provided with, a user identification code, password or any other piece of information as part of our security procedures, you must treat such information as confidential, and you must not disclose it to any third party. We have the right to disable any user identification code or password, whether chosen by you or allocated by us, at any time, if in our opinion you have failed to comply with any of the provisions of these Terms of Use.\n\nAvailability of the App, Security & Accuracy\n•	 We make no warranty that your access to the App will be uninterrupted, timely or error-free. Due to the nature of the Internet, this can not be guaranteed. In addition, we may need to carry out repairs, maintenance, introduce new facilities and functions and updated versions.\n•	Access to the App may be suspended or withdrawn to all users temporarily or permanently at anytime without notice. We may impose restrictions on the length and manner of usage of any part of the App of any reason. If we impose restrictions on you personally, you must not attempt to use the App under any other name or user or on any other mobile device. Any violation might face charges from the Moorgoo Educational Incorporation.\n•	We do not warrant that the App will be compatible with all hardware and software which you may use. We shall not be liable for damage to, or viruses or other code that may affect, any equipment (including but not limited to your mobile device), software, data, or other property as a result of your download, installation, access or use of the App or your obtaining any material from, or as a result of using, the App. We shall also not be liable for the actions of third parties.\n•	 We may change or update the App and anything described in it without notice to you. If the need arises, we may suspend access to the App, or close it indefinitely.\n•	We make no representation or warranty, express or implied, that information and materials on the App are correct , no warranty or representation, express or implied, is given that they are complete, accurate, up-to-date, fit for a particular purpose and, to the extent permitted by law, we do not accept any liability for any errors or omissions. This shall not affect any obligation which we may have under any contract that we may have with you to provide you with products.\n•	People who want to register as the tutors should check their working capabilities in the U.S. Users should be responsible for their own behaviors and should always obey the U.S. constitutions and law. Any violations or misconduct may face extremely severe consequences from the government and Moorgoo Educational Incorporation will not be responsible for it since we notified you this information here. You will not be eligible to register as a tutor unless you read this Terms of Use and agree with it and sign your name electronically, then you will be officially become a tutor.( Remember the Moorgoo Educational Incorporation is not your employer and the relationship between you and Moorgoo Educational Incorporation is simply the Moorgoo Educational Incorporation helps to offer you a platform to help you to promote your service.)\n•	The App is independent of any platform on which it is located. The App is not associated, affiliated, sponsored, endorsed or in any way linked to any platform operator, including, without limitation, Apple, Google, Android or RIM Blackberry.\n•	Your download, installation, access to or use of the App is also bound by the Terms of conditions of the Operators.\n•	You and we acknowledge that these Terms of Use are concluded between you and us only, and not with an Operator, and we, not those Operators, are solely responsible for the App and the content thereof to the extent specified in these Terms of Use.\n•	The license granted to you for the App is limited to a non-transferable license to use the App on a mobile service that you own or control and as permitted by the Terms of Use.\n•	We are solely responsible for providing any maintenance and support services with respect to the App as required under applicable law. You and we acknowledge that an operator has no obligation whatsoever to furnish any maintenance and support services with respect to the App.\n•	About the potential payment, in the event of any failure of the App to confirm to any applicable warranty, you may notify the relevant Operator and that Operator will refund the purchase price for the App ( if any purchase price has been paid) to you; and, to the maximum extent permitted by applicable law, that Operator will have no other warranty obligation whatsoever with respect to the App, and any other claims, losses, liabilities, damages, costs or expenses attributable to any failure to confirm to any warranty will be our sole responsibility. We reserve the right to explain under all the circumstances.\n•	You and we acknowledge that we, not the relevant Operator, are responsible for addressing any claims of you or any third party relating to the App or your possession and/ or use of the App, including, but not limited to :(i) any claim that the App fails to confirm to any applicable legal or regulatory requirement; and (ii) claims arising under consumer protection or similar legislation.\n•	You and we acknowledge that, in the event of any third party claim that the App or your possession and use of the App infringes that third party’s intellectual property rights, we, not the relevant operator, will not be responsible for the investigation, defense, settlement and discharge of any such intellectual property infringement claim since we have notified all users and all providers here that you have to obey the U.S. constitution and common laws as well as the property laws. Any violation will subject to face severe consequences and the Moorgoo Educational Incorporation will be not be responsible for any of these events.\n•	You must comply with any applicable third party terms of agreement when using the App (e.g. you must ensure that your use of the App is not in violation of your mobile device agreement or any wireless data service agreement).\n•	You and we acknowledge and agree that the relevant Operator, and that Operator’s subsidiaries, are third party beneficiaries of these Terms of Use, and that, Upon your acceptance of these Terms of Use, that Operator will have the right ( and will be deemed to have accepted the right) to enforce these Terms of Use against you as a third party beneficiary thereof.\n\nLimited of Liability\n•	You hereby release Moorgoo Educational Inc., its officers, directors, agents and employees from all claims, demands, and damages (actual and consequential) of any kind of nature, known and unknown, suspected and unsuspected, disclosed and undisclosed, arising out of , or in any way, connected with any disputes arising between you and any suppliers, or between you and any suppliers, or between you and other App or Website users.\n•	You assume all responsibility and risk with respect to your use of the App. The App is available “as is, “ and “as available”. You understand and agree that, to the fullest extent permitted by law, we disclaim all warranties representations and endorsements expressor implied, with regard to the site, including, without limitation, implied warranties of title, merchantability. Non-infringement and fitness for a particular purpose. We do not warrant use of the site will be uninterrupted or error-free or that errors will be detected or corrected. We do not assume any liability or responsibility for any computer virus, bugs, malicious code or other harmful components, delays, inaccuracies, errors or omissions, or the accuracy, completeness, reliability or usefulness of the information disclosed or accessed through the app.\n•	Non-infringement and fitness for a particular purpose. We do not warrant use of the site will be uninterrupted or error-free or that errors will be detected or corrected. We do not assume any liability or responsibility for any computer viruses, delays inaccuracies, errors or omissions, or the accuracy, completeness, reliability or usefulness of the information disclosed or accessed through the App. We have no duty to update or modify the App and we are not liable for our failure to do so. In no event, under no legal or equitable theory(contract, tort, strict liability or otherwise), shall we or any of our respective employees, directors, officers, agents or affiliates, be liable hereunder or otherwise for any loss or damage of any kind, direct or indirect, in connection with or arising from the App, the use of the app or our agreement with you concerning the App, including, but not limited to, compensatory, direct consequential, incidental, indirect, special or punitive damages, lost anticipated profits, loss of goodwill, loss of data, business interruption, accuracy of results, or computer failure or malfunction, even if we have been advised of or should have known of the possibility of such damages. If we are held liable to you in a court of competent jurisdiction for any reason, in no event will we be liable for any damages in excess of two hundred and fifty dollars(US $250.00). Some jurisdictions do not allow the limitation or exclusion of the liability for consequential or incidental damages, so the above limitation or exclusion may not apply to you.\n•	You represent and warrant that (a) your use of the App will be in strict accordance with this Agreement and with all applicable laws and regulations, including without limitation any local laws or regulations in your country , state, city or other governmental area, regarding online conduct and acceptable content, and regarding the transmission of technical data exported from the U.S. or the country in which you reside and (b) your use of the App will not infringe or misappropriate the intellectual property rights of any third party.\n•	You agree to indemnify and hold Moorgoo. Edu Incorporation and each of our affiliates, successors and assigns, and their respective officers, directors, employees, agents, representative officers, directors, employees, agents, representatives, licensors, advertisers, suppliers and operational service providers harmless from and against any and all losses, expenses, damages, costs and expenses( including the potential “attorney fees”), resulting from the use of App or any violation of the terms of agreement. Under all circumstances, we reserve the right to assume the exclusive defense and control of any demand, claim or action arising hereunder or in connection with the App. You must fully agree and cooperate with us in the defense of any misconduct.\n•	The “Moorgoo” name and logos and all related names, trademarks, service marks, design marks and slogans are the trademarks or service marks of us or our licensors. Using “Moorgoo” logo without notifying and getting approval from Moorgoo Educational Incorporation might result severe consequences.\n•	As between you and us, we are the sole and exclusive owner or the licensee of all intellectual property rights in the App( only the App), and in the materials published on it.(include the future derivatives) Those works are protected by the copyright and trademark laws and treaties around the world. All these rights are reserved.\n•	You may print off one copy or download the extracts of any pages from the App for your personal reference. But you can not copy it for business usages.\n•	For all tutors, you are not allowed to use/ print/ copy other people’s intellectual properties such as Professor’s lecture notes to teach your students. You can only give your own explanation by using publicized materials such as Official Guidelines/ Kaplans,etc. Violation of the rules, tutors need to be responsible for their own behaviors.\n•	We process information about you in accordance with our Privacy Policy, which is available on our website at www.moorgoo.com. By using the App, you consent to such process and you warrant that all data provided by you is accurate. You are responsible for all the data that you put on the website and the App.\n•	For Third Party Website, we have no control over and accept no responsibility for the content of any website besides www.moorgoo.com or mobile application to which a link from the App exists. Such linked websites and mobile applications are provided “as is” for your convenience only with no warranty, express or implied, for the information provided within them. We do not provide any endorsement or recommendation of any third party website or mobile application to which the App provides a link. (Moorgoo Educational Incorporation reserve all the rights for the contexts that shows on the App)\n•	The terms and conditions, term of use and privacy policies of those third party websites and mobile applications will apply to your use of those websites and mobile applications and any orders you make for goods and services via such websites and mobile applications. If you have any inquiries, concerns or compliant about anything relate to the Moorgoo Educational Incorporation’s business, you are more than welcome to contact Moorgoo Educational Incorporation’s legal service department or their personnel for further explanations.\n•	If any of these terms should be determined to be illegal, invalid, or otherwise unenforceable by reason of the laws of any state or country in which these terms are intended to be effective, then to the extent and within the jurisdiction which that term is illegal, invalid or unenforceable, it shall be severed and deleted and the remaining terms of uses shall survive, remain in full force and effect and continue to be binding and enforceable.\n•	Except as expressly stated in these Terms of Us, all warranties and conditions, whether express or implied by statute, common law or otherwise are hereby excluded to the extent permitted by law.\n•	These Terms of Use ( Privacy Policy, Website Terms of Use, other documents referred to the Moorgoo Educational Incorporation and Moorgoo Tutorial App) contain all the terms agreed between us and you regarding their subject matter and supersedes and excludes any prior terms and conditions, understanding the agreement and arrangement between us and you no matter in oral or in paper work. No representation, undertaking or promise shall be taken to the prior Term of use unless it is stated that it could be cited later.\n•	All these Terms of Use may only be modified by a written amendment signed by the legal representative of Moorgoo Educational Incorporation or by the posting of a revised version by the board of Moorgoo Educational Incorporation. Except to the extent applicable law, if any, provides, otherwise, this Agreement and any access to or use the App will be governed by the laws of the state of California, excluding its conflict of law provisions. If any part of this agreement is held invalid or unforceable, that part will be construed to reflect the parties’ original intent, and the remaining portions will remain in full force and effect. A waiver by either party of any term or condition of this Areement\n\nReserved rights : Moorgoo Educational Incorporation\nIntellectual property rights reserved by : Moorgoo Educational Incorporation\nBibliography: http://goop.com/app-terms-of-use/";


    return TOUText;
}

- (void)registerUser {
    [self.hud show:YES];
    
    PFUser *user = [PFUser user];
    [user setObject:self.firstRegisterTextField.text forKey:@"firstName"];
    [user setObject:self.lastRegisterTextField.text forKey:@"lastName"];
    user.email = self.emailRegisterTextField.text;
    user.username = self.emailRegisterTextField.text;  //use email as login username
    user.password = self.passwordRegisterTextField.text;
    [user setObject:self.phoneRegisterTextField.text forKey:@"phone"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            /************************************************************************/
            PFFile *imageFile = [PFFile fileWithName:@"Profileimage.png" data:imageData];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    PFUser *user = [PFUser currentUser];
                    user[@"profilePicture"] = imageFile;
                    
                    [user saveInBackground];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                    message:@"You have signed up successfully,\n Go find a tutor!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    [self.hud hide:YES];
                    
                } else {
                    // Handle error
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    
                    [self.hud hide:YES];
                }
            }];
            
            /************************************************************************/
            KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainTest" accessGroup:nil];
            [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
            [keychain setObject:self.emailRegisterTextField.text forKey:(__bridge id)(kSecAttrAccount)];
            [keychain setObject:self.passwordRegisterTextField.text forKey:(__bridge id)(kSecValueData)];
            /************************************************************************/
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            [self.hud hide:YES];
            
        }
    }];
}


- (IBAction)pickImageButtonClicked:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - uiimagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    image = [self imageWithImage:image scaledToSize:CGSizeMake(200, 200)];
    imageData = UIImagePNGRepresentation(image);
    [picker dismissViewControllerAnimated:YES completion:^{
        self.profileImageView.image = image;
        [self.pickImageButton setTitle:@"Change Picture" forState:UIControlStateNormal];
    }];
}

#pragma mark - alertViewClicked Response
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
    }
    
}

#pragma mark - <customerAlertViewDelegate>
- (void)customIOS7dialogButtonTouchUpInside:(CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [IOS7AlertView close];
        [self registerUser];
    }
    
}

@end
