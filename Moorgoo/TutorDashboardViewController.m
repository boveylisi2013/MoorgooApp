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
    // Arrays for tableView
    NSMutableArray *courseItems;
    NSMutableArray *stableCourseItems;
    
    BOOL addedCoursesToStableCourseItems;
    BOOL noCourseFound;
    
    NSString *choosenCourse;
    
    NSMutableArray *allCourseLabels;
    NSMutableArray *allDeleteButtons;
    
    NSMutableArray *allACourseLabels;
    NSMutableArray *allADeleteButtons;
    
    NSMutableArray *addedCourses;
    NSMutableArray *availableDays;
    NSMutableArray *ACourses;
    
    NSMutableArray *pickerDepartmentArray;
    /************************************************************************************************/
    
    
    UIScrollView *scrollView;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    UILabel *chooseCourseLabel;
    UILabel *myCourseLabel;
    UILabel *courseLabel1;
    UILabel *courseLabel2;
    UILabel *courseLabel3;
    UILabel *courseLabel4;
    UILabel *courseLabel5;
    
    UILabel *acourseLabel1;
    UILabel *acourseLabel2;
    UILabel *acourseLabel3;
    UILabel *acourseLabel4;
    UILabel *acourseLabel5;
    
    UITextField *chooseCourseTextField;
    
    UITableView *courseTableView;
    
    UIButton *deleteCourseButton1;
    UIButton *deleteCourseButton2;
    UIButton *deleteCourseButton3;
    UIButton *deleteCourseButton4;
    UIButton *deleteCourseButton5;
    
    UIButton *adeleteCourseButton1;
    UIButton *adeleteCourseButton2;
    UIButton *adeleteCourseButton3;
    UIButton *adeleteCourseButton4;
    UIButton *adeleteCourseButton5;
    
    UIButton *submitButton;
    
    UISwitch *mondaySwitch;
    UISwitch *tuesdaySwitch;
    UISwitch *wednesdaySwitch;
    UISwitch *thursdaySwitch;
    UISwitch *fridaySwitch;
    UISwitch *saturdaySwitch;
    UISwitch *sundaySwitch;
    
    UILabel *myAvailableDaysLabel;
    
    UILabel *mondayLabel;
    UILabel *tuesdayLabel;
    UILabel *wednesdayLabel;
    UILabel *thursdayLabel;
    UILabel *fridayLabel;
    UILabel *saturdayLabel;
    UILabel *sundayLabel;
    
    UILabel *myDescriptionLabel;
    UITextView *descriptionTextView;
    
    UILabel *myDepartmentLabel;
    UITextField *departmentTextField;
    UIPickerView *departmentPicker;
    
    UILabel *myACourseLabel;
    UITextField *ACourseTextField;
    UITableView *ACourseTableView;
    
    UILabel *myPriceLabel;
    UITextField *priceTextField;
    
}
@end

@implementation TutorDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hud = [[MBProgressHUD alloc] init];
    [scrollView addSubview:self.hud];
    
    // Get the current screen height and size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    [self allocInitAllSubviews];     /************************************************************************************************/
    
    // Set up the scrollView
    scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight + 1550);
    [self.view addSubview:scrollView];
    
    [self centerSubview:chooseCourseLabel withX:10 Y:10 height:15];
    [chooseCourseLabel setText:@"Input the class that you want to teach"];
    [chooseCourseLabel setTextColor:[UIColor blackColor]];
    
    [self centerSubview:chooseCourseTextField withX:10 Y:35 height:35];
    chooseCourseTextField.placeholder = @"type in the coursename";
    chooseCourseTextField.layer.borderWidth = 1;
    chooseCourseTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    [chooseCourseTextField setReturnKeyType:UIReturnKeyDone];
    chooseCourseTextField.delegate = self;
    
    ACourseTextField.delegate = self;
    [ACourseTextField setReturnKeyType:UIReturnKeyDone];
    
    
    [self centerSubview:courseTableView withX:10 Y:80 height:220];
    [self centerSubview:ACourseTableView withX:10 Y:1350 height:205];
    
    
    for(int i = 1; i < 6; i++)
    {
        [self hideCourseLabelAndButtonNumber:i YorN:true];
    }
    
    for(int i = 1; i < 6; i++)
    {
        [self hideACourseLabelAndButtonNumber:i YorN:true];
    }
    
    [submitButton setTitle:@"SAVE" forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor purpleColor];
    
    [self layoutMyCoursesBlock:100];
    [self layoutWeekDaysBlock:440];
    [self layoutMyDescriptionAndDepartmentBlock:900];
    [self centerSubview:submitButton withX:40 Y:1860 height:60];
    [self layoutACoursesBlocks:1260 + 100];
    [self layoutPriceBlock:1750];
    
    [self addAllSubviews];      /************************************************************************************************/
    
    /************************************************************************************************/
    [mondayLabel setText:@"  MONDAY"];
    [tuesdayLabel setText:@"  TUESDAY"];
    [wednesdayLabel setText:@"  WEDNESDAY"];
    [thursdayLabel setText:@"  THURSDAY"];
    [fridayLabel setText:@"  FRIDAY"];
    [saturdayLabel setText:@"  SATURDAY"];
    [sundayLabel setText:@"  SUNDAY"];
    
    // Set the switches for the days to be off
    [mondaySwitch setOn:NO];
    [tuesdaySwitch setOn:NO];
    [wednesdaySwitch setOn:NO];
    [thursdaySwitch setOn:NO];
    [fridaySwitch setOn:NO];
    [saturdaySwitch setOn:NO];
    [sundaySwitch setOn:NO];
    
    /************************************************************************************************/
    // Initialize and query for arrays that serve as datasource for the tableView
    stableCourseItems = [[NSMutableArray alloc] init];
    courseItems = [[NSMutableArray alloc] init];
    
    // TABLE VIEW SET UP
    
    courseTableView.delegate = self;
    courseTableView.dataSource = self;
    
    [self getCourses:courseItems];
    addedCoursesToStableCourseItems = false;
    
    // Add the method to detect change in the specficClassTextField
    [chooseCourseTextField addTarget:self
                              action:@selector(textFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
    
    //Initially hide the table view
    courseTableView.rowHeight = 44;
    [courseTableView setHidden:YES];
    /************************************************************************************************/
    // A COURSE TABLE VIEW SET UP
    
    ACourseTableView.delegate = self;
    ACourseTableView.dataSource = self;
    
    //    [self getCourses:courseItems];
    addedCoursesToStableCourseItems = false;
    
    // Add the method to detect change in the specficClassTextField
    [ACourseTextField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    
    //Initially hide the table view
    ACourseTableView.rowHeight = 44;
    [ACourseTableView setHidden:YES];
    /************************************************************************************************/
    // ADD ALL THE COURSE LABELS INTO THE ARRAY
    allCourseLabels = [[NSMutableArray alloc] init];
    [allCourseLabels addObject:courseLabel1];
    [allCourseLabels addObject:courseLabel2];
    [allCourseLabels addObject:courseLabel3];
    [allCourseLabels addObject:courseLabel4];
    [allCourseLabels addObject:courseLabel5];
    
    allDeleteButtons = [[NSMutableArray alloc] init];
    [allDeleteButtons addObject:deleteCourseButton1];
    [allDeleteButtons addObject:deleteCourseButton2];
    [allDeleteButtons addObject:deleteCourseButton3];
    [allDeleteButtons addObject:deleteCourseButton4];
    [allDeleteButtons addObject:deleteCourseButton5];
    
    allACourseLabels = [[NSMutableArray alloc] init];
    [allACourseLabels addObject:acourseLabel1];
    [allACourseLabels addObject:acourseLabel2];
    [allACourseLabels addObject:acourseLabel3];
    [allACourseLabels addObject:acourseLabel4];
    [allACourseLabels addObject:acourseLabel5];
    
    allADeleteButtons = [[NSMutableArray alloc] init];
    [allADeleteButtons addObject:adeleteCourseButton1];
    [allADeleteButtons addObject:adeleteCourseButton2];
    [allADeleteButtons addObject:adeleteCourseButton3];
    [allADeleteButtons addObject:adeleteCourseButton4];
    [allADeleteButtons addObject:adeleteCourseButton5];
    
    // FIRSTLY HIDE ALL THE COURSE LABELS AND DELETE BUTTON
    [self hideCourseLabelAndButtonNumber:1 YorN:true];
    [self hideCourseLabelAndButtonNumber:2 YorN:true];
    [self hideCourseLabelAndButtonNumber:3 YorN:true];
    [self hideCourseLabelAndButtonNumber:4 YorN:true];
    [self hideCourseLabelAndButtonNumber:5 YorN:true];
    
    /************************************************************************************************/
    [deleteCourseButton1 addTarget:self action:@selector(pressDelete1) forControlEvents:UIControlEventTouchUpInside];
    [deleteCourseButton2 addTarget:self action:@selector(pressDelete2) forControlEvents:UIControlEventTouchUpInside];
    [deleteCourseButton3 addTarget:self action:@selector(pressDelete3) forControlEvents:UIControlEventTouchUpInside];
    [deleteCourseButton4 addTarget:self action:@selector(pressDelete4) forControlEvents:UIControlEventTouchUpInside];
    [deleteCourseButton5 addTarget:self action:@selector(pressDelete5) forControlEvents:UIControlEventTouchUpInside];
    
    [deleteCourseButton1 setTitle:@"DELETE" forState:UIControlStateNormal];
    [deleteCourseButton2 setTitle:@"DELETE" forState:UIControlStateNormal];
    [deleteCourseButton3 setTitle:@"DELETE" forState:UIControlStateNormal];
    [deleteCourseButton4 setTitle:@"DELETE" forState:UIControlStateNormal];
    [deleteCourseButton5 setTitle:@"DELETE" forState:UIControlStateNormal];
    
    [adeleteCourseButton1 addTarget:self action:@selector(pressADelete1) forControlEvents:UIControlEventTouchUpInside];
    [adeleteCourseButton2 addTarget:self action:@selector(pressADelete2) forControlEvents:UIControlEventTouchUpInside];
    [adeleteCourseButton3 addTarget:self action:@selector(pressADelete3) forControlEvents:UIControlEventTouchUpInside];
    [adeleteCourseButton4 addTarget:self action:@selector(pressADelete4) forControlEvents:UIControlEventTouchUpInside];
    [adeleteCourseButton5 addTarget:self action:@selector(pressADelete5) forControlEvents:UIControlEventTouchUpInside];
    
    [adeleteCourseButton1 setTitle:@"DELETE" forState:UIControlStateNormal];
    [adeleteCourseButton2 setTitle:@"DELETE" forState:UIControlStateNormal];
    [adeleteCourseButton3 setTitle:@"DELETE" forState:UIControlStateNormal];
    [adeleteCourseButton4 setTitle:@"DELETE" forState:UIControlStateNormal];
    [adeleteCourseButton5 setTitle:@"DELETE" forState:UIControlStateNormal];
    
    /************************************************************************************/
    
    [self fetchTutorInfoAndSetSubviews];
    [self fetchAllDepartmentsAndFillThePickerArray];
    [self addDepartmentPicker];
    
    // Add the method to detect change in the specficClassTextField
    [submitButton addTarget:self
                     action:@selector(submitButtonPressed)
           forControlEvents:UIControlEventTouchUpInside];
    
    ACourses = [[NSMutableArray alloc] init];
    
    /*******************************************************************************/
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // prevent the touch event to the table view being eaten by the tap
    [tap setCancelsTouchesInView:NO];
    
}

# pragma mark - dismissKeyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark- database query methods
-(void)fetchTutorInfoAndSetSubviews
{
    addedCourses = [[NSMutableArray alloc] init];
    availableDays = [[NSMutableArray alloc] init];
    
    // QUERY TUTOR INFORMATION
    PFObject *userPointer = [PFObject objectWithoutDataWithClassName:@"_User" objectId:([PFUser currentUser]).objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"CollegeClassTutor"];
    [query whereKey:@"userId" equalTo:userPointer];
    [query includeKey:@"departmentId"];
    [query setLimit:1000];
    
    [self.hud show:YES];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *tutor, NSError *error)
     {
         
         if(!error)
         {
             [self.hud hide:YES];
             if(tutor == nil)
             {
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Tutor information missing, please contact Moorgoo staff"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 return;
             }
             
             NSArray *tempAddedClasses = (NSArray *)[tutor objectForKey:@"courses"];
             [addedCourses addObjectsFromArray:tempAddedClasses];
             
             NSArray *tempAvailableDays = (NSArray *)[tutor objectForKey:@"availableDays"];
             [availableDays addObjectsFromArray:tempAvailableDays];
             
             NSArray *tempAddedAClasses = (NSArray *)[tutor objectForKey:@"AClasses"];
             [ACourses addObjectsFromArray:tempAddedAClasses];
             
             PFObject *departmentPointer = [tutor objectForKey:@"departmentId"];
             departmentTextField.text = [departmentPointer objectForKey:@"department"];
             
             NSString *price = (NSString *)[tutor objectForKey:@"price"];
             priceTextField.text = price;
             
             // Set the course labels
             if([addedCourses count] != 0)
             {
                 int i = 1;
                 for(NSString *courseString in addedCourses)
                 {
                     [self setCourseLabelNumber:i toString:courseString];
                     [self hideCourseLabelAndButtonNumber:i YorN:false];
                     i++;
                 }
             }
             
             // Set the course labels
             if([ACourses count] != 0)
             {
                 int i = 1;
                 for(NSString *courseString in ACourses)
                 {
                     [self setACourseLabelNumber:i toString:courseString];
                     [self hideACourseLabelAndButtonNumber:i YorN:false];
                     i++;
                 }
             }
             
             // Set the day labels and switchs
             if([availableDays count] != 0)
             {
                 if([availableDays containsObject:@"Monday"]) [mondaySwitch setOn:YES];
                 if([availableDays containsObject:@"Tuesday"]) [tuesdaySwitch setOn:YES];
                 if([availableDays containsObject:@"Wednesday"]) [wednesdaySwitch setOn:YES];
                 if([availableDays containsObject:@"Thursday"]) [thursdaySwitch setOn:YES];
                 if([availableDays containsObject:@"Friday"]) [fridaySwitch setOn:YES];
                 if([availableDays containsObject:@"Saturday"]) [saturdaySwitch setOn:YES];
                 if([availableDays containsObject:@"Sunday"]) [sundaySwitch setOn:YES];
             }
             
             // Set myDescription textField
             NSString *descriptionText = (NSString *)[tutor objectForKey:@"selfAd"];
             [descriptionTextView setText:descriptionText];
         }
         else
         {
             [self.hud hide:YES];
             // Not found the tutor information in the database
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Tutor information missing, please contact with Moorgoo staff!!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
             return;
         }
         
     }];
}

-(void)fetchAllDepartmentsAndFillThePickerArray
{
    PFQuery *query = [PFQuery queryWithClassName:@"Department"];
    [query setLimit:1000];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            [pickerDepartmentArray addObjectsFromArray:[objects valueForKey:@"department"]];
            [pickerDepartmentArray insertObject:@"" atIndex:0];
            [pickerDepartmentArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Some error happened during fetching departments"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
    }];
}

#pragma mark- tableView delegete methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([courseItems count] != 0) return [courseItems count];
    else                          return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"courseItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if([courseItems count] != 0)
    {
        cell.textLabel.text = courseItems[indexPath.row];
        noCourseFound = false;
    }
    else
    {
        cell.textLabel.text = @"No course matches the input";
        noCourseFound = true;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Do not let the cell stay selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == courseTableView)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!noCourseFound)
        {
            choosenCourse = cell.textLabel.text;
            NSString *alertMessage = [@"Do you wanna add " stringByAppendingString:choosenCourse];
            alertMessage = [alertMessage stringByAppendingString:@" to My Courses?"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                            message:alertMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert show];
        }
        else
        {
            [self hideCourseTableView:YES AndSetYOfMyCoursesBlock:100];
            chooseCourseTextField.text = @"";
            [self.view endEditing:YES];
        }
    }
    else if(tableView == ACourseTableView)
    {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!noCourseFound)
        {
            choosenCourse = cell.textLabel.text;
            NSString *alertMessage = [@"Do you wanna add " stringByAppendingString:choosenCourse];
            alertMessage = [alertMessage stringByAppendingString:@" to My A+/A/A- Courses?"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                            message:alertMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"No!"
                                                  otherButtonTitles:@"Yes!", nil];
            [alert show];
        }
        else
        {
            [self hideACourseTableView:true AndSetYOfACoursesAndButtons:1350];
            ACourseTextField.text = @"";
            [self.view endEditing:YES];
        }
    }
}


# pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"No"] || [title isEqualToString:@"No!"])
    {
        // Do nothing
    }
    
    if([title isEqualToString:@"Yes!"])
    {
        if([ACourses count] == 5)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You can add at most 5 courses"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            ACourseTextField.text = @"";
            [self.view endEditing:YES];
            [self hideACourseTableView:true AndSetYOfACoursesAndButtons:1350];
        }
        else
        {
            if([ACourses containsObject:choosenCourse])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"You have already added this course"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                [self.view endEditing:YES];
                ACourseTextField.text = @"";
            }
            else
            {
                [ACourses addObject:choosenCourse];
                for(UILabel *courseLabel in allACourseLabels)
                {
                    if([courseLabel isHidden])
                    {
                        [courseLabel setHidden:false];
                        [courseLabel setText:choosenCourse];
                        break;
                    }
                }
                
                for(UIButton *deleteButton in allADeleteButtons)
                {
                    if([deleteButton isHidden])
                    {
                        [deleteButton setHidden:false];
                        break;
                    }
                }
                [self.view endEditing:YES];
                [self hideACourseTableView:true AndSetYOfACoursesAndButtons:1350];
                ACourseTextField.text = @"";
            }
        }
    }
    
    if([title isEqualToString:@"Yes"])
    {
        if([addedCourses count] == 5)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You can add at most 5 courses"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [self.view endEditing:YES];
            chooseCourseTextField.text = @"";
            [self hideCourseTableView:YES AndSetYOfMyCoursesBlock:100];
            [self centerSubview:submitButton withX:40 Y:1750 height:60];
        }
        else
        {
            if([addedCourses containsObject:choosenCourse])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"You have already added this course"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                [self.view endEditing:YES];
                chooseCourseTextField.text = @"";
            }
            else
            {
                [addedCourses addObject:choosenCourse];
                for(UILabel *courseLabel in allCourseLabels)
                {
                    if([courseLabel isHidden])
                    {
                        [courseLabel setHidden:false];
                        [courseLabel setText:choosenCourse];
                        break;
                    }
                }
                
                for(UIButton *deleteButton in allDeleteButtons)
                {
                    if([deleteButton isHidden])
                    {
                        [deleteButton setHidden:false];
                        break;
                    }
                }
                [self.view endEditing:YES];
                [self hideCourseTableView:YES AndSetYOfMyCoursesBlock:100];
                [self centerSubview:submitButton withX:40 Y:1750 height:60];
                [self.view endEditing:YES];
                chooseCourseTextField.text = @"";
            }
        }
    }
}

#pragma mark - textView delegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - textField delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- textField delegete methods
-(void)textFieldDidChange:(UITextField *)textField
{
    // The following adding courses to stableCourseItems code
    // probably should be place somewhere else, but currently
    // just put it here
    if(!addedCoursesToStableCourseItems)
    {
        [stableCourseItems addObjectsFromArray:courseItems];
        addedCoursesToStableCourseItems = true;
    }
    
    if(textField == chooseCourseTextField)
    {
        if (textField.text.length == 0)
        {
            [self hideCourseTableView:YES AndSetYOfMyCoursesBlock:100];
            [self layoutPriceBlock:1660];
            [self centerSubview:submitButton withX:40 Y:1760 height:60];
        }
        else
        {
            [self hideCourseTableView:NO AndSetYOfMyCoursesBlock:360];
            [self layoutPriceBlock:1760];
            [self centerSubview:submitButton withX:40 Y:1890 height:60];
            
            
            NSString *inputString = [textField.text uppercaseString];
            NSMutableArray *discardItems = [[NSMutableArray alloc] init];
            
            // Filter out classes based on user input
            for (NSString *currentString in courseItems)
            {
                if(![self string:currentString containsString:inputString])
                    [discardItems addObject:currentString];
            }
            [courseItems removeObjectsInArray:discardItems];
            
            // Add classes back when user delete characters
            for (NSString *currentString in stableCourseItems)
            {
                if([self string:currentString containsString:inputString])
                    if(![courseItems containsObject:currentString])
                    {
                        [courseItems addObject:currentString];
                    }
            }
            [courseTableView reloadData];
        }
    }
    else if(textField == ACourseTextField)
    {
        if (textField.text.length == 0)
        {
            [self hideACourseTableView:true AndSetYOfACoursesAndButtons:1350];
            [self layoutPriceBlock:1660];
            [self centerSubview:submitButton withX:40 Y:1760 height:60];
        }
        else
        {
            [self hideACourseTableView:false AndSetYOfACoursesAndButtons:1550];
            [self layoutPriceBlock:1760];
            [self centerSubview:submitButton withX:40 Y:1890 height:60];
            
            NSString *inputString = [textField.text uppercaseString];
            NSMutableArray *discardItems = [[NSMutableArray alloc] init];
            
            // Filter out classes based on user input
            for (NSString *currentString in courseItems)
            {
                if(![self string:currentString containsString:inputString])
                    [discardItems addObject:currentString];
            }
            [courseItems removeObjectsInArray:discardItems];
            
            // Add classes back when user delete characters
            for (NSString *currentString in stableCourseItems)
            {
                if([self string:currentString containsString:inputString])
                    if(![courseItems containsObject:currentString])
                    {
                        [courseItems addObject:currentString];
                    }
            }
            [ACourseTableView reloadData];
        }
    }
}



// Helper method which checks whether one string contains another string
-(BOOL)string:(NSString *)string_1 containsString:(NSString *)string_2
{
    return !([string_1 rangeOfString:string_2].location == NSNotFound);
}


#pragma mark - query methods
// Method to query all the classes from parse
-(void)getCourses:(NSMutableArray *)array
{
    PFQuery *query = [PFQuery queryWithClassName:@"Course"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [array addObjectsFromArray:[objects valueForKey:@"courseName"]];
            [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
    }];
}

#pragma mark - buttonPressed methods
-(void)pressDelete1
{
    [courseLabel1 setHidden:true];
    [deleteCourseButton1 setHidden:true];
    
    NSString *courseName = [courseLabel1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [addedCourses removeObject:courseName];
    
}

-(void)pressDelete2
{
    [courseLabel2 setHidden:true];
    [deleteCourseButton2 setHidden:true];
    NSString *courseName = [courseLabel2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [addedCourses removeObject:courseName];
}

-(void)pressDelete3
{
    [courseLabel3 setHidden:true];
    [deleteCourseButton3 setHidden:true];
    NSString *courseName = [courseLabel3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [addedCourses removeObject:courseName];
}

-(void)pressDelete4
{
    [courseLabel4 setHidden:true];
    [deleteCourseButton4 setHidden:true];
    NSString *courseName = [courseLabel4.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [addedCourses removeObject:courseName];
}

-(void)pressDelete5
{
    [courseLabel5 setHidden:true];
    [deleteCourseButton5 setHidden:true];
    NSString *courseName = [courseLabel5.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [addedCourses removeObject:courseName];
}

-(void)pressADelete1
{
    [acourseLabel1 setHidden:true];
    [adeleteCourseButton1 setHidden:true];
    
    NSString *courseName = [acourseLabel1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [ACourses removeObject:courseName];
    
}

-(void)pressADelete2
{
    [acourseLabel2 setHidden:true];
    [adeleteCourseButton2 setHidden:true];
    NSString *courseName = [acourseLabel2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [ACourses removeObject:courseName];
}

-(void)pressADelete3
{
    [acourseLabel3 setHidden:true];
    [adeleteCourseButton3 setHidden:true];
    NSString *courseName = [acourseLabel3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [ACourses removeObject:courseName];
}

-(void)pressADelete4
{
    [acourseLabel4 setHidden:true];
    [adeleteCourseButton4 setHidden:true];
    NSString *courseName = [acourseLabel4.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [ACourses removeObject:courseName];
}

-(void)pressADelete5
{
    [acourseLabel5 setHidden:true];
    [adeleteCourseButton5 setHidden:true];
    NSString *courseName = [acourseLabel5.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [ACourses removeObject:courseName];
}

-(void)submitButtonPressed
{
    [availableDays removeAllObjects];
    
    if(mondaySwitch.isOn)    [availableDays addObject:@"Monday"];
    if(tuesdaySwitch.isOn)   [availableDays addObject:@"Tuesday"];
    if(wednesdaySwitch.isOn) [availableDays addObject:@"Wednesday"];
    if(thursdaySwitch.isOn)  [availableDays addObject:@"Thursday"];
    if(fridaySwitch.isOn)    [availableDays addObject:@"Friday"];
    if(saturdaySwitch.isOn)  [availableDays addObject:@"Saturday"];
    if(sundaySwitch.isOn)    [availableDays addObject:@"Sunday"];
    
    // QUERY TUTOR INFORMATION
    PFObject *userPointer = [PFObject objectWithoutDataWithClassName:@"_User" objectId:([PFUser currentUser]).objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"CollegeClassTutor"];
    [query whereKey:@"userId" equalTo:userPointer];
    [query setLimit:1000];
    
    [self.hud show:YES];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *tutor, NSError *error)
     {
         NSLog(@"in submit press qurey");
         if(!error)
         {
             NSLog(@"in submit press before !error");
             
             PFQuery *theQuery = [PFQuery queryWithClassName:@"Department"];
             [theQuery whereKey:@"department" equalTo:departmentTextField.text];
             [theQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                 PFObject *departmentPointer = [PFObject objectWithoutDataWithClassName:@"Department" objectId:object.objectId];
                 
                 [tutor setObject:addedCourses forKey:@"courses"];
                 [tutor setObject:availableDays forKey:@"availableDays"];
                 [tutor setObject:descriptionTextView.text forKey:@"selfAd"];
                 [tutor setObject:ACourses forKey:@"AClasses"];
                 [tutor setObject:departmentPointer forKey:@"departmentId"];
                 [tutor setObject:priceTextField.text forKey:@"price"];
                 [tutor saveInBackground];
                 
                 [self.hud hide:YES];
                 
                 // successfully updated tutor information
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                 message:@"You have successfully updated your tutor information"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 NSLog(@"in submit press !error");
                 
                 return;
             }];
             
         }
         else
         {
             NSLog(@"in submit press have before error");
             
             [self.hud hide:YES];
             
             // Not found the tutor information in the database
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Tutor information missing, please contact with Moorgoo staff"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
             NSLog(@"in submit press have error");
             return;
         }
     }];
    
    NSLog(@"in submit press");
}

#pragma mark - add picker helper method
// Helper method to add the picker
-(void)addDepartmentPicker
{
    pickerDepartmentArray = [[NSMutableArray alloc] init];
    
    departmentPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    departmentPicker.delegate = self;
    departmentPicker.dataSource = self;
    [departmentPicker setShowsSelectionIndicator:YES];
    departmentTextField.inputView = departmentPicker;
    
    // Create done button in UIPickerView
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [mypickerToolbar setItems:barItems animated:YES];
    departmentTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked
{
    [departmentTextField resignFirstResponder];
}

/*************************************************************************************/
#pragma mark - Picker View Data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    return pickerDepartmentArray.count;
}

#pragma mark- Picker View Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return [pickerDepartmentArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    departmentTextField.text = [NSString stringWithFormat:@"%@", [pickerDepartmentArray objectAtIndex:row]];
}


#pragma mark - layout encapsulation method
/************************************************************************************************/

-(void)allocInitAllSubviews
{
    // ScrollView
    scrollView = [[UIScrollView alloc] init];
    
    // Label
    chooseCourseLabel = [[UILabel alloc] init];
    myCourseLabel = [[UILabel alloc] init];
    courseLabel1 = [[UILabel alloc] init];
    courseLabel2 = [[UILabel alloc] init];
    courseLabel3 = [[UILabel alloc] init];
    courseLabel4 = [[UILabel alloc] init];
    courseLabel5 = [[UILabel alloc] init];
    
    acourseLabel1 = [[UILabel alloc] init];
    acourseLabel2 = [[UILabel alloc] init];
    acourseLabel3 = [[UILabel alloc] init];
    acourseLabel4 = [[UILabel alloc] init];
    acourseLabel5 = [[UILabel alloc] init];
    
    mondayLabel = [[UILabel alloc] init];
    tuesdayLabel = [[UILabel alloc] init];
    wednesdayLabel = [[UILabel alloc] init];
    thursdayLabel = [[UILabel alloc] init];
    fridayLabel = [[UILabel alloc] init];
    saturdayLabel = [[UILabel alloc] init];
    sundayLabel = [[UILabel alloc] init];
    myAvailableDaysLabel = [[UILabel alloc] init];
    myDescriptionLabel = [[UILabel alloc] init];
    myDepartmentLabel = [[UILabel alloc] init];
    myACourseLabel = [[UILabel alloc] init];
    myPriceLabel = [[UILabel alloc] init];
    
    // TextField
    chooseCourseTextField = [[UITextField alloc] init];
    departmentTextField = [[UITextField alloc] init];
    ACourseTextField = [[UITextField alloc] init];
    priceTextField = [[UITextField alloc] init];
    
    // TableView
    courseTableView = [[UITableView alloc] init];
    ACourseTableView = [[UITableView alloc] init];
    
    // Button
    deleteCourseButton1 = [[UIButton alloc] init];
    deleteCourseButton2 = [[UIButton alloc] init];
    deleteCourseButton3 = [[UIButton alloc] init];
    deleteCourseButton4 = [[UIButton alloc] init];
    deleteCourseButton5 = [[UIButton alloc] init];
    
    adeleteCourseButton1 = [[UIButton alloc] init];
    adeleteCourseButton2 = [[UIButton alloc] init];
    adeleteCourseButton3 = [[UIButton alloc] init];
    adeleteCourseButton4 = [[UIButton alloc] init];
    adeleteCourseButton5 = [[UIButton alloc] init];
    
    submitButton = [[UIButton alloc] init];
    
    // Switch
    mondaySwitch = [[UISwitch alloc] init];
    tuesdaySwitch = [[UISwitch alloc] init];
    wednesdaySwitch = [[UISwitch alloc] init];
    thursdaySwitch = [[UISwitch alloc] init];
    fridaySwitch = [[UISwitch alloc] init];
    saturdaySwitch = [[UISwitch alloc] init];
    sundaySwitch = [[UISwitch alloc] init];
    
    // UITextView
    descriptionTextView = [[UITextView alloc] init];
    
    // UIPickerView
    departmentPicker = [[UIPickerView alloc] init];
}

-(void)addAllSubviews
{
    // Label
    [scrollView addSubview:chooseCourseLabel];
    [scrollView addSubview:myCourseLabel];
    [scrollView addSubview:courseLabel1];
    [scrollView addSubview:courseLabel2];
    [scrollView addSubview:courseLabel3];
    [scrollView addSubview:courseLabel4];
    [scrollView addSubview:courseLabel5];
    
    [scrollView addSubview:acourseLabel1];
    [scrollView addSubview:acourseLabel2];
    [scrollView addSubview:acourseLabel3];
    [scrollView addSubview:acourseLabel4];
    [scrollView addSubview:acourseLabel5];
    
    [scrollView addSubview:mondayLabel];
    [scrollView addSubview:tuesdayLabel];
    [scrollView addSubview:wednesdayLabel];
    [scrollView addSubview:thursdayLabel];
    [scrollView addSubview:fridayLabel];
    [scrollView addSubview:saturdayLabel];
    [scrollView addSubview:sundayLabel];
    [scrollView addSubview:myAvailableDaysLabel];
    [scrollView addSubview:myDescriptionLabel];
    [scrollView addSubview:myDepartmentLabel];
    [scrollView addSubview:myACourseLabel];
    [scrollView addSubview:myPriceLabel];
    
    // TextField
    [scrollView addSubview:chooseCourseTextField];
    [scrollView addSubview:departmentTextField];
    [scrollView addSubview:ACourseTextField];
    [scrollView addSubview:priceTextField];
    
    // TableView
    [scrollView addSubview:courseTableView];
    [scrollView addSubview:ACourseTableView];
    
    
    // Button
    [scrollView addSubview:deleteCourseButton1];
    [scrollView addSubview:deleteCourseButton2];
    [scrollView addSubview:deleteCourseButton3];
    [scrollView addSubview:deleteCourseButton4];
    [scrollView addSubview:deleteCourseButton5];
    
    [scrollView addSubview:adeleteCourseButton1];
    [scrollView addSubview:adeleteCourseButton2];
    [scrollView addSubview:adeleteCourseButton3];
    [scrollView addSubview:adeleteCourseButton4];
    [scrollView addSubview:adeleteCourseButton5];
    
    [scrollView addSubview:submitButton];
    
    // Switch
    [scrollView addSubview:mondaySwitch];
    [scrollView addSubview:tuesdaySwitch];
    [scrollView addSubview:wednesdaySwitch];
    [scrollView addSubview:thursdaySwitch];
    [scrollView addSubview:fridaySwitch];
    [scrollView addSubview:saturdaySwitch];
    [scrollView addSubview:sundaySwitch];
    
    // TextView
    [scrollView addSubview:descriptionTextView];
}

-(void)centerSubview:(UIView *)subView withX:(CGFloat)xCoordinate Y:(CGFloat)yCoordinate height:(CGFloat)height
{
    CGFloat width = screenWidth - 2*xCoordinate;
    subView.frame = CGRectMake(xCoordinate,yCoordinate,width,height);
}

-(void)layoutPriceBlock:(CGFloat)yCoordinate
{
    [self centerSubview:myPriceLabel withX:0 Y:yCoordinate height:30];
    [myPriceLabel setText:@"  My Price"];
    myPriceLabel.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:120.0/255.0 blue:180.0 alpha:1];
    myPriceLabel.textColor = [UIColor whiteColor];
    
    [self centerSubview:priceTextField withX:10 Y:yCoordinate + 40 height:35];
    priceTextField.layer.borderWidth = 1;
    priceTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    [priceTextField setReturnKeyType:UIReturnKeyDone];
    [priceTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [priceTextField setPlaceholder:@"input your hourly rate"];
    priceTextField.delegate = self;
}

-(void)layoutMyCoursesBlock:(CGFloat)yCoordinate
{
    [self centerSubview:myCourseLabel withX:0 Y:yCoordinate height:30];
    [myCourseLabel setText:@"  My Courses"];
    myCourseLabel.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:120.0/255.0 blue:180.0 alpha:1];
    myCourseLabel.textColor = [UIColor whiteColor];
    
    CGFloat courseLabelWidth = screenWidth * (2.0/3.0);
    CGFloat deleteButtonWidth = screenWidth * (1.0/3.0);
    
    CGFloat firstCourseLabelYCoordinate = yCoordinate + 40;
    CGFloat theHeight = 50;
    
    courseLabel1.frame = CGRectMake(0, firstCourseLabelYCoordinate, courseLabelWidth, theHeight);
    courseLabel1.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    courseLabel1.textColor = [UIColor whiteColor];
    
    deleteCourseButton1.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate, deleteButtonWidth, theHeight);
    deleteCourseButton1.backgroundColor = [UIColor redColor];
    
    CGFloat LLDistance = 55;
    
    courseLabel2.frame = CGRectMake(0, firstCourseLabelYCoordinate + LLDistance, courseLabelWidth, theHeight);
    courseLabel2.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    courseLabel2.textColor = [UIColor whiteColor];
    
    deleteCourseButton2.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate + LLDistance, deleteButtonWidth, theHeight);
    deleteCourseButton2.backgroundColor = [UIColor redColor];
    
    courseLabel3.frame = CGRectMake(0, firstCourseLabelYCoordinate + 2*LLDistance, courseLabelWidth, theHeight);
    courseLabel3.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    courseLabel3.textColor = [UIColor whiteColor];
    
    deleteCourseButton3.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate + 2*LLDistance, deleteButtonWidth, theHeight);
    deleteCourseButton3.backgroundColor = [UIColor redColor];
    
    courseLabel4.frame = CGRectMake(0, firstCourseLabelYCoordinate + 3*LLDistance, courseLabelWidth, theHeight);
    courseLabel4.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    courseLabel4.textColor = [UIColor whiteColor];
    
    deleteCourseButton4.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate + 3*LLDistance, deleteButtonWidth, theHeight);
    deleteCourseButton4.backgroundColor = [UIColor redColor];
    
    courseLabel5.frame = CGRectMake(0, firstCourseLabelYCoordinate + 4*LLDistance, courseLabelWidth, theHeight);
    courseLabel5.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    courseLabel5.textColor = [UIColor whiteColor];
    
    deleteCourseButton5.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate + 4*LLDistance, deleteButtonWidth, theHeight);
    deleteCourseButton5.backgroundColor = [UIColor redColor];
}

-(void)layoutWeekDaysBlock:(CGFloat)yCoordinate
{
    [self centerSubview:myAvailableDaysLabel withX:0 Y:yCoordinate height:35];
    [myAvailableDaysLabel setText:@"  My Available Days"];
    myAvailableDaysLabel.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:120.0/255.0 blue:180.0 alpha:1];
    myAvailableDaysLabel.textColor = [UIColor whiteColor];
    
    CGFloat dayLabelWidth = screenWidth * (2.0/3.0);
    CGFloat daySwitchWidth = screenWidth * (1.0/3.0);
    
    CGFloat firstCourseLabelYCoordinate = yCoordinate + 45;
    
    mondayLabel.frame = CGRectMake(0, firstCourseLabelYCoordinate, dayLabelWidth, 40);
    
    mondaySwitch.frame = CGRectMake(dayLabelWidth,firstCourseLabelYCoordinate + 5, daySwitchWidth, 40);
    
    CGFloat LLDistance = 55;
    
    tuesdayLabel.frame = CGRectMake(0, firstCourseLabelYCoordinate + LLDistance, dayLabelWidth, 40);
    
    tuesdaySwitch.frame = CGRectMake(dayLabelWidth,firstCourseLabelYCoordinate + 5 + LLDistance, daySwitchWidth, 40);
    
    wednesdayLabel.frame = CGRectMake(0, firstCourseLabelYCoordinate + 2*LLDistance, dayLabelWidth, 40);
    
    wednesdaySwitch.frame = CGRectMake(dayLabelWidth,firstCourseLabelYCoordinate + 5 + 2*LLDistance, daySwitchWidth, 40);
    
    thursdayLabel.frame = CGRectMake(0, firstCourseLabelYCoordinate + 3*LLDistance, dayLabelWidth, 40);
    
    thursdaySwitch.frame = CGRectMake(dayLabelWidth,firstCourseLabelYCoordinate + 5 + 3*LLDistance, daySwitchWidth, 40);
    
    fridayLabel.frame = CGRectMake(0, firstCourseLabelYCoordinate + 4*LLDistance, dayLabelWidth, 40);
    
    fridaySwitch.frame = CGRectMake(dayLabelWidth,firstCourseLabelYCoordinate + 5 + 4*LLDistance, daySwitchWidth, 40);
    
    saturdayLabel.frame = CGRectMake(0, firstCourseLabelYCoordinate + 5*LLDistance, dayLabelWidth, 40);
    
    saturdaySwitch.frame = CGRectMake(dayLabelWidth,firstCourseLabelYCoordinate + 5 + 5*LLDistance, daySwitchWidth, 40);
    
    sundayLabel.frame = CGRectMake(0, firstCourseLabelYCoordinate + 6*LLDistance, dayLabelWidth, 40);
    
    sundaySwitch.frame = CGRectMake(dayLabelWidth,firstCourseLabelYCoordinate + 5 + 6*LLDistance, daySwitchWidth, 40);
    
}

-(void)layoutMyDescriptionAndDepartmentBlock:(CGFloat)yCoordinate
{
    [self centerSubview:myDescriptionLabel withX:0 Y:yCoordinate height:35];
    [myDescriptionLabel setText:@"  My Description"];
    myDescriptionLabel.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:120.0/255.0 blue:180.0 alpha:1];
    myDescriptionLabel.textColor = [UIColor whiteColor];
    
    [self centerSubview:descriptionTextView withX:10 Y:yCoordinate + 45 height:200];
    descriptionTextView.layer.borderWidth = 1;
    descriptionTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    [descriptionTextView setReturnKeyType:UIReturnKeyDone];
    descriptionTextView.delegate = self;
    
    
    [self centerSubview:myDepartmentLabel withX:0 Y:yCoordinate + 260 height:35];
    [myDepartmentLabel setText:@"  My Department"];
    myDepartmentLabel.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:120.0/255.0 blue:180.0 alpha:1];
    myDepartmentLabel.textColor = [UIColor whiteColor];
    
    [self centerSubview:departmentTextField withX:10 Y:yCoordinate + 305 height:35];
    departmentTextField.layer.borderWidth = 1;
    departmentTextField.layer.borderColor = [[UIColor blackColor] CGColor];
}

-(void)layoutACoursesBlocks:(CGFloat)yCoordinate
{
    [self centerSubview:myACourseLabel withX:0 Y:yCoordinate height:35];
    [myACourseLabel setText:@"  A+/A/A- courses"];
    myACourseLabel.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:120.0/255.0 blue:180.0 alpha:1];
    myACourseLabel.textColor = [UIColor whiteColor];
    
    [self centerSubview:ACourseTextField withX:10 Y:yCoordinate + 45 height:35];
    ACourseTextField.layer.borderWidth = 1;
    ACourseTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    [ACourseTextField setPlaceholder:@"input the course with grade > A-"];
    
    CGFloat firstCourseLabelYCoordinate = yCoordinate + 90;
    
    [self layoutACoursesAndButtons:firstCourseLabelYCoordinate];
    
}

-(void)layoutACoursesAndButtons:(CGFloat)firstCourseLabelYCoordinate
{
    CGFloat courseLabelWidth = screenWidth * (2.0/3.0);
    CGFloat deleteButtonWidth = screenWidth * (1.0/3.0);
    CGFloat theHeight = 50;
    
    acourseLabel1.frame = CGRectMake(0, firstCourseLabelYCoordinate, courseLabelWidth, theHeight);
    acourseLabel1.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    acourseLabel1.textColor = [UIColor whiteColor];
    
    adeleteCourseButton1.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate, deleteButtonWidth, theHeight);
    adeleteCourseButton1.backgroundColor = [UIColor redColor];
    
    CGFloat LLDistance = 55;
    
    acourseLabel2.frame = CGRectMake(0, firstCourseLabelYCoordinate + LLDistance, courseLabelWidth, theHeight);
    acourseLabel2.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    acourseLabel2.textColor = [UIColor whiteColor];
    
    adeleteCourseButton2.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate + LLDistance, deleteButtonWidth, theHeight);
    adeleteCourseButton2.backgroundColor = [UIColor redColor];
    
    acourseLabel3.frame = CGRectMake(0, firstCourseLabelYCoordinate + 2*LLDistance, courseLabelWidth, theHeight);
    acourseLabel3.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    acourseLabel3.textColor = [UIColor whiteColor];
    
    adeleteCourseButton3.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate + 2*LLDistance, deleteButtonWidth, theHeight);
    adeleteCourseButton3.backgroundColor = [UIColor redColor];
    
    acourseLabel4.frame = CGRectMake(0, firstCourseLabelYCoordinate + 3*LLDistance, courseLabelWidth, theHeight);
    acourseLabel4.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    acourseLabel4.textColor = [UIColor whiteColor];
    
    adeleteCourseButton4.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate + 3*LLDistance, deleteButtonWidth, theHeight);
    adeleteCourseButton4.backgroundColor = [UIColor redColor];
    
    acourseLabel5.frame = CGRectMake(0, firstCourseLabelYCoordinate + 4*LLDistance, courseLabelWidth, theHeight);
    acourseLabel5.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:178.0/255.0 blue:255.0 alpha:1];
    acourseLabel5.textColor = [UIColor whiteColor];
    
    adeleteCourseButton5.frame = CGRectMake(courseLabelWidth, firstCourseLabelYCoordinate + 4*LLDistance, deleteButtonWidth, theHeight);
    adeleteCourseButton5.backgroundColor = [UIColor redColor];
}

-(void)layoutIfNeededAllBlocks
{
    [myCourseLabel layoutIfNeeded];
    [courseLabel1 layoutIfNeeded];
    [courseLabel2 layoutIfNeeded];
    [courseLabel3 layoutIfNeeded];
    [courseLabel4 layoutIfNeeded];
    [deleteCourseButton1 layoutIfNeeded];
    [deleteCourseButton2 layoutIfNeeded];
    [deleteCourseButton3 layoutIfNeeded];
    [deleteCourseButton4 layoutIfNeeded];
    
    [acourseLabel1 layoutIfNeeded];
    [acourseLabel2 layoutIfNeeded];
    [acourseLabel3 layoutIfNeeded];
    [acourseLabel4 layoutIfNeeded];
    [adeleteCourseButton1 layoutIfNeeded];
    [adeleteCourseButton2 layoutIfNeeded];
    [adeleteCourseButton3 layoutIfNeeded];
    [adeleteCourseButton4 layoutIfNeeded];
    
    [mondayLabel layoutIfNeeded];
    [tuesdayLabel layoutIfNeeded];
    [wednesdayLabel layoutIfNeeded];
    [thursdayLabel layoutIfNeeded];
    [fridayLabel layoutIfNeeded];
    [saturdayLabel layoutIfNeeded];
    [sundayLabel layoutIfNeeded];
    
    [mondaySwitch layoutIfNeeded];
    [tuesdaySwitch layoutIfNeeded];
    [wednesdaySwitch layoutIfNeeded];
    [thursdaySwitch layoutIfNeeded];
    [fridaySwitch layoutIfNeeded];
    [saturdaySwitch layoutIfNeeded];
    [sundaySwitch layoutIfNeeded];
    
    [myDescriptionLabel layoutIfNeeded];
    [descriptionTextView layoutIfNeeded];
    
    [myDepartmentLabel layoutIfNeeded];
    [departmentTextField layoutIfNeeded];
}


-(void)hideCourseLabelAndButtonNumber:(int)number YorN:(BOOL)YN
{
    if(number == 1)
    {
        [courseLabel1 setHidden:YN];
        [deleteCourseButton1 setHidden:YN];
    }
    else if(number == 2)
    {
        [courseLabel2 setHidden:YN];
        [deleteCourseButton2 setHidden:YN];
    }
    else if(number == 3)
    {
        [courseLabel3 setHidden:YN];
        [deleteCourseButton3 setHidden:YN];
    }
    else if(number == 4)
    {
        [courseLabel4 setHidden:YN];
        [deleteCourseButton4 setHidden:YN];
    }
    else
    {
        [courseLabel5 setHidden:YN];
        [deleteCourseButton5 setHidden:YN];
    }
}

-(void)hideACourseLabelAndButtonNumber:(int)number YorN:(BOOL)YN
{
    if(number == 1)
    {
        [acourseLabel1 setHidden:YN];
        [adeleteCourseButton1 setHidden:YN];
    }
    else if(number == 2)
    {
        [acourseLabel2 setHidden:YN];
        [adeleteCourseButton2 setHidden:YN];
    }
    else if(number == 3)
    {
        [acourseLabel3 setHidden:YN];
        [adeleteCourseButton3 setHidden:YN];
    }
    else if(number == 4)
    {
        [acourseLabel4 setHidden:YN];
        [adeleteCourseButton4 setHidden:YN];
    }
    else
    {
        [acourseLabel5 setHidden:YN];
        [adeleteCourseButton5 setHidden:YN];
    }
}

-(void)setCourseLabelNumber:(int)number toString:(NSString *)string
{
    NSString *theString = [@" " stringByAppendingString:string];
    if(number == 1)
    {
        [courseLabel1 setText:theString];
    }
    else if(number == 2)
    {
        [courseLabel2 setText:theString];
    }
    else if(number == 3)
    {
        [courseLabel3 setText:theString];
    }
    else if(number == 4)
    {
        [courseLabel4 setText:theString];
    }
    else
    {
        [courseLabel5 setText:theString];
    }
}

-(void)setACourseLabelNumber:(int)number toString:(NSString *)string
{
    NSString *theString = [@" " stringByAppendingString:string];
    if(number == 1)
    {
        [acourseLabel1 setText:theString];
    }
    else if(number == 2)
    {
        [acourseLabel2 setText:theString];
    }
    else if(number == 3)
    {
        [acourseLabel3 setText:theString];
    }
    else if(number == 4)
    {
        [acourseLabel4 setText:theString];
    }
    else
    {
        [acourseLabel5 setText:theString];
    }
}

-(void)hideCourseTableView:(BOOL)YN AndSetYOfMyCoursesBlock:(CGFloat)yCoordinate
{
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.2];
    
    [courseTableView setHidden:YN];
    [self layoutMyCoursesBlock:yCoordinate];
    [self layoutWeekDaysBlock:yCoordinate + 340];
    [self layoutMyDescriptionAndDepartmentBlock:yCoordinate + 800];
    [self layoutACoursesBlocks:yCoordinate + 1160];
    [self layoutIfNeededAllBlocks];
    
    
    [UIView commitAnimations];
}

-(void)hideACourseTableView:(BOOL)YN AndSetYOfACoursesAndButtons:(CGFloat)yCoordinate
{
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.2];
    
    [ACourseTableView setHidden:YN];
    
    [self layoutACoursesAndButtons:yCoordinate + 5];
    [self centerSubview:submitButton withX:40 Y:yCoordinate + 500 height:60];
    [self layoutIfNeededAllBlocks];
    
    
    [UIView commitAnimations];
}




@end

