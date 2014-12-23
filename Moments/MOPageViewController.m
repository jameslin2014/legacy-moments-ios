//
//  PageViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOPageViewController.h"

@implementation MOPageViewController {
    NSArray *viewControllers;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Instantiating view controllers with identifiers for IB to interact with.
    MOListViewController *listView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"listView"];
    MOCaptureViewController *captureView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"captureView"];
//    MOFollowingViewController *friendsView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"friendsView"];
	MOFollowingViewController *friendsView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"followerStuff"];
	
    // Load the ViewControllers in our pages array.
    self.pages = [[NSArray alloc] initWithObjects:listView, captureView, friendsView, nil];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageControl.hidden = YES;
    [self.pageController setDelegate:self];
    [self.pageController setDataSource:self];
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    viewControllers = [NSArray arrayWithObject:[self.pages objectAtIndex:0]];
    [self.pageControl setCurrentPage:0];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    
    [self.view addSubview:self.pageControl];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    [self.view sendSubviewToBack:[self.pageController view]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];
    [self.pageControl setCurrentPage:self.pageControl.currentPage + 1];
    
    if (currentIndex < [self.pages count] - 1) {
        return [self.pages objectAtIndex:currentIndex + 1];
    } else {
        return nil;
    }
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];
    [self.pageControl setCurrentPage:self.pageControl.currentPage - 1];
    
    if (currentIndex > 0) {
        return [self.pages objectAtIndex:currentIndex - 1];
    } else {
        return nil;
    }
    
}

- (void)changePage:(id)sender {
    
    UIViewController *visibleViewController = self.pageController.viewControllers[0];
    NSUInteger currentIndex = [self.pages indexOfObject:visibleViewController];
    NSArray *controllers = [NSArray arrayWithObjects:[self.pages objectAtIndex:self.pageControl.currentPage], nil];
    
    if (self.pageControl.currentPage > currentIndex) {
        [self.pageController setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self.pageController setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    
    
}

@end
