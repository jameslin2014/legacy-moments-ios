//
//  MOTableViewController.m
//  Moments
//
//  Created by Evan Dekhayser on 12/24/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOTableViewController.h"
#import "SSKeychain.h"
#import "MomentsAPIUtilities.h"
#import "UIImageView+AFNetworking.h"
#import "MOSettingsViewController.h"
#import <SceneKit/SceneKit.h>
#import "EDSpinningBoxScene.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface MOTableViewController ()
@property (strong, nonatomic) NSArray *following;
@end

@implementation MOTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Moments";
	self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.101 green:0.450 blue:0.635 alpha:1.0];
	self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
	self.tableView.backgroundColor = [UIColor colorWithRed:36/255.0 green: 36/255.0 blue:36/255.0 alpha:1.0];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(showOptionsAndAbout)];
	button.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = button;
	
	
	[[[MomentsAPIUtilities alloc]init] getUserFollowingListWithUsername:[SSKeychain passwordForService:@"moments" account:@"username"] completion:^(NSArray *followedUsers) {
		self.following = followedUsers;
		[self.tableView reloadData];
	}];
}

- (void)showOptionsAndAbout{
	MOSettingsViewController *settingsViewController = [[MOSettingsViewController alloc]init];
	settingsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	settingsViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
	self.providesPresentationContextTransitionStyle = YES;
	self.definesPresentationContext = YES;
	[self presentViewController:settingsViewController animated:YES completion:nil];
}

- (void)shareMoment {
	NSString *user = [SSKeychain passwordForService:@"moments" account:@"username"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"saved.mp4"];
	NSURL *video = [NSURL fileURLWithPath:imagePath];
	SCNView *v = [[SCNView alloc] initWithFrame:self.view.bounds];
	v.scene = [[EDSpinningBoxScene alloc] init];
	v.alpha = 0.0;
	v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self.view addSubview:v];
	[UIView animateWithDuration:0.2 animations:^{
		v.alpha = 1.0;
	}];
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	//    [LoadingHUD.textLabel setText:@"Exporting..."];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-videos/%@.mp4",user]]];
		[videoData writeToFile:imagePath atomically:NO];
		UIActivityViewController *shareSheet = [[UIActivityViewController alloc] initWithActivityItems:@[video] applicationActivities:nil];
		[shareSheet setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
			if([activityType isEqualToString: UIActivityTypeSaveToCameraRoll]){
				ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
				[library saveVideo:video toAlbum:@"Saved Moments" withCompletionBlock:nil];
			}
		}];
		[self presentViewController:shareSheet animated:YES completion:^ {
			[UIView animateWithDuration:0.2 animations:^{
				v.alpha = 0.0;
			} completion:^(BOOL finished) {
				[v removeFromSuperview];
				[[UIApplication sharedApplication] endIgnoringInteractionEvents];
			}];
		}];
		
	});
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return section == 0 ? 1 : self.following.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 55;
}

-(void)viewWillAppear:(BOOL)animated {
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"signOut"
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *note)
     {
         UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
         [self presentViewController:loginVC animated:YES completion:nil];
         
         
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell){
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	cell.backgroundColor = [UIColor colorWithRed:36/255.0 green: 36/255.0 blue:36/255.0 alpha:1.0];
	cell.textLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
	cell.textLabel.textColor = [UIColor whiteColor];

	UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 55 - 5*2, 55 - 5*2)];
	profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2;
	profileImageView.clipsToBounds = YES;
	[cell.contentView addSubview:profileImageView];
	
	if (indexPath.section == 0){
		cell.textLabel.text = [NSString stringWithFormat:@"\t\t%@",[SSKeychain passwordForService:@"moments" account:@"username"]];
		__weak UIImageView *weakImageView = profileImageView;
		[profileImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png", [SSKeychain passwordForService:@"moments" account:@"username"]]]] placeholderImage:[UIImage imageNamed:@"capture-button.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
			NSLog(@"Success!!!");
			weakImageView.image = image;
		} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
			NSLog(@"Failure: %@", error);
		}];
		UIToolbar *toolbar = [[UIToolbar alloc] init];
		toolbar.barTintColor = [UIColor colorWithRed:36/255.0 green: 36/255.0 blue:36/255.0 alpha:1.0];
		toolbar.translucent = false;
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareMoment)];
		toolbar.frame = CGRectMake(0, 0, 55, 55);
		item.tintColor = [UIColor whiteColor];
		[toolbar setItems:[NSArray arrayWithObject:item] animated:NO];
		[toolbar setBarTintColor:[UIColor clearColor]];
		for(UIView *view in [toolbar subviews])
		{
			if([view isKindOfClass:[UIImageView class]])
			{
				[view setHidden:YES];
				[view setAlpha:0.0f];
			}
		}
		cell.accessoryView = toolbar;
	} else{
		cell.textLabel.text = [NSString stringWithFormat:@"\t\t%@",self.following[indexPath.row]];
		__weak UIImageView *weakImageView = profileImageView;
		[profileImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png", self.following[indexPath.row]]]] placeholderImage:[UIImage imageNamed:@"capture-button.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
			weakImageView.image = image;
			weakImageView.layer.cornerRadius = weakImageView.frame.size.width / 2;
			weakImageView.clipsToBounds = YES;
			NSLog(@"Sucess..!!");
		} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
			NSLog(@"Failure: %@", error);
		}];
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return (CGFloat) 0.0;
	} else {
		return 21.5f;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return nil;
	} else {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 18)];
		/* Create custom view to display section header... */
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, self.tableView.frame.size.width, 18)];
		[label setFont:[UIFont fontWithName:@"Avenir-Book" size:12]];
		label.textColor = [UIColor whiteColor];
		NSString *string =[NSString stringWithFormat:@"Recent Updates"];
		[label setText:string];
		[view addSubview:label];
		[view setBackgroundColor:[UIColor colorWithRed:0.101 green:0.450 blue:0.635 alpha:1.0]]; //your background color...
		return view;
	}
}

@end
