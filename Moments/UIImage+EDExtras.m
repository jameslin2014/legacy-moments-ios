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
	CGRect rect = CGRectMake(0, 0, 600, 600);
	UIGraphicsBeginImageContext(rect.size);
	//// Group
	{
		//// Bezier 2 Drawing
		UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
		[bezier2Path moveToPoint: CGPointMake(299.99, 100)];
		[bezier2Path addCurveToPoint: CGPointMake(100, 300) controlPoint1: CGPointMake(189.72, 100) controlPoint2: CGPointMake(100, 189.72)];
		[bezier2Path addCurveToPoint: CGPointMake(299.99, 500) controlPoint1: CGPointMake(100, 410.28) controlPoint2: CGPointMake(189.72, 500)];
		[bezier2Path addCurveToPoint: CGPointMake(500, 300) controlPoint1: CGPointMake(410.27, 500) controlPoint2: CGPointMake(500, 410.28)];
		[bezier2Path addCurveToPoint: CGPointMake(299.99, 100) controlPoint1: CGPointMake(500, 189.72) controlPoint2: CGPointMake(410.27, 100)];
		[bezier2Path closePath];
		[bezier2Path moveToPoint: CGPointMake(299.99, 473.77)];
		[bezier2Path addCurveToPoint: CGPointMake(126.23, 300) controlPoint1: CGPointMake(204.18, 473.77) controlPoint2: CGPointMake(126.23, 395.82)];
		[bezier2Path addCurveToPoint: CGPointMake(299.99, 126.23) controlPoint1: CGPointMake(126.23, 204.18) controlPoint2: CGPointMake(204.18, 126.23)];
		[bezier2Path addCurveToPoint: CGPointMake(473.77, 300) controlPoint1: CGPointMake(395.81, 126.23) controlPoint2: CGPointMake(473.77, 204.18)];
		[bezier2Path addCurveToPoint: CGPointMake(299.99, 473.77) controlPoint1: CGPointMake(473.77, 395.82) controlPoint2: CGPointMake(395.81, 473.77)];
		[bezier2Path closePath];
		bezier2Path.miterLimit = 4;
		
		[UIColor.blackColor setFill];
		[bezier2Path fill];
		
		
		//// Bezier 4 Drawing
		UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
		[bezier4Path moveToPoint: CGPointMake(365.47, 234.53)];
		[bezier4Path addCurveToPoint: CGPointMake(346.93, 234.53) controlPoint1: CGPointMake(360.35, 229.41) controlPoint2: CGPointMake(352.05, 229.41)];
		[bezier4Path addLineToPoint: CGPointMake(300, 281.45)];
		[bezier4Path addLineToPoint: CGPointMake(253.07, 234.53)];
		[bezier4Path addCurveToPoint: CGPointMake(234.53, 234.53) controlPoint1: CGPointMake(247.95, 229.41) controlPoint2: CGPointMake(239.65, 229.41)];
		[bezier4Path addCurveToPoint: CGPointMake(234.53, 253.07) controlPoint1: CGPointMake(229.4, 239.65) controlPoint2: CGPointMake(229.4, 247.95)];
		[bezier4Path addLineToPoint: CGPointMake(281.45, 300)];
		[bezier4Path addLineToPoint: CGPointMake(234.52, 346.93)];
		[bezier4Path addCurveToPoint: CGPointMake(234.52, 365.47) controlPoint1: CGPointMake(229.4, 352.04) controlPoint2: CGPointMake(229.4, 360.35)];
		[bezier4Path addCurveToPoint: CGPointMake(243.79, 369.31) controlPoint1: CGPointMake(237.08, 368.03) controlPoint2: CGPointMake(240.44, 369.31)];
		[bezier4Path addCurveToPoint: CGPointMake(253.06, 365.47) controlPoint1: CGPointMake(247.15, 369.31) controlPoint2: CGPointMake(250.5, 368.03)];
		[bezier4Path addLineToPoint: CGPointMake(300, 318.54)];
		[bezier4Path addLineToPoint: CGPointMake(346.93, 365.48)];
		[bezier4Path addCurveToPoint: CGPointMake(356.2, 369.32) controlPoint1: CGPointMake(349.49, 368.04) controlPoint2: CGPointMake(352.84, 369.32)];
		[bezier4Path addCurveToPoint: CGPointMake(365.47, 365.48) controlPoint1: CGPointMake(359.55, 369.32) controlPoint2: CGPointMake(362.91, 368.04)];
		[bezier4Path addCurveToPoint: CGPointMake(365.47, 346.93) controlPoint1: CGPointMake(370.6, 360.36) controlPoint2: CGPointMake(370.6, 352.05)];
		[bezier4Path addLineToPoint: CGPointMake(318.55, 300)];
		[bezier4Path addLineToPoint: CGPointMake(365.47, 253.07)];
		[bezier4Path addCurveToPoint: CGPointMake(365.47, 234.53) controlPoint1: CGPointMake(370.6, 247.96) controlPoint2: CGPointMake(370.6, 239.65)];
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
