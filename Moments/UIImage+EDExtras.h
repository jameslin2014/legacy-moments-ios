//
//  UIImage+Color.h
//  Moments
//
//  Created by Evan Dekhayser on 1/1/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EDExtras)

+ (UIImage *)circleImageWithColor:(UIColor *)color;

+ (UIImage *)cameraButton;

+ (UIImage *)recordButton;

+ (NSArray *)transitionButtonImages: (BOOL) reversed;

- (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)cancelButtonX;

+ (UIImage *)cancelButtonLine;

+ (NSArray *)transitionCancelButtonImages: (BOOL) reversed;

+ (UIImage *)backButtonOpen;

+ (UIImage *)backButtonClosed;

+ (NSArray *)transitionBackButtonImages: (BOOL) reversed;

+ (UIImage *)plusButton;

+ (UIImage *)plusButtonHighlighted;

+ (UIImage *)circleCancelButton;

+ (UIImage *)followingNo;

+ (UIImage *)followingYes;

+ (NSArray *)transitionFollowing:(BOOL)reversed;

@end

