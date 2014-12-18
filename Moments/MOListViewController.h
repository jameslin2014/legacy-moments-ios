//
//  ViewController.h
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// External Libraries
#import "PBJVideoPlayerController.h"
#import "UIImageView+AFNetworking.h"
#import "EDSpinningBoxScene.h"
#import "SSKeychain.h"

// Internal Classes
#import "MOTableViewController.h"
#import "MomentsAPIUtilities.h"

@interface MOListViewController : MOTableViewController <UITableViewDataSource, UITableViewDelegate, PBJVideoPlayerControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;

@end

