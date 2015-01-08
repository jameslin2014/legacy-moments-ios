//
//  MOUser.m
//  Moments
//
//  Created by Damon Jones on 1/4/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOUser.h"
#import "MomentsAPIUtilities.h"
#import "SSKeychain.h"

@implementation MOUser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loggedIn = NO;
        [self loadFromKeychain];
    }
    return self;
}

- (void)loadFromKeychain {
    self.name = [SSKeychain passwordForService:@"moments" account:@"username"];
    self.email = [SSKeychain passwordForService:@"moments" account:@"email"];
    self.password = [SSKeychain passwordForService:@"moments" account:@"password"];
    self.token = [SSKeychain passwordForService:@"moments" account:@"token"];
}

- (void)saveToKeychain {
    [SSKeychain setPassword:self.name forService:@"moments" account:@"username"];
    [SSKeychain setPassword:self.email forService:@"moments" account:@"email"];
    [SSKeychain setPassword:self.password forService:@"moments" account:@"password"];
    [SSKeychain setPassword:self.token forService:@"moments" account:@"token"];
}

- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password {
    [[MomentsAPIUtilities sharedInstance] createUserWithUsername:username email:email andPassword:password completion:^(NSDictionary *dictionary) {
        self.name = username;
        self.email = email;
        self.password = password;
        self.token = [dictionary objectForKey:@"token"];

        self.loggedIn = YES;
        
        [self saveToKeychain];
    }];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    [[MomentsAPIUtilities sharedInstance] verifyUsername:username andPassword:password completion:^(NSDictionary *dictionary) {
        BOOL valid = [[dictionary objectForKey:@"login"] boolValue];
        if (valid) {
            self.loggedIn = YES;
            self.name = username;
            self.password = password;
            self.token = [dictionary objectForKey:@"token"];
            
            [self reload];
            
            [self saveToKeychain];
        } else {
            NSLog(@"Login failed");
        }
    }];
}

- (void)loginAs:(NSString *)name password:(NSString *)password token:(NSString *)token {
    self.loggedIn = YES;
    self.name = name;
    self.password = password;
    self.token = token;
    
    [self reload];

    [self saveToKeychain];
}

- (void)logout {
    self.loggedIn = NO;
    
    self.name = nil;
    self.email = nil;
    self.password = nil;
    self.token = nil;
    
    self.following = nil;
    self.followers = nil;
    
    [self saveToKeychain];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"dataLoaded" object:nil]];
}

- (void)reload {
    
    if (!self.loggedIn) {
        return;
    }
    
    [[MomentsAPIUtilities sharedInstance] getAllUserDataWithUsername:self.name completion:^(NSDictionary *dictionary) {
        self.email = [dictionary objectForKey:@"email"];
        self.token = [dictionary objectForKey:@"token"];
        self.followers = [dictionary objectForKey:@"followers"];
        self.following = [dictionary objectForKey:@"follows"];
        
        [self log];
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"dataLoaded" object:nil]];
    }];
}

- (void)log {
    NSLog(@"Name: %@", self.name);
    NSLog(@"Email: %@", self.email);
    NSLog(@"Password: %@", self.password);
    NSLog(@"Token: %@", self.token);
}

@end
