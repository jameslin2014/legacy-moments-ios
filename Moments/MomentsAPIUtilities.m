//
//  MomentsAPIUtilities.m
//  Moments
//
//  Created by Colton Anglin on 11/28/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MomentsAPIUtilities.h"

@implementation MomentsAPIUtilities {
    BOOL loginStatus;
    NSArray *followingArray;
}

// Grab all user data from Firebase with a specified username
-(void)getAllUserDataWithUsername:(NSString *)username completion:(void (^)(NSDictionary *))data {
    Firebase *UserPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@",username]];
        [UserPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"Success");
            data(snapshot.value);
        } withCancelBlock:^(NSError *error) {
            NSLog(@"Error: %@",error);
        }];
}

// Grab the phone number from Firebase with a specified username
-(void)getUserPhoneNumberWithUsername:(NSString *)username completion:(void (^)(NSString *))data {
    Firebase *UserPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/phone_number",username]];
        [UserPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSString *phoneData = snapshot.value;
            data(phoneData);
        } withCancelBlock:^(NSError *error) {
            NSLog(@"Error: %@",error);
        }];
    
}

// Grab a user password from Firebase with a specified username
-(void)getUserPasswordWithUsername:(NSString *)username completion:(void (^)(NSString *))data {
    Firebase *UserPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/password",username]];
    [UserPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSString *password = snapshot.value;
        data(password);
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Error: %@",error);
    }];
    
}

// Attempt to login with specified credentials (username/pass) and throw a boolean with the result
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(BOOL))data {
    Firebase *userPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@",username]];
        [userPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if (snapshot.value == [NSNull null]) {
                data(false);
            } else {
                Firebase *passPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/password",username]];
                [passPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    NSString *pass = snapshot.value;
                    if (snapshot.value == [NSNull null]) {
                        data(false);
                    } else {
                    if ([pass isEqualToString:password]) {
                        data(true);
                    } else {
                        data(false);
                    }
                    }
                } withCancelBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                    data(false);
                }];
            }
        } withCancelBlock:^(NSError *error) {
            NSLog(@"%@",error);
            data(false);
        }];
}

-(void)followUserWithUsername:(NSString *)followedUsername fromUsername:(NSString *)followerUsername completion:(void (^)(BOOL))data{
    [Firebase goOnline];
    Firebase *userPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/following",followerUsername]];
    [userPath observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        followingArray = snapshot.value;
        if (snapshot.value == [NSNull null]) {
            NSArray *array = @[followedUsername];
            [userPath setValue:array];
            NSLog(@"Success: Followed User: %@",followedUsername);
            [Firebase goOffline];
        } else {

        if ([followingArray containsObject:followedUsername]) {
            NSLog(@"Error: Already following user: %@",followedUsername);
            data(false);
            [Firebase goOffline];
        } else {
            NSMutableArray *editableArray = [followingArray mutableCopy];
            [editableArray addObject:followedUsername];
            followingArray = [editableArray copy];
            NSLog(@"Success: Followed User: %@",followedUsername);
            [userPath setValue:followingArray];
            data(true);
            [Firebase goOffline];
        }
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
        [Firebase goOffline];
    }];

    
}


@end
