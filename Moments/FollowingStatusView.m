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
#warning animate
}

- (void)layoutSubviews{
	if (!_backgroundGrayCircle){
		_backgroundGrayCircle = [[CAShapeLayer alloc]init];
		_backgroundGrayCircle.frame = self.bounds;
		_backgroundGrayCircle.strokeColor = [UIColor grayColor].CGColor;
		_backgroundGrayCircle.lineWidth = 2.0;
		[self.layer addSublayer:_backgroundGrayCircle];
	}
	if (!_innerGreenCircle){
		_innerGreenCircle = [[CAShapeLayer alloc]init];
		_innerGreenCircle.frame = CGRectMake(.1*self.bounds.size.width, .1*self.bounds.size.height, .8*self.bounds.size.width, .8*self.bounds.size.height);
		_innerGreenCircle.fillColor = [UIColor colorWithRed:0 green:0.78 blue:0.42 alpha:1].CGColor;
		[self.layer addSublayer:_innerGreenCircle];
	}
	if (!_outerGreenCircle){
		_outerGreenCircle = [[CAShapeLayer alloc]init];
		_outerGreenCircle.frame = self.bounds;
		_outerGreenCircle.strokeColor = [UIColor colorWithRed:0 green:0.78 blue:0.42 alpha:1].CGColor;
		_outerGreenCircle.lineWidth = 2.0;
		_outerGreenCircle.hidden = !self.isFollowing;
		[self.layer addSublayer:_outerGreenCircle];
	}
}

@end
