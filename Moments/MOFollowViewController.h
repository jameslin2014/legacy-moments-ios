//
//  EDTableViewController.h
//  Moments
//
//  Created by Evan Dekhayser on 12/22/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOFollowViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property IBOutlet UIBarButtonItem *searchButton;

@property (nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *subNavigationView;

- (IBAction)showSearch;

@end
