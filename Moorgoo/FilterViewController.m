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
    UIPickerView *classPicker;
    NSMutableArray *pickerSchoolArray;
    NSMutableArray *pickerClassArray;
}
@property (weak, nonatomic) IBOutlet UITextField *schoolTextField;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@end

@implementation FilterViewController
@synthesize filter, tutorArray, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"school: %@", filter.collegeClassTutorSchool);
    NSLog(@"course: %@", filter.collegeClassTutorCourse);
    NSLog(@"price: %@", filter.collegeClassTutorPrice);
    self.schoolTextField.text = filter.collegeClassTutorSchool;
    self.classTextField.text = filter.collegeClassTutorCourse;
    self.priceTextField.text = filter.collegeClassTutorPrice;
    
    /*******************************************************************************/
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    /*******************************************************************************/
    
    filter = [[SearchFilter alloc] init];
    [self addSchoolPicker];
    [self addClassPicker];
    
    
    
    //self.schoolTextField.delegate = self;
    //self.classTextField.delegate = self;
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
    if(pickerView == schoolPicker)
        return pickerSchoolArray.count;
    else
        return pickerClassArray.count;
}

#pragma mark- Picker View Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    if(pickerView == schoolPicker)
        return [pickerSchoolArray objectAtIndex:row];
    else
        return [pickerClassArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if(pickerView == schoolPicker)
        self.schoolTextField.text = [NSString stringWithFormat:@"%@", [pickerSchoolArray objectAtIndex:row]];
    else
        self.classTextField.text = [NSString stringWithFormat:@"%@", [pickerClassArray objectAtIndex:row]];
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
-(void)addClassPicker{
    pickerClassArray = [[NSMutableArray alloc]init];
    [self getCourses];
    
    classPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    classPicker.delegate = self;
    classPicker.dataSource = self;
    [classPicker setShowsSelectionIndicator:YES];
    self.classTextField.inputView = classPicker;
    
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
    self.classTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked2
{
    //NSLog(@"Done Clicked");
    [self.classTextField resignFirstResponder];
}

-(void)getCourses{
    [pickerClassArray addObject:@""];
    
    for(CollegeClassTutor *tutor in tutorArray){
        for(NSString *course in tutor.courses){
            if(![pickerClassArray containsObject:course]){
                [pickerClassArray addObject:course];
            }
        }
    }
    //sort the array according to character
    [pickerClassArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}
/*************************************************************************************/


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

@end
