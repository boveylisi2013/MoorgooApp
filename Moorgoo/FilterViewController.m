//
//  FilterViewController.m
//  Moorgoo
//
//  Created by SI  on 3/3/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "FilterViewController.h"
#import "FindTutorTableViewController.h"

@interface FilterViewController (){
    UIPickerView *schoolPicker;

    NSMutableArray *pickerSchoolArray;
    
    NSMutableArray *flexibleClassArray;
    NSMutableArray *stableClassArray;
    
    BOOL noClassFound;
}
@property (weak, nonatomic) IBOutlet UITextField *schoolTextField;

@end

@implementation FilterViewController
@synthesize filter, tutorArray, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSLog(@"school: %@", filter.collegeClassTutorSchool);
//    NSLog(@"course: %@", filter.collegeClassTutorCourse);
//    NSLog(@"price: %@", filter.collegeClassTutorPrice);

//    self.schoolTextField.text = filter.collegeClassTutorSchool;
//    self.priceTextField.text = filter.collegeClassTutorPrice;
//    
//    if([self.schoolTextField.text length] != 0)
//    {
//        [self getCourses:flexibleClassArray];
//        [self getCourses:stableClassArray];
//        [self.courseTableView reloadData];
//    }
    
    /*******************************************************************************/
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // prevent the touch event to the table view being eaten by the tap
    [tap setCancelsTouchesInView:NO];
    /*******************************************************************************/
    
    filter = [[SearchFilter alloc] init];
    [self addSchoolPicker];
    
    /*******************************************************************************/
    
    if([self.schoolTextField.text isEqualToString:@""]) {
        self.classTextField.userInteractionEnabled = FALSE;
        self.schoolTextField.layer.borderColor = [[UIColor redColor] CGColor];
        self.schoolTextField.layer.borderWidth = 1.0;
    }
    else {
        self.classTextField.userInteractionEnabled = TRUE;
        self.schoolTextField.layer.borderWidth = 0.0;

    }

    /*******************************************************************************/
    //self.schoolTextField.delegate = self;
    self.classTextField.delegate = self;
    
    /*******************************************************************************/
    flexibleClassArray = [[NSMutableArray alloc] init];
    stableClassArray = [[NSMutableArray alloc] init];
    
    [self.courseTableView setHidden:TRUE];
    self.perhourVerticalSpaceLayout.constant = 15;
    self.maxpriceVerticalSpaceLayout.constant = 15;
    
    /*******************************************************************************/
    // Add the method to detect change in the specficClassTextField
    [self.classTextField addTarget:self
                                    action:@selector(textFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
    
    /*******************************************************************************/
    self.courseTableView.delegate = self;
    self.courseTableView.dataSource = self;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    if(filter.collegeClassTutorSchool != nil) {
        self.schoolTextField.text = filter.collegeClassTutorSchool;
    }
    if(filter.collegeClassTutorCourse != nil) {
        self.classTextField.text = filter.collegeClassTutorCourse;
    }
    if(filter.collegeClassTutorPrice != nil) {
        self.priceTextField.text = filter.collegeClassTutorPrice;
    }
}

/*************************************************************************************/
#pragma mark - Picker View Data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    return pickerSchoolArray.count;
}

#pragma mark- Picker View Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return [pickerSchoolArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    
    self.schoolTextField.text = [NSString stringWithFormat:@"%@", [pickerSchoolArray objectAtIndex:row]];
    self.classTextField.text = @"";
    
    if([self.schoolTextField.text isEqualToString:@""]) {
        self.classTextField.userInteractionEnabled = FALSE;
        self.classTextField.text = @"";
        self.schoolTextField.layer.borderColor = [[UIColor redColor] CGColor];        
        self.schoolTextField.layer.borderWidth = 1.0;
    }
    else {
        self.schoolTextField.layer.borderWidth = 0.0;
        self.classTextField.userInteractionEnabled = TRUE;
        
        [self getCourses:flexibleClassArray];
        [self getCourses:stableClassArray];
        NSLog(@"flexibleClassArray: %@", flexibleClassArray);
        NSLog(@"stableClassArray: %@", stableClassArray);
    }
}


/*************************************************************************************/
//UIpicker view replace keyborad for school
-(void)addSchoolPicker{
    pickerSchoolArray = [[NSMutableArray alloc]init];
    [self getSchools];
    
    schoolPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    schoolPicker.delegate = self;
    schoolPicker.dataSource = self;
    [schoolPicker setShowsSelectionIndicator:YES];
    self.schoolTextField.inputView = schoolPicker;
    
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
    self.schoolTextField.inputAccessoryView = mypickerToolbar;
}

-(void)getSchools {
    [pickerSchoolArray addObject:@""];
    for(CollegeClassTutor *tutor in tutorArray){
        if(![pickerSchoolArray containsObject:tutor.school]){
            [pickerSchoolArray addObject:tutor.school];
        }
    }
    
    [pickerSchoolArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

-(void)pickerDoneClicked
{
    [self.schoolTextField resignFirstResponder];
}
/***********************************************************************************/

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
/*************************************************************************************/
# pragma mark - table view delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"in numberofrows, count: %d", [flexibleClassArray count]);
//    for(NSString *ts in flexibleClassArray)
//        NSLog(@"in numrows: class is %@", ts);
    
    if([flexibleClassArray count] != 0)
        return [flexibleClassArray count];
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseItem"];
    
    // configure text for cell
    UILabel *label = (UILabel *)[cell viewWithTag:550];
    
    if ([flexibleClassArray count] != 0)
    {
        label.text = flexibleClassArray[indexPath.row];
        noClassFound = false;
    }
    else
    {
        label.text = @"No tutor is available for this class";
        noClassFound = true;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:550];
    if(!noClassFound)
    {
        NSString *chosenString = label.text;
        self.classTextField.text = chosenString;
    }
    
    [self.courseTableView setHidden:YES];
    self.perhourVerticalSpaceLayout.constant = 15;
    self.maxpriceVerticalSpaceLayout.constant = 15;
    
    [self.view endEditing:YES];
    //ChecklistItem *item = _items[indexPath.row];
}

/*************************************************************************************/
- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender {
    filter.collegeClassTutorSchool = self.schoolTextField.text;
    filter.collegeClassTutorCourse = self.classTextField.text;
    filter.collegeClassTutorPrice = self.priceTextField.text;
    
    //[self performSegueWithIdentifier:@"backToTutorList" sender:self];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(applyFilterToFetchTutors:)]) {
        [self.delegate applyFilterToFetchTutors:filter];
    }
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
        [UIView beginAnimations: nil context: NULL];
        [UIView setAnimationDuration: 0.2];
        
        [self.courseTableView setHidden:YES];
        self.perhourVerticalSpaceLayout.constant = 15;
        self.maxpriceVerticalSpaceLayout.constant = 15;
        
        [self.perHourLabel layoutIfNeeded];
        [self.priceTextField layoutIfNeeded];
        [self.courseTableView layoutIfNeeded];
        
        [UIView commitAnimations];

//        self.next.enabled = NO; DO WE NEED TO DISABLE SEARCH BUTTON???????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    }
    else
    {
//        self.next.enabled = !textFieldIsEmpty;
        [UIView beginAnimations: nil context: NULL];
        [UIView setAnimationDuration: 0.2];
        
        [self.courseTableView setHidden:NO];
        self.perhourVerticalSpaceLayout.constant = 266;
        self.maxpriceVerticalSpaceLayout.constant = 266;
        
        [self.perHourLabel layoutIfNeeded];
        [self.priceTextField layoutIfNeeded];
        [self.courseTableView layoutIfNeeded];
        
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
        [self.courseTableView reloadData];
    }
    
}

@end
