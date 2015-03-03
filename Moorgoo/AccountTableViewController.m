//
//  AccountTableViewController.m
//  Moorgoo
//
//  Created by SI  on 3/2/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "AccountTableViewController.h"

@interface AccountTableViewController ()

@end

@implementation AccountTableViewController

@synthesize tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableData = [[NSMutableArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",@"Five",nil];

    //hide empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = @"Account Setting";
    }
    else if(indexPath.section == 1) {
        cell.textLabel.text = @"Log Out";
        [cell setBackgroundColor:[UIColor redColor]];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1) {
        [PFUser logOut];
        
        /******************************************************/
        KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainTest" accessGroup:nil];
        [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
        [keychain resetKeychainItem];
        /******************************************************/
        
        [self performSegueWithIdentifier:@"LogoutSuccessful" sender:self];
    }
}
@end
