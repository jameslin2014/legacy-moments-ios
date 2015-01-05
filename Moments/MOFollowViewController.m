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
#import "UIImageView+AFNetworking.h"
#import "UIImage+EDExtras.h"

@interface MOFollowViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tapper;
@property (strong, nonatomic) JKSegmentedControl *segmentedControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *followers;
@property (strong, nonatomic) NSArray *following;

@end

@implementation MOFollowViewController

- (void)viewDidLoad{
	[super viewDidLoad];
	
	self.tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	self.tapper.cancelsTouchesInView = YES;
	[self.view addGestureRecognizer:self.tapper];
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
	[self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccurred:)]];
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
    [[MomentsAPIUtilities sharedInstance].user reload];
	
    if ([segmentedControl selectedSegmentIndex] == 0) {
		self.title = @"Following";
	} else {
		self.title = @"Followers";
	}
}

- (void)handleSingleTap: (UITapGestureRecognizer *) tap{
	[self.view endEditing:YES];
}

- (IBAction)showSearch{
	[self.searchButton setAction:@selector(showRegular)];
	[UIView animateWithDuration:0.1 animations:^{
		self.segmentedControl.alpha = 0.0f;
		self.segmentedControl.userInteractionEnabled = false;
		self.searchBar.alpha = 1.0;
		[self.searchBar becomeFirstResponder];
		
	} completion:^(BOOL finished) {}];
}

- (void)showRegular {
	[self.searchBar resignFirstResponder];
	[self.searchButton setAction:@selector(showSearch)];
	[UIView animateWithDuration:0.1 animations:^{
		self.searchBar.alpha = 0.0f;
		self.segmentedControl.userInteractionEnabled = true;
		
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
	return self.segmentedControl.selectedSegmentIndex == 0 ? self.following.count : self.followers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DaCell"];
	
	UILabel *nameLabel;
	UIImageView *profileImageView;
	
	for (UIView *v in cell.contentView.subviews){
		if ([v isKindOfClass:[UIImageView class]]){
			profileImageView = (UIImageView *) v;
		} else if ([v isKindOfClass:[UILabel class]]){
			nameLabel = (UILabel *) v;
		}
	}
	
	cell.backgroundColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if (!nameLabel) {nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, cell.frame.size.width, cell.frame.size.height)];}
	nameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	nameLabel.textColor = [UIColor whiteColor];
	nameLabel.text = self.segmentedControl.selectedSegmentIndex == 0 ? self.following[indexPath.row] : self.followers[indexPath.row];
	if (!nameLabel.superview){
		[cell.contentView addSubview:nameLabel];
	}
	if (!profileImageView){profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];}
	profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
	profileImageView.clipsToBounds = YES;
	if (!profileImageView.superview){
		[cell.contentView addSubview:profileImageView];
	}
	[profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png",self.segmentedControl.selectedSegmentIndex == 0 ? self.following[indexPath.row] : self.followers[indexPath.row]]] placeholderImage:[UIImage circleImageWithColor:[UIColor colorWithRed:0 green:0.78 blue:0.42 alpha:1]]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 21.5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (self.segmentedControl.selectedSegmentIndex == 0){
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
    [[MomentsAPIUtilities sharedInstance] searchForUsersLikeUsername:searchText completion:^(NSArray *results) {
        for (NSString *name in results) {
            NSLog(@"%@", name);
        }
    }];
}

- (void)dataLoaded {
    MOUser *user = [MomentsAPIUtilities sharedInstance].user;
    self.following = user.following;
    self.followers = user.followers;
    
    [self.tableView reloadData];
}

@end
