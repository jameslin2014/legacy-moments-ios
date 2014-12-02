//
//  FollowersViewController.m
//  Moments
//
//  Created by Colton Anglin on 11/30/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

#import "MOFollowersViewController.h"
#import "MomentsAPIUtilities.h"

@implementation MOFollowersViewController {
    NSUInteger number;
    NSArray *tempArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    self.tableView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (void)reloadTable {
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    [APIHelper getUserFollowersListWithUsername:currentUser completion:^(NSArray *followedUsers) {
        if ([followedUsers isEqual:tempArray]) {
        } else {
            tempArray = followedUsers;
            [self.tableView reloadData];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tempArray count];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    if(indexPath.row % 2 == 0)
        // color for first alternating cell
        cell.backgroundColor = [UIColor colorWithRed:(40/255.0) green:(38/255.0) blue:(38/255.0) alpha:100];
    else
        // color for second alternating cell
        cell.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"done");
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
    
    UIImageView *chevronImgVw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"follow-waiting"]];
    chevronImgVw.frame = CGRectMake(cell.accessoryView.frame.origin.x, cell.accessoryView.frame.origin.y, 20, 20);
    cell.accessoryView = chevronImgVw;
    
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    [APIHelper getUserFollowersListWithUsername:currentUser completion:^(NSArray *followers) {
        tempArray = followers;
        nameLabel.text = [followers objectAtIndex:indexPath.row ];
        [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png",[followers objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"capture-button.png"]];
        NSLog(@"done");
        
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
    }];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:1]];
    label.textColor = [UIColor whiteColor];
    if ([tableView numberOfRowsInSection:0] == 1) {
        NSString *string =[NSString stringWithFormat:@"Followed by 1 user"];
        [label setText:string];
        
    } else {
        NSString *string =[NSString stringWithFormat:@"Followed by %lu users",[tempArray count]];
        [label setText:string];
    }
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:0.101 green:0.450 blue:0.635 alpha:1.0]]; //your background color...
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
