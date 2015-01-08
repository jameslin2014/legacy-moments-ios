//
//  MOLoginViewController.m
//  Onboarding
//
//  Created by Evan Dekhayser on 1/2/15.
//  Copyright (c) 2015 Xappox, LLC. All rights reserved.
//

#import "MOSignInViewController.h"
#import "UIImage+EDExtras.h"
#import "EDPagingViewController.h"
#import "MomentsAPIUtilities.h"
#import "MOUser.h"
#import <SceneKit/SceneKit.h>
#import "EDSpinningBoxScene.h"

@interface MOSignInViewController ()

@end

@implementation MOSignInViewController{
	UIView *containerView;
	UILabel *descriptionLabel;
	UITextField *usernameField;
	UITextField *passwordField;
	UIButton *roundSignInContainer;
	UIImageView *carrot;
	UILabel *signInLabel;
	
	UIButton *cancelButton;
	UIImageView *cancelImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	self.modalPresentationStyle = UIModalPresentationOverFullScreen;
	self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAllResponders)]];
	
	containerView = [[UIView alloc] init];
	containerView.translatesAutoresizingMaskIntoConstraints = NO;
	containerView.layer.cornerRadius = 20;
	containerView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:containerView];
	[self.view addConstraints:@[
								[NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-50]
								]];
	
	descriptionLabel = [[UILabel alloc] init];
	descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
	descriptionLabel.text = @"Type in your Username and Password";
	descriptionLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
	descriptionLabel.numberOfLines = -1;
	descriptionLabel.textAlignment = NSTextAlignmentCenter;
	[containerView addSubview:descriptionLabel];
	[containerView addConstraints:@[
								 [NSLayoutConstraint constraintWithItem:descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20],
								 [NSLayoutConstraint constraintWithItem:descriptionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
								 [NSLayoutConstraint constraintWithItem:descriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]
								 ]];
	
	usernameField = [[UITextField alloc]init];
	usernameField.translatesAutoresizingMaskIntoConstraints = NO;
	usernameField.leftView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"user"] imageWithColor:[UIColor colorWithRed:0.76 green:0.78 blue:0.79 alpha:1]]];
	usernameField.leftView.frame = CGRectMake(0, 0, 42, 42);
	usernameField.leftView.contentMode = UIViewContentModeCenter;
	usernameField.leftViewMode = UITextFieldViewModeAlways;
	usernameField.placeholder = @"username";
	usernameField.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1];
	usernameField.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    usernameField.delegate = self;
	[containerView addSubview:usernameField];
	[containerView addConstraints:@[
								 [NSLayoutConstraint constraintWithItem:usernameField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:descriptionLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20],
								 [NSLayoutConstraint constraintWithItem:usernameField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
								 [NSLayoutConstraint constraintWithItem:usernameField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:42],
								 [NSLayoutConstraint constraintWithItem:usernameField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
								 ]];
	
	passwordField = [[UITextField alloc]init];
	passwordField.translatesAutoresizingMaskIntoConstraints = NO;
	passwordField.leftView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"lock"] imageWithColor:[UIColor colorWithRed:0.76 green:0.78 blue:0.79 alpha:1]]];
	passwordField.leftView.frame = CGRectMake(0, 0, 42, 42);
	passwordField.leftView.contentMode = UIViewContentModeCenter;
	passwordField.leftViewMode = UITextFieldViewModeAlways;
	passwordField.placeholder = @"password";
	passwordField.secureTextEntry = YES;
	passwordField.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1];
	passwordField.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    passwordField.delegate = self;
	[containerView addSubview:passwordField];
	[containerView addConstraints:@[
								 [NSLayoutConstraint constraintWithItem:passwordField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:usernameField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
								 [NSLayoutConstraint constraintWithItem:passwordField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
								 [NSLayoutConstraint constraintWithItem:passwordField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:42],
								 [NSLayoutConstraint constraintWithItem:passwordField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
								 ]];
	
	roundSignInContainer = [UIButton buttonWithType:UIButtonTypeSystem];
	roundSignInContainer.translatesAutoresizingMaskIntoConstraints = NO;
	roundSignInContainer.backgroundColor = [UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1];
	roundSignInContainer.layer.cornerRadius = 20;
	[roundSignInContainer addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
	[containerView addSubview:roundSignInContainer];
	[containerView addConstraints:@[
							   [NSLayoutConstraint constraintWithItem:roundSignInContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeWidth multiplier:0.7 constant:0],
							   [NSLayoutConstraint constraintWithItem:roundSignInContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: 40],
							   [NSLayoutConstraint constraintWithItem:roundSignInContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
							   [NSLayoutConstraint constraintWithItem:roundSignInContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:passwordField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20],
							   [NSLayoutConstraint constraintWithItem:roundSignInContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]
							   ]];
	
	carrot = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"carrot"] imageWithColor:[UIColor whiteColor]]];
	carrot.translatesAutoresizingMaskIntoConstraints = NO;
	carrot.userInteractionEnabled = NO;
	carrot.exclusiveTouch = NO;
	[roundSignInContainer addSubview:carrot];
	[roundSignInContainer addConstraints:@[
							   [NSLayoutConstraint constraintWithItem:carrot attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
							   [NSLayoutConstraint constraintWithItem:carrot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeHeight multiplier:0.4 constant:0],
							   [NSLayoutConstraint constraintWithItem:carrot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:carrot attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
							   [NSLayoutConstraint constraintWithItem:carrot attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
							   ]];
	
	signInLabel = [[UILabel alloc]init];
	signInLabel.translatesAutoresizingMaskIntoConstraints = NO;
	signInLabel.userInteractionEnabled = NO;
	signInLabel.exclusiveTouch = NO;
	signInLabel.text = @"Sign In";
	signInLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	signInLabel.textColor = [UIColor whiteColor];
	signInLabel.textAlignment = NSTextAlignmentLeft;
	[roundSignInContainer addSubview:signInLabel];
	[roundSignInContainer addConstraints:@[
							   [NSLayoutConstraint constraintWithItem:signInLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20],
							   [NSLayoutConstraint constraintWithItem:signInLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20],
							   [NSLayoutConstraint constraintWithItem:signInLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0],
							   [NSLayoutConstraint constraintWithItem:signInLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:roundSignInContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
							   ]];
	
	cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
	cancelButton.backgroundColor = [UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1];
	cancelButton.layer.cornerRadius = 40;
	[cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:cancelButton];
	[self.view addConstraints:@[
								[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80],
								[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
								[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80],
								[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-80]
								]];
	
	cancelImage = [[UIImageView alloc]initWithImage:[UIImage cancelButtonX]];
	cancelImage.translatesAutoresizingMaskIntoConstraints = NO;
	cancelImage.contentMode = UIViewContentModeScaleAspectFit;
	[cancelButton addSubview:cancelImage];
	[cancelButton addConstraints:@[
								   [NSLayoutConstraint constraintWithItem:cancelImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:cancelImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:cancelImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25],
								   [NSLayoutConstraint constraintWithItem:cancelImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25]
								   ]];

    [usernameField becomeFirstResponder];
}

- (void)signIn {
    [self resignAllResponders];
    
    SCNView *v = [[SCNView alloc] initWithFrame:self.view.bounds];
    v.scene = [[EDSpinningBoxScene alloc] init];
    v.alpha = 0.0;
    v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:v];
    [UIView animateWithDuration:0.2 animations:^{
        v.alpha = 1.0;
    }];
    
    MOUser *user = [MomentsAPIUtilities sharedInstance].user;
    [[MomentsAPIUtilities sharedInstance] verifyUsername:usernameField.text andPassword:passwordField.text completion:^(NSDictionary *dictionary) {
        BOOL valid = [[dictionary objectForKey:@"login"] boolValue];
        if (valid) {
            user.loggedIn = YES;
            user.token = [dictionary objectForKey:@"token"];
            [user reload];
            // TODO: Go to the normal view controller
        } else {
            NSLog(@"Login failed");
        }
        [v removeFromSuperview];
        
        // TODO: Go to the MOTableViewController
    }];
}

- (void)cancelButtonPressed{
	cancelImage.image = [UIImage cancelButtonLine];
	cancelImage.animationImages = [UIImage transitionCancelButtonImages:NO];
	cancelImage.animationDuration = 0.15;
	cancelImage.animationRepeatCount = 1;
	[cancelImage startAnimating];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if ([self.presentingViewController isKindOfClass:[EDPagingViewController class]]){
			[((EDPagingViewController *)self.presentingViewController) pageControlToggleOnScreen];
		}
		[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	});
}

- (void)resignAllResponders{
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self signIn];
    
    return YES;
}

@end
