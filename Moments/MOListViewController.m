//
//  ViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOListViewController.h"
#import "MomentsAPIUtilities.h"
#import "PBJVideoPlayerController.h"
#import "JGProgressHUD.h"
#import "UIImageView+AFNetworking.h"
@interface MOListViewController ()

@end

@implementation MOListViewController {
    NSArray *followingArray;
    PBJVideoPlayerController *videoPlayer;
    JGProgressHUD *HUD;
    JGProgressHUD *HUD1;
    NSTimer *reloadTimer;
}
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // UINavigationBar styling
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Moments";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.52 blue:0.68 alpha:0.39]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:17], NSFontAttributeName, nil]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.tableView.separatorColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
    self.tableView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
}

-(void)viewWillAppear:(BOOL)animated {
    [self numberOfRows];
    reloadTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(numberOfRows) userInfo:nil repeats:YES];
}

#pragma mark —— Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"log: %@",followingArray);
    NSLog(@"%lu",(unsigned long)[followingArray count]);
    return [followingArray count];
}

-(void)numberOfRows {
    MomentsAPIUtilities *API = [MomentsAPIUtilities alloc];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    [API getUserFollowingListWithUsername:user completion:^(NSArray *followingList) {
        followingArray = followingList;
        NSLog(@"%@",followingArray);
        [tableView reloadData];
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
    cell.textLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:20];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:20];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 7, cell.frame.size.width, cell.frame.size.height)];
    nameLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:24];
    nameLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:nameLabel];

    
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
    profileImageView.clipsToBounds = YES;
    [cell addSubview:profileImageView];

    MomentsAPIUtilities *API = [MomentsAPIUtilities alloc];
    [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.png",[followingArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"capture-button"]];
    
    nameLabel.text = [followingArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    if(indexPath.row % 2 == 0)
    cell.contentView.backgroundColor = [UIColor colorWithRed:(38/255.0) green:(37/255.0) blue:(36/255.0) alpha:100];
    else
        cell.contentView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:100];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HUD1 = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    [self.view addSubview:HUD1];
    [HUD1 showInView:self.view animated:YES];

    videoPlayer = [[PBJVideoPlayerController alloc] init];
    videoPlayer.view.frame = self.view.bounds;
    videoPlayer.delegate = self;
    // setup media
    videoPlayer.videoPath = [NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.mp4",[followingArray objectAtIndex:indexPath.row]];

    // present
    [self addChildViewController:videoPlayer];
    [self.view addSubview:videoPlayer.view];
    [videoPlayer didMoveToParentViewController:self];
    
    UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] init];
    dismissGesture.numberOfTapsRequired = 1;
    [dismissGesture setNumberOfTouchesRequired:1];
    dismissGesture.delegate = self;
    [videoPlayer.view addGestureRecognizer:dismissGesture];
    [dismissGesture addTarget:self action:@selector(dismissPlayer)];
    
    HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    [videoPlayer.view addSubview:HUD];
    [HUD showInView:videoPlayer.view animated:YES];
    }

-(void)dismissPlayer {
    [videoPlayer removeFromParentViewController];
    [videoPlayer.view removeFromSuperview];
    self.navigationController.navigationBar.alpha = 1.0f;
    reloadTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(numberOfRows) userInfo:nil repeats:YES];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

-(void)videoPlayerReady:(PBJVideoPlayerController *)player {
    [player playFromBeginning];
    [reloadTimer invalidate];
    self.navigationController.navigationBar.alpha = 0.0f;
    [HUD1 dismissAnimated:NO];
}

-(void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)player {
    [player removeFromParentViewController];
    [player.view removeFromSuperview];
    self.navigationController.navigationBar.alpha = 1.0f;
     reloadTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(numberOfRows) userInfo:nil repeats:YES];
}

-(void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)player {
    NSLog(@"beginning");
    [HUD dismissAnimated:YES];
}

-(void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)player {
    if (player.playbackState == PBJVideoPlayerPlaybackStateStopped) {
        NSLog(@"stopped");
    }
}

@end
