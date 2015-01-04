//
//  MOAWSUtilities.h
//  Moments
//
//  Created by Douglas Bumby on 2015-01-03.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface MOS3APIUtilities : NSObject {}

/**
 Grabs a user's profile picture from S3 from a username.
 */
- (void)getUserProfilePictureWithUsername:(NSString *)username completion:(void(^)(UIImage *profilePicture))data;

@end
