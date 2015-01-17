//
//  MOUser.m
//  Moments
//
//  Created by Damon Jones on 1/4/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOUser.h"
#import "MomentsAPIUtilities.h"
#import "TSMessage.h"

@implementation MOUser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loggedIn = NO;
        [self loadFromKeychain];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"authenticationFailed"
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          if (self.name && self.password) {
                                                              NSLog(@"Trying to auto-login...");
                                                              [self loginWithUsername:self.name password:self.password completion:^(BOOL success) {
                                                                  if (success) {
                                                                      NSLog(@"Logged in. Reloading...");
                                                                      [self reload];
                                                                  } else {
                                                                      [TSMessage showNotificationWithTitle:@"Authentication Error" subtitle:@"Please sign-in again." type:TSMessageNotificationTypeError];
                                                                  }
                                                              }];
                                                          } else {
                                                              [TSMessage showNotificationWithTitle:@"Authentication Error" subtitle:@"Please sign-in again." type:TSMessageNotificationTypeError];
                                                          }
                                                      }];
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
        
        completion(nil != dictionary && nil == dictionary[@"errors"]);
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
            
            // No longer needed, the API will do this
//            [[[MOAvatarCache alloc] init] renameAvatarforUsername:oldUsername newUsername:self.name];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dataLoaded" object:nil];
            
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"signOut" object:nil];
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataLoaded" object:nil];
    }];
}

- (void)setAvatar:(UIImage *)avatar {
    _avatar = avatar;
    [[[MOAvatarCache alloc] init] putAvatar:self.avatar forUsername:self.name];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avatarChanged" object:nil];
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
