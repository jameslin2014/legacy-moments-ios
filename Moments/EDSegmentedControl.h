//
//  EDSegmentedControl.h
//  Moments
//
//  Created by Evan Dekhayser on 12/18/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, State) {
	StateLeftSelected,
	StateRightSelected,
	StateLeftHighlighted,
	StateRightHighlighted
};

@interface EDSegmentedControl : UIView

@property (nonatomic) State stateBeforeTouches;
@property (nonatomic) State state;

@end
