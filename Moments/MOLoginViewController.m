//
//  LoginViewController.m
//  Moments
//
//  Created by Douglas Bumby on 2014-11-28.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOLoginViewController.h"
#import "MomentsAPIUtilities.h"
#import "SSKeychain.h"

@interface MOLoginViewController ()

@property UIGestureRecognizer *tapper;

@end

@implementation MOLoginViewController
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
    self.view.alpha = 1.0;
    
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
    usernameField.tintColor = [UIColor whiteColor];
    [self.view addSubview:usernameField];
    usernameField.text = [SSKeychain passwordForService:@"moments" account:@"username"];
    
    // Password Field
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.tintColor = [UIColor whiteColor];
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
    passwordField.text = [SSKeychain passwordForService:@"moments" account:@"password"];
}

- (void)loginButtonAction:(UIButton *)sender {
    NSLog(@"Login button pressed.");
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender {
    [self.view endEditing:YES];
    
    // Attempt to login
    MomentsAPIUtilities *LoginAPI = [MomentsAPIUtilities alloc];
    [LoginAPI loginWithUsername:usernameField.text andPassword:passwordField.text completion:^(BOOL login) {
        if (login == true) {
            [SSKeychain setPassword:passwordField.text forService:@"moments" account:@"password"];
            [SSKeychain setPassword:usernameField.text forService:@"moments" account:@"username"];
            NSLog(@"Login Succeeded");
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"pageView"];
            [self presentViewController:vc animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] setObject:usernameField.text forKey:@"currentUserName"];
        } else {
            NSLog(@"Login Failed");
        }
        
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    self.view.alpha = 0.0f;
    MomentsAPIUtilities *LoginAPI = [MomentsAPIUtilities alloc];
    [LoginAPI loginWithUsername:[SSKeychain passwordForService:@"moments" account:@"username"] andPassword:[SSKeychain passwordForService:@"moments" account:@"password"] completion:^(BOOL login) {
        if (login == true) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"pageView"];
            [[NSUserDefaults standardUserDefaults] setObject:[SSKeychain passwordForService:@"moments" account:@"username"] forKey:@"currentUserName"];
            [self presentViewController:vc animated:NO completion:nil];
        } else {
            self.view.alpha = 1;
        }
    }];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end