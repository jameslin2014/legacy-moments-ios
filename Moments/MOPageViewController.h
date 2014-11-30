//
//  PageViewController.h
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MOListViewController.h"
#import "MOCaptureViewController.h"
#import "MOFollowingViewController.h"

@interface MOPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

// UIPageViewController properties
@property (strong, nonatomic) UIPageViewController *pageController;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) NSArray *pages;

@end