//
//  NewPostViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 3/29/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController ()
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
}
@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    originalColor = self.view.backgroundColor;
    /*******************************************************************************/
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    self.datePickerYAlignment.constant = 150;
    
    [self.datePicker layoutIfNeeded];
    [self.selectButton layoutIfNeeded];
    
    [UIView commitAnimations];

}

/*************************************************************************************/

- (IBAction)selectButtonPressed:(UIButton *)sender
{
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


@end
