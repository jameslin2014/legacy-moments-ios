//
//  EDTableViewController.m
//  Moments
//
//  Created by Evan Dekhayser on 12/24/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "EDTableViewController.h"
#import "SSKeychain.h"
#import "MomentsAPIUtilities.h"
#import "UIImageView+AFNetworking.h"
#import "MOSettingsViewController.h"
#import <SceneKit/SceneKit.h>
#import "EDSpinningBoxScene.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface EDTableViewController ()
@property (strong, nonatomic) NSArray *following;
@end

@implementation EDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Moments";
	self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.101 green:0.450 blue:0.635 alpha:1.0];
	self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
	self.tableView.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:1.0];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(showOptionsAndAbout)];
	button.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = button;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell){
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	cell.textLabel.font = [UIFont fontWithName:@"Avenir-Book" size:20];
	if (indexPath.section == 0){
		cell.textLabel.text = [SSKeychain passwordForService:@"moments" account:@"username"];
		UIToolbar *toolbar = [[UIToolbar alloc] init];
		toolbar.barTintColor = [UIColor colorWithRed:(38/255.0) green:(37/255.0) blue:(36/255.0) alpha:100];
		
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
		NSURL *imageURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png", cell.textLabel.text]];
		UIImage *placeholder = [UIImage imageNamed:@"capture-button.png"];
		[cell.imageView	setImageWithURL:imageURL placeholderImage:placeholder];
		__weak UITableViewCell *weakCell = cell;
		[cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png", cell.textLabel.text]]] placeholderImage:[UIImage imageNamed:@"capture-button.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
			weakCell.imageView.image = image;
			weakCell.imageView.layer.cornerRadius = weakCell.imageView.frame.size.width / 2;
			weakCell.imageView.clipsToBounds = YES;
		} failure:nil];
	} else{
		cell.textLabel.text = self.following[indexPath.row];
		cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2;
		cell.imageView.clipsToBounds = YES;
		[cell addSubview:cell.imageView];
		__weak UITableViewCell *weakCell = cell;
		[cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png", self.following[indexPath.row]]]] placeholderImage:[UIImage imageNamed:@"capture-button.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
			weakCell.imageView.image = image;
			weakCell.imageView.layer.cornerRadius = weakCell.imageView.frame.size.width / 2;
			weakCell.imageView.clipsToBounds = YES;
		} failure:nil];
	}
	
	cell.backgroundColor = [UIColor colorWithRed:(36/255.0) green:(35/255.0) blue:(34/255.0) alpha:1.0];
	cell.textLabel.textColor = [UIColor whiteColor];
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
