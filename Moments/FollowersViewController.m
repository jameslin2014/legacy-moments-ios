//
//  FollowersViewController.m
//  Moments
//
//  Created by Colton Anglin on 11/30/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "FollowersViewController.h"
#import "MomentsAPIUtilities.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
@interface FollowersViewController ()

@end

@implementation FollowersViewController {
    NSUInteger number;
    NSArray *tempArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    self.tableView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(void)reloadTable {
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    [APIHelper getUserFollowersListWithUsername:currentUser completion:^(NSArray *followedUsers) {
        if ([followedUsers isEqual:tempArray]) {
        } else {
            [self.tableView reloadData];
            [self.tableView numberOfRowsInSection:0];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    number = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved"];
    return number;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    if(indexPath.row % 2 == 0)
        // color for first alternating cell
        cell.backgroundColor = [UIColor colorWithRed:(38/255.0) green:(37/255.0) blue:(36/255.0) alpha:100];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
