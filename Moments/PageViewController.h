//
//  PageViewController.h
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "CaptureViewController.h"
#import "FollowingViewController.h"

@interface PageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) NSArray *pages;

@end
