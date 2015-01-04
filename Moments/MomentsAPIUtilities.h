//
//  MOAPI.h
//  Moments
//
//  Created by Damon Jones on 1/2/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MomentsAPIUtilities : NSObject

- (void)checkIsTakenUsername:(NSString *)username completion:(void (^)(BOOL))data;
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(BOOL))data;
- (void)getAllUserDataWithUsername:(NSString *)username completion:(void (^)(NSDictionary *))completion;
- (void)searchForUsersLikeUsername:(NSString *)searchText completion:(void (^)(NSArray *))completion;
- (void)createUserWithUsername:(NSString *)name email:(NSString *)email andPassword:(NSString *)password completion:(void (^)(NSDictionary *))completion;
- (void)followUser:(NSString *)user withFollower:(NSString *)follower completion:(void (^)(NSDictionary *))completion;
- (void)unfollowUser:(NSString *)user withFollower:(NSString *)follower completion:(void (^)(NSDictionary *))completion;
@end
