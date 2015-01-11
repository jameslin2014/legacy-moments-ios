//
//  MORegisterViewController.m
//  Onboarding
//
//  Created by Evan Dekhayser on 1/4/15.
//  Copyright (c) 2015 Xappox, LLC. All rights reserved.
//

#import "MORegisterViewController.h"
#import "UIImage+EDExtras.h"
#import "EDPagingViewController.h"
#import "MomentsAPIUtilities.h"
#import "MOUser.h"
#import <SceneKit/SceneKit.h>
#import "EDSpinningBoxScene.h"
#import "MOS3APIUtilities.h"
#import "MMPopLabel.h"
#import "UIImage+Avatar.h"
#import <AudioToolbox/AudioServices.h>

#import <pop/POP.h>

@interface MORegisterViewController ()

@property (nonatomic) NSInteger currentIndex;

@end

@implementation MORegisterViewController {
	NSLayoutConstraint *_leftmostLayoutConstraint;
	
	UIButton *backButton;
	UIImageView *backButtonImage;
	
	UIView *backgroundNegative1;
	
	UIView *background1;
	UIView *containerView1;
	UILabel *descriptionLabel1;
	UITextField *usernameField1;
	UITextField *emailField1;
	UIButton *roundContinueContainer1;
	UIImageView *carrot1;
	UILabel *continueLabel1;
	
	UIView *background2;
	UIView *containerView2;
	UILabel *descriptionLabel2;
	UITextField *passwordField2;
	UITextField *confirmPasswordField2;
	UIButton *roundContinueContainer2;
	UIImageView *carrot2;
	UILabel *continueLabel2;
	
	UIView *background3;
	UIView *containerView3;
	UIButton *imageButton3;
	UIButton *roundWelcomeLabel3;
	UIImageView *carrot3;
	UILabel *welcomeLabel3;
	
	UIView *background4;
	
	MMPopLabel *popLabel;
}

- (BOOL)prefersStatusBarHidden{
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[[MMPopLabel appearance] setLabelColor:[UIColor whiteColor]];
	[[MMPopLabel appearance] setLabelTextColor:[UIColor blackColor]];
	[[MMPopLabel appearance] setLabelFont:[UIFont fontWithName:@"Avenir-Book" size:12.0f]];

	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	self.modalPresentationStyle = UIModalPresentationOverFullScreen;
		
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAllResponders)]];
	
	background1 = [[UIView alloc]init];
	background1.translatesAutoresizingMaskIntoConstraints = NO;
	background1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self.view addSubview:background1];
	_leftmostLayoutConstraint = [NSLayoutConstraint constraintWithItem:background1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
	[self.view addConstraints:@[
								_leftmostLayoutConstraint,
								[NSLayoutConstraint constraintWithItem:background1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
								]];
	
	background2 = [[UIView alloc]init];
	background2.translatesAutoresizingMaskIntoConstraints = NO;
	background2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self.view addSubview:background2];
	[self.view addConstraints:@[
								[NSLayoutConstraint constraintWithItem:background2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:background1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
								]];
	
	containerView1 = [[UIView alloc] init];
	containerView1.translatesAutoresizingMaskIntoConstraints = NO;
	containerView1.layer.cornerRadius = 20;
	containerView1.backgroundColor = [UIColor whiteColor];
	[background1 addSubview:containerView1];
	[background1 addConstraints:@[
								[NSLayoutConstraint constraintWithItem:containerView1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:background1 attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:containerView1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:background1 attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:containerView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:background1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-50]
								]];
	
	descriptionLabel1 = [[UILabel alloc] init];
	descriptionLabel1.translatesAutoresizingMaskIntoConstraints = NO;
	descriptionLabel1.text = @"Type in your Username and Email";
	descriptionLabel1.font = [UIFont fontWithName:@"Avenir-Book" size:14];
	descriptionLabel1.numberOfLines = -1;
	descriptionLabel1.textAlignment = NSTextAlignmentCenter;
	[containerView1 addSubview:descriptionLabel1];
	[containerView1 addConstraints:@[
								 [NSLayoutConstraint constraintWithItem:descriptionLabel1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeTop multiplier:1.0 constant:20],
								 [NSLayoutConstraint constraintWithItem:descriptionLabel1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
								 [NSLayoutConstraint constraintWithItem:descriptionLabel1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]
								 ]];
	
	usernameField1 = [[UITextField alloc]init];
	usernameField1.translatesAutoresizingMaskIntoConstraints = NO;
	usernameField1.autocapitalizationType = UITextAutocapitalizationTypeNone;
	usernameField1.leftView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"user"] imageWithColor:[UIColor colorWithRed:0.76 green:0.78 blue:0.79 alpha:1]]];
	usernameField1.delegate = self;
	usernameField1.leftView.frame = CGRectMake(0, 0, 42, 42);
	usernameField1.leftView.contentMode = UIViewContentModeCenter;
	usernameField1.leftViewMode = UITextFieldViewModeAlways;
	usernameField1.placeholder = @"username";
	usernameField1.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1];
	usernameField1.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    usernameField1.autocorrectionType = UITextAutocorrectionTypeNo;
	[containerView1 addSubview:usernameField1];
	[containerView1 addConstraints:@[
								 [NSLayoutConstraint constraintWithItem:usernameField1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:descriptionLabel1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20],
								 [NSLayoutConstraint constraintWithItem:usernameField1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
								 [NSLayoutConstraint constraintWithItem:usernameField1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:42],
								 [NSLayoutConstraint constraintWithItem:usernameField1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
								 ]];
	
	emailField1 = [[UITextField alloc]init];
	emailField1.translatesAutoresizingMaskIntoConstraints = NO;
	emailField1.leftView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"mail"] imageWithColor:[UIColor colorWithRed:0.76 green:0.78 blue:0.79 alpha:1]]];
	emailField1.delegate = self;
	emailField1.leftView.frame = CGRectMake(0, 0, 42, 42);
	emailField1.leftView.contentMode = UIViewContentModeCenter;
	emailField1.leftViewMode = UITextFieldViewModeAlways;
	emailField1.placeholder = @"email address";
	emailField1.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1];
	emailField1.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    emailField1.autocorrectionType = UITextAutocorrectionTypeNo;
	[containerView1 addSubview:emailField1];
	[containerView1 addConstraints:@[
								 [NSLayoutConstraint constraintWithItem:emailField1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:usernameField1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
								 [NSLayoutConstraint constraintWithItem:emailField1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
								 [NSLayoutConstraint constraintWithItem:emailField1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:42],
								 [NSLayoutConstraint constraintWithItem:emailField1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
								 ]];
	
	roundContinueContainer1 = [UIButton buttonWithType:UIButtonTypeSystem];
	roundContinueContainer1.translatesAutoresizingMaskIntoConstraints = NO;
	roundContinueContainer1.backgroundColor = [UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1];
	roundContinueContainer1.layer.cornerRadius = 20;
	[roundContinueContainer1 addTarget:self action:@selector(continueButton1Pressed) forControlEvents:UIControlEventTouchUpInside];
	[containerView1 addSubview:roundContinueContainer1];
	[containerView1 addConstraints:@[
									[NSLayoutConstraint constraintWithItem:roundContinueContainer1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeWidth multiplier:0.7 constant:0],
									[NSLayoutConstraint constraintWithItem:roundContinueContainer1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: 40],
									[NSLayoutConstraint constraintWithItem:roundContinueContainer1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
									[NSLayoutConstraint constraintWithItem:roundContinueContainer1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:emailField1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20],
									[NSLayoutConstraint constraintWithItem:roundContinueContainer1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]
									]];
	
	carrot1 = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"carrot"] imageWithColor:[UIColor whiteColor]]];
	carrot1.translatesAutoresizingMaskIntoConstraints = NO;
	carrot1.userInteractionEnabled = NO;
	carrot1.exclusiveTouch = NO;
	[roundContinueContainer1 addSubview:carrot1];
	[roundContinueContainer1 addConstraints:@[
											 [NSLayoutConstraint constraintWithItem:carrot1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
											 [NSLayoutConstraint constraintWithItem:carrot1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer1 attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0],
											 [NSLayoutConstraint constraintWithItem:carrot1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:carrot1 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
											 [NSLayoutConstraint constraintWithItem:carrot1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
											 ]];
	
	continueLabel1 = [[UILabel alloc]init];
	continueLabel1.translatesAutoresizingMaskIntoConstraints = NO;
	continueLabel1.userInteractionEnabled = NO;
	continueLabel1.exclusiveTouch = NO;
	continueLabel1.text = @"Continue";
	continueLabel1.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	continueLabel1.textColor = [UIColor whiteColor];
	continueLabel1.textAlignment = NSTextAlignmentLeft;
	[roundContinueContainer1 addSubview:continueLabel1];
	[roundContinueContainer1 addConstraints:@[
											 [NSLayoutConstraint constraintWithItem:continueLabel1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20],
											 [NSLayoutConstraint constraintWithItem:continueLabel1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
											 [NSLayoutConstraint constraintWithItem:continueLabel1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer1 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
											 [NSLayoutConstraint constraintWithItem:continueLabel1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
											 ]];
	
	backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.translatesAutoresizingMaskIntoConstraints = NO;
	backButton.backgroundColor = [UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1];
	backButton.layer.cornerRadius = 40;
	[backButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	[self.view addConstraints:@[
								[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80],
								[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80],
								[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-80]
								]];
	
	backButtonImage = [[UIImageView alloc]initWithImage:[UIImage cancelButtonX]];
	backButtonImage.translatesAutoresizingMaskIntoConstraints = NO;
	backButtonImage.contentMode = UIViewContentModeScaleAspectFit;
	[backButton addSubview:backButtonImage];
	[backButton addConstraints:@[
								   [NSLayoutConstraint constraintWithItem:backButtonImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:backButtonImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:backButtonImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25],
								   [NSLayoutConstraint constraintWithItem:backButtonImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25]
								   ]];
	
	background2 = [[UIView alloc]init];
	background2.translatesAutoresizingMaskIntoConstraints = NO;
	background2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self.view addSubview:background2];
	[self.view addConstraints:@[
								[NSLayoutConstraint constraintWithItem:background2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:background1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
								]];
	
	containerView2 = [[UIView alloc] init];
	containerView2.translatesAutoresizingMaskIntoConstraints = NO;
	containerView2.layer.cornerRadius = 20;
	containerView2.backgroundColor = [UIColor whiteColor];
	[background2 addSubview:containerView2];
	[background2 addConstraints:@[
								[NSLayoutConstraint constraintWithItem:containerView2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:background2 attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:containerView2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:background2 attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:containerView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:background2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-50]
								]];
	
	descriptionLabel2 = [[UILabel alloc] init];
	descriptionLabel2.translatesAutoresizingMaskIntoConstraints = NO;
	descriptionLabel2.text = @"Type in and confirm your Password";
	descriptionLabel2.font = [UIFont fontWithName:@"Avenir-Book" size:14];
	descriptionLabel2.numberOfLines = -1;
	descriptionLabel2.textAlignment = NSTextAlignmentCenter;
	[containerView2 addSubview:descriptionLabel2];
	[containerView2 addConstraints:@[
									 [NSLayoutConstraint constraintWithItem:descriptionLabel2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:20],
									 [NSLayoutConstraint constraintWithItem:descriptionLabel2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
									 [NSLayoutConstraint constraintWithItem:descriptionLabel2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]
									 ]];
	
	passwordField2 = [[UITextField alloc]init];
	passwordField2.translatesAutoresizingMaskIntoConstraints = NO;
	passwordField2.leftView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"lock"] imageWithColor:[UIColor colorWithRed:0.76 green:0.78 blue:0.79 alpha:1]]];
	passwordField2.delegate = self;
	passwordField2.leftView.frame = CGRectMake(0, 0, 42, 42);
	passwordField2.leftView.contentMode = UIViewContentModeCenter;
	passwordField2.leftViewMode = UITextFieldViewModeAlways;
	passwordField2.placeholder = @"password";
	passwordField2.secureTextEntry = YES;
	passwordField2.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1];
	passwordField2.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    passwordField2.autocorrectionType = UITextAutocorrectionTypeNo;
	[containerView2 addSubview:passwordField2];
	[containerView2 addConstraints:@[
									 [NSLayoutConstraint constraintWithItem:passwordField2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:descriptionLabel2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20],
									 [NSLayoutConstraint constraintWithItem:passwordField2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
									 [NSLayoutConstraint constraintWithItem:passwordField2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:42],
									 [NSLayoutConstraint constraintWithItem:passwordField2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
									 ]];
	
	confirmPasswordField2 = [[UITextField alloc]init];
	confirmPasswordField2.translatesAutoresizingMaskIntoConstraints = NO;
	confirmPasswordField2.leftView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"lock"] imageWithColor:[UIColor colorWithRed:0.76 green:0.78 blue:0.79 alpha:1]]];
	confirmPasswordField2.delegate = self;
	confirmPasswordField2.leftView.frame = CGRectMake(0, 0, 42, 42);
	confirmPasswordField2.leftView.contentMode = UIViewContentModeCenter;
	confirmPasswordField2.leftViewMode = UITextFieldViewModeAlways;
	confirmPasswordField2.placeholder = @"confirm password";
	confirmPasswordField2.secureTextEntry = YES;
	confirmPasswordField2.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1];
	confirmPasswordField2.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    confirmPasswordField2.autocorrectionType = UITextAutocorrectionTypeNo;
	[containerView2 addSubview:confirmPasswordField2];
	[containerView2 addConstraints:@[
									 [NSLayoutConstraint constraintWithItem:confirmPasswordField2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:passwordField2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
									 [NSLayoutConstraint constraintWithItem:confirmPasswordField2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
									 [NSLayoutConstraint constraintWithItem:confirmPasswordField2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:42],
									 [NSLayoutConstraint constraintWithItem:confirmPasswordField2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
									 ]];
	
	roundContinueContainer2 = [UIButton buttonWithType:UIButtonTypeSystem];
	roundContinueContainer2.translatesAutoresizingMaskIntoConstraints = NO;
	roundContinueContainer2.backgroundColor = [UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1];
	roundContinueContainer2.layer.cornerRadius = 20;
	[roundContinueContainer2 addTarget:self action:@selector(continueButton2Pressed) forControlEvents:UIControlEventTouchUpInside];
	[containerView2 addSubview:roundContinueContainer2];
	[containerView2 addConstraints:@[
									 [NSLayoutConstraint constraintWithItem:roundContinueContainer2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeWidth multiplier:0.7 constant:0],
									 [NSLayoutConstraint constraintWithItem:roundContinueContainer2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: 40],
									 [NSLayoutConstraint constraintWithItem:roundContinueContainer2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
									 [NSLayoutConstraint constraintWithItem:roundContinueContainer2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:confirmPasswordField2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20],
									 [NSLayoutConstraint constraintWithItem:roundContinueContainer2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]
									 ]];
	
	carrot2 = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"carrot"] imageWithColor:[UIColor whiteColor]]];
	carrot2.translatesAutoresizingMaskIntoConstraints = NO;
	carrot2.userInteractionEnabled = NO;
	carrot2.exclusiveTouch = NO;
	[roundContinueContainer2 addSubview:carrot2];
	[roundContinueContainer2 addConstraints:@[
										   [NSLayoutConstraint constraintWithItem:carrot2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
										   [NSLayoutConstraint constraintWithItem:carrot2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer2 attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0],
										   [NSLayoutConstraint constraintWithItem:carrot2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:carrot2 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
										   [NSLayoutConstraint constraintWithItem:carrot2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
										   ]];
	
	continueLabel2 = [[UILabel alloc]init];
	continueLabel2.translatesAutoresizingMaskIntoConstraints = NO;
	continueLabel2.userInteractionEnabled = NO;
	continueLabel2.exclusiveTouch = NO;
	continueLabel2.text = @"Continue";
	continueLabel2.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	continueLabel2.textColor = [UIColor whiteColor];
	continueLabel2.textAlignment = NSTextAlignmentLeft;
	[roundContinueContainer2 addSubview:continueLabel2];
	[roundContinueContainer2 addConstraints:@[
										   [NSLayoutConstraint constraintWithItem:continueLabel2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20],
										   [NSLayoutConstraint constraintWithItem:continueLabel2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
										   [NSLayoutConstraint constraintWithItem:continueLabel2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer2 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
										   [NSLayoutConstraint constraintWithItem:continueLabel2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundContinueContainer2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
										   ]];
	
	background3 = [[UIView alloc]init];
	background3.translatesAutoresizingMaskIntoConstraints = NO;
	background3.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self.view addSubview:background3];
	[self.view addConstraints:@[
								[NSLayoutConstraint constraintWithItem:background3 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:background2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background3 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
								]];
	
	containerView3 = [[UIView alloc] init];
	containerView3.translatesAutoresizingMaskIntoConstraints = NO;
	containerView3.layer.cornerRadius = 20;
	containerView3.backgroundColor = [UIColor whiteColor];
	[background3 addSubview:containerView3];
	[background3 addConstraints:@[
								  [NSLayoutConstraint constraintWithItem:containerView3 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:background3 attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:0],
								  [NSLayoutConstraint constraintWithItem:containerView3 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:background3 attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0],
								  [NSLayoutConstraint constraintWithItem:containerView3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:background3 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-50],
								  [NSLayoutConstraint constraintWithItem:containerView3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:223.5]
								  ]];
	
	imageButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
	imageButton3.translatesAutoresizingMaskIntoConstraints = NO;
	[imageButton3 setImage:[UIImage plusButton] forState:UIControlStateNormal];
	[imageButton3 setImage:[UIImage plusButtonHighlighted] forState:UIControlStateHighlighted];
	imageButton3.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[imageButton3 addTarget:self action:@selector(imageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[containerView3 addSubview:imageButton3];
	[containerView3 addConstraints:@[
									 [NSLayoutConstraint constraintWithItem:imageButton3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageButton3 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
									 [NSLayoutConstraint constraintWithItem:imageButton3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView3 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
									 [NSLayoutConstraint constraintWithItem:imageButton3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView3 attribute:NSLayoutAttributeTop multiplier:1.0 constant:30]
									 ]];
	
	roundWelcomeLabel3 = [UIButton buttonWithType:UIButtonTypeSystem];
	roundWelcomeLabel3.translatesAutoresizingMaskIntoConstraints = NO;
	roundWelcomeLabel3.backgroundColor = [UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1];
	roundWelcomeLabel3.layer.cornerRadius = 20;
    [roundWelcomeLabel3 addTarget:self action:@selector(welcomeButton3Pressed) forControlEvents:UIControlEventTouchUpInside];
	//	[roundSignInContainer addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
	[containerView3 addSubview:roundWelcomeLabel3];
	[containerView3 addConstraints:@[
									 [NSLayoutConstraint constraintWithItem:roundWelcomeLabel3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containerView3 attribute:NSLayoutAttributeWidth multiplier:0.7 constant:0],
									 [NSLayoutConstraint constraintWithItem:roundWelcomeLabel3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: 40],
									 [NSLayoutConstraint constraintWithItem:roundWelcomeLabel3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView3 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
									 [NSLayoutConstraint constraintWithItem:roundWelcomeLabel3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageButton3 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:30],
									 [NSLayoutConstraint constraintWithItem:roundWelcomeLabel3 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView3 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]
									 ]];
	
	carrot3 = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"carrot"] imageWithColor:[UIColor whiteColor]]];
	carrot3.translatesAutoresizingMaskIntoConstraints = NO;
	carrot3.userInteractionEnabled = NO;
	carrot3.exclusiveTouch = NO;
	[roundWelcomeLabel3 addSubview:carrot3];
	[roundWelcomeLabel3 addConstraints:@[
											   [NSLayoutConstraint constraintWithItem:carrot3 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundWelcomeLabel3 attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
											   [NSLayoutConstraint constraintWithItem:carrot3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundWelcomeLabel3 attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0],
											   [NSLayoutConstraint constraintWithItem:carrot3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:carrot3 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
											   [NSLayoutConstraint constraintWithItem:carrot3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundWelcomeLabel3 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
											   ]];
	
	welcomeLabel3 = [[UILabel alloc]init];
	welcomeLabel3.translatesAutoresizingMaskIntoConstraints = NO;
	welcomeLabel3.userInteractionEnabled = NO;
	welcomeLabel3.exclusiveTouch = NO;
	welcomeLabel3.text = @"Welcome";
	welcomeLabel3.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	welcomeLabel3.textColor = [UIColor whiteColor];
	welcomeLabel3.textAlignment = NSTextAlignmentLeft;
	[roundWelcomeLabel3 addSubview:welcomeLabel3];
	[roundWelcomeLabel3 addConstraints:@[
											   [NSLayoutConstraint constraintWithItem:welcomeLabel3 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:roundWelcomeLabel3 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20],
											   [NSLayoutConstraint constraintWithItem:welcomeLabel3 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundWelcomeLabel3 attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
											   [NSLayoutConstraint constraintWithItem:welcomeLabel3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundWelcomeLabel3 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
											   [NSLayoutConstraint constraintWithItem:welcomeLabel3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundWelcomeLabel3 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
											   ]];
	
	background4 = [[UIView alloc]init];
	background4.translatesAutoresizingMaskIntoConstraints = NO;
	background4.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self.view addSubview:background4];
	[self.view addConstraints:@[
								[NSLayoutConstraint constraintWithItem:background4 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:background3 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:background4 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
								]];
	
	[self.view bringSubviewToFront:backButton];
}

- (void)continueButton1Pressed{
	[self resignAllResponders];
#warning NOT WORKING!!!!!!!!
	[[MomentsAPIUtilities sharedInstance] isRegisteredUsername:usernameField1.text orEmail:emailField1.text completion:^(NSDictionary *values) {
		NSLog(@"%@   %@", values[@"usernameAvailable"], values[@"emailAvailable"]);
		if (values[@"usernameAvailable"] != nil && values[@"emailAvailable"] != nil){
			backButtonImage.image = [UIImage backButtonClosed];
			backButtonImage.animationImages = [UIImage transitionCancelButtonImages:NO];
			backButtonImage.animationDuration = 0.25;
			backButtonImage.animationRepeatCount = 1;
			[backButtonImage startAnimating];
			backButton.enabled = NO;
			POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
			layoutAnimation.springSpeed = 10.0f;
			layoutAnimation.springBounciness = 5.0f;
			layoutAnimation.toValue = @(-self.view.bounds.size.width);
			layoutAnimation.beginTime = CACurrentMediaTime();
			[_leftmostLayoutConstraint pop_addAnimation:layoutAnimation forKey:@"detailsContainerWidthAnimate"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				backButtonImage.image = [UIImage backButtonOpen];
				backButtonImage.animationImages = [UIImage transitionBackButtonImages:YES];
				backButtonImage.animationDuration = 0.25;
				backButtonImage.animationRepeatCount = 1;
				[backButtonImage startAnimating];
				backButton.enabled = YES;
				[backButton removeTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
				[backButton addTarget:self action:@selector(backButton2Pressed) forControlEvents:UIControlEventTouchUpInside];
			});
		} else{
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
			
			UILabel *errorLabel = [[UILabel alloc]init];
			errorLabel.textColor = [UIColor redColor];
			errorLabel.alpha = 0;
			errorLabel.font = [UIFont fontWithName:@"Avenir-Book" size:11];
			errorLabel.textAlignment = NSTextAlignmentCenter;
			errorLabel.center = CGPointMake(background1.center.x / 2.0, containerView1.frame.origin.y / 2.0);
			BOOL usernameAvailable = [values[@"usernameAvailable"] boolValue];
			BOOL emailAvailable = [values[@"emailAvailable"] boolValue];
			NSString *message = [NSString stringWithFormat:@"%@ already taken.", usernameAvailable ? (emailAvailable ? @"Username and email are" : @"Username is") : @"Email is"];
			NSLog(@"%@   %@", usernameAvailable, emailAvailable);
			errorLabel.text = message;
			[background1 addSubview:errorLabel];
			[UIView animateWithDuration:0.2 animations:^{
				errorLabel.alpha = 1;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.2 delay:1.5 options:0 animations:^{
					errorLabel.alpha = 0;
				} completion:^(BOOL finished) {
					[errorLabel removeFromSuperview];
				}];
			}];
		}
	}];
}

- (void)cancelButtonPressed{
	[self resignAllResponders];
	backButtonImage.image = [UIImage cancelButtonLine];
	backButtonImage.animationImages = [UIImage transitionCancelButtonImages:NO];
	backButtonImage.animationDuration = 0.25;
	backButtonImage.animationRepeatCount = 1;
	[backButtonImage startAnimating];
	backButton.enabled = NO;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if ([self.presentingViewController isKindOfClass:[EDPagingViewController class]]){
			[((EDPagingViewController *)self.presentingViewController) pageControlToggleOnScreen];
		}
		[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	});
}

- (void)continueButton2Pressed{
#warning TODO: Check the passwords are the same
    
	[self resignAllResponders];
    backButton.enabled = NO;
	
	POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
	layoutAnimation.springSpeed = 10.0f;
	layoutAnimation.springBounciness = 5.0f;
	layoutAnimation.toValue = @(2 * -self.view.bounds.size.width);
	layoutAnimation.beginTime = CACurrentMediaTime();
	[_leftmostLayoutConstraint pop_addAnimation:layoutAnimation forKey:@"detailsContainerWidthAnimate"];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		backButton.enabled = YES;
		[backButton removeTarget:self action:@selector(backButton2Pressed) forControlEvents:UIControlEventTouchUpInside];
		[backButton addTarget:self action:@selector(backButton3Pressed) forControlEvents:UIControlEventTouchUpInside];
	});
}

- (void)backButton2Pressed{
	[self resignAllResponders];
	backButtonImage.image = [UIImage backButtonClosed];
	backButtonImage.animationImages = [UIImage transitionBackButtonImages:NO];
	backButtonImage.animationDuration = 0.25;
	backButtonImage.animationRepeatCount = 1;
	[backButtonImage startAnimating];
	backButton.enabled = NO;
	
	POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
	layoutAnimation.springSpeed = 10.0f;
	layoutAnimation.springBounciness = 5.0f;
	layoutAnimation.toValue = @(0);
	layoutAnimation.beginTime = CACurrentMediaTime();
	[_leftmostLayoutConstraint pop_addAnimation:layoutAnimation forKey:@"detailsContainerWidthAnimate"];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		backButtonImage.image = [UIImage cancelButtonX];
		backButtonImage.animationImages = [UIImage transitionCancelButtonImages:YES];
		backButtonImage.animationDuration = 0.25;
		backButtonImage.animationRepeatCount = 1;
		[backButtonImage startAnimating];
		backButton.enabled = YES;
		[backButton removeTarget:self action:@selector(backButton2Pressed) forControlEvents:UIControlEventTouchUpInside];
		[backButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	});
}

- (void)welcomeButton3Pressed{
	[self resignAllResponders];
    
    SCNView *v = [[SCNView alloc] initWithFrame:self.view.bounds];
    v.scene = [[EDSpinningBoxScene alloc] init];
	v.backgroundColor = [UIColor clearColor];
	UIView *vContainer = [[UIView alloc]initWithFrame:self.view.bounds];
	vContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	vContainer.alpha = 0.0;
	[vContainer addSubview:v];
	[self.view addSubview:vContainer];
	v.center = CGPointMake(v.center.x, containerView3.frame.origin.y / 2);
    [UIView animateWithDuration:0.2 delay:0.05 options:0 animations:^{
        vContainer.alpha = 1.0;
    } completion:nil];
    
    MOUser *user = [MomentsAPIUtilities sharedInstance].user;
    [user registerWithUsername:usernameField1.text
                         email:emailField1.text
                      password:passwordField2.text
                    completion:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                user.avatar = [imageButton3.imageView.image cropAndScaleToSize:imageButton3.imageView.frame.size.width];
                [[MOS3APIUtilities sharedInstance] putAvatarForUsername:user.name image:user.avatar];
                
                _leftmostLayoutConstraint.constant = 2 * -self.view.frame.size.width;
                backButtonImage.image = [UIImage backButtonClosed];
                backButtonImage.animationImages = [UIImage transitionBackButtonImages:NO];
                backButtonImage.animationDuration = 0.25;
                backButtonImage.animationRepeatCount = 1;
                [backButtonImage startAnimating];
                backButton.enabled = NO;
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.view layoutIfNeeded];
                    vContainer.alpha = 0;
                } completion:^(BOOL finished) {
                    backButtonImage.image = [UIImage backButtonOpen];
                    backButtonImage.animationImages = [UIImage transitionBackButtonImages:YES];
                    backButtonImage.animationDuration = 0.25;
                    backButtonImage.animationRepeatCount = 1;
                    [backButtonImage startAnimating];
                    backButton.enabled = YES;
                    [backButton removeTarget:self action:@selector(backButton3Pressed) forControlEvents:UIControlEventTouchUpInside];
                    [vContainer removeFromSuperview];
                    
                    UIViewController *destinationViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                    
                    [self presentViewController:destinationViewController animated:YES completion:^{
                        EDPagingViewController *pagingViewController = (EDPagingViewController *) self.presentingViewController;
                        [pagingViewController.player stop];
                        pagingViewController = nil;
                    }];
                }];
            } else {
#warning TODO: Show error message
                [UIView animateWithDuration:0.2 animations:^{
                    vContainer.alpha = 0;
                } completion:^(BOOL finished) {
                    [vContainer removeFromSuperview];
                }];
            }
        });
    }];
}

- (void)backButton3Pressed{
	[self resignAllResponders];
	backButton.enabled = NO;
	
	POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
	layoutAnimation.springSpeed = 10.0f;
	layoutAnimation.springBounciness = 5.0f;
	layoutAnimation.toValue = @(-self.view.bounds.size.width);
	layoutAnimation.beginTime = CACurrentMediaTime();
	[_leftmostLayoutConstraint pop_addAnimation:layoutAnimation forKey:@"detailsContainerWidthAnimate"];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		backButton.enabled = YES;
		[backButton removeTarget:self action:@selector(backButton3Pressed) forControlEvents:UIControlEventTouchUpInside];
		[backButton addTarget:self action:@selector(backButton2Pressed) forControlEvents:UIControlEventTouchUpInside];
	});
}

- (void)resignAllResponders{
	[usernameField1 resignFirstResponder];
	[emailField1 resignFirstResponder];
	[passwordField2 resignFirstResponder];
	[confirmPasswordField2 resignFirstResponder];
}

- (void)imageButtonPressed {
	//present action sheet
	[imageButton3 setImage:[UIImage plusButton] forState:UIControlStateNormal];
	imageButton3.imageView.layer.cornerRadius = 0;
	imageButton3.imageView.layer.masksToBounds = NO;
	
	[imageButton3.imageView.layer pop_removeAnimationForKey:@"rotationAnim"];
	POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
	imageButton3.imageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 0);
	rotationAnimation.beginTime = CACurrentMediaTime();
	rotationAnimation.toValue = @(M_PI_2);
	rotationAnimation.springBounciness = 0;
	rotationAnimation.springSpeed = 0;
	[imageButton3.imageView.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnim"];
    
    // temporary design for what would look like a UIAlertController.
    // damon needs to implement the backend on this. :)
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cameraButton = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *photoLibraryButton = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    [sheet addAction:cameraButton];
    [sheet addAction:photoLibraryButton];
    [sheet addAction:cancelButton];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    [picker dismissViewControllerAnimated:YES completion:^{
		[imageButton3 setImage:image forState:UIControlStateNormal];
		imageButton3.imageView.layer.cornerRadius = imageButton3.imageView.layer.frame.size.height / 2.0;
		imageButton3.imageView.layer.masksToBounds = YES;
		imageButton3.imageView.layer.borderWidth = 0;
		imageButton3.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageButton3.imageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if (textField.rightView){
		[UIView animateWithDuration:0.2 animations:^{
			textField.rightView.alpha = 0;
		} completion:^(BOOL finished) {
			textField.rightView = nil;
		}];
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	
	if (textField == usernameField1) {
		[emailField1 becomeFirstResponder];
	} else if (textField == emailField1) {
		[self continueButton1Pressed];
	} else if (textField == passwordField2) {
		[confirmPasswordField2 becomeFirstResponder];
	} else if (textField == confirmPasswordField2) {
		[self continueButton2Pressed];
	}
	
    return YES;
}

@end
