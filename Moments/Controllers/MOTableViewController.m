//
//  MOTableViewController.m
//  Moments
//
//  Created by Evan Dekhayser on 12/24/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOTableViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MOTableViewController () <PBJVideoPlayerControllerDelegate>
@property (strong, nonatomic) NSArray *recents;
@property (nonatomic) BOOL tableShouldRegisterTapEvents;
@property (strong, nonatomic) PBJVideoPlayerController *videoPlayer;
@property (strong, nonatomic) SCNView *loadingView;
@property (strong, nonatomic) NSTimer *reloadTimer;
@end

@implementation MOTableViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
	return NO;
}

- (void)viewDidLoad {
	[super viewDidLoad];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
	self.navigationItem.title = @"Moments";
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Avenir-Book" size:17] }];
	self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir-Book" size:17], NSForegroundColorAttributeName : [UIColor whiteColor]};
	self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1];
	self.tableView.backgroundColor = [UIColor colorWithRed:36/255.0 green: 36/255.0 blue:36/255.0 alpha:1.0];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(showOptionsAndAbout)];
	button.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = button;
    
    [self getDataFromServer];
}

- (void)getDataFromServer{
    [[MomentsAPIUtilities sharedInstance].user reload];
}

- (IBAction)openCameraView:(UIBarButtonItem *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JumpToCamera" object:nil];
    NSLog(@"Camera");
}

- (void)showOptionsAndAbout{
	MOSettingsViewController *settingsViewController = [[MOSettingsViewController alloc]init];
	settingsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	settingsViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
	self.providesPresentationContextTransitionStyle = YES;
	self.definesPresentationContext = YES;
	[self presentViewController:settingsViewController animated:YES completion:nil];
}

- (void)shareMoment {
    NSString *user = [MomentsAPIUtilities sharedInstance].user.name;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"saved.mp4"];
	NSURL *video = [NSURL fileURLWithPath:imagePath];
	SCNView *v = [[SCNView alloc] initWithFrame:self.view.bounds];
	v.scene = [[EDSpinningBoxScene alloc] init];
	v.alpha = 0.0;
	v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self.view addSubview:v];
	[UIView animateWithDuration:0.2 delay:0.05 options:0 animations:^{
		v.alpha = 1.0;
	} completion:nil];
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/pickmoments/videos/%@.mp4",user]]];
		[videoData writeToFile:imagePath atomically:NO];
		UIActivityViewController *shareSheet = [[UIActivityViewController alloc] initWithActivityItems:@[video] applicationActivities:nil];
		[shareSheet setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
			if([activityType isEqualToString: UIActivityTypeSaveToCameraRoll]){
				ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
				[library saveVideo:video toAlbum:@"Saved Moments" withCompletionBlock:nil];
			}
		}];
		[self presentViewController:shareSheet animated:YES completion:^ {
			[UIView animateWithDuration:0.2 animations:^{
				v.alpha = 0.0;
			} completion:^(BOOL finished) {
				[v removeFromSuperview];
				[[UIApplication sharedApplication] endIgnoringInteractionEvents];
			}];
		}];
		
	});
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return section == 0 ? 1 : self.recents.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 55;
}

- (void)viewWillAppear:(BOOL)animated {
	NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
	[[NSNotificationCenter defaultCenter] addObserverForName:@"signOut"
													  object:nil
													   queue:mainQueue
												  usingBlock:^(NSNotification *note)
	 {
         UIViewController *destinationViewController = [[MODecisionViewController alloc] init];
         [[[UIApplication sharedApplication] delegate] window].rootViewController = destinationViewController;
         [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
	 }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"dataLoaded"
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *note) {
      [self dataLoaded];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"avatarChanged"
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      [self avatarChanged];
                                                  }];
    
    self.recents = [MomentsAPIUtilities sharedInstance].user.recents;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"signOut" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dataLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"avatarChanged" object:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSString *identifier = indexPath.section == 0 ? @"usercell" : @"cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell){
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
	}
	cell.backgroundColor = [UIColor colorWithRed:36/255.0 green: 36/255.0 blue:36/255.0 alpha:1.0];
	cell.textLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	cell.textLabel.textColor = [UIColor whiteColor];
	
	UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 55 - 10*2, 55 - 10*2)];
	profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
	profileImageView.clipsToBounds = YES;
	[cell.contentView addSubview:profileImageView];
	
	UIView *bgView = [[UIView alloc] init];
	bgView.translatesAutoresizingMaskIntoConstraints = NO;
	bgView.backgroundColor = [UIColor colorWithRed:60/255.0 green: 60/255.0 blue:60/255.0 alpha:1.0];
	cell.selectedBackgroundView = bgView;
	
	if (indexPath.section == 0){
		cell.textLabel.text = [NSString stringWithFormat:@"\t\t%@", [MomentsAPIUtilities sharedInstance].user.name ?: @""];
        
        profileImageView.image = [MomentsAPIUtilities sharedInstance].user.avatar;
        
        if ([MomentsAPIUtilities sharedInstance].user.posted) {
            UIToolbar *toolbar = [[UIToolbar alloc] init];
            toolbar.barTintColor = [UIColor colorWithRed:36/255.0 green: 36/255.0 blue:36/255.0 alpha:1.0];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareMoment)];
            toolbar.frame = CGRectMake(0, 0, 55, 55);
            item.tintColor = [UIColor whiteColor];
            [toolbar setItems:@[item] animated:NO];
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
        }
	} else{
		cell.textLabel.text = [NSString stringWithFormat:@"\t\t%@", self.recents[indexPath.row]];
        
        [[[MOAvatarCache alloc] init] getAvatarForUsername:self.recents[indexPath.row] completion:^(UIImage *avatar) {
            profileImageView.image = avatar;
        }];
	}
    
	return cell;
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
		[label setFont:[UIFont fontWithName:@"Avenir-Book" size:12]];
		label.textColor = [UIColor whiteColor];
		NSString *string =[NSString stringWithFormat:@"Recent Updates"];
		[label setText:string];
		[view addSubview:label];
		[view setBackgroundColor:[UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1]];
		return view;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (!self.tableShouldRegisterTapEvents){
		self.tableShouldRegisterTapEvents = YES;
		self.videoPlayer = [[PBJVideoPlayerController alloc] init];
		self.videoPlayer.view.frame = self.view.bounds;
		self.videoPlayer.delegate = self;
		
		// setup media
		NSString *username;
		if (indexPath.section == 0) {
			username = [MomentsAPIUtilities sharedInstance].user.name;
		} else {
			username = self.recents[indexPath.row];
		}
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/pickmoments/videos/%@.mp4",username]]];
		[request setHTTPMethod:@"HEAD"];
		AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
		[op start];
		[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			self.tableView.scrollEnabled = NO;
			self.tableShouldRegisterTapEvents = NO;
			[self.reloadTimer invalidate];
			self.videoPlayer.videoPath = [NSString stringWithFormat:@"https://s3.amazonaws.com/pickmoments/videos/%@.mp4",username];
			self.videoPlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			self.modalPresentationStyle = UIModalPresentationOverFullScreen;
			[self presentViewController:self.videoPlayer animated:YES completion:nil];
			
			UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] init];
			dismissGesture.numberOfTapsRequired = 1;
			[dismissGesture setNumberOfTouchesRequired:1];
			[self.videoPlayer.view addGestureRecognizer:dismissGesture];
			
			[dismissGesture addTarget:self action:@selector(dismissPlayer)];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"DisableScrollView" object:nil];
			[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			self.tableShouldRegisterTapEvents = NO;
		}];
		[op setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
			return nil;
		}];
		
	}
}

- (void)dismissPlayer{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EnableScrollView" object:nil];
	[self.videoPlayer dismissViewControllerAnimated:YES completion:nil];
	self.tableView.scrollEnabled = YES;
	self.tableShouldRegisterTapEvents = NO;
	[self.videoPlayer removeFromParentViewController];
	[self.videoPlayer.view removeFromSuperview];
	self.navigationController.navigationBar.alpha = 1.0f;
	self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(getDataFromServer) userInfo:nil repeats:YES];
}

- (void)videoPlayerReady:(PBJVideoPlayerController *)player {
	[player playFromBeginning];
	self.navigationController.navigationBar.alpha = 0.0f;
	[UIView animateWithDuration:0.2 animations:^{
		self.loadingView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self.loadingView removeFromSuperview];
		[[UIApplication sharedApplication]endIgnoringInteractionEvents];
	}];
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)player {
	[player dismissViewControllerAnimated:YES completion:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EnableScrollView" object:nil];
	self.navigationController.navigationBar.alpha = 1.0f;
	self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(getDataFromServer) userInfo:nil repeats:YES];
	self.tableShouldRegisterTapEvents = NO;
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer {
	//Dont remove this please
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)player {
	[UIView animateWithDuration:0.2 animations:^{
		self.loadingView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self.loadingView removeFromSuperview];
		[[UIApplication sharedApplication]endIgnoringInteractionEvents];
	}];
}

- (void)dataLoaded {
    self.recents = [MomentsAPIUtilities sharedInstance].user.recents;
    
    [self.tableView reloadData];
}

- (void)avatarChanged {
    [self.tableView reloadData];
}

@end