//
//  FriendsViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "JKSegmentedControl.h"
#import "AFNetworking.h"
#import "MOFollowingViewController.h"
#import "MomentsAPIUtilities.h"
#import "SSKeychain.h"
@interface MOFollowingViewController ()

// UI Parent properties
@property JKSegmentedControl *tabSegmentedControl;
@property UIGestureRecognizer *tapper;
@property UIView *segmentView;
@property UIView *view1;
@property UIView *view2;

// UI Child properties
@property UISearchBar *searchBar;
@property UITableViewController *followersVC;
@property UILabel *nameLabel;
@property UIImageView *profileImageView;

// Numeric properties
@property NSUInteger number;
@property NSArray *tempArray;
@property NSArray *followersArray;

@end

@implementation MOFollowingViewController

@synthesize tabSegmentedControl, segmentView, view1, view2, followersVC;
@synthesize searchBar, nameLabel, profileImageView;
@synthesize number, tempArray, followersArray;
@synthesize tableView, tapper;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapper];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* docFile = [docDir stringByAppendingPathComponent: @"followingTemp.plist"];
    followersArray = [NSKeyedUnarchiver unarchiveObjectWithFile:docFile];
    
    
//    followersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"followersVC"]; // make sure
	
//    NSTimer *rowTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
//                                                         target:self selector:@selector(numberOfRows) userInfo:nil repeats:YES];
	
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Following";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.52 blue:0.68 alpha:0.39]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Avenir-Book" size:17], NSFontAttributeName, nil]];
    
    self.segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, 50)];
    
    [self.segmentView setBackgroundColor:[UIColor colorWithRed:0.23 green:0.52 blue:0.68 alpha:0.39]];
    self.segmentView.alpha = 1;
    self.tabSegmentedControl = [[JKSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Following", @"Followers", nil]];
    self.tabSegmentedControl.frame = CGRectMake(20, self.navigationController.navigationBar.frame.size.height + 30, self.navigationController.navigationBar.frame.size.width - 40, 30);
	[self.tabSegmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:12]} forState:UIControlStateNormal];
    self.tabSegmentedControl.userInteractionEnabled = YES;
    self.tabSegmentedControl.tintColor = [UIColor whiteColor];
    
    
    [self.tabSegmentedControl addTarget:self action:@selector(tabsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.view addSubview:self.tabSegmentedControl];
    self.segmentView.layer.zPosition = 0;
    [self.tabSegmentedControl setSelectedSegmentIndex:0];
    self.tabSegmentedControl.layer.zPosition = 1;
    self.segmentView.userInteractionEnabled = YES;
    [self.navigationController.navigationBar addSubview:self.segmentView];
    searchBar = [[UISearchBar alloc] initWithFrame:self.tabSegmentedControl.frame];
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.tintColor = [UIColor whiteColor];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.delegate = self;
    searchBar.placeholder = @"Search for a username";
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [searchBar removeFromSuperview];
    [self.navigationController.view addSubview:searchBar];
    searchBar.alpha = 0.0f;
    UITextField *searchField = nil;
    view2 = [[UIView alloc] initWithFrame:CGRectMake(0, tableView.frame.origin.y, self.view.frame.size.width, 60.5)];
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, tableView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, view2.frame.size.width, view2.frame.size.height)];
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 35, 35)];
    
    for (UIView *v in searchBar.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            searchField = (UITextField *)v;
            break;
        }
    }
    
    if (searchField) {
        searchField.textColor = [UIColor whiteColor];
    }
    
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.tableView.separatorColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    self.tableView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    [self.tableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
	[self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccurred:)]];
}

- (void)tapOccurred: (UITapGestureRecognizer *) tap{
	CGPoint location = [tap locationInView:self.tableView];
	NSIndexPath *path = [self.tableView indexPathForRowAtPoint:location];
	if (!path){
		[self showRegular];
	}
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [view1 removeFromSuperview];
    } else {
        MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
        [APIHelper searchForUsersWithUserName:searchText completion:^(BOOL valid) {
            
            if (valid) {
                
                view1.backgroundColor = tableView.backgroundColor;
				view1.backgroundColor = [UIColor redColor];
                [self.view addSubview:view1];
                
                view2.backgroundColor = [UIColor colorWithRed:(38/255.0) green:(37/255.0) blue:(36/255.0) alpha:100];
                [view1 addSubview:view2];
                
                nameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:24];
                nameLabel.textColor = [UIColor whiteColor];
                [view2 addSubview:nameLabel];
                nameLabel.text = @"Loading..";
                nameLabel.text = searchText;
                profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
                profileImageView.clipsToBounds = YES;
                [view2 addSubview:profileImageView];
                
                [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png",nameLabel.text]] placeholderImage:[UIImage imageNamed:@"capture-button.png"]];
                
            } else {
                view1.backgroundColor = tableView.backgroundColor;
                [self.view addSubview:view1];
                view2.backgroundColor = [UIColor colorWithRed:(38/255.0) green:(37/255.0) blue:(36/255.0) alpha:100];
                [view1 addSubview:view2];
                
                nameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:25];
                nameLabel.textColor = [UIColor whiteColor];
                nameLabel.text = @"User Not Found";
                [view2 addSubview:nameLabel];
                [profileImageView removeFromSuperview];
            }
            
        }];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender {
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabsChanged:(id)sender {
    if ([self.tabSegmentedControl selectedSegmentIndex] == 0) {
        followersVC.view.alpha = 0.0f;
        self.title = @"Following";
    } else {
        followersVC.view.alpha = 1.0f;
        [self addChildViewController:followersVC];
        [followersVC didMoveToParentViewController:self];
        followersVC.view.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        self.title = @"Followers";
        [self.view addSubview:followersVC.view];
    }
}

- (void)showSearch {
    [self.searchButton setAction:@selector(showRegular)];
    [UIView animateWithDuration:0.1 animations:^{
        self.tabSegmentedControl.alpha = 0.0f;
        self.tabSegmentedControl.userInteractionEnabled = false;
        searchBar.alpha = 1.0;
		[self.searchBar becomeFirstResponder];

    } completion:^(BOOL finished) {}];
    
    
}

- (void)showRegular {
    [view1 removeFromSuperview];
    [searchBar resignFirstResponder];
    [self.searchButton setAction:@selector(showSearch)];
    [UIView animateWithDuration:0.1 animations:^{
        searchBar.alpha = 0.0f;
        self.tabSegmentedControl.userInteractionEnabled = true;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.tabSegmentedControl.alpha = 1.0;
            }];
        }
    }];
}

#pragma mark —— Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [followersArray count];
}

-(void)numberOfRows {
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [SSKeychain passwordForService:@"moments" account:@"username"];
    [APIHelper getUserFollowingListWithUsername:currentUser completion:^(NSArray *followedUsers) {
        if ([followedUsers isEqual:followersArray]) {
        } else {
            followersArray = followedUsers;
            [self.tableView reloadData];
        }
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier: CellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Book" size:20];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, cell.frame.size.width, cell.frame.size.height)];
    nameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
    nameLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:nameLabel];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];
    
    self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
    profileImageView.clipsToBounds = YES;
    [cell.contentView addSubview:profileImageView];
    
    if (self.tabSegmentedControl.selectedSegmentIndex == 0) {
        MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
        NSString *currentUser = [SSKeychain passwordForService:@"moments" account:@"username"];
        [APIHelper getUserFollowingListWithUsername:currentUser completion:^(NSArray *followedUsers) {
            nameLabel.text = [followedUsers objectAtIndex:indexPath.row ];
            [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png",[followedUsers objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"capture-button.png"]];
            tempArray = followedUsers;
            
        }];
    } else {
        MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
        NSString *currentUser = [SSKeychain passwordForService:@"moments" account:@"username"];
        [APIHelper getUserFollowingListWithUsername:currentUser completion:^(NSArray *followedUsers) {
            nameLabel.text = [followedUsers objectAtIndex:indexPath.row ];
            [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png",[followedUsers objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"capture-button.png"]];
            tempArray = followedUsers;
        }];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [searchBar resignFirstResponder];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    if(indexPath.row % 2 == 0)
        // color for first alternating cell
        cell.backgroundColor = [UIColor colorWithRed:(40/255.0) green:(38/255.0) blue:(38/255.0) alpha:100];
    else
        // color for second alternating cell
        cell.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
}

- (UIView *)tableView:(UITableView *)localTableView viewForHeaderInSection:(NSInteger)section {
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, localTableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, localTableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"Avenir-Book" size:12]];
    label.textColor = [UIColor whiteColor];
    if ([followersArray count] == 1) {
        NSString *string =[NSString stringWithFormat:@"Following 1 user"];
        [label setText:string];
        
    } else {
        NSString *string =[NSString stringWithFormat:@"Following %lu users",(unsigned long)[followersArray count]];
        [label setText:string];
    }
    
    [view1 addSubview:label];
    [view1 setBackgroundColor:[UIColor colorWithRed:0.101 green:0.450 blue:0.635 alpha:1.0]]; //your background color...
    return view1;
}



@end