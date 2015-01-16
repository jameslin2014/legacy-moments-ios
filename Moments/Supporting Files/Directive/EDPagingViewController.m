//
//  EDPagingViewController.m
//  Onboarding
//
//  Created by Evan Dekhayser on 12/24/14.
//  Copyright (c) 2014 Xappox, LLC. All rights reserved.
//

#import "EDPagingViewController.h"
#import "PBJVideoPlayerController.h"
#import "MOSignInViewController.h"
#import "MORegisterViewController.h"

@interface EDPagingViewController () <UIScrollViewDelegate, PBJVideoPlayerControllerDelegate>

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation EDPagingViewController{
	PBJVideoPlayerController *v1;
	PBJVideoPlayerController *v2;
	PBJVideoPlayerController *v3;
	
	UILabel *lastLabel;
	
	UIButton *roundSignInContainer;
	UIButton *roundRegisterContainer;
	UILabel *signInLabel;
	UILabel *registerLabel;
	UIImageView *carrot1;
	UIImageView *carrot2;
	
	UIVisualEffectView *blurView;
	
	NSLayoutConstraint *_pageBottomConstraint;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideos) name:
	 @"AppCamBack" object:nil];
	
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];

    if (![[AVAudioSession sharedInstance] isOtherAudioPlaying]) {
        self.player = [[MOMusicPlayer alloc] init];
    }
	
	self.scrollView = [[UIScrollView alloc]init];
	self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.scrollView];
	[self.view addConstraints:@[
								[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
								]];

	NSString *first = [[NSBundle mainBundle]pathForResource:@"cars" ofType:@"mp4"];
	NSString *second = [[NSBundle mainBundle]pathForResource:@"snow" ofType:@"mov"];
	NSString *third = [[NSBundle mainBundle]pathForResource:@"train" ofType:@"mov"];
	
	v1 = [[PBJVideoPlayerController alloc]initWithAudioMuted:YES];
	v1.view.frame = CGRectMake(self.view.bounds.size.width * 0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	v1.videoPath = first;
	v1.view.userInteractionEnabled = NO;
	[v1 playFromBeginning];
	v1.delegate = self;
	[self.scrollView addSubview:v1.view];	
	UILabel *label1 = [[UILabel alloc] init];
	label1.translatesAutoresizingMaskIntoConstraints = NO;
	label1.text = @"Create awesome video blogs on your handheld.";
	label1.textColor = [UIColor whiteColor];
	label1.numberOfLines = -1;
	label1.font = [UIFont fontWithName:@"Avenir-Book" size:17];
	label1.textAlignment = NSTextAlignmentCenter;
	[v1.view addSubview:label1];
	[v1.view addConstraints:@[
							  [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:v1.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:v1.view attribute:NSLayoutAttributeCenterY multiplier:0.25 constant:0],
							  [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:v1.view attribute:NSLayoutAttributeWidth multiplier:0.75 constant:0]
							  ]];
    
	v2 = [[PBJVideoPlayerController alloc]initWithAudioMuted:YES];
	v2.view.frame = CGRectMake(self.view.bounds.size.width * 1, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	v2.videoPath = second;
	v2.view.userInteractionEnabled = NO;
	[v2 playFromBeginning];
	v2.delegate = self;
	[self.scrollView addSubview:v2.view];
	UILabel *label2 = [[UILabel alloc] init];
	label2.translatesAutoresizingMaskIntoConstraints = NO;
	label2.text = @"See what people from around the world are doing day-by-day.";
	label2.textColor = [UIColor whiteColor];
	label2.numberOfLines = -1;
	label2.font = [UIFont fontWithName:@"Avenir-Book" size:17];
	label2.textAlignment = NSTextAlignmentCenter;
	[v2.view addSubview:label2];
	[v2.view addConstraints:@[
							  [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:v2.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:v2.view attribute:NSLayoutAttributeCenterY multiplier:0.25 constant:0],
							  [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:v2.view attribute:NSLayoutAttributeWidth multiplier:0.75 constant:0]
							  ]];

	v3 = [[PBJVideoPlayerController alloc]initWithAudioMuted:YES];
	v3.view.frame = CGRectMake(self.view.bounds.size.width * 2, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	v3.videoPath = third;
	v3.view.userInteractionEnabled = NO;
	[v3 playFromBeginning];
	v3.delegate = self;
	[self.scrollView addSubview:v3.view];
	
	lastLabel = [[UILabel alloc] init];
	lastLabel.translatesAutoresizingMaskIntoConstraints = NO;
	lastLabel.text = @"Join the movement and make your moment.";
	lastLabel.textColor = [UIColor whiteColor];
	lastLabel.numberOfLines = -1;
	lastLabel.font = [UIFont fontWithName:@"Avenir-Book" size:17];
	lastLabel.textAlignment = NSTextAlignmentCenter;
	[v3.view addSubview:lastLabel];
	[v3.view addConstraints:@[
							  [NSLayoutConstraint constraintWithItem:lastLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:v3.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:lastLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:v3.view attribute:NSLayoutAttributeCenterY multiplier:0.25 constant:0],
							  [NSLayoutConstraint constraintWithItem:lastLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:v3.view attribute:NSLayoutAttributeWidth multiplier:0.75 constant:0]
							  ]];
	
	blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
	blurView.translatesAutoresizingMaskIntoConstraints = NO;
	blurView.alpha = 0;
	[v3.view addSubview:blurView];
	[v3.view addConstraints:@[
							  [NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:v3.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:v3.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:v3.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:v3.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
							  ]];
	
	roundSignInContainer = [UIButton buttonWithType:UIButtonTypeSystem];
	roundSignInContainer.translatesAutoresizingMaskIntoConstraints = NO;
	roundSignInContainer.backgroundColor = [UIColor whiteColor];
	roundSignInContainer.layer.cornerRadius = 20;
	roundSignInContainer.alpha = 0;
	[roundSignInContainer addTarget:self action:@selector(presentSignIn) forControlEvents:UIControlEventTouchUpInside];
	[blurView addSubview:roundSignInContainer];
	[blurView addConstraints:@[
							  [NSLayoutConstraint constraintWithItem:roundSignInContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0],
							  [NSLayoutConstraint constraintWithItem:roundSignInContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: 40],
							  [NSLayoutConstraint constraintWithItem:roundSignInContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:roundSignInContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant: -30],
							  ]];
	
	carrot1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"carrot"]];
	carrot1.translatesAutoresizingMaskIntoConstraints = NO;
	carrot1.userInteractionEnabled = NO;
	carrot1.exclusiveTouch = NO;
	[blurView addSubview:carrot1];
	[blurView addConstraints:@[
										   [NSLayoutConstraint constraintWithItem:carrot1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
										   [NSLayoutConstraint constraintWithItem:carrot1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0],
										   [NSLayoutConstraint constraintWithItem:carrot1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:carrot1 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
										   [NSLayoutConstraint constraintWithItem:carrot1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
										   ]];
	
	signInLabel = [[UILabel alloc]init];
	signInLabel.translatesAutoresizingMaskIntoConstraints = NO;
	signInLabel.userInteractionEnabled = NO;
	signInLabel.exclusiveTouch = NO;
	signInLabel.text = @"Sign In";
	signInLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	signInLabel.tintColor = [UIColor blackColor];
	signInLabel.textAlignment = NSTextAlignmentLeft;
	[blurView addSubview:signInLabel];
	[blurView addConstraints:@[
										   [NSLayoutConstraint constraintWithItem:signInLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20],
										   [NSLayoutConstraint constraintWithItem:signInLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
										   [NSLayoutConstraint constraintWithItem:signInLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
										   [NSLayoutConstraint constraintWithItem:signInLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
										   ]];
	
	roundRegisterContainer = [UIButton buttonWithType:UIButtonTypeCustom];
	roundRegisterContainer.translatesAutoresizingMaskIntoConstraints = NO;
	roundRegisterContainer.backgroundColor = [UIColor whiteColor];
	roundRegisterContainer.layer.cornerRadius = 20;
	roundRegisterContainer.alpha = 0;
	[roundRegisterContainer addTarget:self action:@selector(presentRegister) forControlEvents:UIControlEventTouchUpInside];
	[blurView addSubview:roundRegisterContainer];
	[blurView addConstraints:@[
							  [NSLayoutConstraint constraintWithItem:roundRegisterContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0],
							  [NSLayoutConstraint constraintWithItem:roundRegisterContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: 40],
							  [NSLayoutConstraint constraintWithItem:roundRegisterContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:roundRegisterContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant: 30],
							  ]];
	
	carrot2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"carrot"]];
	carrot2.translatesAutoresizingMaskIntoConstraints = NO;
	[roundRegisterContainer addSubview:carrot2];
	[roundRegisterContainer addConstraints:@[
										   [NSLayoutConstraint constraintWithItem:carrot2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundRegisterContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
										   [NSLayoutConstraint constraintWithItem:carrot2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundRegisterContainer attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0],
										   [NSLayoutConstraint constraintWithItem:carrot2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:carrot2 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
										   [NSLayoutConstraint constraintWithItem:carrot2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundRegisterContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
										   ]];
	
	registerLabel = [[UILabel alloc]init];
	registerLabel.translatesAutoresizingMaskIntoConstraints = NO;
	registerLabel.text = @"Register";
	registerLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	registerLabel.tintColor = [UIColor blackColor];
	registerLabel.textAlignment = NSTextAlignmentLeft;
	[roundRegisterContainer addSubview:registerLabel];
	[roundRegisterContainer addConstraints:@[
										   [NSLayoutConstraint constraintWithItem:registerLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:roundRegisterContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20],
										   [NSLayoutConstraint constraintWithItem:registerLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundRegisterContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
										   [NSLayoutConstraint constraintWithItem:registerLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundRegisterContainer attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
										   [NSLayoutConstraint constraintWithItem:registerLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundRegisterContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
										   ]];
	
	self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 4, 0);
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.bounces = NO;
	self.scrollView.delegate = self;
	
	self.pageControl = [[UIPageControl alloc] init];
	self.pageControl.numberOfPages = 4;
	self.pageControl.currentPage = 0;
	self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.pageControl];
	[self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
	_pageBottomConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-0];
	[self.view addConstraint:_pageBottomConstraint];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)presentSignIn{
	MOSignInViewController *signIn = [[MOSignInViewController alloc]init];
	
	signIn.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	signIn.modalPresentationStyle = UIModalPresentationOverFullScreen;
	
	self.providesPresentationContextTransitionStyle = YES;
	self.definesPresentationContext = YES;
	
	[self presentViewController:signIn animated:YES completion:nil];
	[self pageControlToggleOnScreen];
}

- (void)presentRegister{
	MORegisterViewController *registerVC = [[MORegisterViewController alloc]init];
	
	registerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	registerVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	
	self.providesPresentationContextTransitionStyle = YES;
	self.definesPresentationContext = YES;
	
	[self presentViewController:registerVC animated:YES completion:nil];
	[self pageControlToggleOnScreen];
}

- (void)pageControlToggleOnScreen{
	BOOL hiding = _pageBottomConstraint.constant != 30;
	_pageBottomConstraint.constant = hiding ? 30 : 0;
	roundSignInContainer.hidden = hiding;
	roundRegisterContainer.hidden = hiding;
	signInLabel.hidden = hiding;
	registerLabel.hidden = hiding;
	carrot1.hidden = hiding;
	carrot2.hidden = hiding;
	
	[UIView animateWithDuration:0.5 animations:^{
		[self.view layoutIfNeeded];
	}];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.player start];
    
	[super viewDidAppear:animated];
	[self performSelector:@selector(bounceScrollView) withObject:nil afterDelay:0.5];
}

- (void)bounceScrollView
{
	self.scrollView.pagingEnabled = NO;
	self.scrollView.scrollEnabled = NO;
	[self.scrollView setContentOffset:CGPointMake(40, 0) animated:YES];
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(unbounceScrollView) userInfo:nil repeats:NO];
}

- (void)unbounceScrollView
{
	[self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
	[self.scrollView setPagingEnabled:YES];
	[self.scrollView setScrollEnabled:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offset = scrollView.contentOffset.x / scrollView.frame.size.width;
    int page = floor(offset);
    float scroll = offset - page;
    
    [self.player setPage:page fade:scroll];
    
	self.pageControl.currentPage = floor(offset + 0.5);
	
	if (offset >= 2){
		v3.view.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
		float percentToFour = (offset - 2.0) / 1.0;
		roundRegisterContainer.alpha = percentToFour;
		roundSignInContainer.alpha = percentToFour;
		blurView.alpha = percentToFour;
		lastLabel.alpha = 1.0 - percentToFour;
		if (offset >= 2.5){
			v3.view.userInteractionEnabled = YES;
		} else{
			v3.view.userInteractionEnabled = NO;
		}
	}
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer{
	[videoPlayer playFromBeginning];
}

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer{
	
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer{
	
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer{
	
}

- (void)playVideos{
	[v1 playFromCurrentTime];
	[v2 playFromCurrentTime];
	[v3 playFromCurrentTime];
}

@end
