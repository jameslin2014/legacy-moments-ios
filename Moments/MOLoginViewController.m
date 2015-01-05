//
//  LoginViewController.m
//  Moments
//
//  Created by Douglas Bumby on 2014-11-28.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOLoginViewController.h"

@interface MOLoginViewController ()

@property UIGestureRecognizer *tapper;

@property IBOutlet UITextField *usernameField;
@property IBOutlet UITextField *passwordField;
@property IBOutlet UIButton *loginButton;
@property IBOutlet UIImageView *backgroundImage;

@end

@implementation MOLoginViewController
@synthesize loginButton, usernameField, passwordField;
@synthesize tapper, backgroundImage;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"UserHasLoggedInSuccessfullyVersion-1.0"] && [MomentsAPIUtilities sharedInstance].user.name){
		[[[[UIApplication sharedApplication] delegate] window] setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"pageView"]];
	}
	
    // Do any additional setup after loading the view.
    tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    // Username Field
    usernameField.borderStyle = UITextBorderStyleNone;
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    usernameField.font = [UIFont fontWithName:@"Avenir-Book" size:15];
    usernameField.textColor = [UIColor whiteColor];
    usernameField.keyboardAppearance = UIKeyboardAppearanceLight;
    usernameField.keyboardType = UIKeyboardTypeEmailAddress;
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.returnKeyType = UIReturnKeyNext;
    usernameField.tintColor = [UIColor whiteColor];
    [self.view addSubview:usernameField];
    usernameField.text = [MomentsAPIUtilities sharedInstance].user.name;
    
    // Password Field
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.tintColor = [UIColor whiteColor];
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordField.font = [UIFont fontWithName:@"Avenir-Book" size:15];
    passwordField.textColor = [UIColor whiteColor];
    passwordField.keyboardAppearance = UIKeyboardAppearanceLight;
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.secureTextEntry = YES;
    [self.view addSubview:passwordField];
    passwordField.text = [MomentsAPIUtilities sharedInstance].user.password;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender {
    [self.view endEditing:YES];
    
    [[MomentsAPIUtilities sharedInstance].user loginWithUsername:usernameField.text password:passwordField.text];
     
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload" object:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserHasLoggedInSuccessfullyVersion-1.0"];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.view.alpha = 0.0f;
    
    [[MomentsAPIUtilities sharedInstance].user loginWithUsername:usernameField.text password:passwordField.text];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"pageView"];
    [self presentViewController:viewController animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end