//
//  MOAvatarCache.h
//  Moments
//
//  Created by Damon Jones on 1/10/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MOS3APIUtilities.h"
#import "UIImage+EDExtras.h"

@interface MOAvatarCache : NSObject

- (void)getAvatarForUsername:(NSString *)username completion:(void (^)(UIImage *))completion;

@end
