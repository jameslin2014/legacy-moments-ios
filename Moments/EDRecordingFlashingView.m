//
//  EDRecordingFlashingView.m
//  Moments
//
//  Created by Evan Dekhayser on 1/1/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "EDRecordingFlashingView.h"

@interface EDRecordingFlashingView ()
@property (nonatomic) BOOL dotVisible;
@property (strong, nonatomic) NSTimer *flashTimer;
@end

@implementation EDRecordingFlashingView

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
	if (self = [super initWithCoder:aDecoder]){
		self.dotVisible = YES;
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]){
		self.dotVisible = YES;
	}
	return self;
}

- (instancetype) init{
	if (self = [super init]){
		self.dotVisible = YES;
	}
	return self;
}

- (void)toggleFlashing{
	self.dotVisible = !self.dotVisible;
	[self setNeedsDisplay];
}

- (void)show{
	self.hidden = NO;
	self.flashTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(toggleFlashing) userInfo:nil repeats:YES];
}

- (void)hide{
	self.hidden = YES;
}

- (void)drawRect:(CGRect)rect {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Text Drawing
	CGRect textRect = CGRectMake(16, 0, 104, 14);
	{
		NSString* textContent = @"RECORDING";
		NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
		textStyle.alignment = NSTextAlignmentLeft;
		
		NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Futura-Medium" size: UIFont.labelFontSize], NSForegroundColorAttributeName: UIColor.redColor, NSParagraphStyleAttributeName: textStyle};
		
		CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
		CGContextSaveGState(context);
		CGContextClipToRect(context, textRect);
		[textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
		CGContextRestoreGState(context);
	}
	
	if (self.dotVisible){
		//// Oval Drawing
		CGRect ovalRect = CGRectMake(4, 4, 7, 7);
		UIBezierPath* ovalPath = UIBezierPath.bezierPath;
		[ovalPath addArcWithCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)) radius: CGRectGetWidth(ovalRect) / 2 startAngle: 1 * M_PI/180 endAngle: 0 * M_PI/180 clockwise: YES];
		[ovalPath addLineToPoint: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect))];
		[ovalPath closePath];
		
		[UIColor.redColor setFill];
		[ovalPath fill];
	}
}

@end
