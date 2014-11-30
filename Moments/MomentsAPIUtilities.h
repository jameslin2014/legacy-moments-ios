//
//  MomentsAPIUtilities.h
//  Moments
//
//  Created by Colton Anglin on 11/28/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <Firebase/Firebase.h>


/**
 A block based iOS library for interacting with the Moments API */

@interface MomentsAPIUtilities : NSObject {}

/**
 Grabs every piece of data from a user from a username
 */
-(void)getAllUserDataWithUsername:(NSString *)username completion:(void(^)(NSDictionary *userData))data;

/**
 Grabs a user's phone number from Firebase from a username.
 */
-(void)getUserPhoneNumberWithUsername:(NSString *)username completion:(void(^)(NSString *phoneNumber))data;
;

/**
 Grabs a user's password from Firebase from a username.
 */
-(void)getUserPasswordWithUsername:(NSString *)username completion:(void(^)(NSString *password))data;;

/**
 Grabs a user's following list from Firebase from a username.
 */
-(void)getUserFollowingListWithUsername:(NSString *)username completion:(void(^)(NSArray *followedUsers))data;;;;

-(void)getUserFollowersListWithUsername:(NSString *)username completion:(void(^)(NSArray *followers))data;;;;

/**
 Attempts to login with a username/password combination. Gives you a boolean with the result (true, it did authenticate or false, it did not authenticate).
 */
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void(^)(BOOL loginStatus))data;;;

/**
 Attempts to follow a user from a username from another user with a username. Gives you a bool with the result.
 */
-(void)followUserWithUsername:(NSString *)followedUsername fromUsername:(NSString *)followerUsername completion:(void(^)(BOOL followStatus))data;;;;

/**
 Attempts to unfollow a user from a username from another user with a username. Gives you a bool with the result.
 */
-(void)unfollowUserWithUsername:(NSString *)followedUsername fromUsername:(NSString *)followerUsername completion:(void(^)(BOOL unfollowStatus))data;;;;

/**
 Searches for a user with a specified username and gives you the result in a boolean.
 */
-(void)searchForUsersWithUserName:(NSString *)searchString completion:(void(^)(BOOL validUser))data;;;;


@end