//
//  FollowersViewController.h
//  Moments
//
//  Created by Colton Anglin on 11/30/14.
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

@interface MOFollowersViewController : MOTableViewController <UITableViewDataSource, UITableViewDelegate> {}

@property (nonatomic) IBOutlet UITableView *tableView;

@end
