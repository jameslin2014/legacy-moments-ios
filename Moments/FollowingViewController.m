//
//  FriendsViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "FollowingViewController.h"

@interface FollowingViewController ()

@property UISegmentedControl *tabSegmentedControl;
@property UIView *segmentView;

@end

@implementation FollowingViewController
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Following";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.52 blue:0.68 alpha:0.39]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:17], NSFontAttributeName, nil]];
    
//    UISegmentedControl *statFilter = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Filter_Personnal", @"Filter_Department", @"Filter_Company", nil]];
//    [statFilter setSegmentedControlStyle:UISegmentedControlStyleBar];
//    [statFilter sizeToFit];
//    self.navigationItem.titleView = statFilter;
//    
//    [statFilter sizeToFit];

    self.segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, 50)];
    
    [self.segmentView setBackgroundColor:[UIColor colorWithRed:0.23 green:0.52 blue:0.68 alpha:0.39]];
    self.segmentView.alpha = 0.95;
    
    self.tabSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Following", @"Followers", nil]];
    self.tabSegmentedControl.frame = CGRectMake(20, 10, self.navigationController.navigationBar.frame.size.width - 40, 30);
    self.tabSegmentedControl.userInteractionEnabled = YES;
    self.tabSegmentedControl.tintColor = [UIColor whiteColor];
    
    
    [self.tabSegmentedControl addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
    [self.segmentView addSubview:self.tabSegmentedControl];
    [self.navigationController.navigationBar addSubview:self.segmentView];
//    [self.tabSegmentedControl setSelectedSegmentIndex:1];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.tableView.separatorColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    self.tableView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark —— Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier: CellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:20];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:20];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    if(indexPath.row % 2 == 0)
        // color for first alternating cell
        cell.contentView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    else
        // color for second alternating cell
        cell.contentView.backgroundColor = [UIColor colorWithRed:(38/255.0) green:(37/255.0) blue:(36/255.0) alpha:100];
}


@end
