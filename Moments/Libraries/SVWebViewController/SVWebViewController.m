//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewController.h"

@interface SVWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;

@end


@implementation SVWebViewController

#pragma mark - Initialization

- (void)dealloc {
    [self.webView stopLoading];
 	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.webView.delegate = nil;
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)loadRequest:(NSURLRequest*)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = self.webView;
    [self loadRequest:self.request];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    
    self.title = @"Privacy Policy";
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Avenir-Book" size:17], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.52 blue:0.68 alpha:0.39]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.webView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Getters

- (UIWebView *)webView {
    if(!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (void)doneButtonTapped:(id)sùender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
