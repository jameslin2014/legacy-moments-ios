//
//  MOAvatarCache.h
//  Moments
//
//  Created by Damon Jones on 1/10/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MOAvatarCache : NSObject

- (void)getAvatarForUsername:(NSString *)username completion:(void (^)(UIImage *))completion;
- (void)putAvatarForUsername:(NSString *)username;

@end
