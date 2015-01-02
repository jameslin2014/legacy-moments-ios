//
//  MOAPI.m
//  Moments
//
//  Created by Damon Jones on 1/2/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOAPI.h"

@implementation MOAPI

static NSString *apiEndpoint = @"http://pickmoments.io/api/users/";

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

- (void)createUserWithName:(NSString *)name andEmail:(NSString *)email completion:(void (^)(NSDictionary *))completion {
    NSURL *url = [[NSURL alloc] initWithString:apiEndpoint];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    urlRequest.HTTPMethod = @"POST";
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name",
                              email, @"email", nil];
    NSData *postData = [self encodeDictionary:postDict];
    
    [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long) postData.length] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completion(dictionary);
        }
    }];
}

- (NSData *)encodeDictionary:(NSDictionary *)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

@end