//
//  MOTableView.m
//  Moments
//
//  Created by Douglas Bumby on 2014-12-07.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOTableViewController.h"
#import "MOListViewController.h"

@implementation MOTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.52 blue:0.68 alpha:0.39]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:17], NSFontAttributeName, nil]];
    
    self.tableView.separatorColor = [UIColor colorWithRed:0.141 green:0.137 blue:0.13 alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.141 green:0.137 blue:0.13 alpha:1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.5;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:(38/255.0) green:(37/255.0) blue:(36/255.0) alpha:100];
    else
        cell.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
}

@end
