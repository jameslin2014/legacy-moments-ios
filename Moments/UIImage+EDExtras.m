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
	ovalPath.lineWidth = 3;
	[ovalPath stroke];
	
	
	//// Rectangle Drawing
	UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(13, 13, 60, 60) cornerRadius: 30];
	[color setFill];
	[rectanglePath fill];
	
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
	ovalPath.lineWidth = 3;
	[ovalPath stroke];
	
	//// Rectangle Drawing
	UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(23, 23, 40, 40) cornerRadius: 10];
	[color setFill];
	[rectanglePath fill];
	
	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (NSArray *)transitionButtonImages: (BOOL)reversed{
	NSMutableArray *finalArray = [NSMutableArray array];
	for (float i = 0; i <= 10.0; i += 1.0){
		CGRect rect = CGRectMake(0, 0, 86, 86);
		UIGraphicsBeginImageContext(rect.size);
		
		//// Color Declarations
		UIColor* color = [UIColor colorWithRed: 0 green: 0.776 blue: 0.42 alpha: 1];
		
		//// Oval Drawing
		UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(3, 3, 80, 80)];
		[UIColor.whiteColor setStroke];
		ovalPath.lineWidth = 3;
		[ovalPath stroke];
		
		//// Rectangle Drawing
		UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(13 + i, 13 + i, 60 - 2*i, 60 - 2*i) cornerRadius: 30.0 - 2*i];
		[color setFill];
		[rectanglePath fill];
		
		UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[finalArray addObject:returnImage];
	}
	if (reversed){
		finalArray = [[[finalArray reverseObjectEnumerator]allObjects] mutableCopy];
	}
	return finalArray;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
	UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0, self.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextSetBlendMode(context, kCGBlendModeNormal);
	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
	CGContextClipToMask(context, rect, self.CGImage);
	[color setFill];
	CGContextFillRect(context, rect);
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+ (UIImage *)cancelButtonX{
	CGRect rect = CGRectMake(0, 0, 40, 40);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Bezier Drawing
	UIBezierPath* bezierPath = UIBezierPath.bezierPath;
	[bezierPath moveToPoint: CGPointMake(2.5, 2.5)];
	[bezierPath addLineToPoint: CGPointMake(37.5, 37.5)];
	bezierPath.lineCapStyle = kCGLineCapRound;
	
	bezierPath.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezierPath.lineWidth = 4;
	[bezierPath stroke];
	
	
	//// Bezier 2 Drawing
	UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
	[bezier2Path moveToPoint: CGPointMake(37.5, 2.5)];
	[bezier2Path addLineToPoint: CGPointMake(2.5, 37.5)];
	bezier2Path.lineCapStyle = kCGLineCapRound;
	
	bezier2Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier2Path.lineWidth = 4;
	[bezier2Path stroke];
	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (UIImage *)cancelButtonLine{
	CGRect rect = CGRectMake(0, 0, 40, 40);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Bezier Drawing
	UIBezierPath* bezierPath = UIBezierPath.bezierPath;
	[bezierPath moveToPoint: CGPointMake(2.5, 19.5)];
	[bezierPath addLineToPoint: CGPointMake(37.5, 19.5)];
	bezierPath.lineCapStyle = kCGLineCapRound;
	
	bezierPath.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezierPath.lineWidth = 4;
	[bezierPath stroke];
	
	//// Bezier 2 Drawing
	UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
	[bezier2Path moveToPoint: CGPointMake(37.5, 19.5)];
	[bezier2Path addLineToPoint: CGPointMake(2.5, 19.5)];
	bezier2Path.lineCapStyle = kCGLineCapRound;
	
	bezier2Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier2Path.lineWidth = 4;
	[bezier2Path stroke];
	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (NSArray *)transitionCancelButtonImages:(BOOL)reversed{
	NSMutableArray *finalArray = [NSMutableArray array];
	for (float i = 0; i <= 10.0; i += 1.0){
		CGRect rect = CGRectMake(0, 0, 40, 40);
		UIGraphicsBeginImageContext(rect.size);
		
		//// Bezier Drawing
		UIBezierPath* bezierPath = UIBezierPath.bezierPath;
		[bezierPath moveToPoint: CGPointMake(2.5, 2.5 + (17.0 / 10.0) * i)];
		[bezierPath addLineToPoint: CGPointMake(37.5, 37.5 - (17.0 / 10.0) * i)];
		bezierPath.lineCapStyle = kCGLineCapRound;
		
		bezierPath.lineJoinStyle = kCGLineJoinRound;
		
		[UIColor.blackColor setStroke];
		bezierPath.lineWidth = 4;
		[bezierPath stroke];
		
		//// Bezier 2 Drawing
		UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
		[bezier2Path moveToPoint: CGPointMake(37.5, 2.5 + (17.0 / 10.0) * i)];
		[bezier2Path addLineToPoint: CGPointMake(2.5, 37.5 - (17.0 / 10.0) * i)];
		bezier2Path.lineCapStyle = kCGLineCapRound;
		
		bezier2Path.lineJoinStyle = kCGLineJoinRound;
		
		[UIColor.blackColor setStroke];
		bezier2Path.lineWidth = 4;
		[bezier2Path stroke];
		
		UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[finalArray addObject:returnImage];
	}
	if (reversed){
		finalArray = [[[finalArray reverseObjectEnumerator]allObjects] mutableCopy];
	}
	return finalArray;
}

@end
