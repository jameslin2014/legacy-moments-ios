//
//  MOAPI.m
//  Moments
//
//  Created by Damon Jones on 1/2/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOAPI.h"

@implementation MOAPI

static const NSString *apiEndpoint = @"http://pickmoments.io/api/users/";

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(BOOL))data {
}

- (void)getAllUserDataWithUsername:(NSString *)username completion:(void (^)(NSDictionary *))completion {
    NSURL *url = [[NSURL alloc] initWithString:[apiEndpoint stringByAppendingString:username]];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completion(dictionary);
        }
    }];
}

- (void)searchForUsersLikeUserName:(NSString *)searchText completion:(void (^)(NSArray *))completion {
    NSURL *url = [[NSURL alloc] initWithString:[[apiEndpoint stringByAppendingString:@"search/"] stringByAppendingString:searchText]];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completion(array);
        }
    }];
}

@end