//
//  UserInfoViewController.m
//  Moments
//
//  Created by Colton Anglin on 11/29/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "UserInfoViewController.h"
#import "MomentsAPIUtilities.h"
@interface UserInfoViewController ()

@end

@implementation UserInfoViewController {
    NSString *currentUserName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MomentsAPIUtilities *APIHelper = [MomentsAPIUtilities alloc];

    currentUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    phoneNumberLabel.text = [APIHelper getUserPhoneNumberWithUsername:currentUserName];
    phoneNumberLabel.text = [APIHelper getUserPhoneNumberWithUsername:currentUserName];
    usernameLabel.text = currentUserName;
    usernameLabel.text = currentUserName;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
