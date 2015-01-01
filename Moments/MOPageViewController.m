//
//  PageViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOPageViewController.h"
#import "MomentsAPIUtilities.h"
#import "SSKeychain.h"

@interface MOPageViewController ()
@property (strong, nonatomic) NSArray *viewControllers;
@end

@implementation MOPageViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
    // Do any additional setup after loading the view.
	self.viewControllers = @[
							 [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"listView"],
							 [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"captureView"],
							 [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"followerStuff"]];
	
	self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	self.scrollView.pagingEnabled = YES;
	self.scrollView.bounces = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:self.scrollView];
	int x = 0;
	for (UIViewController *vc in self.viewControllers){
		vc.view.hidden = YES;
		[self addChildViewController:vc];
		vc.view.frame = CGRectMake(self.scrollView.frame.size.width  * x++, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
		[self.scrollView addSubview:vc.view];
		[vc didMoveToParentViewController:self];
	}
	self.scrollView.contentSize = CGSizeMake(self.viewControllers.count * self.view.frame.size.width, self.view.frame.size.height);
	MomentsAPIUtilities *LoginAPI = [MomentsAPIUtilities alloc];
	[LoginAPI loginWithUsername:[SSKeychain passwordForService:@"moments" account:@"username"] andPassword:[SSKeychain passwordForService:@"moments" account:@"password"] completion:^(BOOL login) {
		if (login == NO) {
			UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
			UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"login"];
			[self presentViewController:vc animated:YES completion:nil];
		}
	}];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	for (UIViewController *vc in self.viewControllers){
		vc.view.hidden = NO;
	}
}

- (UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

@end
