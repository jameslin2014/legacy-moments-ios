//
//  ViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOListViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@interface MOListViewController ()

@property PBJVideoPlayerController *videoPlayer;
@property JGProgressHUD *HUD;
@property JGProgressHUD *HUD1;

@end

@implementation MOListViewController {
    NSArray *followingArray;
    NSTimer *reloadTimer;
    BOOL taps;
    
}

@synthesize videoPlayer, HUD, HUD1;
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Moments";
    
    NSString *currentUser = [SSKeychain passwordForService:@"moments" account:@"username"];
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];
    
    [APIHelper getUserFollowingListWithUsername:currentUser completion:^(NSArray *followingList) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex: 0];
        NSString* docFile = [docDir stringByAppendingPathComponent: @"followingTemp.plist"];
        [NSKeyedArchiver archiveRootObject:followingList toFile:docFile];
    }];
    
    [APIHelper getUserFollowersListWithUsername:currentUser completion:^(NSArray *followingList) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString* docFile = [docDir stringByAppendingPathComponent: @"followersTemp.plist"];
        [NSKeyedArchiver archiveRootObject:followingList toFile:docFile];
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // UIBarButtonItem = Right
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"file_name"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButton:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewWillAppear:(BOOL)animated {
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

- (void)numberOfRows {
    MomentsAPIUtilities *API = [MomentsAPIUtilities alloc];
    NSString *user = [SSKeychain passwordForService:@"moments" account:@"username"];
    [API getUserFollowingListWithUsername:user completion:^(NSArray *followingList) {
        if ([followingArray isEqual:followingList]) {} else {
            followingArray = followingList;
            [tableView reloadData];
        }
    }];
    
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
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.barTintColor = [UIColor colorWithRed:(38/255.0) green:(37/255.0) blue:(36/255.0) alpha:100];

        toolbar.translucent = false;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareMoment)];
        toolbar.frame = CGRectMake(0, 0, 55, 55);
        item.tintColor = [UIColor whiteColor];
        [toolbar setItems:[NSArray arrayWithObject:item] animated:NO];
        [toolbar setBarTintColor:[UIColor clearColor]];
        for(UIView *view in [toolbar subviews])
        {
            if([view isKindOfClass:[UIImageView class]])
            {
                [view setHidden:YES];
                [view setAlpha:0.0f];
            }
        }
        cell.accessoryView = toolbar;

        NSString *user = [SSKeychain passwordForService:@"moments" account:@"username"];
        nameLabel.text = user;
        nameLabel.frame = CGRectMake(55, 7, cell.frame.size.width, cell.frame.size.height);
        UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        profileImageView.clipsToBounds = YES;
        [cell addSubview:profileImageView];
        [profileImageView setImage:[UIImage imageNamed:@"capture-button"]];         

        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.jpg",user]];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                        scale:image.scale
                                                  orientation:UIImageOrientationRight];
            dispatch_async(dispatch_get_main_queue(), ^(void){
 [profileImageView setImage:flippedImage];            });
        });

        NSLog(@"%@",[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.jpg",user]);
    } else {
        UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 35, 35)];
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
        profileImageView.clipsToBounds = YES;
        [cell addSubview:profileImageView];
        [profileImageView setImage:[UIImage imageNamed:@"capture-button"]];

            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.jpg",[followingArray objectAtIndex:indexPath.row]]];
                NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage * image = [UIImage imageWithData:imageData];
                UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                            scale:image.scale
                                                      orientation:UIImageOrientationRight];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [profileImageView setImage:flippedImage];
                });
            });
    
        nameLabel.text = [followingArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)shareMoment {
    NSString *user = [SSKeychain passwordForService:@"moments" account:@"username"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:@"saved.mp4"];
    NSURL *video = [NSURL fileURLWithPath:imagePath];
    JGProgressHUD *LoadingHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    [LoadingHUD.textLabel setText:@"Exporting..."];
    [LoadingHUD showInView:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.mp4",user]]];
        [videoData writeToFile:imagePath atomically:NO];
        UIActivityViewController *shareSheet = [[UIActivityViewController alloc] initWithActivityItems:@[video] applicationActivities:nil];
        [shareSheet setCompletionHandler:^(NSString *activityType, BOOL completed) {
            if([activityType isEqualToString: UIActivityTypeSaveToCameraRoll]){
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library saveVideo:video toAlbum:@"Saved Moments" withCompletionBlock:nil];
            }
        }];
        [self presentViewController:shareSheet animated:YES completion:^ {
            [LoadingHUD dismissAnimated:YES];

        }];

    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return (CGFloat) 0.0;
    } else {
        return 21.5f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (taps == YES) {
    } else {
        taps = YES;
        videoPlayer = [[PBJVideoPlayerController alloc] init];
        videoPlayer.view.frame = self.view.bounds;
        videoPlayer.delegate = self;
        
        // setup media
        if (indexPath.section == 0) {
            NSString *user = [SSKeychain passwordForService:@"moments" account:@"username"];
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

- (void)dismissPlayer {
    taps = NO;
    [videoPlayer removeFromParentViewController];
    [videoPlayer.view removeFromSuperview];
    self.navigationController.navigationBar.alpha = 1.0f;
    reloadTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(numberOfRows) userInfo:nil repeats:YES];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)videoPlayerReady:(PBJVideoPlayerController *)player {
    [player playFromBeginning];
    self.navigationController.navigationBar.alpha = 0.0f;
    HUD1.alpha = 0.0f;
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)player {
    [player removeFromParentViewController];
    [player.view removeFromSuperview];
    self.navigationController.navigationBar.alpha = 1.0f;
    reloadTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(numberOfRows) userInfo:nil repeats:YES];
    taps = NO;
}

-(void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer {
    //Dont remove this please
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)player {
    HUD1.alpha = 0.0f;
}

@end