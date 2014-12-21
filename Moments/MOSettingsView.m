//
//  MOSettingsView.m
//  Moments
//
//  Created by Evan Dekhayser on 12/20/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOSettingsView.h"
#import "EDSegmentedControl.h"

static NSString *CellIdentifier = @"CellID";

@interface MOSettingsView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *phoneNumberField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UIVisualEffectView *backgroundBlurView;
@property (strong, nonatomic) UIVisualEffectView *vibrancyView;
@property (strong, nonatomic) EDSegmentedControl *control;
@property (strong, nonatomic) UIButton *doneButton;
@property (strong, nonatomic) UIImageView *profilePicture;

@end

@implementation MOSettingsView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.phoneNumberField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    
}

- (instancetype) init{
	if (self = [super init]){
		
		self.backgroundColor = [UIColor clearColor];
		
		self.backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
		[self.backgroundBlurView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self addSubview:self.backgroundBlurView];
		[self addConstraints:@[
									[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
									[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
									[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
									[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
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
		[self.doneButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
		[self.vibrancyView addSubview:self.doneButton];
		[self.vibrancyView addConstraints:@[
											[NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:-10],
											[NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.control attribute:NSLayoutAttributeCenterY multiplier:1.0 constant: 0]
											]];
		
//		self.profilePicture = [[UIImageView alloc]init];
		
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
	return self;
}

- (void)controlStateChanged{
	//Change image at the top?
	[self.tableView reloadData];
}

- (void)dismissView{
	[UIView animateWithDuration:0.25 animations:^{
		self.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

#pragma mark - UITableView Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	if (self.control.stateBeforeTouches == StateLeftSelected){
		return 3;
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		return 2;
	}
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (self.control.stateBeforeTouches == StateLeftSelected){
		if (section == 0) return 1;
		if (section == 1) return 3;
		if (section == 2) return 1;
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		if (section == 0) return 5;
		if (section == 1) return 1;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (self.control.stateBeforeTouches == StateLeftSelected){
		if (section == 0) return 30;
		if (section == 1) return 30;
		if (section == 2) return 30;
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		if (section == 0) return 0;
		if (section == 1) return 30;
	}
	return 0;
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
	if (self.control.stateBeforeTouches == StateLeftSelected){
		if (indexPath.section == 0){
			//Change Image
			cell.textLabel.text = @"Change Profile Image";
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
		} else if (indexPath.section == 1 && indexPath.row == 0){
			cell.textLabel.text = @"Phone Number";
			cell.imageView.image = [[UIImage imageNamed:@"phone"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			self.phoneNumberField = [[UITextField alloc] init];
			self.phoneNumberField.translatesAutoresizingMaskIntoConstraints = NO;
			self.phoneNumberField.adjustsFontSizeToFitWidth = YES;
			self.phoneNumberField.textColor = [UIColor whiteColor];
			self.phoneNumberField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"987-654-3210" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:14]}];
			self.phoneNumberField.tintColor = [UIColor whiteColor];
			self.phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
			self.phoneNumberField.returnKeyType = UIReturnKeyGo;
			self.phoneNumberField.backgroundColor = [UIColor clearColor];
			self.phoneNumberField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
			self.phoneNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
			self.phoneNumberField.textAlignment = NSTextAlignmentRight;
			self.phoneNumberField.tag = 0;
			self.phoneNumberField.delegate = self;
			[self.phoneNumberField setEnabled: YES];
			[cell addSubview:self.phoneNumberField];
			
			[cell addConstraints:@[
								   [NSLayoutConstraint constraintWithItem:self.phoneNumberField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:self.phoneNumberField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0]
								   ]];
			
		} else if (indexPath.section == 1 && indexPath.row == 1){
			cell.textLabel.text = @"Password";
			cell.imageView.image = [[UIImage imageNamed:@"lock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			self.passwordField = [[UITextField alloc] init];
			self.passwordField.translatesAutoresizingMaskIntoConstraints = NO;
			self.passwordField.adjustsFontSizeToFitWidth = YES;
			self.passwordField.secureTextEntry = YES;
			self.passwordField.textColor = [UIColor whiteColor];
			self.passwordField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:14]}];
			self.passwordField.tintColor = [UIColor whiteColor];
			self.passwordField.keyboardType = UIKeyboardTypeAlphabet;
			self.passwordField.returnKeyType = UIReturnKeyGo;
			self.passwordField.backgroundColor = [UIColor clearColor];
			self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
			self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
			self.passwordField.textAlignment = NSTextAlignmentRight;
			self.passwordField.tag = 0;
			self.passwordField.delegate = self;
			[self.passwordField setEnabled: YES];
			[cell addSubview:self.passwordField];
			
			[cell addConstraints:@[
								   [NSLayoutConstraint constraintWithItem:self.passwordField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:self.passwordField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0]
								   ]];
			
		} else if (indexPath.section == 1 && indexPath.row == 2){
			cell.textLabel.text = @"Username";
			cell.imageView.image = [[UIImage imageNamed:@"user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			self.usernameField = [[UITextField alloc] init];
			self.usernameField.translatesAutoresizingMaskIntoConstraints = NO;
			self.usernameField.adjustsFontSizeToFitWidth = YES;
			self.usernameField.textColor = [UIColor whiteColor];
			self.usernameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Username" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:14]}];
			self.usernameField.tintColor = [UIColor whiteColor];
			self.usernameField.keyboardType = UIKeyboardTypeAlphabet;
			self.usernameField.returnKeyType = UIReturnKeyGo;
			self.usernameField.backgroundColor = [UIColor clearColor];
			self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
			self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
			self.usernameField.textAlignment = NSTextAlignmentRight;
			self.usernameField.tag = 0;
			self.usernameField.delegate = self;
			[self.usernameField setEnabled: YES];
			[cell addSubview:self.usernameField];
			
			[cell addConstraints:@[
								   [NSLayoutConstraint constraintWithItem:self.usernameField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
								   [NSLayoutConstraint constraintWithItem:self.usernameField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0]
								   ]];
		}else if (indexPath.section == 2){
			cell.textLabel.text = @"Sign Out";
			cell.imageView.image = [[UIImage imageNamed:@"exit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			cell.contentView.backgroundColor = [UIColor clearColor];
			cell.backgroundColor = [UIColor colorWithRed:0.890 green:0.313 blue:0.313 alpha:0.75];
			cell.textLabel.backgroundColor = [UIColor clearColor];
		}
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		if (indexPath.section == 0){
			if (indexPath.row == 0){
				cell.textLabel.text = @"Send Feedback";
				cell.imageView.image = [[UIImage imageNamed:@"mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			} else if (indexPath.row == 1){
				cell.textLabel.text = @"Review on App Store";
				cell.imageView.image = [[UIImage imageNamed:@"heart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			} else if (indexPath.row == 2){
				cell.textLabel.text = @"Follow @pickmoments";
				cell.imageView.image = [[UIImage imageNamed:@"twitter"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			} else if (indexPath.row == 3){
				cell.textLabel.text = @"Like PickMoments";
				cell.imageView.image = [[UIImage imageNamed:@"facebook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			} else if (indexPath.row == 4){
				cell.textLabel.text = @"Share with Friends";
				cell.imageView.image = [[UIImage imageNamed:@"upload"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
		} else if (indexPath.section == 1){
			if (indexPath.row == 0){
				cell.textLabel.text = @"Privacy Policy";
				cell.imageView.image = [[UIImage imageNamed:@"legal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
		}
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.phoneNumberField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (self.control.stateBeforeTouches == StateLeftSelected){
		if (indexPath.section == 0){
			//TODO: change image!
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
				//TODO: log out!
			}]];
			UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
			
			while (topController.presentedViewController) {
				topController = topController.presentedViewController;
			}
			[topController presentViewController:alertController animated:YES completion:nil];
		}
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		if (indexPath.section == 0){
			//TODO
		} else if (indexPath.section == 1){
			//TODO
		}
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (self.control.stateBeforeTouches == StateLeftSelected){
		if (section == 0) return @"Profile";
		else if (section == 1) return @"Account";
		else if (section == 2) return @"Leaving";
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		if (section == 0) return @"";
		else if (section == 1) return @"Legal";
	}
	return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (self.control.stateBeforeTouches == StateLeftSelected){
		UILabel *headerLabel = [[UILabel alloc] init];
		headerLabel.textColor = [UIColor lightGrayColor];
		headerLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12];
		headerLabel.text = [NSString stringWithFormat:@"    %@",
							[self tableView:tableView titleForHeaderInSection:section]];
		return headerLabel;
	} else if (self.control.stateBeforeTouches == StateRightSelected){
		if (section == 0){
			return nil;
		}
		UILabel *headerLabel = [[UILabel alloc]init];
		headerLabel.textColor = [UIColor lightGrayColor];
		headerLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12];
		headerLabel.text = [NSString stringWithFormat:@"    %@",
							[self tableView:tableView titleForHeaderInSection:section]];
		return headerLabel;
	}
	return nil;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
	//Save changes
}

- (void)dealloc{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
