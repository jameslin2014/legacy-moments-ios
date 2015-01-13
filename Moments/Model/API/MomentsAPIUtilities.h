//
//  MomentsAPIUtilities.h
//  Moments
//
//  Created by Damon Jones on 1/2/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOUser.h"

@interface MomentsAPIUtilities : NSObject

@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, copy) NSString *apiUsername;
@property (nonatomic, copy) NSString *apiPassword;

@property (nonatomic, strong) MOUser *user;

+ (instancetype)sharedInstance;

/**
 * Sends a request to the API to check if the intended username and e-mail are valid
 */
- (void)isValidUsername:(NSString *)username andEmail:(NSString *)email completion:(void (^)(NSDictionary *))completion;

/**
 * Sends a request to the API to check if the user can login with this username and password
 */
- (void)verifyUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(NSDictionary *))completion;

/**
 * Sends a request to the API which returns the data for a given user
 */
- (void)getAllUserDataWithUsername:(NSString *)username completion:(void (^)(NSDictionary *))completion;

/**
 * Sends a request to the API which returns an array of usernames which contain the search text
 */
- (void)searchForUsersLikeUsername:(NSString *)searchText completion:(void (^)(NSDictionary
                                                                               *))completion;

/**
 * Sends a request to the API to create a new user with the username, e-mail and password provided
 */
- (void)createUserWithUsername:(NSString *)name email:(NSString *)email andPassword:(NSString *)password completion:(void (^)(NSDictionary *))completion;

/**
 * Sends a request to the API to subscribe to a user's video content
 */
- (void)followUser:(NSString *)user completion:(void (^)(NSDictionary *))completion;

/**
 * Sends a request to the API to unsubscribe from a user's video content
 */
- (void)unfollowUser:(NSString *)user completion:(void (^)(NSDictionary *))completion;

/**
 * Sends a request to the API to record when the user uploads a video
 */
- (void)recordPostForUser:(NSString *)username;

/**
 * Sends a request to the API to update the user data
 */
- (void)updateUser:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *))completion;

@end
