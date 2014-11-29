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

-(NSDictionary*)getAllUserDataWithUsername:(NSString *)username;

-(NSString*)getUserPhoneNumberWithUsername:(NSString *)username; // Grab user phone number

-(NSString*)getUserPasswordWithUsername:(NSString *)username; // Grab user phone number

@end
