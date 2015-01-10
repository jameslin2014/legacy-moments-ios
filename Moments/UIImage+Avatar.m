//
//  UIImage+Avatar.m
//  Moments
//
//  Created by Damon Jones on 1/10/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "UIImage+Avatar.h"
#import "Math.h"

@implementation UIImage (Avatar)

- (UIImage *)cropToSquare {
    CGFloat cropSize = fminf(self.size.width, self.size.height);
    CGRect cropSquare = CGRectMake((self.size.width - cropSize) / 2.0, (self.size.height - cropSize) / 2.0, cropSize, cropSize);
    
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.CGImage, cropSquare)
                               scale: [UIScreen mainScreen].scale
                         orientation:self.imageOrientation];

}

- (UIImage *)scaleToSize:(CGFloat)maximumSize {
    CGRect scaleRect = CGRectMake(0.0, 0.0, maximumSize, maximumSize);
    UIGraphicsBeginImageContextWithOptions(scaleRect.size, YES, [UIScreen mainScreen].scale);
    [self drawInRect:scaleRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)cropAndScaleToSize:(CGFloat)maximumSize {
    return [[self cropToSquare] scaleToSize:maximumSize];
}

@end