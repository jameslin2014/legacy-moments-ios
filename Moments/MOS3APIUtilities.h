//
//  MOS3APIUtilities.h
//  Moments
//
//  Created by Douglas Bumby on 2015-01-03.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MOS3APIUtilities : NSObject

@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *bucket;

+ (instancetype)sharedInstance;

- (void)putAvatarForUsername:(NSString *)username image:(UIImage *)image;
- (void)getAvatarForUsername:(NSString *)username completion:(void (^)(UIImage *))completion;
- (NSURLRequest *)avatarRequestForUsername:(NSString *)username;

@end
