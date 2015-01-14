//
//  MOSettingsViewController.m
//  Moments
//
//  Created by Evan Dekhayser on 12/21/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOSettingsViewController.h"

static NSString *CellIdentifier = @"CellID";

@interface MOSettingsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UIVisualEffectView *backgroundBlurView;
@property (strong, nonatomic) UIVisualEffectView *vibrancyView;
@property (strong, nonatomic) EDSegmentedControl *control;
@property (strong, nonatomic) UIButton *doneButton;
@property (strong, nonatomic) UIImageView *profilePicture;
@end

@implementation MOSettingsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad{
	[super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
	self.backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
	[self.backgroundBlurView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:self.backgroundBlurView];
	[self.view addConstraints:@[
						   [NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
						   [NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
						   [NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
						   [NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
						   ]];
	self.vibrancyView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]]];
	[self.vibrancyView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.backgroundBlurView addSubview:self.vibrancyView];
	[self.backgroundBlurView addConstraints:@[
											  [NSLayoutConstraint constraintWithItem:self.vibrancyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundBlurView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
											  [NSLayoutConstraint constraintWithItem:self.vibrancyView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundBlurView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
											  [NSLayoutConstraint constraintWithItem:self.vibrancyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundBlurView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
											  [NSLayoutConstraint constraintWithItem:self.vibrancyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundBlurView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
											  ]];
	
	self.control = [[EDSegmentedControl alloc]init];
	[self.control setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.vibrancyView addSubview:self.control];
	[self.vibrancyView addConstraints:@[
										[NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
										[NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant: [[UIApplication sharedApplication]statusBarFrame].size.height + 10],
										[NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:136],
										[NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]
										]];
	
	self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.doneButton.tintColor = [UIColor whiteColor];
	[self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
	self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.doneButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
	[self.doneButton addTarget:self action:@selector(dismissOptionsAndAbout) forControlEvents:UIControlEventTouchUpInside];
	[self.vibrancyView addSubview:self.doneButton];
	[self.vibrancyView addConstraints:@[
										[NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:-10],
										[NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.control attribute:NSLayoutAttributeCenterY multiplier:1.0 constant: 0]
										]];
	
	self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
	self.tableView.separatorColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.tableFooterView = [[UIView alloc]init];
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.layoutMargins = UIEdgeInsetsZero;
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.vibrancyView addSubview:self.tableView];
	[self.vibrancyView addConstraints:@[
										[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
										[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
										[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.control attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20],
										[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:0]
										]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlStateChanged) name:@"SegmentedControlStateChanged" object:nil];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    
}

- (void)dismissOptionsAndAbout {
    MOUser *user = [MomentsAPIUtilities sharedInstance].user;
    
    if ([self.emailField.text isEqual:user.email]
        &&
        (
         [self.passwordField.text isEqual:user.password]
         ||
         [self.passwordField.text isEqual:@""]
        )
        &&
        [self.usernameField.text isEqual:user.name]
        ) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Do you want to save these changes?" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self save];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)controlStateChanged{
	[self.tableView reloadData];
}

#pragma mark - UITableView Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	if (self.control.stateBeforeTouches == StateLeftSelected){
		return 3;
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		return 4;
	}
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (self.control.stateBeforeTouches == StateLeftSelected){
		if (section == 0) return 1;
		if (section == 1) return 4;
		if (section == 2) return 1;
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		if (section == 0) return 2;
		if (section == 1) return 2;
		if (section == 2) return 1;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if (!cell){
		
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
	}
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.selectedBackgroundView = [[UIView alloc]init];
	cell.selectedBackgroundView.layer.masksToBounds = YES;
	cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
	cell.separatorInset = UIEdgeInsetsZero;
	cell.imageView.image = nil;
	cell.imageView.tintColor = [UIColor whiteColor];
	for (UIView *subview in cell.subviews){
		if ([subview isKindOfClass:[UITextField class]]){
			[subview removeFromSuperview];
		}
	}
	if (self.control.stateBeforeTouches == StateLeftSelected){
        MOUser *user = [MomentsAPIUtilities sharedInstance].user;
        
		if (indexPath.section == 0){
			// Change Image
//            cell.imageView.translatesAutoresizingMaskIntoConstraints = NO;
            cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2.0;
            cell.imageView.clipsToBounds = YES;
            cell.imageView.image = [MomentsAPIUtilities sharedInstance].user.avatar;
            
			cell.textLabel.text = @"Change Profile Image";
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
		} else if (indexPath.section == 1 && indexPath.row == 0){
            
            
			cell.textLabel.text = @" "; // @"Email Address";
			cell.imageView.image = [[UIImage imageNamed:@"mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			self.emailField = [[UITextField alloc] init];
			self.emailField.translatesAutoresizingMaskIntoConstraints = NO;
			self.emailField.adjustsFontSizeToFitWidth = NO;
			self.emailField.textColor = [UIColor whiteColor];
			self.emailField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"E-mail Address" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:14]}];
            self.emailField.text = user.email;
			self.emailField.tintColor = [UIColor whiteColor];
			self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
			self.emailField.returnKeyType = UIReturnKeyGo;
			self.emailField.backgroundColor = [UIColor clearColor];
			self.emailField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
			self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
			self.emailField.textAlignment = NSTextAlignmentLeft;
			self.emailField.tag = 0;
			self.emailField.delegate = self;
			[self.emailField setEnabled: YES];
			[cell addSubview:self.emailField];
			
			[cell addConstraints:@[
								   [NSLayoutConstraint constraintWithItem:self.emailField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:self.emailField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:0],
                                   [NSLayoutConstraint constraintWithItem:self.emailField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0]
								   ]];
			
		} else if (indexPath.section == 1 && indexPath.row == 1){
			cell.textLabel.text = @" "; // @"Password";
			cell.imageView.image = [[UIImage imageNamed:@"lock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			self.passwordField = [[UITextField alloc] init];
			self.passwordField.translatesAutoresizingMaskIntoConstraints = NO;
			self.passwordField.adjustsFontSizeToFitWidth = NO;
			self.passwordField.secureTextEntry = YES;
			self.passwordField.textColor = [UIColor whiteColor];
			self.passwordField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"••••••" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:16]}];
			self.passwordField.tintColor = [UIColor whiteColor];
			self.passwordField.keyboardType = UIKeyboardTypeAlphabet;
			self.passwordField.returnKeyType = UIReturnKeyGo;
			self.passwordField.backgroundColor = [UIColor clearColor];
			self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
			self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
			self.passwordField.textAlignment = NSTextAlignmentLeft;
			self.passwordField.tag = 0;
			self.passwordField.delegate = self;
			[self.passwordField setEnabled: YES];
			[cell addSubview:self.passwordField];
			
			[cell addConstraints:@[
								   [NSLayoutConstraint constraintWithItem:self.passwordField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:self.passwordField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:0],
                                   [NSLayoutConstraint constraintWithItem:self.passwordField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0]
								   ]];
			
		} else if (indexPath.section == 1 && indexPath.row == 2){
			cell.textLabel.text = @" "; // @"Username";
			cell.imageView.image = [[UIImage imageNamed:@"user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			self.usernameField = [[UITextField alloc] init];
			self.usernameField.translatesAutoresizingMaskIntoConstraints = NO;
			self.usernameField.adjustsFontSizeToFitWidth = NO;
			self.usernameField.textColor = [UIColor whiteColor];
			self.usernameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Username" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:14]}];
            self.usernameField.text = user.name;
			self.usernameField.tintColor = [UIColor whiteColor];
			self.usernameField.keyboardType = UIKeyboardTypeAlphabet;
			self.usernameField.returnKeyType = UIReturnKeyGo;
			self.usernameField.backgroundColor = [UIColor clearColor];
			self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
			self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
			self.usernameField.textAlignment = NSTextAlignmentLeft;
			self.usernameField.tag = 0;
			self.usernameField.delegate = self;
			[self.usernameField setEnabled: YES];
			[cell addSubview:self.usernameField];
			
			[cell addConstraints:@[
								   [NSLayoutConstraint constraintWithItem:self.usernameField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:self.usernameField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:0],
                                   [NSLayoutConstraint constraintWithItem:self.usernameField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0]
								   ]];
		} else if (indexPath.section == 2){
			cell.textLabel.text = @"Sign Out";
			cell.imageView.image = [[UIImage imageNamed:@"exit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			cell.contentView.backgroundColor = [UIColor clearColor];
			cell.backgroundColor = [UIColor colorWithRed:0.890 green:0.313 blue:0.313 alpha:0.75];
			cell.textLabel.backgroundColor = [UIColor clearColor];
		}
	}
	else if (self.control.stateBeforeTouches == StateRightSelected){
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		if (indexPath.section == 0){
			if (indexPath.row == 0){
				cell.textLabel.text = @"Send Feedback";
				cell.imageView.image = [[UIImage imageNamed:@"mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			} else if (indexPath.row == 1){
				cell.textLabel.text = @"Review on App Store";
				cell.imageView.image = [[UIImage imageNamed:@"heart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
		} else if (indexPath.section == 1){
			if (indexPath.row == 0){
				cell.textLabel.text = @"Follow @pickmoments";
				cell.imageView.image = [[UIImage imageNamed:@"twitter"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			} else if (indexPath.row == 1){
				cell.textLabel.text = @"Share with Friends";
				cell.imageView.image = [[UIImage imageNamed:@"upload"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
		} else if (indexPath.section == 2){
			if (indexPath.row == 0){
				cell.textLabel.text = @"Privacy Policy";
				cell.imageView.image = [[UIImage imageNamed:@"legal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
		}
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 && indexPath.section == 0 ? 40 : 55;
//    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self.emailField resignFirstResponder];
	[self.passwordField resignFirstResponder];
	[self.usernameField resignFirstResponder];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (self.control.stateBeforeTouches == StateLeftSelected){
		if (indexPath.section == 0){
			[self changeProfilePicture];
		} else if (indexPath.section == 1){
			UITextField *textField;
			UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
			for (UIView *subView in tableViewCell.subviews){
				if (subView.class == [UITextField class]){
					textField = (UITextField*)subView;
				}
			}
			if (textField){
				[textField becomeFirstResponder];
			}
		} else if (indexPath.section == 2){
            
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to sign out?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
			[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
			[alertController addAction:[UIAlertAction actionWithTitle:@"Sign Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [[MomentsAPIUtilities sharedInstance].user logout];
                
                UIViewController *destinationViewController = [[MODecisionViewController alloc] init];
                [[[UIApplication sharedApplication] delegate] window].rootViewController = destinationViewController;
                [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];                
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
		}
        
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		if (indexPath.section == 0){
            if (indexPath.row == 0) {
                [UserVoice presentUserVoiceContactUsFormForParentViewController:self];
            } else if (indexPath.row == 1){
				NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d?mt=8", 953901607];
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
			}
		} else if (indexPath.section == 1){
			if (indexPath.row == 0){
				ACAccountStore *accountStore = [[ACAccountStore alloc] init];
				
				ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
				
				[accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
					if(granted) {
						// Get the list of Twitter accounts.
						NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
						
						// For the sake of brevity, we'll assume there is only one Twitter account present.
						// You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
						if ([accountsArray count] == 1) {
							// Grab the initial Twitter account to tweet from.
							ACAccount *twitterAccount = accountsArray[0];
							
							NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
							[tempDict setValue:@"pickmoments" forKey:@"screen_name"];
							[tempDict setValue:@"true" forKey:@"follow"];
							NSLog(@"*******tempDict %@*******",tempDict);
							
							//requestForServiceType
							dispatch_async(dispatch_get_main_queue(), ^{
								[SVProgressHUD show];
							});

							SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:tempDict];
							[postRequest setAccount:twitterAccount];
							[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
								NSString *output = [NSString stringWithFormat:@"HTTP response status: %li Error %ld", (long)[urlResponse statusCode],(long)error.code];
								NSLog(@"%@error %@", output,error.description);
								dispatch_async(dispatch_get_main_queue(), ^{
									[SVProgressHUD showSuccessWithStatus:@"Now following @PickMoments"];
								});
							}];
						} else if ([accountsArray count] > 1){
							UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
							for (ACAccount *twitterAccount in accountsArray){
								NSString *twitterHandle = twitterAccount.username;
								[alertController addAction:[UIAlertAction actionWithTitle:twitterHandle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
									// Grab the initial Twitter account to tweet from.
									
									NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
									[tempDict setValue:@"pickmoments" forKey:@"screen_name"];
									[tempDict setValue:@"true" forKey:@"follow"];
									NSLog(@"*******tempDict %@*******",tempDict);
									
									//requestForServiceType
									dispatch_async(dispatch_get_main_queue(), ^{
										[SVProgressHUD show];
									});
									
									
									SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:tempDict];
									[postRequest setAccount:twitterAccount];
									[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
										NSString *output = [NSString stringWithFormat:@"HTTP response status: %li Error %ld", (long)[urlResponse statusCode],(long)error.code];
										NSLog(@"%@error %@", output,error.description);
										dispatch_async(dispatch_get_main_queue(), ^{
											[SVProgressHUD showSuccessWithStatus:@"Now following @PickMoments"];
										});
									}];
								}]];
							}
							[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
							[self presentViewController:alertController animated:YES completion:nil];
						}
						
					}
				}];
			} else if (indexPath.row == 1){
				NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d?mt=8", 953901607];
				NSURL *url = [NSURL URLWithString:urlString];
				UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:@[url, @"Share your moments with Moments."] applicationActivities:nil];
				[self presentViewController:activityViewController animated:YES completion:nil];
			}
		} else if (indexPath.section == 2){
            if (indexPath.row == 0) {
				
                NSURL *URL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"]];
                SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
                webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
                webViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:webViewController animated:YES completion:NULL];
            }
        }
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (self.control.stateBeforeTouches == StateLeftSelected){
		if (section == 0) return @"Profile";
		else if (section == 1) return @"Account";
		else if (section == 2) return @"Leaving";
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		if (section == 0) return @"App";
		else if (section == 1) return @"Share";
		else if (section == 2) return @"Legal";
	}
	return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UILabel *headerLabel = [[UILabel alloc] init];
	headerLabel.textColor = [UIColor lightGrayColor];
	headerLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12];
	headerLabel.text = [NSString stringWithFormat:@"    %@",
						[self tableView:tableView titleForHeaderInSection:section]];
	return headerLabel;
}

- (void)changeProfilePicture{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraButton = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = NO;
            picker.delegate = self;
            picker.sourceType = type;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertController addAction:cameraButton];
    }
    
    UIAlertAction *photoLibraryButton = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [alertController addAction:photoLibraryButton];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelButton];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)save {
    MOUser *user = [MomentsAPIUtilities sharedInstance].user;
    [user updateUsername:self.usernameField.text email:self.emailField.text password:self.passwordField.text completion:^(BOOL success) {
        if (!success) {
            NSLog(@"FAILED");
            dispatch_async(dispatch_get_main_queue(), ^{
                [TSMessage showNotificationInViewController:self title:@"Profile Update Failed"
                                        subtitle:nil
                                            type:TSMessageNotificationTypeError];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TSMessage showNotificationInViewController:self title:@"Profile Saved"
                                        subtitle:nil
                                            type:TSMessageNotificationTypeSuccess];
            });
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.emailField || textField == self.usernameField) {
        [[MomentsAPIUtilities sharedInstance] isValidUsername:self.usernameField.text andEmail:self.emailField.text completion:^(NSDictionary *dictionary) {
            NSArray *errors = dictionary[@"errors"];
            NSLog(@"%@", errors);
            if (errors.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [TSMessage showNotificationInViewController:self title:@"Warning" subtitle:[errors componentsJoinedByString:@"\n"] type:TSMessageNotificationTypeWarning];
                });
            }
        }];
    } else if (textField == self.passwordField) {
        if (textField.text.length > 0 && textField.text.length < 6) {
            [TSMessage showNotificationInViewController:self title:@"Password Too Short"                                        subtitle:@"Your password must be at least 6 characters long" type:TSMessageNotificationTypeWarning];
        }
    }
}

- (void)dealloc{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info[UIImagePickerControllerOriginalImage] cropAndScaleToSize:250.0];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        MOUser *user = [MomentsAPIUtilities sharedInstance].user;
        user.avatar = image;
        [[MOS3APIUtilities sharedInstance] putAvatarForUsername:user.name image:user.avatar];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
