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
    
    UITextField *chooseCourseTextField;
    
    UITableView *courseTableView;
    
    UIButton *deleteCourseButton1;
    UIButton *deleteCourseButton2;
    UIButton *deleteCourseButton3;
    UIButton *deleteCourseButton4;
}
@end

@implementation TutorDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Get the current screen height and size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    [self allocInitAllSubviews];
    
    // Set up the scrollView
    scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight + 500);
    [self.view addSubview:scrollView];
    
    [self centerSubview:chooseCourseLabel withX:10 Y:10 height:15];
    [chooseCourseLabel setText:@"Input the class that you want to teach"];
    [chooseCourseLabel setTextColor:[UIColor blackColor]];
    
    [self centerSubview:chooseCourseTextField withX:10 Y:35 height:35];
    chooseCourseTextField.placeholder = @"type in the coursename";
    chooseCourseTextField.layer.borderWidth = 1;
    chooseCourseTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    
    [self centerSubview:courseTableView withX:10 Y:80 height:220];
    
    [self centerSubview:myCourseLabel withX:0 Y:320 height:30];
    [myCourseLabel setText:@"  My Courses"];
    myCourseLabel.backgroundColor = [UIColor yellowColor];
    
    CGFloat courseLabelWidth = screenWidth * (2/3);
    courseLabel1.frame = CGRectMake(0, 360, courseLabelWidth, 40);
    courseLabel1.backgroundColor = [UIColor yellowColor];
    [courseLabel1 setText:@"MATH 20A"];
    
    CGFloat deleteButtonWidth = screenWidth * (1/3);
    deleteCourseButton1.frame = CGRectMake(courseLabelWidth, 360, deleteButtonWidth, 40);
    deleteCourseButton1.backgroundColor = [UIColor redColor];
    [deleteCourseButton1 setTitle:@"DELETE" forState:UIControlStateNormal];
    
    
    
    [self addAllSubviews];
    
    /************************************************************************************************/
    // TABLE VIEW SET UP
    
    courseTableView.delegate = self;
    courseTableView.dataSource = self;
    
    // Initialize and query for arrays that serve as datasource for the tableView
    stableCourseItems = [[NSMutableArray alloc] init];
    courseItems = [[NSMutableArray alloc] init];
    [self getCourses:courseItems];
    addedCoursesToStableCourseItems = false;
    
    // Add the method to detect change in the specficClassTextField
    [chooseCourseTextField addTarget:self
                                    action:@selector(textFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
    
    //Initially hide the table view
    courseTableView.rowHeight = 44;
    [courseTableView setHidden:YES];
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
        cell.textLabel.text = courseItems[indexPath.row];
    else
        cell.textLabel.text = @"No course matches the input";
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UILabel *label = (UILabel *)[cell viewWithTag:1000];
//    if(!noClassFound)
//    {
//        NSString *chosenString = label.text;
//        self.specificClassTextField.text = chosenString;
//    }
//    [self.classesTableView setHidden:YES];
//    [self.view endEditing:YES];
//    //ChecklistItem *item = _items[indexPath.row];
//}

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
    
    
    if (textField.text.length == 0) [courseTableView setHidden:YES];
    else
    {
        [courseTableView setHidden:NO];
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
            [array insertObject:@"" atIndex:0];
            [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
    }];
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
    
    // TextField
    chooseCourseTextField = [[UITextField alloc] init];
    
    // TableView
    courseTableView = [[UITableView alloc] init];
    
    // Button
    deleteCourseButton1 = [[UIButton alloc] init];
    deleteCourseButton2 = [[UIButton alloc] init];
    deleteCourseButton3 = [[UIButton alloc] init];
    deleteCourseButton4 = [[UIButton alloc] init];
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
    
    // TextField
    [scrollView addSubview:chooseCourseTextField];
    
    // TableView
    [scrollView addSubview:courseTableView];
    
    //Button
    [scrollView addSubview:deleteCourseButton1];
    [scrollView addSubview:deleteCourseButton2];
    [scrollView addSubview:deleteCourseButton3];
    [scrollView addSubview:deleteCourseButton4];
}

-(void)centerSubview:(UIView *)subView withX:(CGFloat)xCoordinate Y:(CGFloat)yCoordinate height:(CGFloat)height
{
    CGFloat width = screenWidth - 2*xCoordinate;
    subView.frame = CGRectMake(xCoordinate,yCoordinate,width,height);
}


@end

