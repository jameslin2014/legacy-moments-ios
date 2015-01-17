//
//  MOAvatarCache.m
//  Moments
//
//  Created by Damon Jones on 1/10/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOAvatarCache.h"

@implementation MOAvatarCache

- (NSString *)getFilePathForUserAvatar:(NSString *)username {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    [fileManager createDirectoryAtPath:[cachePaths[0] stringByAppendingPathComponent:@"/avatars"] withIntermediateDirectories:YES attributes:nil error:nil];
    
    return [[[cachePaths[0] stringByAppendingPathComponent:@"/avatars"]
             stringByAppendingPathComponent:[username lowercaseString]]
            stringByAppendingPathExtension:@"png"];
}

- (void)getAvatarForUsername:(NSString *)username completion:(void (^)(UIImage *))completion {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Try to load the avatar from the local library cache directory
    NSString *filepath = [self getFilePathForUserAvatar:username];
    if ([fileManager fileExistsAtPath:filepath]) {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filepath error:nil] fileModificationDate];
        NSDate *oneHourAgo = [NSDate dateWithTimeIntervalSinceNow:-3600];
        
        // if the cached file is newer than 1 hour ago use it, otherwise reload it from S3
        if (NSOrderedDescending == [modificationDate compare:oneHourAgo]) {
            completion([UIImage imageWithContentsOfFile:filepath]);

            return;
        }
    }
        
    // Load the avatar from S3 and then save it to the local library cache directory
    [[MOS3APIUtilities sharedInstance] getAvatarForUsername:username completion:^(UIImage *avatar) {
        if (avatar) {
            [self putAvatar:avatar forUsername:username];
            completion(avatar);
        } else {
            // There is no remote avatar, so generate a green circle
            completion([self defaultAvatar]);
        }
    }];
}

- (void)putAvatar:(UIImage *)avatar forUsername:(NSString *)username {
    [UIImagePNGRepresentation(avatar) writeToFile:[self getFilePathForUserAvatar:username] atomically:YES];
}

- (UIImage *)defaultAvatar {
    return [UIImage circleImageWithColor:[UIColor colorWithRed:0 green:0.78 blue:0.42 alpha:1]];
}

//- (void)renameAvatarforUsername:(NSString *)oldUsername newUsername:(NSString *)newUsername {
//    [[NSFileManager defaultManager] moveItemAtPath:[self getFilePathForUserAvatar:oldUsername]
//                         toPath:[self getFilePathForUserAvatar:newUsername]
//                          error:nil];
//}

@end
