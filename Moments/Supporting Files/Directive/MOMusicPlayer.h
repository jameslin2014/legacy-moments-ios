//
//  MOMusicPlayer.h
//  Onboarding
//
//  Created by Damon Jones on 12/28/14.
//  Copyright (c) 2014 Xappox, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

@interface MOMusicPlayer : NSObject

- (void)start;
- (void)stop;
- (void)setPage:(int)page fade:(float)fade;

@end
