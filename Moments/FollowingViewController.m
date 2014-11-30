//
//  FriendsViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "FollowingViewController.h"
#import "JKSegmentedControl.h"
#import "MomentsAPIUtilities.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
@interface FollowingViewController ()

@property JKSegmentedControl *tabSegmentedControl;
@property UIView *segmentView;

@end

@implementation FollowingViewController {
    UISearchBar *searchBar;
    NSUInteger number;
    NSArray *tempArray;
}
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];

    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Following";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.52 blue:0.68 alpha:0.39]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:17], NSFontAttributeName, nil]];
    
//    UISegmentedControl *statFilter = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Filter_Personnal", @"Filter_Department", @"Filter_Company", nil]];
//    [statFilter setSegmentedControlStyle:UISegmentedControlStyleBar];
//    [statFilter sizeToFit];
//    self.navigationItem.titleView = statFilter;
//    
//    [statFilter sizeToFit];

    self.segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, 50)];
    
    [self.segmentView setBackgroundColor:[UIColor colorWithRed:0.23 green:0.52 blue:0.68 alpha:0.39]];
    self.segmentView.alpha = 1;
    self.tabSegmentedControl = [[JKSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Following", @"Followers", nil]];
    self.tabSegmentedControl.frame = CGRectMake(20, self.navigationController.navigationBar.frame.size.height + 30, self.navigationController.navigationBar.frame.size.width - 40, 30);
    self.tabSegmentedControl.userInteractionEnabled = YES;
    self.tabSegmentedControl.tintColor = [UIColor whiteColor];
    
    
    [self.tabSegmentedControl addTarget:self action:@selector(tabsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.view addSubview:self.tabSegmentedControl];
    self.segmentView.layer.zPosition = 0;
    [self.tabSegmentedControl setSelectedSegmentIndex:0];
    self.tabSegmentedControl.layer.zPosition = 1;
    self.segmentView.userInteractionEnabled = YES;
    [self.navigationController.navigationBar addSubview:self.segmentView];
//    [self.tabSegmentedControl setSelectedSegmentIndex:1];
    searchBar = [[UISearchBar alloc] initWithFrame:self.tabSegmentedControl.frame];
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.tintColor = [UIColor whiteColor];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"Search for a username";
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [searchBar removeFromSuperview];
    [self.navigationController.view addSubview:searchBar];
    searchBar.alpha = 0.0f;
    UITextField *searchField = nil;
    for (UIView *v in searchBar.subviews)
    {
        if ([v isKindOfClass:[UITextField class]])
        {
            searchField = (UITextField *)v;
            break;
        }
    }
    
    if (searchField)
    {
        searchField.textColor = [UIColor whiteColor];
    }

    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.tableView.separatorColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    self.tableView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    [self.tableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadTable {
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    [APIHelper getUserFollowingListWithUsername:currentUser completion:^(NSArray *followedUsers) {
        if ([followedUsers isEqual:tempArray]) {
        } else {
            [self.tableView reloadData];
            [self.tableView numberOfRowsInSection:0];
        }
    }];
}

-(void)tabsChanged:(id)sender {
    
}

-(void)showSearch {
    [self.searchButton setAction:@selector(showRegular)];
    [UIView animateWithDuration:0.1 animations:^{
        self.tabSegmentedControl.alpha = 0.0f;
        self.tabSegmentedControl.userInteractionEnabled = false;
        searchBar.alpha = 1.0;
    } completion:^(BOOL finished) {}];
    
        
}

-(void)showRegular {
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
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    [APIHelper getUserFollowingListWithUsername:currentUser completion:^(NSArray *followedUsers) {
        number = [followedUsers count];
    }];
    NSLog(@"numbers");
    return number;
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
   
    cell.detailTextLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:20];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, cell.frame.size.width, cell.frame.size.height)];
    nameLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:24];
    nameLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:nameLabel];

       UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];
    
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
    profileImageView.clipsToBounds = YES;
    [cell.contentView addSubview:profileImageView];
    
    
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    [APIHelper getUserFollowingListWithUsername:currentUser completion:^(NSArray *followedUsers) {
        nameLabel.text = [followedUsers objectAtIndex:indexPath.row ];
         [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png",[followedUsers objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"capture-button.png"]];
        tempArray = followedUsers;
         }];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    if(indexPath.row % 2 == 0)
        // color for first alternating cell
        cell.contentView.backgroundColor = [UIColor colorWithRed:(38/255.0) green:(37/255.0) blue:(36/255.0) alpha:100];
    else
        // color for second alternating cell
        cell.contentView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
}


@end
