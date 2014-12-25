//
//  PageViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOPageViewController.h"

@interface MOPageViewController ()
@property (strong, nonatomic) NSArray *viewControllers;
@end

@implementation MOPageViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
    // Do any additional setup after loading the view.
	self.viewControllers = @[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"listView"],[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"captureView"],[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"followerStuff"]];
	
	self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	self.scrollView.pagingEnabled = YES;
	self.scrollView.bounces = NO;
	[self.view addSubview:self.scrollView];
	int x = 0;
	for (UIViewController *vc in self.viewControllers){
		[self addChildViewController:vc];
		vc.view.frame = CGRectMake(x++*vc.view.frame.size.width, 0, vc.view.frame.size.width, vc.view.frame.size.height);
		[self.scrollView addSubview:vc.view];
		[vc didMoveToParentViewController:self];
		self.scrollView.contentSize = CGSizeMake(self.viewControllers.count*vc.view.frame.size.width, vc.view.frame.size.height);
	}
}

- (UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

@end
