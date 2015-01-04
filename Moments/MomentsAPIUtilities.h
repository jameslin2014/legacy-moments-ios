//
//  MOAPI.h
//  Moments
//
//  Created by Damon Jones on 1/2/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MomentsAPIUtilities : NSObject

/**
 Sends a request to droplet to check if the username is available
 */
- (void)checkIsTakenUsername:(NSString *)username completion:(void (^)(BOOL))data;

/**
 Authenticates user into Moments with pre-determined username and password
 */
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(BOOL))data;

/**
 Grabs every piece of data from a user from a username
 */
- (void)getAllUserDataWithUsername:(NSString *)username completion:(void (^)(NSDictionary *))completion;

/**
 Search user records for other users based on UISearchBar contents
 */
- (void)searchForUsersLikeUsername:(NSString *)searchText completion:(void (^)(NSArray *))completion;

/**
 Creates a new user instance during registration
 */
- (void)createUserWithUsername:(NSString *)name email:(NSString *)email andPassword:(NSString *)password completion:(void (^)(NSDictionary *))completion;

/**
 Subscribe to a user's video content
 */
- (void)followUser:(NSString *)user withFollower:(NSString *)follower completion:(void (^)(NSDictionary *))completion;

/**
 Unsubscribe from a user's video content
 */
- (void)unfollowUser:(NSString *)user withFollower:(NSString *)follower completion:(void (^)(NSDictionary *))completion;

@end
