//
//  MOUser.h
//  Moments
//
//  Created by Damon Jones on 1/4/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOUser : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, copy) NSArray *followers;
@property (nonatomic, copy) NSArray *following;
@property (nonatomic, assign) BOOL loggedIn;

- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)reload;
- (void)logout;

@end
