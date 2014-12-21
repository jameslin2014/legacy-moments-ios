//
//  FollowersViewController.m
//  Moments
//
//  Created by Colton Anglin on 11/30/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOFollowersViewController.h"

@implementation MOFollowersViewController {
    NSUInteger number;
    NSArray *tempArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* docFile = [docDir stringByAppendingPathComponent: @"followersTemp.plist"];
    tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:docFile];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)reloadTable {
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [SSKeychain passwordForService:@"moments" account:@"username"];
    [APIHelper getUserFollowersListWithUsername:currentUser completion:^(NSArray *followerUsers) {
        if ([followerUsers isEqual:tempArray]) {
        } else {
            tempArray = followerUsers;
            [self.tableView reloadData];
        }
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tempArray count];
    
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
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, cell.frame.size.width, cell.frame.size.height)];
    nameLabel.font = [UIFont fontWithName:@"Avenir-Book" size:24];
    nameLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:nameLabel];
    nameLabel.text = [tempArray objectAtIndex:indexPath.row ];

    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];
    
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
    profileImageView.clipsToBounds = YES;
    [cell.contentView addSubview:profileImageView];
    
    UIImageView *chevronImgVw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"follow-waiting"]];
    chevronImgVw.frame = CGRectMake(cell.accessoryView.frame.origin.x, cell.accessoryView.frame.origin.y, 20, 20);
    cell.accessoryView = chevronImgVw;
    
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [SSKeychain passwordForService:@"moments" account:@"username"];
        NSArray *followers = [NSArray new];
    followers = tempArray;
    [profileImageView setImage:[UIImage imageNamed:@"capture-button"]];
    [APIHelper getUserProfilePictureWithUsername:[followers objectAtIndex:indexPath.row] completion:^(UIImage *profileImage) {
        [profileImageView setImage:profileImage];
    }];
        [APIHelper getUserFollowingListWithUsername:currentUser completion:^(NSArray *following) {
            if ([following containsObject:[followers objectAtIndex:indexPath.row]]) {
                UIImageView *chevronImgVw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"follow-successful"]];
                chevronImgVw.frame = CGRectMake(cell.accessoryView.frame.origin.x, cell.accessoryView.frame.origin.y, 15, 15);
                cell.accessoryView = chevronImgVw;
            } else {
                UIImageView *chevronImgVw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"follow-waiting"]];
                chevronImgVw.frame = CGRectMake(cell.accessoryView.frame.origin.x, cell.accessoryView.frame.origin.y, 15, 15);
                cell.accessoryView = chevronImgVw;
            }
    }];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"Avenir-Book" size:1]];
    label.textColor = [UIColor whiteColor];
    if ([tableView numberOfRowsInSection:0] == 1) {
        NSString *string =[NSString stringWithFormat:@"Followed by 1 user"];
        [label setText:string];
        
    } else {
        NSString *string =[NSString stringWithFormat:@"Followed by %lu users",(long)[tableView numberOfRowsInSection:0]];
        [label setText:string];
    }
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:0.101 green:0.450 blue:0.635 alpha:1.0]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected");
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [SSKeychain passwordForService:@"moments" account:@"username"];
    [APIHelper getUserFollowingListWithUsername:currentUser completion:^(NSArray *following) {
        if ([following containsObject:[tempArray objectAtIndex:indexPath.row]]) {
            [APIHelper unfollowUserWithUsername:[tempArray objectAtIndex:indexPath.row] fromUsername:currentUser completion:nil];
            UITableViewCell *cell =  [self.tableView cellForRowAtIndexPath:indexPath];
            UIImageView *chevronImgVw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"follow-waiting"]];
            chevronImgVw.frame = CGRectMake(cell.accessoryView.frame.origin.x, cell.accessoryView.frame.origin.y, 15, 15);
            cell.accessoryView = chevronImgVw;
        } else {
            [APIHelper followUserWithUsername:[tempArray objectAtIndex:indexPath.row] fromUsername:currentUser completion:nil];
            UITableViewCell *cell =  [self.tableView cellForRowAtIndexPath:indexPath];
            UIImageView *chevronImgVw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"follow-successful"]];
            chevronImgVw.frame = CGRectMake(cell.accessoryView.frame.origin.x, cell.accessoryView.frame.origin.y, 15, 15);
            cell.accessoryView = chevronImgVw;
        }
    }];
}

@end
