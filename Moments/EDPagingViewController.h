//
//  EDPagingViewController.h
//  Onboarding
//
//  Created by Evan Dekhayser on 12/24/14.
//  Copyright (c) 2014 Xappox, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOMusicPlayer.h"

@interface EDPagingViewController : UIViewController

- (void)pageControlToggleOnScreen;
    @property (strong, nonatomic) MOMusicPlayer *player;
@end
