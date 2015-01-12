//
//  MOTableViewController.h
//  Moments
//
//  Created by Evan Dekhayser on 12/22/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MomentsAPIUtilities.h"
#import "MOS3APIUtilities.h"
#import "UIImageView+AFNetworking.h"
#import "MOAvatarCache.h"
#import "FollowingStatusView.h"
#import "JKSegmentedControl.h"
#import "UIImage+EDExtras.h"
#import "UIImage+EDExtras.h"
#import "EDSpinningBoxScene.h"

@interface MOFollowViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property IBOutlet UIBarButtonItem *searchButton;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *subNavigationView;
@property (strong, nonatomic) UISearchBar *searchBar;

- (IBAction)showSearch;
- (void)showRegular;

@end
