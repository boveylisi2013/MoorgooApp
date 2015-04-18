//
//  NewPostViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 3/29/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController () <UIAlertViewDelegate>
{
    UIColor *originalColor;
    
    NSMutableArray *flexibleClassArray;
    NSMutableArray *stableClassArray;
    
    BOOL noClassFound;
    
    NSMutableArray *subviews;
    NSMutableArray *textFields;
    NSMutableArray *buttons;
    
    UIPickerView *helpPicker;
    NSMutableArray *pickerHelpArray;
    
    UIPickerView *hourPicker;
    NSMutableArray *pickerHourArray;
}
@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.hud];
    /*******************************************************************************/
    self.navigationItem.title = @"New Post";
    /*******************************************************************************/

    
    originalColor = self.view.backgroundColor;
    /*******************************************************************************/
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.courseTextField.delegate = self;
    [self.courseTextField setReturnKeyType:UIReturnKeyDone];
    
    /*******************************************************************************/
    // Add the method to detect change in the specficClassTextField
    [self.courseTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    
    /*******************************************************************************/
    // Use code to hide dateLabels and canelButtons
    [self.dateLabel1 setHidden:true];
    [self.dateLabel2 setHidden:true];
    [self.dateLabel3 setHidden:true];
    [self.dateLabel4 setHidden:true];
    [self.cancelButton1 setHidden:true];
    [self.cancelButton2 setHidden:true];
    [self.cancelButton3 setHidden:true];
    [self.cancelButton4 setHidden:true];
    
    /*******************************************************************************/
    flexibleClassArray = [[NSMutableArray alloc] init];
    stableClassArray = [[NSMutableArray alloc] init];
    
    for(NSString *course in allCourseFromParse){
        [flexibleClassArray addObject:course];
        [stableClassArray addObject:course];
    }
    
    /*******************************************************************************/
    subviews= [[NSMutableArray alloc] init];
    
    [subviews addObject:self.tableView];
    [subviews addObject:self.courseTextField];
    [subviews addObject:self.helptypeTextField];
    [subviews addObject:self.hourTextField];
    [subviews addObject:self.moneyTextField];
    [subviews addObject:self.dateLabel1];
    [subviews addObject:self.dateLabel2];
    [subviews addObject:self.dateLabel3];
    [subviews addObject:self.dateLabel4];
    [subviews addObject:self.addADateButton];
    [subviews addObject:self.cancelButton1];
    [subviews addObject:self.cancelButton2];
    [subviews addObject:self.cancelButton3];
    [subviews addObject:self.cancelButton4];
    [subviews addObject:self.hourLabel];
    [subviews addObject:self.perhourLabel];
    [subviews addObject:self.postButton];
    
    textFields = [[NSMutableArray alloc] init];
    
    [textFields addObject:self.helptypeTextField];
    [textFields addObject:self.hourTextField];
    [textFields addObject:self.moneyTextField];
    
    buttons = [[NSMutableArray alloc] init];

    [buttons addObject:self.addADateButton];
    [buttons addObject:self.cancelButton1];
    [buttons addObject:self.cancelButton2];
    [buttons addObject:self.cancelButton3];
    [buttons addObject:self.cancelButton4];
    [buttons addObject:self.postButton];
    
    /*******************************************************************************/

    [self addHelpPicker];
    [self addHourPicker];
    
    [self.moneyTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    /*******************************************************************************/
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // prevent the touch event to the table view being eaten by the tap
    [tap setCancelsTouchesInView:NO];
    /*******************************************************************************/
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
}

# pragma mark - dismissKeyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*************************************************************************************/
# pragma mark - table view delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [flexibleClassArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    
    // configure text for cell
    UILabel *label = (UILabel *)[cell viewWithTag:650];
    
    if ([flexibleClassArray count] != 0)
    {
        label.text = flexibleClassArray[indexPath.row];
        noClassFound = false;
    }
    else
    {
        label.text = @"";
        noClassFound = true;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:650];
    if(!noClassFound)
    {
        NSString *chosenString = label.text;
        self.courseTextField.text = chosenString;
    }
    
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.delaysContentTouches = YES;
    self.scrollView.scrollEnabled = YES;
    
    [self enableButtons:buttons TextFields:textFields TF:YES];
    
    // UI / Animation
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.2];
    
    [self.tableView setHidden:YES];
    
    if(self.helpTypeVerticalLayout.constant != 15)
        self.helpTypeVerticalLayout.constant -= 251;
    
    [self layoutSubviews:subviews];
    
    [UIView commitAnimations];

    [self.view endEditing:YES];
}

/*************************************************************************************/
#pragma mark - Picker View Data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    if(pickerView == helpPicker)
        return pickerHelpArray.count;
    else
        return pickerHourArray.count;
}

#pragma mark- Picker View Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    if(pickerView == helpPicker)
        return [pickerHelpArray objectAtIndex:row];
    else
        return [pickerHourArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if(pickerView == helpPicker)
        self.helptypeTextField.text = [NSString stringWithFormat:@"%@", [pickerHelpArray objectAtIndex:row]];
    else
        self.hourTextField.text = [NSString stringWithFormat:@"%@", [pickerHourArray objectAtIndex:row]];

}

/*************************************************************************************/
// Helper method which checks whether one string contains another string
-(BOOL)string:(NSString *)string_1 containsString:(NSString *)string_2
{
    return !([string_1 rangeOfString:string_2].location == NSNotFound);
}

#pragma mark - textField delegate methods

// the method which will be called when specificClassTextField is changed
// this method is added as a selector to specficClassTextField
-(void)textFieldDidChange:(UITextField *)textField
{
    //BOOL textFieldIsEmpty = (self.pickHelpTextField.text.length == 0 || self.specificClassTextField.text.length == 0);
    if (textField.text.length == 0)
    {
        self.scrollView.canCancelContentTouches = YES;
        self.scrollView.delaysContentTouches = YES;
        self.scrollView.scrollEnabled = YES;

        [self enableButtons:buttons TextFields:textFields TF:YES];
        
        [UIView beginAnimations: nil context: NULL];
        [UIView setAnimationDuration: 0.2];
        
        [self.tableView setHidden:YES];
        
        if(self.helpTypeVerticalLayout.constant != 15)
            self.helpTypeVerticalLayout.constant -= 251;
        
        [self layoutSubviews:subviews];

        [UIView commitAnimations];        
    }
    else
    {
        self.scrollView.canCancelContentTouches = NO;
        self.scrollView.delaysContentTouches = NO;
        self.scrollView.scrollEnabled = NO;
        
        [self enableButtons:buttons TextFields:textFields TF:NO];
        
        //        self.next.enabled = !textFieldIsEmpty;
        [UIView beginAnimations: nil context: NULL];
        [UIView setAnimationDuration: 0.2];
        
        [self.tableView setHidden:NO];
        
        if(self.helpTypeVerticalLayout.constant != 266)
            self.helpTypeVerticalLayout.constant += 251;

        [self layoutSubviews:subviews];
        
        [UIView commitAnimations];

        
        NSString *inputString = [textField.text uppercaseString];
        NSMutableArray *discardItems = [[NSMutableArray alloc] init];
        
        // Filter out classes based on user input
        for (NSString *currentString in flexibleClassArray)
        {
            if(![self string:currentString containsString:inputString])
                [discardItems addObject:currentString];
        }
        [flexibleClassArray removeObjectsInArray:discardItems];
        
        // Add classes back when user delete characters
        for (NSString *currentString in stableClassArray)
        {
            if([self string:currentString containsString:inputString])
                if(![flexibleClassArray containsObject:currentString])
                    [flexibleClassArray addObject:currentString];
        }
        [self.tableView reloadData];
    }
    
    
    
}

/*************************************************************************************/

#pragma mark - button pressed methods

- (IBAction)addADateButtonPressed:(UIButton *)sender
{
    self.scrollView.canCancelContentTouches = NO;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.scrollEnabled = NO;
    
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.4];
    
    self.view.backgroundColor = [UIColor colorWithRed:10.0f green:10.0f blue:10.0f alpha:0.3f];

    [self setAlphaOfSubviews:subviews ToValue:0.1f];
    
    self.courseTextField.enabled = NO;
    [self enableButtons:buttons TextFields:textFields TF:NO];

    
    [self.datePicker setHidden:false];
    [self.selectButton setHidden:false];
    self.datePickerYAlignment.constant = 15;
    
    [self.datePicker layoutIfNeeded];
    [self.selectButton layoutIfNeeded];
    
    [UIView commitAnimations];

}

/*************************************************************************************/

- (IBAction)selectButtonPressed:(UIButton *)sender
{
    // Animation
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.delaysContentTouches = YES;
    self.scrollView.scrollEnabled = YES;
    
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.4];
    
    self.view.backgroundColor = originalColor;
    
    [self setAlphaOfSubviews:subviews ToValue:1.0f];
    
    self.courseTextField.enabled = YES;
    [self enableButtons:buttons TextFields:textFields TF:YES];

    
    [self.datePicker setHidden:true];
    [self.selectButton setHidden:true];
    self.datePickerYAlignment.constant = -198;
    
    
    [self.datePicker layoutIfNeeded];
    [self.selectButton layoutIfNeeded];
    
    [UIView commitAnimations];
    
    // Non - Animation
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm"];
    
    NSDate *chosenDate = [self.datePicker date];
    NSString *dateString = [dateFormatter stringFromDate:chosenDate];
    
    if(self.dateLabel1.hidden == true)
    {
        self.dateLabel1.text = dateString;
        [self.dateLabel1 setHidden:false];
        [self.cancelButton1 setHidden:false];
    }
    else if(self.dateLabel2.hidden == true)
    {
        self.dateLabel2.text = dateString;
        [self.dateLabel2 setHidden:false];
        [self.cancelButton2 setHidden:false];
    }
    else if(self.dateLabel3.hidden == true)
    {
        self.dateLabel3.text = dateString;
        [self.dateLabel3 setHidden:false];
        [self.cancelButton3 setHidden:false];
    }
    else if(self.dateLabel4.hidden == true)
    {
        self.dateLabel4.text = dateString;
        [self.dateLabel4 setHidden:false];
        [self.cancelButton4 setHidden:false];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You can add at most 4 schedule"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)cancelButton1Pressed:(UIButton *)sender {
    [self.dateLabel1 setHidden:true];
    [self.cancelButton1 setHidden:true];
}

- (IBAction)cancelButton2Pressed:(UIButton *)sender {
    [self.dateLabel2 setHidden:true];
    [self.cancelButton2 setHidden:true];
}

- (IBAction)cancelButton3Pressed:(UIButton *)sender {
    [self.dateLabel3 setHidden:true];
    [self.cancelButton3 setHidden:true];
}

- (IBAction)cancelButton4Pressed:(UIButton *)sender {
    [self.dateLabel4 setHidden:true];
    [self.cancelButton4 setHidden:true];
}

#pragma mark - datePicker set method
-(void)datePickerChanged:(UIDatePicker *)datePicker
{
    self.datePicker = datePicker;
    NSDate *chosenDate = [datePicker date];
    
    NSDate *CurrentDate = [NSDate date];
    if([CurrentDate compare:chosenDate] == NSOrderedDescending)
    {
        [datePicker setDate:CurrentDate];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
}

#pragma mark - encapsulation methods
// Helper methods to encapsulate chunk of codes

-(void)layoutSubviews:(NSMutableArray *)arrayOfSubviews
{
    for (UIView *subView in arrayOfSubviews)
    {
        [subView layoutIfNeeded];
    }
}

-(void)setAlphaOfSubviews:(NSMutableArray *)arrayOfSubviews ToValue:(CGFloat)alpha
{
    for(UIView *subview in arrayOfSubviews)
    {
        subview.alpha = alpha;
    }
}

-(void)enableButtons:(NSMutableArray *)buttonsArray TextFields:(NSMutableArray *)textFieldsArray TF:(BOOL)enabled
{
    for(UIButton *button in buttonsArray)
    {
        button.enabled = enabled;
    }
    
    for(UITextField *textField in textFieldsArray)
    {
        textField.enabled = enabled;
    }
}

// Helper method to add the picker
-(void)addHelpPicker
{
    pickerHelpArray = [[NSMutableArray alloc]init];
    
    [pickerHelpArray addObject:@""];
    [pickerHelpArray addObject:@"Homework Help"];
    [pickerHelpArray addObject:@"Lab Assignment Help"];
    [pickerHelpArray addObject:@"Exam Review"];
    [pickerHelpArray addObject:@"Lecture Review"];
    [pickerHelpArray addObject:@"Project Help"];
    [pickerHelpArray addObject:@"Quiz Review"];
    
    
    helpPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    helpPicker.delegate = self;
    helpPicker.dataSource = self;
    [helpPicker setShowsSelectionIndicator:YES];
    self.helptypeTextField.inputView = helpPicker;
    
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
    self.helptypeTextField.inputAccessoryView = mypickerToolbar;
}

-(void)addHourPicker
{
    pickerHourArray = [[NSMutableArray alloc]init];
    
    [pickerHourArray addObject:@""];
    [pickerHourArray addObject:@"1"];
    [pickerHourArray addObject:@"2"];
    [pickerHourArray addObject:@"3"];
    [pickerHourArray addObject:@"4"];
    [pickerHourArray addObject:@"5"];

    hourPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    hourPicker.delegate = self;
    hourPicker.dataSource = self;
    [hourPicker setShowsSelectionIndicator:YES];
    self.hourTextField.inputView = hourPicker;
    
    // Create done button in UIPickerView
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked2)];
    [barItems addObject:doneBtn];
    
    [mypickerToolbar setItems:barItems animated:YES];
    self.hourTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked
{
    [self.helptypeTextField resignFirstResponder];
}

-(void)pickerDoneClicked2
{
    [self.hourTextField resignFirstResponder];
}

- (IBAction)postButtonClicked:(id)sender {
    
    // The string contains all possible errors
    NSString *errorString = @"";
    
    if (self.courseTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input the course\n"];
    }
    if (self.helptypeTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input help type\n"];
    }
    if (self.hourTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input number of hours\n"];
    }
    if (self.moneyTextField.text.length == 0){
        errorString = [errorString stringByAppendingString:@"Please input hourly rate\n"];
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
        NSMutableArray *timeArray = [[NSMutableArray alloc] init];
        if(![self.dateLabel1 isHidden])
            [timeArray addObject:self.dateLabel1.text];
        if(![self.dateLabel2 isHidden])
            [timeArray addObject:self.dateLabel2.text];
        if(![self.dateLabel3 isHidden])
            [timeArray addObject:self.dateLabel3.text];
        if(![self.dateLabel4 isHidden])
            [timeArray addObject:self.dateLabel4.text];
        
        [self.hud show:TRUE];
        
        PFObject *userPointer = [PFObject objectWithoutDataWithClassName:@"_User" objectId:([PFUser currentUser]).objectId];
        
        PFObject *studentPost = [PFObject objectWithClassName:@"StudentPost"];
        [studentPost setObject:userPointer forKey:@"userId"];
        [studentPost setObject:self.courseTextField.text forKey:@"course"];
        [studentPost setObject:self.helptypeTextField.text forKey:@"typeOfHelp"];
        [studentPost setObject:self.hourTextField.text forKey:@"numOfHour"];
        [studentPost setObject:self.moneyTextField.text forKey:@"ratePerHour"];
        [studentPost setObject:timeArray forKey:@"datePicked"];
        [studentPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error) {
                [[[UIAlertView alloc] initWithTitle:nil message:@"Your posts have been successfully uploaded! You could delete your post in the account setting page." delegate:nil cancelButtonTitle:@"Got ya!" otherButtonTitles:nil, nil] show];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your request is failed. Please try again!" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil] show];
            }
            [self.hud hide:TRUE];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}


@end
