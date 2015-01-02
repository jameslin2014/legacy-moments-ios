//
//  UIImage+Color.m
//  Moments
//
//  Created by Evan Dekhayser on 1/1/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "UIImage+EDExtras.h"

@implementation UIImage (EDExtras)

+ (UIImage *)circleImageWithColor:(UIColor *)color{
	CGRect rect = CGRectMake(0, 0, 100, 100);
	UIGraphicsBeginImageContext(rect.size);
	[color setFill];
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height / 2];
	[path fill];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (UIImage *)cameraButton{
	CGRect rect = CGRectMake(0, 0, 86, 86);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Color Declarations
	UIColor* color = [UIColor colorWithRed: 0 green: 0.776 blue: 0.42 alpha: 1];
	
	//// Oval Drawing
	UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(3, 3, 80, 80)];
	[UIColor.whiteColor setStroke];
	ovalPath.lineWidth = 6;
	[ovalPath stroke];
	
	//// Oval 2 Drawing
	UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(13, 13, 60, 60)];
	[color setFill];
	[oval2Path fill];
	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (UIImage *)recordButton{
	CGRect rect = CGRectMake(0, 0, 86, 86);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Color Declarations
	UIColor* color = [UIColor colorWithRed: 0 green: 0.776 blue: 0.42 alpha: 1];
	
	//// Oval Drawing
	UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(3, 3, 80, 80)];
	[UIColor.whiteColor setStroke];
	ovalPath.lineWidth = 6;
	[ovalPath stroke];
	
	//// Rectangle Drawing
	UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(23, 23, 40, 40) cornerRadius: 10];
	[color setFill];
	[rectanglePath fill];

	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

@end
