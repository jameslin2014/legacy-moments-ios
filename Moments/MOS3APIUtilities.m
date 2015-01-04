//
//  MOAWSUtilities.m
//  Moments
//
//  Created by Douglas Bumby on 2015-01-03.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOS3APIUtilities.h"
#import "DLIL.h"

@implementation MOS3APIUtilities {}

/**
 Grabs a user's profile picture from S3 from a username.
 */
- (void)getUserProfilePictureWithUsername:(NSString *)username completion:(void (^)(UIImage *))data {
    [[DLImageLoader sharedInstance] loadImageFromUrl:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png",username]
                                           completed:^(NSError *error, UIImage *image) {
                                               
                                               if (nil == error) {
                                                   data(image);
                                                   
                                               } else {
                                                   NSLog(@"Error: %@",error);
                                                   UIImage *errorImage = [UIImage imageNamed:@"captue-button"];
                                                   data(errorImage);
                                               }
                                           }];
}

@end
