//
//  EDSegmentedControl.m
//  Moments
//
//  Created by Evan Dekhayser on 12/18/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "EDSegmentedControl.h"
#import "EDSegments.h"

@interface EDSegmentedControl()


@end

@implementation EDSegmentedControl

- (instancetype)init{
	if (self = [super init]){
		self.state = StateLeftSelected;
		self.stateBeforeTouches = StateLeftSelected;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = touches.anyObject;
	self.stateBeforeTouches = self.state;
	if ([touch locationInView:self].x < self.bounds.size.width / 2){
		self.state = StateLeftHighlighted;
	} else{
		self.state = StateRightHighlighted;
	}
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = touches.anyObject;
	if ([touch locationInView:self].x < self.bounds.size.width / 2){
		self.state = StateLeftHighlighted;
	} else{
		self.state = StateRightHighlighted;
	}
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = touches.anyObject;
	[self setNeedsDisplay];
	if ([touch locationInView:self].x < self.bounds.size.width / 2){
		self.state = StateLeftSelected;
		self.stateBeforeTouches = self.state;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SegmentedControlStateChanged" object:nil];
	} else{
		self.state = StateRightSelected;
		self.stateBeforeTouches = self.state;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SegmentedControlStateChanged" object:nil];	
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	self.state = self.stateBeforeTouches;
}

- (void)drawRect:(CGRect)rect{
	switch (self.state) {
		case StateLeftSelected:
			[EDSegments drawCanvas1];
			break;
		case StateRightSelected:
			[EDSegments drawCanvas2];
			break;
		case StateLeftHighlighted:
			[EDSegments drawCanvas3];
			break;
		case StateRightHighlighted:
			[EDSegments drawCanvas4];
			break;
		default:
			break;
	}
}

@end
