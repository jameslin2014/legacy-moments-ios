//
//  MODecisionViewController.m
//  Moments
//
//  Created by Evan Dekhayser on 1/5/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MODecisionViewController.h"
#import "PBJVideoPlayerController.h"
#import "MOSignInViewController.h"
#import "MORegisterViewController.h"

@interface MODecisionViewController () <PBJVideoPlayerControllerDelegate>

@end

@implementation MODecisionViewController{
	PBJVideoPlayerController *videoPlayer;
	UIVisualEffectView *blurView;
	UIButton *roundSignInContainer;
	UIButton *roundRegisterContainer;
	UIImageView *carrot1;
	UIImageView *carrot2;
	UILabel *signInLabel;
	UILabel *registerLabel;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideos) name:
	 @"AppCamBack" object:nil];

	NSString *video = [[NSBundle mainBundle]pathForResource:@"Late" ofType:@"mov"];
	
	videoPlayer = [[PBJVideoPlayerController alloc]initWithAudioMuted:YES];
	videoPlayer.view.frame = CGRectMake(self.view.bounds.size.width * 0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	videoPlayer.videoPath = video;
	videoPlayer.view.userInteractionEnabled = NO;
	[videoPlayer playFromBeginning];
	videoPlayer.delegate = self;
	[self.view addSubview:videoPlayer.view];
	UILabel *label = [[UILabel alloc] init];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	label.text = @"Create awesome video blogs on your handheld";
	label.textColor = [UIColor whiteColor];
	label.numberOfLines = -1;
	label.font = [UIFont fontWithName:@"Avenir-Book" size:17];
	label.textAlignment = NSTextAlignmentCenter;
	[videoPlayer.view addSubview:label];
	[videoPlayer.view addConstraints:@[
							  [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:videoPlayer.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:videoPlayer.view attribute:NSLayoutAttributeCenterY multiplier:0.25 constant:0],
							  [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:videoPlayer.view attribute:NSLayoutAttributeWidth multiplier:0.75 constant:0]
							  ]];
	
	blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
	blurView.translatesAutoresizingMaskIntoConstraints = NO;
	blurView.alpha = 0;
	[self.view addSubview:blurView];
	[self.view addConstraints:@[
							  [NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
							  [NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
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

    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)presentSignIn{
	MOSignInViewController *signIn = [[MOSignInViewController alloc]init];
	
	signIn.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	signIn.modalPresentationStyle = UIModalPresentationOverFullScreen;
	
	self.providesPresentationContextTransitionStyle = YES;
	self.definesPresentationContext = YES;
	
	[self presentViewController:signIn animated:YES completion:nil];
}

- (void)presentRegister{
	MORegisterViewController *registerVC = [[MORegisterViewController alloc]init];
	
	registerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	registerVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	
	self.providesPresentationContextTransitionStyle = YES;
	self.definesPresentationContext = YES;
	
	[self presentViewController:registerVC animated:YES completion:nil];
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)vidPlayer{
	[vidPlayer playFromBeginning];
}

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer{
	
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer{
	
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer{
	
}

- (void)playVideos{
	[videoPlayer playFromCurrentTime];
}


@end
