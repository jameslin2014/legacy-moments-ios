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
#import "MOAppDelegate.h"
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

- (BOOL)prefersStatusBarHidden{
	return YES;
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
	usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	usernameField.leftView.contentMode = UIViewContentModeCenter;
	usernameField.leftViewMode = UITextFieldViewModeAlways;
	usernameField.placeholder = @"username";
	usernameField.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1];
	usernameField.font = [UIFont fontWithName:@"Avenir-Book" size:17];
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
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
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
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
	[roundSignInContainer addTarget:self action:@selector(signInButtonPressed) forControlEvents:UIControlEventTouchDown];
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
	[cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchDown];
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

}

- (void)signInButtonPressed {
    [self resignAllResponders];
    
	SCNView *v = [[SCNView alloc] initWithFrame:self.view.bounds];
	v.scene = [[EDSpinningBoxScene alloc] init];
	v.backgroundColor = [UIColor clearColor];
	UIView *vContainer = [[UIView alloc]initWithFrame:self.view.bounds];
	vContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	vContainer.alpha = 0.0;
	[vContainer addSubview:v];
	[self.view addSubview:vContainer];
	v.center = CGPointMake(v.center.x, containerView.frame.origin.y / 2);
	[UIView animateWithDuration:0.2 delay:0.2 options:0 animations:^{
		vContainer.alpha = 1.0;
	} completion:nil];
	
    MOUser *user = [MomentsAPIUtilities sharedInstance].user;
    [user loginWithUsername:usernameField.text password:passwordField.text completion:^(BOOL success) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.2 animations:^{
				vContainer.alpha = 0;
			} completion:^(BOOL finished) {
				[vContainer removeFromSuperview];
				if (success) {
					UIViewController *destinationViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
					[[[UIApplication sharedApplication] delegate] window].rootViewController = destinationViewController;
					[[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
					if ([self.presentingViewController isKindOfClass:[EDPagingViewController class]]){
						EDPagingViewController *pagingViewController = (EDPagingViewController *) self.presentingViewController;
						[pagingViewController.player stop];
					}
				} else {
					AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
					UILabel *errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, containerView.superview.frame.size.width * .8, 30)];
					errorLabel.textColor = [UIColor redColor];
//					errorLabel.alpha = 0;
					errorLabel.backgroundColor = [UIColor whiteColor];
					errorLabel.font = [UIFont fontWithName:@"Avenir-Book" size:11];
					errorLabel.textAlignment = NSTextAlignmentCenter;
					[errorLabel sizeToFit];
					errorLabel.center = CGPointMake(containerView.superview.bounds.size.width / 2.0, containerView.frame.origin.y / 2.0);
					NSString *message = @"Sign in failed.";
					errorLabel.text = message;
					[containerView.superview addSubview:errorLabel];
					[UIView animateWithDuration:0.2 animations:^{
						errorLabel.alpha = 1;
					} completion:^(BOOL finished) {
						[UIView animateWithDuration:0.2 delay:1.5 options:0 animations:^{
							errorLabel.alpha = 0;
						} completion:^(BOOL finished) {
							[errorLabel removeFromSuperview];
						}];
					}];
					return;
				}
			}];
		});
    }];
}

- (void)cancelButtonPressed{
	cancelImage.image = [UIImage cancelButtonLine];
	cancelImage.animationImages = [UIImage transitionCancelButtonImages:NO];
	cancelImage.animationDuration = 0.15;
	cancelImage.animationRepeatCount = 1;
	[cancelImage startAnimating];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    
	if (textField == usernameField) {
		[passwordField becomeFirstResponder];
	} else {
		[self signInButtonPressed];
	}
    
    return YES;
}

@end
