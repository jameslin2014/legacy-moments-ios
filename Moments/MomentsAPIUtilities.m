//
//  MomentsAPIUtilities.m
//  Moments
//
//  Created by Colton Anglin on 11/28/14.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MomentsAPIUtilities.h"

@implementation MomentsAPIUtilities {
    BOOL loginStatus;
}

-(NSDictionary*)getAllUserDataWithUsername:(NSString *)username {
    Firebase *UserPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@",username]];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        // Get user data from Firebase
        [UserPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSDictionary *data = snapshot.value;
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"tempuserdatall"];
        } withCancelBlock:^(NSError *error) {
        }];
    });
    
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"tempuserdataall"];
    
    return userData;
}

-(NSString*)getUserPhoneNumberWithUsername:(NSString *)username {
    Firebase *UserPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/phone_number",username]];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [UserPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSString *data = snapshot.value;
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"tempuserdataphonenumber"];
        } withCancelBlock:^(NSError *error) {
        }];
    });
    
    NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"tempuserdataphonenumber"];
    
    
    return number;
    
}

-(NSString*)getUserPasswordWithUsername:(NSString *)username {
    Firebase *UserPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/password",username]];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [UserPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSString *data = snapshot.value;
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"tempuserdatapassword"];
        } withCancelBlock:^(NSError *error) {
        }];
    });
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"tempuserdatapassword"];
    
    return password;
}

-(BOOL)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    Firebase *userPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@",username]];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [userPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if (snapshot.value == nil) {
            } else {
                Firebase *passPath = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://moments-users.firebaseio.com/%@/password",username]];
                [passPath observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    NSString *pass = snapshot.value;
                    if ([pass isEqualToString:password]) {
                        loginStatus = true;
                        [[NSUserDefaults standardUserDefaults] setBool:loginStatus forKey:@"tempuserdataloginstatus"];
                        
                    } else {
                        loginStatus = false;
                        [[NSUserDefaults standardUserDefaults] setBool:loginStatus forKey:@"tempuserdataloginstatus"];
                    }
                } withCancelBlock:^(NSError *error) {
                }];
                
            }
        } withCancelBlock:^(NSError *error) {
        }];

    });
    BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:@"tempuserdataloginstatus"];

    return status;
    
}


@end
