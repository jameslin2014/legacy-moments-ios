//
//  MOS3APIUtilities.h
//  Moments
//
//  Created by Douglas Bumby on 2015-01-03.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFAmazonS3Manager.h"

@interface MOS3APIUtilities : NSObject

@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *bucket;
@property (nonatomic, strong) AFAmazonS3Manager *s3;

+ (instancetype)sharedInstance;
- (void)initManager;

- (void)putAvatarForUsername:(NSString *)username image:(UIImage *)image;
- (void)getAvatarForUsername:(NSString *)username completion:(void (^)(UIImage *))completion;

@end
