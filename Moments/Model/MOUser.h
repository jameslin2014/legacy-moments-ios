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

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, copy) NSArray *followers;
@property (nonatomic, copy) NSArray *following;
@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, strong) UIImage *avatar;

- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL))completion;
- (void)updateUsername:(NSString *)username email:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL))completion;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL))completion;
- (void)reload;
- (void)logout;

@end
