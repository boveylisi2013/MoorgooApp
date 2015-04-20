//
//  tutorDetailTableViewController.m
//  Moorgoo
//
//  Created by SI  on 4/14/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "TutorDetailTableViewController.h"

@interface TutorDetailTableViewController ()

@end

@implementation TutorDetailTableViewController
@synthesize tutorInstance;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", tutorInstance.firstName);
    
    self.navigationItem.title = @"Profile";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"tutorDetailReuse"];
    cell.contentView.backgroundColor = [UIColor colorWithRed:250.0/255.0
                                                       green:250.0/255.0
                                                        blue:250.0/255.0
                                                       alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0) {
        UIImageView *profileImageView = [[UIImageView alloc] init];
        profileImageView.frame = CGRectMake(5, 5, 140, 140);
        profileImageView.image = tutorInstance.profileImage;
        [cell.contentView addSubview:profileImageView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(155, 20, [[UIScreen mainScreen] bounds].size.width-160, 20);
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        NSMutableString *fullName = [NSMutableString new];
        [fullName appendString:tutorInstance.firstName];
        [fullName appendString:@" "];
        [fullName appendString:tutorInstance.lastName];
        nameLabel.text = fullName;
        [cell.contentView addSubview:nameLabel];
        
        //school + department
        UILabel *departmentLabel = [[UILabel alloc] init];
        departmentLabel.numberOfLines = 0;
        departmentLabel.frame = CGRectMake(155, 60, [[UIScreen mainScreen] bounds].size.width-160, 40);
        departmentLabel.font = [UIFont boldSystemFontOfSize:15];
        NSMutableString *department = [NSMutableString new];
        [department appendString:tutorInstance.schoolAbbreviation];
        [department appendString:@" "];
        [department appendString:tutorInstance.department];
        departmentLabel.text = department;
        [cell.contentView addSubview:departmentLabel];
        
        //price
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.frame = CGRectMake(155, 110, [[UIScreen mainScreen] bounds].size.width-160, 20);
        priceLabel.font = [UIFont boldSystemFontOfSize:18];
        NSMutableString *price = [NSMutableString new];
        [price appendString:@"$"];
        [price appendString:tutorInstance.price];
        [price appendString:@" per hour"];
        priceLabel.text = price;
        [cell.contentView addSubview:priceLabel];
    }
    else if(indexPath.section == 1) {
        UIView *goodView = [[UIView alloc] init];
        goodView.frame = CGRectMake(5, 20, [[UIScreen mainScreen] bounds].size.width-10, 40);
        goodView.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:255.0 alpha:1].CGColor;
        goodView.layer.borderWidth = 2.0f;
        
        UILabel *goodNum = [[UILabel alloc] init];
        goodNum.frame = CGRectMake(5, 5, 50, 30);
        goodNum.text = tutorInstance.goodRating;
        [goodView addSubview:goodNum];
        
        
        UILabel *goodText = [[UILabel alloc] init];
        goodText.frame = CGRectMake(goodView.bounds.size.width/2-50, 5, 100, 30);
        goodText.text = @"Good Tutor";
        [goodView addSubview:goodText];
        
        UIButton *goodButton = [[UIButton alloc] init];
        goodButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-60, 5, 30, 30);
        [goodButton setImage:[UIImage imageNamed:@"ThunbUp"] forState:UIControlStateNormal];
        [goodButton addTarget:self
                       action:@selector(goodRateButtonClicked)
             forControlEvents:UIControlEventTouchUpInside];
        [goodView addSubview:goodButton];
        

        
        /*****************************************************************************/
        UIView *badView = [[UIView alloc] init];
        badView.frame = CGRectMake(5, 80, [[UIScreen mainScreen] bounds].size.width-10, 40);
        badView.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:255.0 alpha:1].CGColor;
        badView.layer.borderWidth = 2.0f;
        
        UILabel *badNum = [[UILabel alloc] init];
        badNum.frame = CGRectMake(5, 5, 50, 30);
        badNum.text = tutorInstance.badRating;
        [badView addSubview:badNum];
        
        
        UILabel *badText = [[UILabel alloc] init];
        badText.frame = CGRectMake(badView.bounds.size.width/2-50, 5, 100, 30);
        badText.text = @"Bad Tutor";
        [badView addSubview:badText];
        
        UIButton *badButton = [[UIButton alloc] init];
        badButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-60, 5, 30, 30);
        [badButton setImage:[UIImage imageNamed:@"ThunbDown"] forState:UIControlStateNormal];
        [badButton addTarget:self
                       action:@selector(badRateButtonClicked)
             forControlEvents:UIControlEventTouchUpInside];
        [badView addSubview:badButton];

        
        
        [cell.contentView addSubview:goodView];
        [cell.contentView addSubview:badView];
        
    }
    else if(indexPath.section == 2) {
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(5, 5, [[UIScreen mainScreen] bounds].size.width-10, 150);
        textView.text = tutorInstance.selfAd;
        textView.font = [UIFont systemFontOfSize:16];
        textView.editable = FALSE;
        
        [cell.contentView addSubview:textView];
    }
    else if(indexPath.section == 3) {
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(5, 5, [[UIScreen mainScreen] bounds].size.width-10, 150);
        NSString *education = [NSString stringWithFormat:@"%@\n%@", tutorInstance.school, tutorInstance.department];
        textView.text = education;
        textView.font = [UIFont systemFontOfSize:16];
        textView.editable = FALSE;
        
        [cell.contentView addSubview:textView];
        
    }
    else if(indexPath.section == 4) {
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(5, 5, [[UIScreen mainScreen] bounds].size.width-10, 150);
        NSMutableString *AClasses = [[NSMutableString alloc] init];
        
        for(NSString *class in tutorInstance.AClasses) {
            [AClasses appendString:[NSString stringWithFormat:@"%@%@", class, @"\n"]];
        }
        
        textView.text = AClasses;
        textView.font = [UIFont systemFontOfSize:16];
        textView.editable = FALSE;
        
        [cell.contentView addSubview:textView];
        
    }
    else if(indexPath.section == 5) {
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(5, 5, [[UIScreen mainScreen] bounds].size.width-10, 150);
        NSMutableString *classTutoring = [[NSMutableString alloc] init];
        
        for(NSString *class in tutorInstance.courses) {
            [classTutoring appendString:[NSString stringWithFormat:@"%@%@", class, @"\n"]];
        }
        
        textView.text = classTutoring;
        textView.font = [UIFont systemFontOfSize:16];
        textView.editable = FALSE;
        
        [cell.contentView addSubview:textView];
    }
    else if(indexPath.section == 6) {
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(5, 5, [[UIScreen mainScreen] bounds].size.width-10, 170);
        NSMutableString *availability = [[NSMutableString alloc] init];
        
        for(NSString *day in tutorInstance.availableDays) {
            [availability appendString:[NSString stringWithFormat:@"%@%@", day, @"\n"]];
        }
        
        
        textView.text = availability;
        textView.font = [UIFont systemFontOfSize:16];
        textView.editable = FALSE;
        
        [cell.contentView addSubview:textView];
        
    }
    else if(indexPath.section == 7) {

        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.frame = CGRectMake(5, 5, [[UIScreen mainScreen] bounds].size.width-10, 20);
        NSString *phone = [NSString stringWithFormat:@"%@%@", @"Phone: ", tutorInstance.phone];
        phoneLabel.text = phone;
        [cell.contentView addSubview:phoneLabel];
        
        UILabel *emailLabel = [[UILabel alloc] init];
        emailLabel.frame = CGRectMake(5, 30, [[UIScreen mainScreen] bounds].size.width-10, 20);
        NSString *email = [NSString stringWithFormat:@"%@%@", @"Email: ", tutorInstance.email];
        emailLabel.text = email;
        [cell.contentView addSubview:emailLabel];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3 || indexPath.section == 7)
        return 80;
    
    if(indexPath.section == 6) {
        return 190;
    }
    
    return 160;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 25);
    header.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                             green:51.0/255.0
                                              blue:51.0/255.0
                                             alpha:1];
    
    UILabel *headerLabel =[[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 0, [[UIScreen mainScreen] bounds].size.width-5, 25);
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:17];
    [header addSubview:headerLabel];
    
    if(section == 0) {
        
    }
    else if(section == 1) {
        headerLabel.text = @"Rating";
    }
    else if(section == 2) {
        headerLabel.text = @"Description";
    }
    else if(section == 3) {
        headerLabel.text = @"Education Background";
    }
    else if(section == 4) {
        headerLabel.text = @"Got A+/A/A-";
    }
    else if(section == 5) {
        headerLabel.text = @"Tutoring for";
    }
    else if(section == 6) {
        headerLabel.text = @"Availability";
    }
    else if(section == 7) {
        headerLabel.text = @"Contact Info";
    }
    
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0;
    
    
    return 25.0;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <uialertviewdelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([alertView.title isEqualToString:@"Dear"]) {
        if(buttonIndex == 1) {
            PFObject *userPointer = [PFObject objectWithoutDataWithClassName:@"_User"
                                                                    objectId:tutorInstance.userId];

            PFQuery *query = [PFQuery queryWithClassName:@"CollegeClassTutor"];
            [query whereKey:@"userId" equalTo:userPointer];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *userStats, NSError *error) {
                if (!error) {
                    NSString *good = [userStats objectForKey:@"goodRating"];
                    good = [NSString stringWithFormat:@"%d", [good intValue] + 1];
                    [userStats setObject:good forKey:@"goodRating"];
                    [userStats saveInBackground];
                    
                    /**************************************************************/
                    PFObject *rater = [PFObject objectWithoutDataWithClassName:@"_User"
                                                                      objectId:([PFUser currentUser]).objectId];
                    PFObject *ratee = [PFObject objectWithoutDataWithClassName:@"_User"
                                                                      objectId:tutorInstance.userId];
                    
                    PFObject *rating = [PFObject objectWithClassName:@"Rate"];
                    [rating setObject:rater forKey:@"rater"];
                    [rating setObject:ratee forKey:@"ratee"];
                    [rating setObject:[NSNumber numberWithBool:YES] forKey:@"type"];
                    [rating saveInBackground];
                    /**************************************************************/
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
        }
    }
    else if([alertView.title isEqualToString:@"Oops"]) {
        if(buttonIndex == 1) {
            PFObject *userPointer = [PFObject objectWithoutDataWithClassName:@"_User"
                                                                    objectId:tutorInstance.userId];
            
            PFQuery *query = [PFQuery queryWithClassName:@"CollegeClassTutor"];
            [query whereKey:@"userId" equalTo:userPointer];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                if (!error) {
                    NSString *bad = [userStats objectForKey:@"badRating"];
                    bad = [NSString stringWithFormat:@"%d", [bad intValue] + 1];
                    [userStats setObject:bad forKey:@"badRating"];
                    [userStats saveInBackground];
                    
                    /**************************************************************/
                    PFObject *rater = [PFObject objectWithoutDataWithClassName:@"_User"
                                                                      objectId:([PFUser currentUser]).objectId];
                    PFObject *ratee = [PFObject objectWithoutDataWithClassName:@"_User"
                                                                      objectId:tutorInstance.userId];
                    
                    PFObject *rating = [PFObject objectWithClassName:@"Rate"];
                    [rating setObject:rater forKey:@"rater"];
                    [rating setObject:ratee forKey:@"ratee"];
                    [rating setObject:[NSNumber numberWithBool:NO] forKey:@"type"];
                    [rating saveInBackground];
                    /**************************************************************/
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
        }
    }
}

- (void)goodRateButtonClicked {
    PFObject *rater = [PFObject objectWithoutDataWithClassName:@"_User"
                                                      objectId:([PFUser currentUser]).objectId];
    PFObject *ratee = [PFObject objectWithoutDataWithClassName:@"_User"
                                                      objectId:tutorInstance.userId];
    PFQuery *query = [PFQuery queryWithClassName:@"Rate"];
    [query whereKey:@"rater" equalTo:rater];
    [query whereKey:@"ratee" equalTo:ratee];
    [query whereKey:@"type" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if([objects count] == 0) {
                [[[UIAlertView alloc] initWithTitle:@"Dear"
                                            message:@"Do you want to give this tutor a positive rating?"
                                           delegate:self
                                  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil] show];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"You have rated this tutor"
                                           delegate:nil
                                  cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil] show];
            }
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)badRateButtonClicked {
    PFObject *rater = [PFObject objectWithoutDataWithClassName:@"_User"
                                                      objectId:([PFUser currentUser]).objectId];
    PFObject *ratee = [PFObject objectWithoutDataWithClassName:@"_User"
                                                      objectId:tutorInstance.userId];
    PFQuery *query = [PFQuery queryWithClassName:@"Rate"];
    [query whereKey:@"rater" equalTo:rater];
    [query whereKey:@"ratee" equalTo:ratee];
    [query whereKey:@"type" equalTo:[NSNumber numberWithBool:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if([objects count] == 0) {
                [[[UIAlertView alloc] initWithTitle:@"Oops"
                                            message:@"Do you want to give this tutor a negative rating?"
                                           delegate:self
                                  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil] show];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"You have rated this tutor"
                                           delegate:nil
                                  cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil] show];
            }
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
