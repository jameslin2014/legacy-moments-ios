//
//  ViewController.h
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView *tableView;

@end
