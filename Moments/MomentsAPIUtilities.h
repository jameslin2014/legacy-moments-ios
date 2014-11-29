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

@interface MomentsAPIUtilities : NSObject {}

-(void)getAllUserDataWithUsername:(NSString *)username completion:(void(^)(NSDictionary *userData))data;

-(void)getUserPhoneNumberWithUsername:(NSString *)username completion:(void(^)(NSString *phoneNumber))data;
; // Grab user phone number

-(void)getUserPasswordWithUsername:(NSString *)username completion:(void(^)(NSString *password))data;; // Grab user password

-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void(^)(BOOL loginStatus))data;; ;

@end
