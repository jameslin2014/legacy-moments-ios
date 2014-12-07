//
//  FriendsViewController.h
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOTableViewController.h"
@interface MOFollowingViewController : MOTableViewController <UISearchBarDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;
@property IBOutlet UIBarButtonItem *searchButton;

- (IBAction)showSearch;

@end
