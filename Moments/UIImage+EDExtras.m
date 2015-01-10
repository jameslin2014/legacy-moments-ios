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
	ovalPath.lineWidth = 4;
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
	ovalPath.lineWidth = 4;
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
		
		CGFloat cornerRadius = reversed ? 30 : 10;
		//// Rectangle Drawing
		CGRect r = CGRectMake(13 + i, 13 + i, 60 - 2*i, 60 - 2*i);
		if (!reversed){
			r = CGRectMake(MIN(13+i+5, 23), MIN(13+i+5, 23), MAX(60-2*i-10, 40), MAX(60-2*i-10, 40));
		}
		NSLog(@"%@", NSStringFromCGRect(r));
		UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: r cornerRadius: cornerRadius];
		[color setFill];
		[rectanglePath fill];
		
		//// Oval Drawing
		UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(3, 3, 80, 80)];
		[UIColor.whiteColor setStroke];
		ovalPath.lineWidth = 4;
		[ovalPath stroke];
		
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
	CGRect rect = CGRectMake(0, 0, 80, 80);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Bezier Drawing
	UIBezierPath* bezierPath = UIBezierPath.bezierPath;
	[bezierPath moveToPoint: CGPointMake(4, 76)];
	[bezierPath addLineToPoint: CGPointMake(40, 40)];
	bezierPath.lineCapStyle = kCGLineCapRound;
	
	bezierPath.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezierPath.lineWidth = 8;
	[bezierPath stroke];
	
	//// Bezier 2 Drawing
	UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
	[bezier2Path moveToPoint: CGPointMake(40, 40)];
	[bezier2Path addLineToPoint: CGPointMake(4, 4)];
	bezier2Path.lineCapStyle = kCGLineCapRound;
	
	bezier2Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier2Path.lineWidth = 8;
	[bezier2Path stroke];
	
	//// Bezier 3 Drawing
	UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
	[bezier3Path moveToPoint: CGPointMake(40, 40)];
	[bezier3Path addLineToPoint: CGPointMake(76, 4)];
	bezier3Path.lineCapStyle = kCGLineCapRound;
	
	bezier3Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier3Path.lineWidth = 8;
	[bezier3Path stroke];
	
	//// Bezier 4 Drawing
	UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
	[bezier4Path moveToPoint: CGPointMake(40, 40)];
	[bezier4Path addLineToPoint: CGPointMake(76, 76)];
	bezier4Path.lineCapStyle = kCGLineCapRound;
	
	bezier4Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier4Path.lineWidth = 8;
	[bezier4Path stroke];
	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (UIImage *)cancelButtonLine{
	CGRect rect = CGRectMake(0, 0, 80, 80);
	UIGraphicsBeginImageContext(rect.size);
	
	
	//// Bezier Drawing
	UIBezierPath* bezierPath = UIBezierPath.bezierPath;
	[bezierPath moveToPoint: CGPointMake(4, 40)];
	[bezierPath addLineToPoint: CGPointMake(40, 40)];
	bezierPath.lineCapStyle = kCGLineCapRound;
	
	bezierPath.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezierPath.lineWidth = 8;
	[bezierPath stroke];
	
	
	//// Bezier 2 Drawing
	UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
	[bezier2Path moveToPoint: CGPointMake(40, 40)];
	[bezier2Path addLineToPoint: CGPointMake(4, 40)];
	bezier2Path.lineCapStyle = kCGLineCapRound;
	
	bezier2Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier2Path.lineWidth = 8;
	[bezier2Path stroke];
	
	
	//// Bezier 3 Drawing
	UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
	[bezier3Path moveToPoint: CGPointMake(40, 40)];
	[bezier3Path addLineToPoint: CGPointMake(76, 40)];
	bezier3Path.lineCapStyle = kCGLineCapRound;
	
	bezier3Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier3Path.lineWidth = 8;
	[bezier3Path stroke];
	
	
	//// Bezier 4 Drawing
	UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
	[bezier4Path moveToPoint: CGPointMake(40, 40)];
	[bezier4Path addLineToPoint: CGPointMake(76, 40)];
	bezier4Path.lineCapStyle = kCGLineCapRound;
	
	bezier4Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier4Path.lineWidth = 8;
	[bezier4Path stroke];

	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (NSArray *)transitionCancelButtonImages:(BOOL)reversed{
	NSMutableArray *finalArray = [NSMutableArray array];
	for (float i = 0; i <= 10.0; i += 1.0){
		CGRect rect = CGRectMake(0, 0, 80, 80);
		UIGraphicsBeginImageContext(rect.size);
		
		//// Bezier Drawing
		UIBezierPath* bezierPath = UIBezierPath.bezierPath;
		[bezierPath moveToPoint: CGPointMake(4, 76 - 3.6*i)];
		[bezierPath addLineToPoint: CGPointMake(40, 40)];
		bezierPath.lineCapStyle = kCGLineCapRound;
		
		bezierPath.lineJoinStyle = kCGLineJoinRound;
		
		[UIColor.blackColor setStroke];
		bezierPath.lineWidth = 8;
		[bezierPath stroke];
		
		//// Bezier 2 Drawing
		UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
		[bezier2Path moveToPoint: CGPointMake(40, 40)];
		[bezier2Path addLineToPoint: CGPointMake(4, 4 + 3.6*i)];
		bezier2Path.lineCapStyle = kCGLineCapRound;
		
		bezier2Path.lineJoinStyle = kCGLineJoinRound;
		
		[UIColor.blackColor setStroke];
		bezier2Path.lineWidth = 8;
		[bezier2Path stroke];
		
		//// Bezier 3 Drawing
		UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
		[bezier3Path moveToPoint: CGPointMake(40, 40)];
		[bezier3Path addLineToPoint: CGPointMake(76, 4 + 3.6*i)];
		bezier3Path.lineCapStyle = kCGLineCapRound;
		
		bezier3Path.lineJoinStyle = kCGLineJoinRound;
		
		[UIColor.blackColor setStroke];
		bezier3Path.lineWidth = 8;
		[bezier3Path stroke];
		
		//// Bezier 4 Drawing
		UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
		[bezier4Path moveToPoint: CGPointMake(40, 40)];
		[bezier4Path addLineToPoint: CGPointMake(76, 76 - 3.6*i)];
		bezier4Path.lineCapStyle = kCGLineCapRound;
		
		bezier4Path.lineJoinStyle = kCGLineJoinRound;
		
		[UIColor.blackColor setStroke];
		bezier4Path.lineWidth = 8;
		[bezier4Path stroke];
		
		UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[finalArray addObject:returnImage];
	}
	if (reversed){
		finalArray = [[[finalArray reverseObjectEnumerator]allObjects] mutableCopy];
	}
	return finalArray;
}

+ (UIImage *)backButtonOpen{
	CGRect rect = CGRectMake(0, 0, 80, 80);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Bezier Drawing
	UIBezierPath* bezierPath = UIBezierPath.bezierPath;
	[bezierPath moveToPoint: CGPointMake(40, 4)];
	[bezierPath addLineToPoint: CGPointMake(4, 40)];
	[bezierPath addLineToPoint: CGPointMake(40, 76)];
	bezierPath.lineCapStyle = kCGLineCapRound;
	
	bezierPath.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezierPath.lineWidth = 8;
	[bezierPath stroke];
	
	//// Bezier 2 Drawing
	UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
	[bezier2Path moveToPoint: CGPointMake(76, 40)];
	[bezier2Path addLineToPoint: CGPointMake(4, 40)];
	bezier2Path.lineCapStyle = kCGLineCapRound;
	
	bezier2Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier2Path.lineWidth = 8;
	[bezier2Path stroke];
	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (UIImage *)backButtonClosed{
	CGRect rect = CGRectMake(0, 0, 80, 80);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Bezier Drawing
	UIBezierPath* bezierPath = UIBezierPath.bezierPath;
	[bezierPath moveToPoint: CGPointMake(80, 40)];
	[bezierPath addLineToPoint: CGPointMake(4, 40)];
	[bezierPath addLineToPoint: CGPointMake(80, 40)];
	bezierPath.lineCapStyle = kCGLineCapRound;
	
	bezierPath.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezierPath.lineWidth = 8;
	[bezierPath stroke];
	
	
	//// Bezier 2 Drawing
	UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
	[bezier2Path moveToPoint: CGPointMake(76, 40)];
	[bezier2Path addLineToPoint: CGPointMake(4, 40)];
	bezier2Path.lineCapStyle = kCGLineCapRound;
	
	bezier2Path.lineJoinStyle = kCGLineJoinRound;
	
	[UIColor.blackColor setStroke];
	bezier2Path.lineWidth = 8;
	[bezier2Path stroke];
	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (NSArray *)transitionBackButtonImages:(BOOL)reversed{
	NSMutableArray *finalArray = [NSMutableArray array];
	for (float i = 0; i <= 10.0; i += 1.0){
		CGRect rect = CGRectMake(0, 0, 80, 80);
		UIGraphicsBeginImageContext(rect.size);
		
		//// Bezier Drawing
		UIBezierPath* bezierPath = UIBezierPath.bezierPath;
		[bezierPath moveToPoint: CGPointMake(40 + 2*i, 4 + 3.6*i)];
		[bezierPath addLineToPoint: CGPointMake(4, 40)];
		[bezierPath addLineToPoint: CGPointMake(40 + 2*i, 76 - 3.6*i)];
		bezierPath.lineCapStyle = kCGLineCapRound;
		
		bezierPath.lineJoinStyle = kCGLineJoinRound;
		
		[UIColor.blackColor setStroke];
		bezierPath.lineWidth = 8;
		[bezierPath stroke];
		
		
		//// Bezier 2 Drawing
		UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
		[bezier2Path moveToPoint: CGPointMake(76, 40)];
		[bezier2Path addLineToPoint: CGPointMake(4, 40)];
		bezier2Path.lineCapStyle = kCGLineCapRound;
		
		bezier2Path.lineJoinStyle = kCGLineJoinRound;
		
		[UIColor.blackColor setStroke];
		bezier2Path.lineWidth = 8;
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

+ (UIImage *)plusButton{
	CGRect rect = CGRectMake(0, 0, 178, 178);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Color Declarations
	UIColor* color2 = [UIColor colorWithRed: 0.957 green: 0.969 blue: 0.976 alpha: 1];
	
	//// Oval Drawing
	UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(3, 3, 172, 172)];
	[color2 setFill];
	[ovalPath fill];
	[UIColor.blackColor setStroke];
	ovalPath.lineWidth = 2;
	[ovalPath stroke];
	
	
	//// Bezier Drawing
	UIBezierPath* bezierPath = UIBezierPath.bezierPath;
	[bezierPath moveToPoint: CGPointMake(89, 55.5)];
	[bezierPath addLineToPoint: CGPointMake(89, 122.5)];
	bezierPath.lineCapStyle = kCGLineCapRound;
	
	bezierPath.lineJoinStyle = kCGLineJoinRound;
	
	[color2 setFill];
	[bezierPath fill];
	[UIColor.blackColor setStroke];
	bezierPath.lineWidth = 6;
	[bezierPath stroke];
	
	
	//// Bezier 2 Drawing
	UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
	[bezier2Path moveToPoint: CGPointMake(55.5, 89)];
	[bezier2Path addLineToPoint: CGPointMake(122.5, 89)];
	bezier2Path.lineCapStyle = kCGLineCapRound;
	
	bezier2Path.lineJoinStyle = kCGLineJoinRound;
	
	[color2 setFill];
	[bezier2Path fill];
	[UIColor.blackColor setStroke];
	bezier2Path.lineWidth = 6;
	[bezier2Path stroke];
	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (UIImage *)plusButtonHighlighted{
	CGRect rect = CGRectMake(0, 0, 178, 178);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Color Declarations
	UIColor* color2 = [UIColor colorWithRed:0 green:0.63 blue:0.89 alpha:1];
	
	//// Oval Drawing
	UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(3, 3, 172, 172)];
	[color2 setFill];
	[ovalPath fill];
	[UIColor.blackColor setStroke];
	ovalPath.lineWidth = 2;
	[ovalPath stroke];
	
	
	//// Bezier Drawing
	UIBezierPath* bezierPath = UIBezierPath.bezierPath;
	[bezierPath moveToPoint: CGPointMake(89, 55.5)];
	[bezierPath addLineToPoint: CGPointMake(89, 122.5)];
	bezierPath.lineCapStyle = kCGLineCapRound;
	
	bezierPath.lineJoinStyle = kCGLineJoinRound;
	
	[color2 setFill];
	[bezierPath fill];
	[UIColor.blackColor setStroke];
	bezierPath.lineWidth = 6;
	[bezierPath stroke];
	
	
	//// Bezier 2 Drawing
	UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
	[bezier2Path moveToPoint: CGPointMake(55.5, 89)];
	[bezier2Path addLineToPoint: CGPointMake(122.5, 89)];
	bezier2Path.lineCapStyle = kCGLineCapRound;
	
	bezier2Path.lineJoinStyle = kCGLineJoinRound;
	
	[color2 setFill];
	[bezier2Path fill];
	[UIColor.blackColor setStroke];
	bezier2Path.lineWidth = 6;
	[bezier2Path stroke];
	
	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

+ (UIImage *)circleCancelButton{
	CGRect rect = CGRectMake(0, 0, 100, 100);
	UIGraphicsBeginImageContext(rect.size);
	
	//// Group
	{
		//// Bezier 2 Drawing
		UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
		[bezier2Path moveToPoint: CGPointMake(50, 0)];
		[bezier2Path addCurveToPoint: CGPointMake(0, 50) controlPoint1: CGPointMake(22.43, 0) controlPoint2: CGPointMake(0, 22.43)];
		[bezier2Path addCurveToPoint: CGPointMake(50, 100) controlPoint1: CGPointMake(0, 77.57) controlPoint2: CGPointMake(22.43, 100)];
		[bezier2Path addCurveToPoint: CGPointMake(100, 50) controlPoint1: CGPointMake(77.57, 100) controlPoint2: CGPointMake(100, 77.57)];
		[bezier2Path addCurveToPoint: CGPointMake(50, 0) controlPoint1: CGPointMake(100, 22.43) controlPoint2: CGPointMake(77.57, 0)];
		[bezier2Path closePath];
		[bezier2Path moveToPoint: CGPointMake(50, 93.44)];
		[bezier2Path addCurveToPoint: CGPointMake(6.56, 50) controlPoint1: CGPointMake(26.04, 93.44) controlPoint2: CGPointMake(6.56, 73.95)];
		[bezier2Path addCurveToPoint: CGPointMake(50, 6.56) controlPoint1: CGPointMake(6.56, 26.05) controlPoint2: CGPointMake(26.04, 6.56)];
		[bezier2Path addCurveToPoint: CGPointMake(93.44, 50) controlPoint1: CGPointMake(73.95, 6.56) controlPoint2: CGPointMake(93.44, 26.05)];
		[bezier2Path addCurveToPoint: CGPointMake(50, 93.44) controlPoint1: CGPointMake(93.44, 73.95) controlPoint2: CGPointMake(73.95, 93.44)];
		[bezier2Path closePath];
		bezier2Path.miterLimit = 4;
		
		[UIColor.blackColor setFill];
		[bezier2Path fill];
		
		
		//// Bezier 4 Drawing
		UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
		[bezier4Path moveToPoint: CGPointMake(66.37, 33.63)];
		[bezier4Path addCurveToPoint: CGPointMake(61.73, 33.63) controlPoint1: CGPointMake(65.09, 32.35) controlPoint2: CGPointMake(63.01, 32.35)];
		[bezier4Path addLineToPoint: CGPointMake(50, 45.36)];
		[bezier4Path addLineToPoint: CGPointMake(38.27, 33.63)];
		[bezier4Path addCurveToPoint: CGPointMake(33.63, 33.63) controlPoint1: CGPointMake(36.99, 32.35) controlPoint2: CGPointMake(34.91, 32.35)];
		[bezier4Path addCurveToPoint: CGPointMake(33.63, 38.27) controlPoint1: CGPointMake(32.35, 34.91) controlPoint2: CGPointMake(32.35, 36.99)];
		[bezier4Path addLineToPoint: CGPointMake(45.36, 50)];
		[bezier4Path addLineToPoint: CGPointMake(33.63, 61.73)];
		[bezier4Path addCurveToPoint: CGPointMake(33.63, 66.37) controlPoint1: CGPointMake(32.35, 63.01) controlPoint2: CGPointMake(32.35, 65.09)];
		[bezier4Path addCurveToPoint: CGPointMake(35.95, 67.33) controlPoint1: CGPointMake(34.27, 67.01) controlPoint2: CGPointMake(35.11, 67.33)];
		[bezier4Path addCurveToPoint: CGPointMake(38.27, 66.37) controlPoint1: CGPointMake(36.79, 67.33) controlPoint2: CGPointMake(37.63, 67.01)];
		[bezier4Path addLineToPoint: CGPointMake(50, 54.64)];
		[bezier4Path addLineToPoint: CGPointMake(61.73, 66.37)];
		[bezier4Path addCurveToPoint: CGPointMake(64.05, 67.33) controlPoint1: CGPointMake(62.37, 67.01) controlPoint2: CGPointMake(63.21, 67.33)];
		[bezier4Path addCurveToPoint: CGPointMake(66.37, 66.37) controlPoint1: CGPointMake(64.89, 67.33) controlPoint2: CGPointMake(65.73, 67.01)];
		[bezier4Path addCurveToPoint: CGPointMake(66.37, 61.73) controlPoint1: CGPointMake(67.65, 65.09) controlPoint2: CGPointMake(67.65, 63.01)];
		[bezier4Path addLineToPoint: CGPointMake(54.64, 50)];
		[bezier4Path addLineToPoint: CGPointMake(66.37, 38.27)];
		[bezier4Path addCurveToPoint: CGPointMake(66.37, 33.63) controlPoint1: CGPointMake(67.65, 36.99) controlPoint2: CGPointMake(67.65, 34.91)];
		[bezier4Path closePath];
		bezier4Path.miterLimit = 4;
		
		[UIColor.blackColor setFill];
		[bezier4Path fill];
	}

	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return returnImage;
}

@end
