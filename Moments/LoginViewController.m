//
//  LoginViewController.m
//  Moments
//
//  Created by Douglas Bumby on 2014-11-28.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property UIGestureRecognizer *tapper;

@end

@implementation LoginViewController
@synthesize loginButton, usernameField, passwordField;
@synthesize tapper, backgroundImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    // Login Button
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Username Field
    usernameField.borderStyle = UITextBorderStyleNone;
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    usernameField.font = [UIFont fontWithName:@"SanFranciscoText-Regular" size:15];
    usernameField.textColor = [UIColor whiteColor];
    usernameField.keyboardAppearance = UIKeyboardAppearanceLight;
    usernameField.keyboardType = UIKeyboardTypeEmailAddress;
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:usernameField];
    
    // Password Field
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordField.font = [UIFont fontWithName:@"SanFranciscoText-Regular" size:15];
    passwordField.textColor = [UIColor whiteColor];
    passwordField.keyboardAppearance = UIKeyboardAppearanceLight;
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.secureTextEntry = YES;
    [self.view addSubview:passwordField];
    
}

- (void)loginButtonAction:(UIButton *)sender {
    NSLog(@"Login button pressed.");
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender {
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
