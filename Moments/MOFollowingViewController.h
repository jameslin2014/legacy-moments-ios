//
//  FriendsViewController.h
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MOFollowingViewController : UITableViewController <UISearchBarDelegate>

@property IBOutlet UITableView *tableView;
@property IBOutlet UIBarButtonItem *searchButton;

- (IBAction)showSearch;

@end
