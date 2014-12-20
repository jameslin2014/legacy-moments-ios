//
//  SettingsViewController.m
//  Moments
//
//  Created by Evan Dekhayser on 12/18/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "SettingsViewController.h"
#import "EDSegmentedControl.h"

@interface SettingsViewController () /*<UITableViewDataSource, UITableViewDelegate>*/

@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic)

@end

@implementation SettingsViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor darkGrayColor];
	EDSegmentedControl *control = [[EDSegmentedControl alloc]init];
	
	control.center = self.view.center;
	[self.view addSubview:control];
}

#pragma mark - UITableView Data Source and Delegate



@end
