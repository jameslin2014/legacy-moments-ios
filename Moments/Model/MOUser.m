//
//  MOUser.m
//  Moments
//
//  Created by Damon Jones on 1/4/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOUser.h"
#import "MomentsAPIUtilities.h"

@implementation MOUser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loggedIn = NO;
        [self loadFromKeychain];
        if (self.name && self.token) {
            self.loggedIn = YES;
            [[[MOAvatarCache alloc] init] getAvatarForUsername:self.name completion:^(UIImage *avatar) {
                self.avatar = avatar;
            }];
        }
    }
    return self;
}

- (void)loadFromKeychain {
    self.name = [[SSKeychain passwordForService:@"moments" account:@"username"] lowercaseString];
    self.email = [SSKeychain passwordForService:@"moments" account:@"email"];
    self.password = [SSKeychain passwordForService:@"moments" account:@"password"];
    self.token = [SSKeychain passwordForService:@"moments" account:@"token"];
}

- (void)saveToKeychain {
    [SSKeychain setPassword:[self.name lowercaseString] forService:@"moments" account:@"username"];
    [SSKeychain setPassword:self.email forService:@"moments" account:@"email"];
    [SSKeychain setPassword:self.password forService:@"moments" account:@"password"];
    [SSKeychain setPassword:self.token forService:@"moments" account:@"token"];
}

- (void)clearCredentialsFromKeychain {
    [SSKeychain deletePasswordForService:@"moments" account:@"username"];
    [SSKeychain deletePasswordForService:@"moments" account:@"email"];
    [SSKeychain deletePasswordForService:@"moments" account:@"password"];
    [SSKeychain deletePasswordForService:@"moments" account:@"token"];
}

- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL))completion {
    [[MomentsAPIUtilities sharedInstance] createUserWithUsername:username email:email andPassword:password completion:^(NSDictionary *dictionary) {
        self.name = username;
        self.email = email;
        self.password = password;
        self.token = dictionary[@"token"];

        self.loggedIn = YES;
        
        [self saveToKeychain];
        
        completion(nil != dictionary && nil == dictionary[@"error"]);
    }];
}

- (void)updateUsername:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL))completion {
    [[MomentsAPIUtilities sharedInstance] updateUser:username email:email password:password completion:^(NSDictionary *dictionary) {
        NSLog(@"%@", dictionary);
        if (dictionary[@"errors"]) {
            NSLog(@"%@", dictionary[@"errors"]);
            completion(NO);
        } else {
            self.name = username;
            self.email = email;
            self.password = password;
            
            [self saveToKeychain];
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"dataLoaded" object:nil]];
            
            completion(YES);
        }
    }];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL))completion {
    [[MomentsAPIUtilities sharedInstance] verifyUsername:username andPassword:password completion:^(NSDictionary *dictionary) {
        BOOL valid = [dictionary[@"login"] boolValue];
        if (valid) {
            self.loggedIn = YES;
            self.name = username;
            self.password = password;
            self.token = dictionary[@"token"];
            
            [self reload];
            
            [[[MOAvatarCache alloc] init] getAvatarForUsername:self.name completion:^(UIImage *avatar) {
                self.avatar = avatar;
            }];
            
            [self saveToKeychain];
        } else {
            NSLog(@"Login failed");
        }
        completion(valid);
    }];
}

- (void)logout {
    self.loggedIn = NO;
    
    self.name = nil;
    self.email = nil;
    self.password = nil;
    self.token = nil;
    
    self.following = nil;
    self.followers = nil;
    self.recents = nil;
    self.posted = nil;
    
    self.avatar = nil;
    
    [self clearCredentialsFromKeychain];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"signOut" object:nil]];
}

- (void)reload {
    
    if (!self.loggedIn) {
        return;
    }
    
    [[MomentsAPIUtilities sharedInstance] getAllUserDataWithUsername:self.name completion:^(NSDictionary *dictionary) {
        self.email = dictionary [@"email"];
        self.token = dictionary [@"token"];
        self.followers = dictionary [@"followers"];
        self.following = dictionary [@"follows"];
        self.recents = dictionary [@"recents"];
        self.posted = dictionary [@"posted"];
        
        [self log];
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"dataLoaded" object:nil]];
    }];
}

- (void)setAvatar:(UIImage *)avatar {
    _avatar = avatar;
    [[[MOAvatarCache alloc] init] putAvatar:self.avatar forUsername:self.name];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"avatarChanged" object:nil]];
}

- (BOOL)isFollowing:(NSString *)username {
    return [self.following containsObject:username];
}

- (void)log {
    NSLog(@"Name: %@", self.name);
    NSLog(@"Email: %@", self.email);
    NSLog(@"Password: %@", self.password);
    NSLog(@"Token: %@", self.token);
}

@end
