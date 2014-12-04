//
//  ViewController.h
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBJVideoPlayerController.h"

@interface MOListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, PBJVideoPlayerControllerDelegate, UIGestureRecognizerDelegate>

@property IBOutlet UITableView *tableView;

@end

