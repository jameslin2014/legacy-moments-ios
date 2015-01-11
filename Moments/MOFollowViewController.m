//
//  MOTableViewController.m
//  Moments
//
//  Created by Evan Dekhayser on 12/22/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOFollowViewController.h"
#import "JKSegmentedControl.h"
#import "MomentsAPIUtilities.h"
#import "MOS3APIUtilities.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+EDExtras.h"
#import "MOAvatarCache.h"
#import "UIImage+EDExtras.h"
#import "EDSpinningBoxScene.h"
#import "FollowingStatusView.h"


@interface MOFollowViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tapper;
@property (strong, nonatomic) JKSegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray *followers;
@property (strong, nonatomic) NSArray *following;
@property (strong, nonatomic) NSArray *searchUsers;

@property (nonatomic) BOOL textFieldSelected;

@end

@implementation MOFollowViewController

- (BOOL)prefersStatusBarHidden{
	return NO;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:1.0];
	
	// Do any additional setup after loading the view.???????
	self.title = @"Following";
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1]];
	[self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Avenir-Book" size:17], NSFontAttributeName, nil]];
	
	self.subNavigationView.alpha = 1;
	self.segmentedControl = [[JKSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Following", @"Followers", nil]];
	self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
	[self.subNavigationView addSubview:self.segmentedControl];
	[self.subNavigationView addConstraints:@[
											 [NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.subNavigationView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
											 [NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.subNavigationView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
											 [NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30],
											 [NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.subNavigationView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]
											 ]];
	[self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:12]} forState:UIControlStateNormal];
	self.segmentedControl.userInteractionEnabled = YES;
	self.segmentedControl.tintColor = [UIColor whiteColor];
	[self.segmentedControl addTarget:self action:@selector(tabsChanged:) forControlEvents:UIControlEventValueChanged];
	[self.segmentedControl setSelectedSegmentIndex:0];
	self.segmentedControl.layer.zPosition = 1;
	
	self.subNavigationView.userInteractionEnabled = YES;
	self.subNavigationView.layer.zPosition = 0;
	
	self.searchBar = [[UISearchBar alloc] init];
	self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
	self.searchBar.barTintColor = [UIColor blackColor];
	self.searchBar.tintColor = [UIColor blackColor];
	self.searchBar.searchBarStyle = UISearchBarStyleDefault;
	self.searchBar.delegate = self;
	self.searchBar.placeholder = @"Search for a username";
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
	[self.searchBar setBackgroundImage:[UIImage imageWithCGImage:(__bridge CGImageRef)([UIColor clearColor])]];
	[self.subNavigationView addSubview:self.searchBar];
	[self.subNavigationView addConstraints:@[
											 [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.segmentedControl attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
											 [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.segmentedControl attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
											 [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.segmentedControl attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
											 [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.segmentedControl attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
											 ]];
	self.searchBar.alpha = 0.0f;
	
	self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
	self.tableView.separatorColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:1.0];
	self.tableView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:1.0];
	self.tableView.allowsSelection = YES;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccurred:)];
	tap.cancelsTouchesInView = NO;
	[self.tableView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"dataLoaded"
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *note) {
      [self dataLoaded];
    }];
}

- (void)tapOccurred: (UITapGestureRecognizer *)tapGesture{
	if ([self.tableView indexPathForRowAtPoint:[tapGesture locationInView:self.tableView]] == nil){
		[self showRegular];
	}
}

- (void)tabsChanged: (JKSegmentedControl *) segmentedControl{
    [self dataLoaded];

    if ([segmentedControl selectedSegmentIndex] == 0) {
		self.title = @"Following";
	} else {
		self.title = @"Followers";
	}
}

- (IBAction)showSearch{
	[self.tableView reloadData];
	[self.searchButton setAction:@selector(showRegular)];
	[UIView animateWithDuration:0.1 animations:^{
		self.segmentedControl.alpha = 0.0f;
		self.segmentedControl.userInteractionEnabled = false;
		self.searchBar.alpha = 1.0;
		[self.searchBar becomeFirstResponder];
		self.textFieldSelected = YES;
	} completion:^(BOOL finished) {}];
}

- (void)showRegular {
	[self.searchBar resignFirstResponder];
	[self.searchButton setAction:@selector(showSearch)];
	[UIView animateWithDuration:0.1 animations:^{
		self.searchBar.alpha = 0.0f;
		self.segmentedControl.userInteractionEnabled = true;
		self.textFieldSelected = NO;
		[self tabsChanged:self.segmentedControl];
	} completion:^(BOOL finished) {
		if (finished) {
			[UIView animateWithDuration:0.3 animations:^{
				self.segmentedControl.alpha = 1.0;
			}];
		}
	}];
}

#pragma mark - UITableView Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (self.textFieldSelected){
		return self.searchUsers.count;
	}
	return self.segmentedControl.selectedSegmentIndex == 0 ? self.following.count : self.followers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//	UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DaCell"];
	UITableViewCell *cell = [[UITableViewCell alloc]init];
	UILabel *nameLabel;
	nameLabel.tag = 13154;
	UIImageView *profileImageView;
	
	for (UIView *v in cell.contentView.subviews){
		if ([v isKindOfClass:[UIImageView class]]){
			profileImageView = (UIImageView *) v;
		} else if ([v isKindOfClass:[UILabel class]]){
			nameLabel = (UILabel *) v;
		}
	}
	
	cell.backgroundColor = [UIColor clearColor];
//	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if (!nameLabel) {nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, cell.frame.size.width, cell.frame.size.height)];}
	nameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	nameLabel.textColor = [UIColor whiteColor];
	if (!nameLabel.superview){
		[cell addSubview:nameLabel];
	}
	if (!profileImageView){
		profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];
	}
	profileImageView.center = CGPointMake(profileImageView.center.x, 30.25);
	profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
	profileImageView.clipsToBounds = YES;
	if (!profileImageView.superview){
		[cell addSubview:profileImageView];
	}
	NSString *username;
	if (self.textFieldSelected && self.searchUsers.count > indexPath.row){
		username = self.searchUsers[indexPath.row];
	} else if (self.segmentedControl.selectedSegmentIndex == 0){
		username = self.following[indexPath.row];
	} else{
		username = self.followers[indexPath.row];
	}
	nameLabel.text = username;
    
    [[[MOAvatarCache alloc] init] getAvatarForUsername:username completion:^(UIImage *avatar) {
        profileImageView.image = avatar;
    }];

//	FollowingStatusView *followStatus = [[UIImageView alloc]initWithImage:[self.following containsObject:username] ? [UIImage followingYes] : [UIImage followingNo]];
	FollowingStatusView *followStatus = [[FollowingStatusView alloc]init];
	followStatus.isFollowing = [self.following containsObject:username];
	followStatus.center = CGPointMake(cell.bounds.size.width + 30, profileImageView.center.y);
	followStatus.tag = 78900;
	[cell addSubview:followStatus];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	NSString *username;
	if (self.textFieldSelected && self.searchUsers.count > indexPath.row){
		username = self.searchUsers[indexPath.row];
	} else if (self.segmentedControl.selectedSegmentIndex == 0){
		username = self.following[indexPath.row];
	} else if (self.segmentedControl.selectedSegmentIndex == 1){
		username = self.followers[indexPath.row];
	}
	NSLog(@"%@", username);
    //	FollowingStatusView *followingStatus = (FollowingStatusView *)[cell viewWithTag:78900];
    //	SCNView *v = [[SCNView alloc] initWithFrame:self.view.bounds];
    //	v.scene = [[EDSpinningBoxScene alloc] init];
    //	v.alpha = 0.0;
    //	v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    //	[self.view addSubview:v];
    //	[UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
    //		v.alpha = 1.0;
    //	} completion:nil];
    
    MOUser *user = [MomentsAPIUtilities sharedInstance].user;
    
	if ([self.following containsObject:username]){
		[[MomentsAPIUtilities sharedInstance] unfollowUser:username completion:^(NSDictionary *dict) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [UIView animateWithDuration:0.2 animations:^{
//                    v.alpha = 0.0;
//                } completion:^(BOOL finished) {
//                    [v removeFromSuperview];
//                }];
//            });
			NSLog(@"1: %@", dict[@"follows"]);
            user.following = dict[@"follows"];
            user.followers = dict[@"followers"];
            [self dataLoaded];
		}];
	} else{
		[[MomentsAPIUtilities sharedInstance] followUser:username completion:^(NSDictionary *dict) {
//			dispatch_async(dispatch_get_main_queue(), ^{
//				[UIView animateWithDuration:0.2 animations:^{
//					v.alpha = 0.0;
//				} completion:^(BOOL finished) {
//					[v removeFromSuperview];
//				}];
//			});
			NSLog(@"2: %@", dict[@"follows"]);
            user.following = dict[@"follows"];
            user.followers = dict[@"followers"];
            [self dataLoaded];
		}];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return self.textFieldSelected ? 0 : 21.5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (self.textFieldSelected){
		return @"";
	} else if (self.segmentedControl.selectedSegmentIndex == 0){
		return [NSString stringWithFormat:@"Following %lu user%@", (unsigned long)self.following.count, self.following.count == 1 ? @"" : @"s"];
	} else {
		BOOL oneUser = self.followers.count == 1;
		return [NSString stringWithFormat:@"%lu user%@ follow%@ you", (unsigned long)self.followers.count, oneUser ? @"" : @"s", !oneUser ? @"" : @"s"];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 18)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, self.tableView.frame.size.width, 18)];
	[label setFont:[UIFont fontWithName:@"Avenir-Book" size:12]];
	label.textColor = [UIColor whiteColor];
	label.text = [self tableView:tableView titleForHeaderInSection:section];
	
	[view addSubview:label];
	[view setBackgroundColor:[UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1]];
	return view;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length < 3) {
        return;
    }
    
    [[MomentsAPIUtilities sharedInstance] searchForUsersLikeUsername:searchText completion:^(NSDictionary *results) {
        
        NSMutableArray *users = [NSMutableArray arrayWithArray:results[@"results"]];
        NSString *user = [MomentsAPIUtilities sharedInstance].user.name;
        
        if ([users containsObject:user]) {
            [users removeObject:user];
        }
        
		self.searchUsers = users;

		[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (void)dataLoaded {
    MOUser *user = [MomentsAPIUtilities sharedInstance].user;
    self.following = user.following;
    self.followers = user.followers;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

@end
