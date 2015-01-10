//
//  MOAvatarCache.m
//  Moments
//
//  Created by Damon Jones on 1/10/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOAvatarCache.h"
#import "MOS3APIUtilities.h"

@implementation MOAvatarCache

- (void)getAvatarForUsername:(NSString *)username completion:(void (^)(UIImage *))completion {
    // Try to load the avatar from the local library cache directory
    UIImage *avatar = [UIImage imageWithContentsOfFile:[self getFilePathForUserAvatar:username]];
    
    if (avatar) {
        completion(avatar);
    } else {
        // Load the avatar from S3 and then save it to the local library cache directory
        [[MOS3APIUtilities sharedInstance] getAvatarForUsername:username completion:^(UIImage *avatar) {
            [UIImagePNGRepresentation(avatar) writeToFile:[self getFilePathForUserAvatar:username] atomically:YES];
            completion(avatar);
        }];
    }
}

- (NSString *)getFilePathForUserAvatar:(NSString *)username {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    [fileManager createDirectoryAtPath:[cachePath stringByAppendingPathComponent:@"/avatars"] withIntermediateDirectories:YES attributes:nil error:nil];

    return [[[cachePath stringByAppendingPathComponent:@"/avatars"]
             stringByAppendingPathComponent:[username lowercaseString]]
            stringByAppendingPathExtension:@"png"];
}

@end
