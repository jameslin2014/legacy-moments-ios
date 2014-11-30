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
- (void)getAllUserDataWithUsername:(NSString *)username completion:(void (^)(NSDictionary *))data {
    Firebase *UserPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@",username]];
        [UserPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"Success");
            data(snapshot.value);
        } withCancelBlock:^(NSError *error) {
            NSLog(@"Error: %@",error);
        }];
}

// Grab the phone number from Firebase with a specified username
- (void)getUserPhoneNumberWithUsername:(NSString *)username completion:(void (^)(NSString *))data {
    [Firebase goOnline];
    Firebase *UserPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/phone_number",username]];
        [UserPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSString *phoneData = snapshot.value;
            data(phoneData);
            [Firebase goOffline];
        } withCancelBlock:^(NSError *error) {
            NSLog(@"Error: %@",error);
            [Firebase goOffline];
        }];
    
}

// Grab a user password from Firebase with a specified username
- (void)getUserPasswordWithUsername:(NSString *)username completion:(void (^)(NSString *))data {
    /**
     An iOS library for interacting with the Moments API */
    [Firebase goOnline];
    Firebase *UserPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/password",username]];
    [UserPath observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSString *password = snapshot.value;
        data(password);
        [Firebase goOffline];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Error: %@",error);
        [Firebase goOffline];
    }];
    
}

- (void)getUserFollowingListWithUsername:(NSString *)username completion:(void (^)(NSArray *))data {
    [Firebase goOnline];
     Firebase *followingPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/following",username]];
    [followingPath observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value == [NSNull null]) {
            NSArray *empty = @[];
            NSLog(@"Success: Recieved following list for user: %@ but there are 0 followed users.",username);
            data(empty);
            [Firebase goOffline];
        } else {
        NSArray *followingUsers = snapshot.value;
        data(followingUsers);
        NSLog(@"Success: Recieved following list for user: %@",username);
        [Firebase goOffline];
    }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Error: %@",error);
        [Firebase goOffline];
    }];
    
}

- (void)getUserFollowersListWithUsername:(NSString *)username completion:(void (^)(NSArray *))data {
    [Firebase goOnline];
    Firebase *followingPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/followers",username]];
    [followingPath observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value == [NSNull null]) {
            NSArray *empty = @[];
            NSLog(@"Success: Recieved follower list for user: %@ but there are 0 followers.",username);
            data(empty);
            [Firebase goOffline];
        } else {
            NSArray *followingUsers = snapshot.value;
            data(followingUsers);
            NSLog(@"Success: Recieved follower list for user: %@",username);
            [Firebase goOffline];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Error: %@",error);
        [Firebase goOffline];
    }];
    
}




// Attempt to login with specified credentials (username/pass) and throw a boolean with the result
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(BOOL))data {
    [Firebase goOnline];
    Firebase *userPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@",username]];
        [userPath observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if (snapshot.value == [NSNull null]) {
                data(false);
                [Firebase goOffline];
            } else {
                Firebase *passPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/password",username]];
                [passPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    NSString *pass = snapshot.value;
                    if (snapshot.value == [NSNull null]) {
                        data(false);
                        [Firebase goOffline];
                    } else {
                    if ([pass isEqualToString:password]) {
                        data(true);
                        [Firebase goOffline];
                    } else {
                        data(false);
                        [Firebase goOffline];
                    }
                    }
                } withCancelBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                    data(false);
                    [Firebase goOffline];
                }];
            }
        } withCancelBlock:^(NSError *error) {
            NSLog(@"%@",error);
            data(false);
            [Firebase goOffline];
        }];
}

// Follow a user from a specified username and return a boolean with the follow status
- (void)followUserWithUsername:(NSString *)followedUsername fromUsername:(NSString *)followerUsername completion:(void (^)(BOOL))data{
    [Firebase goOnline];
    Firebase *userPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/following",followerUsername]];
    [userPath observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        followingArray = snapshot.value;
        if (snapshot.value == [NSNull null]) {
            NSArray *array = @[followedUsername];
            [userPath setValue:array];
            NSLog(@"Success: Followed User: %@",followedUsername);
            [Firebase goOffline];
            data(true);
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

// Unfollow a user from a specified username and return a boolean with the follow status
- (void)unfollowUserWithUsername:(NSString *)followedUsername fromUsername:(NSString *)followerUsername completion:(void (^)(BOOL))data{
    [Firebase goOnline];
    Firebase *userPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/following",followerUsername]];
    [userPath observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        followingArray = snapshot.value;
        if (snapshot.value == [NSNull null]) {
            NSLog(@"Error: Not Following User: %@", followedUsername);
            [Firebase goOffline];
            data(false);
        } else {
            if ([followingArray containsObject:followedUsername]) {
                NSMutableArray *tempArray = [followingArray mutableCopy];
                [tempArray removeObject:followedUsername];
                followingArray = [tempArray copy];
                [userPath setValue:followingArray];
                NSLog(@"Success: Unfollowed User: %@",followedUsername);
                [Firebase goOffline];
                data(true);
            } else {
                NSLog(@"Error: Not Following User: %@", followedUsername);
                [Firebase goOffline];
                data(false);
            }
            
        }
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
        [Firebase goOffline];
    }];    
}

// Search through Firebase for a specific user. A boolean returns true if its a valid user, false if not
- (void)searchForUsersWithUserName:(NSString *)searchString completion:(void (^)(BOOL))data {
    [Firebase goOnline];
    Firebase *userPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@",searchString]];
    [userPath observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value == [NSNull null]) {
            NSLog(@"User: %@ does not exist",searchString);
            data(false);
            [Firebase goOffline];
        } else {
            [Firebase goOffline];
            NSLog(@"User: %@ is a valid user",searchString);
            data(true);
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"Error: %@",error);
        [Firebase goOffline];
        data(false);
    }];
}

@end