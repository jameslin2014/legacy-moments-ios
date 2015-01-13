//
//  MOUser.h
//  Moments
//
//  Created by Damon Jones on 1/4/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MOAvatarCache.h"
#import "MOS3APIUtilities.h"
#import "SSKeychain.h"

@interface MOUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSArray *followers;
@property (nonatomic, copy) NSArray *following;
@property (nonatomic, copy) NSArray *recents;
@property (nonatomic, copy) NSString *posted;
@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, strong) UIImage *avatar;

- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL))completion;
- (void)updateUsername:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL))completion;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL))completion;
- (void)reload;
- (void)logout;

@end
