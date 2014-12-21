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
@property (strong, nonatomic) UIVisualEffectView *backgroundBlurView;
@property (strong, nonatomic) UIVisualEffectView *vibrancyView;
@property (strong, nonatomic) EDSegmentedControl *control;
@property (strong, nonatomic) UIButton *doneButton;
//@property (strong, nonatomic) UIImageView *profilePicture;

@end

@implementation MOSettingsView

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
											[NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant: [[UIApplication sharedApplication]statusBarFrame].size.height],
											[NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:136],
											[NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]
											]];
		
		self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
		self.doneButton.tintColor = [UIColor whiteColor];
		[self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
		self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
		self.doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
		[self.doneButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
		[self.vibrancyView addSubview:self.doneButton];
		[self.vibrancyView addConstraints:@[
											[NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0],
											[NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.control attribute:NSLayoutAttributeCenterY multiplier:1.0 constant: 0]
											]];
		
//		self.profilePicture = [[UIImageView alloc]initWithImage:<#(UIImage *)#>];
		
		self.tableView = [[UITableView alloc]init];
		[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.tableFooterView = [[UIView alloc]init];
		self.tableView.backgroundColor = [UIColor clearColor];
		self.tableView.layoutMargins = UIEdgeInsetsZero;
		self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.vibrancyView addSubview:self.tableView];
		[self.vibrancyView addConstraints:@[
											[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
											[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0],
											[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.control attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20],
											[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.vibrancyView attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:0]
											]];
	}
	return self;
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
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if (!cell){
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
	}
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.font = [UIFont systemFontOfSize:18];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
//	cell.layoutMargins = UIEdgeInsetsZero;
	cell.separatorInset = UIEdgeInsetsZero;
	if (indexPath.row == 0){
		//Change Image
		cell.textLabel.text = @"Change Profile Image";
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	} else if (indexPath.row == 1){
		cell.textLabel.text = @"Phone Number";
		UITextField *phoneNumberField = [[UITextField alloc] init];
		phoneNumberField.translatesAutoresizingMaskIntoConstraints = NO;
		phoneNumberField.adjustsFontSizeToFitWidth = YES;
		phoneNumberField.textColor = [UIColor whiteColor];
		phoneNumberField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"987-654-3210" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
		phoneNumberField.tintColor = [UIColor whiteColor];
		phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
		phoneNumberField.returnKeyType = UIReturnKeyGo;
		phoneNumberField.backgroundColor = [UIColor clearColor];
		phoneNumberField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
		phoneNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
		phoneNumberField.textAlignment = NSTextAlignmentRight;
		phoneNumberField.tag = 0;
		phoneNumberField.delegate = self;
		[phoneNumberField setEnabled: YES];
		[cell addSubview:phoneNumberField];
		
		[cell addConstraints:@[
							   [NSLayoutConstraint constraintWithItem:phoneNumberField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
							   [NSLayoutConstraint constraintWithItem:phoneNumberField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0]
							   ]];
		
	} else if (indexPath.row == 2){
		cell.textLabel.text = @"Password";
		UITextField *passwordField = [[UITextField alloc] init];
		passwordField.translatesAutoresizingMaskIntoConstraints = NO;
		passwordField.adjustsFontSizeToFitWidth = YES;
		passwordField.secureTextEntry = YES;
		passwordField.textColor = [UIColor whiteColor];
		passwordField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
		passwordField.tintColor = [UIColor whiteColor];
		passwordField.keyboardType = UIKeyboardTypeAlphabet;
		passwordField.returnKeyType = UIReturnKeyGo;
		passwordField.backgroundColor = [UIColor clearColor];
		passwordField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
		passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
		passwordField.textAlignment = NSTextAlignmentRight;
		passwordField.tag = 0;
		passwordField.delegate = self;
		[passwordField setEnabled: YES];
		[cell addSubview:passwordField];
		
		[cell addConstraints:@[
							   [NSLayoutConstraint constraintWithItem:passwordField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
							   [NSLayoutConstraint constraintWithItem:passwordField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0]
							   ]];
		
	} else if (indexPath.row == 3){
		cell.textLabel.text = @"Username";
		UITextField *usernameField = [[UITextField alloc] init];
		usernameField.translatesAutoresizingMaskIntoConstraints = NO;
		usernameField.adjustsFontSizeToFitWidth = YES;
		usernameField.textColor = [UIColor whiteColor];
		usernameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Username" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
		usernameField.tintColor = [UIColor whiteColor];
		usernameField.keyboardType = UIKeyboardTypeAlphabet;
		usernameField.returnKeyType = UIReturnKeyGo;
		usernameField.backgroundColor = [UIColor clearColor];
		usernameField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
		usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
		usernameField.textAlignment = NSTextAlignmentRight;
		usernameField.tag = 0;
		usernameField.delegate = self;
		[usernameField setEnabled: YES];
		[cell addSubview:usernameField];
		
		[cell addConstraints:@[
							   [NSLayoutConstraint constraintWithItem:usernameField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
							   [NSLayoutConstraint constraintWithItem:usernameField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0]
							   ]];
	}else if (indexPath.row == 4){
		cell.textLabel.text = @"Log Out";
		cell.textLabel.textColor = [UIColor redColor];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 0){
		//TODO: change image!
	} else if (indexPath.row == 4){
		NSLog(@"Here");
		UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Are you sure you want to log out?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
		[ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
		[ac addAction:[UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
			//TODO: log out!
		}]];
		UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
		
		while (topController.presentedViewController) {
			topController = topController.presentedViewController;
		}
		[topController presentViewController:ac animated:YES completion:nil];
	}
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
	//Save changes
}

@end
