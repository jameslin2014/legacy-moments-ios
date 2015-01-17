//
//  MOAvatarCache.m
//  Moments
//
//  Created by Damon Jones on 1/10/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOAvatarCache.h"

@implementation MOAvatarCache

- (void)getAvatarForUsername:(NSString *)username completion:(void (^)(UIImage *))completion {
    // Try to load the avatar from the local library cache directory
    UIImage *avatar = [UIImage imageWithContentsOfFile:[self getFilePathForUserAvatar:username]];
    
    if (avatar) {
        completion(avatar);
    } else {
        // Load the avatar from S3 and then save it to the local library cache directory
        [[MOS3APIUtilities sharedInstance] getAvatarForUsername:username completion:^(UIImage *avatar) {
            if (avatar) {
                [UIImagePNGRepresentation(avatar) writeToFile:[self getFilePathForUserAvatar:username] atomically:YES];
                completion(avatar);
            } else {
                completion([self defaultAvatar]);
            }
        }];
    }
}

- (void)putAvatar:(UIImage *)avatar forUsername:(NSString *)username {
    [UIImagePNGRepresentation(avatar) writeToFile:[self getFilePathForUserAvatar:username] atomically:YES];
}

- (NSString *)getFilePathForUserAvatar:(NSString *)username {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    [fileManager createDirectoryAtPath:[cachePaths[0] stringByAppendingPathComponent:@"/avatars"] withIntermediateDirectories:YES attributes:nil error:nil];

    return [[[cachePaths[0] stringByAppendingPathComponent:@"/avatars"]
             stringByAppendingPathComponent:[username lowercaseString]]
            stringByAppendingPathExtension:@"png"];
}

- (UIImage *)defaultAvatar {
    return [UIImage circleImageWithColor:[UIColor colorWithRed:0 green:0.78 blue:0.42 alpha:1]];
}

- (void)renameAvatarforUsername:(NSString *)oldUsername newUsername:(NSString *)newUsername {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    [fileManager moveItemAtPath:[self getFilePathForUserAvatar:oldUsername]
                         toPath:[self getFilePathForUserAvatar:newUsername]
                          error:nil];
    
    [fileManager createDirectoryAtPath:[cachePaths[0] stringByAppendingPathComponent:@"/avatars"] withIntermediateDirectories:YES attributes:nil error:nil];
}

@end
