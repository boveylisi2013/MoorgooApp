//
//  FilterViewController.m
//  Moorgoo
//
//  Created by SI  on 3/3/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "FilterViewController.h"

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
@synthesize filter, tutorArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    /*******************************************************************************/
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    /*******************************************************************************/
    
    [self addSchoolPicker];
    //[self addClassPicker];
    
    //self.schoolTextField.delegate = self;
    //self.TextField.delegate = self;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
}

-(void)pickerDoneClicked
{
    [self.schoolTextField resignFirstResponder];
}
/*************************************************************************************/
//UIpicker view replace keyborad for department
//-(void)addDepartmentPicker{
//    pickerClassArray = [[NSMutableArray alloc]init];
//    [self getDepartments];
//    
//    departmentPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
//    departmentPicker.delegate = self;
//    departmentPicker.dataSource = self;
//    [departmentPicker setShowsSelectionIndicator:YES];
//    departmentRegisterTextField.inputView = departmentPicker;
//    
//    // Create done button in UIPickerView
//    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
//    [mypickerToolbar sizeToFit];
//    NSMutableArray *barItems = [[NSMutableArray alloc] init];
//    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    [barItems addObject:flexSpace];
//    
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked2)];
//    [barItems addObject:doneBtn];
//    
//    [mypickerToolbar setItems:barItems animated:YES];
//    departmentRegisterTextField.inputAccessoryView = mypickerToolbar;
//}
//
//-(void)pickerDoneClicked2
//{
//    //NSLog(@"Done Clicked");
//    [departmentRegisterTextField resignFirstResponder];
//}
//
-(void)getCourses{
    for(CollegeClassTutor *tutor in tutorArray){
        for(NSString *course in tutor.courses){
            if(![pickerClassArray containsObject:course]){
                [pickerClassArray addObject:course];
            }
        }
    }
}
/*************************************************************************************/

- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"backToTutorList" sender:self];
}

@end
