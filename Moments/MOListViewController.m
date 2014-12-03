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
    BOOL taps;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [followingArray count];
    } else {
        return 1;
    }
}

-(void)numberOfRows {
    MomentsAPIUtilities *API = [MomentsAPIUtilities alloc];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    [API getUserFollowingListWithUsername:user completion:^(NSArray *followingList) {
        if ([followingArray isEqual:followingList]) {} else {
            followingArray = followingList;
            [tableView reloadData];
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
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor redColor];
    [cell setSelectedBackgroundView:bgColorView];
    cell.textLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:20];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:20];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 7, cell.frame.size.width, cell.frame.size.height)];
    nameLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:24];
    nameLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:nameLabel];
    
    if (indexPath.section == 0) {
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
        nameLabel.text = user;
        nameLabel.frame = CGRectMake(55, 7, cell.frame.size.width, cell.frame.size.height);
        UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        profileImageView.clipsToBounds = YES;
        [cell addSubview:profileImageView];
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.jpg",user]];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                    scale:image.scale - 200
                                              orientation:UIImageOrientationRight];
        [profileImageView setImage:flippedImage];
        NSLog(@"%@",[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.jpg",user]);
    } else {
        UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        profileImageView.clipsToBounds = YES;
        [cell addSubview:profileImageView];
        
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.jpg",[followingArray objectAtIndex:indexPath.row]]];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                    scale:image.scale - 200
                                              orientation:UIImageOrientationRight];
        [profileImageView setImage:flippedImage];
        
        nameLabel.text = [followingArray objectAtIndex:indexPath.row];
    }
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 18)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, self.tableView.frame.size.width, 18)];
        [label setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:1]];
        label.textColor = [UIColor whiteColor];
        NSString *string =[NSString stringWithFormat:@"You"];
        [label setText:string];
        
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:0.101 green:0.450 blue:0.635 alpha:1.0]]; //your background color...
        return view;
    } else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 18)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, self.tableView.frame.size.width, 18)];
        [label setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:1]];
        label.textColor = [UIColor whiteColor];
        NSString *string =[NSString stringWithFormat:@"Recent Updates"];
        [label setText:string];
        
        
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:0.101 green:0.450 blue:0.635 alpha:1.0]]; //your background color...
        return view;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (taps == YES) {
        
    } else {
        taps = YES;
    videoPlayer = [[PBJVideoPlayerController alloc] init];
    videoPlayer.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    videoPlayer.view.frame = self.view.bounds;
    videoPlayer.delegate = self;

    // setup media
    if (indexPath.section == 0) {
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.mp4",user]]];
        [request setHTTPMethod:@"HEAD"];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [op start];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            taps = NO;
            [reloadTimer invalidate];
            videoPlayer.videoPath = [NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.mp4",user];
            [self addChildViewController:videoPlayer];
            [self.view addSubview:videoPlayer.view];
            [videoPlayer didMoveToParentViewController:self];
            
            UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] init];
            dismissGesture.numberOfTapsRequired = 1;
            [dismissGesture setNumberOfTouchesRequired:1];
            dismissGesture.delegate = self;
            [videoPlayer.view addGestureRecognizer:dismissGesture];

            [dismissGesture addTarget:self action:@selector(dismissPlayer)];
            
            HUD1 = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
            [self.view addSubview:HUD1];
            [HUD1 showInView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            taps = NO;
        }];
        [op setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
            return nil;
        }];


    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.mp4",[followingArray objectAtIndex:indexPath.row]]]];
        [request setHTTPMethod:@"HEAD"];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [op start];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            taps = NO;
            [reloadTimer invalidate];
            videoPlayer.videoPath = [NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.mp4",[followingArray objectAtIndex:indexPath.row]];
            [self addChildViewController:videoPlayer];
            [self.view addSubview:videoPlayer.view];
            [videoPlayer didMoveToParentViewController:self];
            
            UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] init];
            dismissGesture.numberOfTapsRequired = 1;
            [dismissGesture setNumberOfTouchesRequired:1];
            dismissGesture.delegate = self;
            [videoPlayer.view addGestureRecognizer:dismissGesture];
            [dismissGesture addTarget:self action:@selector(dismissPlayer)];
            
            HUD1 = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
            [self.view addSubview:HUD1];
            [HUD1 showInView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            taps = NO;
            NSLog(@"fail");
        }];
        [op setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
            return nil;
        }];
    }
    }
}

-(void)dismissPlayer {
    taps = NO;
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
    self.navigationController.navigationBar.alpha = 0.0f;
    HUD1.alpha = 0.0f;
}

-(void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)player {
    [player removeFromParentViewController];
    [player.view removeFromSuperview];
    self.navigationController.navigationBar.alpha = 1.0f;
    reloadTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(numberOfRows) userInfo:nil repeats:YES];
    taps = NO;
}

-(void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)player {
    HUD1.alpha = 0.0f;
}

-(void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)player {}

@end
