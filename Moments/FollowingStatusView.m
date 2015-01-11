//
//  FollowingStatusView.m
//  Moments
//
//  Created by Evan Dekhayser on 1/10/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "FollowingStatusView.h"

@implementation FollowingStatusView{
	CAShapeLayer *_backgroundGrayCircle;
	CAShapeLayer *_innerGreenCircle;
	CAShapeLayer *_outerGreenCircle;
}

- (void)setIsFollowing:(BOOL)isFollowing{
	_isFollowing = isFollowing;

	_outerGreenCircle.hidden = !_isFollowing;
	_innerGreenCircle.hidden = !_isFollowing;
}

- (instancetype)init{
	if (self = [super initWithFrame:CGRectMake(0, 0, 15, 15)]){
		for (CALayer *l in self.layer.sublayers){
			[l removeFromSuperlayer];
		}
		self.backgroundColor = [UIColor clearColor];
		self.layer.backgroundColor = [UIColor clearColor].CGColor;
		_backgroundGrayCircle = [[CAShapeLayer alloc]init];
		_backgroundGrayCircle.frame = self.layer.bounds;
		_backgroundGrayCircle.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundGrayCircle.frame].CGPath;
		_backgroundGrayCircle.strokeColor = [UIColor grayColor].CGColor;
		_backgroundGrayCircle.fillColor = [UIColor clearColor].CGColor;
		_backgroundGrayCircle.lineWidth = 1.0;
		_backgroundGrayCircle.backgroundColor = [UIColor clearColor].CGColor;
		[self.layer addSublayer:_backgroundGrayCircle];
		_innerGreenCircle = [[CAShapeLayer alloc]init];
		_innerGreenCircle.frame = CGRectMake((15.0 - 10.0) / 4.0, (15.0 - 10.0) / 4.0, 10, 10);
		_innerGreenCircle.path = [UIBezierPath bezierPathWithOvalInRect:_innerGreenCircle.frame].CGPath;
		_innerGreenCircle.fillColor = [UIColor colorWithRed:0 green:0.78 blue:0.42 alpha:1].CGColor;
		_innerGreenCircle.backgroundColor = [UIColor clearColor].CGColor;
		_innerGreenCircle.hidden = !self.isFollowing;
		[self.layer addSublayer:_innerGreenCircle];
		_outerGreenCircle = [[CAShapeLayer alloc]init];
		_outerGreenCircle.frame = self.layer.bounds;
		_outerGreenCircle.path = [UIBezierPath bezierPathWithOvalInRect:_outerGreenCircle.frame].CGPath;
		_outerGreenCircle.strokeColor = [UIColor colorWithRed:0 green:0.78 blue:0.42 alpha:1].CGColor;
		_outerGreenCircle.lineWidth = 1.0;
		_outerGreenCircle.fillColor = [UIColor clearColor].CGColor;
		_outerGreenCircle.hidden = !self.isFollowing;
		_outerGreenCircle.backgroundColor = [UIColor clearColor].CGColor;
		[self.layer addSublayer:_outerGreenCircle];
	}
	return self;
}

@end
