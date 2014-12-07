//
//  FollowersViewController.h
//  Moments
//
//  Created by Colton Anglin on 11/30/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOTableViewController.h"

@interface MOFollowersViewController : MOTableViewController <UITableViewDataSource, UITableViewDelegate> {}

@property (nonatomic) IBOutlet UITableView *tableView;

@end
