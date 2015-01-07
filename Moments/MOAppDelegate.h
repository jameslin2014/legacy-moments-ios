//
//  AppDelegate.h
//  Moments
//
//  Created by Douglas Bumby on 2014-11-28.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentsAPIUtilities.h"
#import "MOS3APIUtilities.h"
#import "UserVoice.h"

@interface MOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MomentsAPIUtilities *api;
@property (strong, nonatomic) MOS3APIUtilities *s3;

@end

