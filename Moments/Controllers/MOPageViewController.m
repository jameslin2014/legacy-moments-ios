//
//  PageViewController.m
//  moments-test
//
//  Created by Douglas Bumby on 2014-11-29.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOPageViewController.h"

@interface MOPageViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) NSArray *viewControllers;
@end

@implementation MOPageViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
	return NO;
}

- (void)enableScrolling{
	self.scrollView.scrollEnabled = YES;
}

- (void)disableScrolling{
	self.scrollView.scrollEnabled = NO;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableScrolling) name:@"EnableScrollView" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableScrolling) name:@"DisableScrollView" object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        NSLog(@"app already launched");
    } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSelector:@selector(bounceScrollView) withObject:nil afterDelay:0.5];
        
    }
    
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
	self.scrollView.delegate = self;
	[self.viewControllers[1] view].alpha = 0;
}

- (void)bounceScrollView {
    self.scrollView.pagingEnabled = NO;
    self.scrollView.scrollEnabled = NO;
    [self.scrollView setContentOffset:CGPointMake(40, 0) animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(unbounceScrollView) userInfo:nil repeats:NO];
}

- (void)unbounceScrollView {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[((MOFollowViewController *)[self.viewControllers[2] topViewController]).searchBar resignFirstResponder];
	[((MOFollowViewController *)[self.viewControllers[2] topViewController]) showRegular];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[UIView animateWithDuration:0.15 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self.viewControllers[1] view].alpha = 1;
	} completion:^(BOOL finished) {
        [self jumpToSearch];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	for (UIViewController *vc in self.viewControllers){
		vc.view.hidden = NO;
	}
}

- (void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)jumpToSearch {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2.0, 0.0) animated:NO];
    
    UINavigationController *navController = (UINavigationController *) self.viewControllers[2];
    MOFollowViewController *followController = (MOFollowViewController *)navController.topViewController;
    
    [followController.tableView reloadData];
    [followController showSearch];
}

@end
