//
//  LoginViewController.m
//  Moments
//
//  Created by Douglas Bumby on 2014-11-28.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginButton, usernameField, passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Login Button
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Username Field
    self.usernameField = [UITextField alloc];
    usernameField.borderStyle = UITextBorderStyleLine;
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    usernameField.font = [UIFont fontWithName:@"SanFranciscoText-Regular" size:15];
    usernameField.textColor = [UIColor whiteColor];
    usernameField.keyboardAppearance = UIKeyboardAppearanceDark;
    usernameField.keyboardType = UIKeyboardTypeEmailAddress;
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:usernameField];
    
    // Password Field
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 250, 280, 45)];
    passwordField.borderStyle = UITextBorderStyleLine;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordField.font = [UIFont fontWithName:@"SanFranciscoText-Regular" size:15];
    passwordField.textColor = [UIColor whiteColor];
    passwordField.keyboardAppearance = UIKeyboardAppearanceDark;
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.secureTextEntry = YES;
    [self.view addSubview:passwordField];
    
}

- (void)loginButtonAction:(UIButton *)sender {
    NSLog(@"Login button pressed.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
