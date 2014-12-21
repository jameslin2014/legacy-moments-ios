//
//  FriendsViewController.h
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>

// External Libraries
#import "UIImageView+AFNetworking.h"
#import "JKSegmentedControl.h"
#import "SSKeychain.h"
#import "AFNetworking.h"

// Internal Classes
#import "MOTableViewController.h"
#import "MomentsAPIUtilities.h"

@interface MOFollowingViewController : MOTableViewController <UISearchBarDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;
@property IBOutlet UIBarButtonItem *searchButton;

- (IBAction)showSearch;

@end
