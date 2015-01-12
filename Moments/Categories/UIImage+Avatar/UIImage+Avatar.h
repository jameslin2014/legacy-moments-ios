//
//  UIImage+Avatar.h
//  Moments
//
//  Created by Damon Jones on 1/10/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Avatar)

- (UIImage *)cropToSquare;
- (UIImage *)scaleToSize:(CGFloat)maximumSize;
- (UIImage *)cropAndScaleToSize:(CGFloat)maximumSize;
@end
