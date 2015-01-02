//
//  MOAPI.h
//  Moments
//
//  Created by Damon Jones on 1/2/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOAPI : NSObject

- (void)createUserWithName:(NSString *)name andEmail:(NSString *)email completion:(void (^)(NSDictionary *))completion;
- (void)getAllUserDataWithUsername:(NSString *)username completion:(void (^)(NSDictionary *))data;
- (void)searchForUsersLikeUserName:(NSString *)searchText completion:(void (^)(NSArray *))completion;
@end
