//
//  MOAPI.m
//  Moments
//
//  Created by Damon Jones on 1/2/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MomentsAPIUtilities.h"

@implementation MomentsAPIUtilities

static const NSString *apiEndpoint = @"http://pickmoments.io/api/users/";
static const NSString *apiUsername = @"moments";
static const NSString *apiPassword = @"qHCLgGKUcKGcEf8avrKRr9JqygeohXJZ";

/**
 * Sends a request to the API to check if the intended username has already been registered
 */
- (void)checkIsTakenUsername:(NSString *)username completion:(void (^)(BOOL))completion {
    NSMutableURLRequest *urlRequest = [MomentsAPIUtilities signedURLRequestForEndpoint:@"/exists/" withHTTPMethod:@"GET" andDictionary:nil];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completion([dictionary objectForKey:@"exists"]);
        }
    }];
}

/**
 * Sends a request to the API to check if the user can login with this username and password
 */
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(BOOL))completion {
    NSMutableURLRequest *urlRequest = [MomentsAPIUtilities signedURLRequestForEndpoint:@"/login/" withHTTPMethod:@"POST" andDictionary:[NSDictionary dictionaryWithObjectsAndKeys:username, @"name", password, @"password", nil]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completion([dictionary objectForKey:@"login"]);
        }
    }];
}

/**
 * Sends a request to the API which returns the data for a given user
 */
- (void)getAllUserDataWithUsername:(NSString *)username completion:(void (^)(NSDictionary *))completion {
    NSMutableURLRequest *urlRequest = [MomentsAPIUtilities signedURLRequestForEndpoint:username withHTTPMethod:@"GET" andDictionary:nil];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
        }
    }];
}

/**
 * Sends a request to the API which returns an array of usernames which contain the search text
 */
- (void)searchForUsersLikeUsername:(NSString *)searchText completion:(void (^)(NSArray *))completion {
    NSMutableURLRequest *urlRequest = [MomentsAPIUtilities signedURLRequestForEndpoint:[NSString stringWithFormat:@"search/%@", searchText] withHTTPMethod:@"GET" andDictionary:nil];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
        }
    }];
}

/**
 * Sends a request to the API to create a new user with the username, e-mail and password provided
 */
- (void)createUserWithUsername:(NSString *)name email:(NSString *)email andPassword:(NSString *)password completion:(void (^)(NSDictionary *))completion {
    NSMutableURLRequest *urlRequest = [MomentsAPIUtilities signedURLRequestForEndpoint:@"" withHTTPMethod:@"POST" andDictionary:[NSDictionary dictionaryWithObjectsAndKeys:name, @"name", email, @"email", password, @"password", nil]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
        }
    }];
}

/**
 * Sends a request to the API to subscribe to a user's video content
 */
- (void)followUser:(NSString *)user withFollower:(NSString *)follower completion:(void (^)(NSDictionary *))completion {
    NSMutableURLRequest *urlRequest = [MomentsAPIUtilities signedURLRequestForEndpoint:@"/follow/" withHTTPMethod:@"POST" andDictionary:[NSDictionary dictionaryWithObjectsAndKeys:user, @"user", follower, @"follower", nil]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
        }
    }];
}

/**
 * Sends a request to the API to unsubscribe from a user's video content
 */
- (void)unfollowUser:(NSString *)user withFollower:(NSString *)follower completion:(void (^)(NSDictionary *))completion {
    NSMutableURLRequest *urlRequest = [MomentsAPIUtilities signedURLRequestForEndpoint:@"/follow/" withHTTPMethod:@"DELETE" andDictionary:[NSDictionary dictionaryWithObjectsAndKeys:user, @"user", follower, @"follower", nil]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
        }
    }];
}

/**
 * Encode user credentials using base64 encoding (for HTTP Basic Authentication)
 */
+ (NSString *)encodedCredentials {
    return [[[NSString stringWithFormat:@"%@:%@", apiUsername, apiPassword] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

/**
 * Encode a dictionary into a percent-encoded query string name=value&name2=value2, etc.
 */
+ (NSData *)encodeDictionary:(NSDictionary *)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

/**
 * Return a signed URL request for server endpoints (with HTTP method and optional body data)
 */
+ (NSMutableURLRequest *)signedURLRequestForEndpoint:(NSString *)endpoint withHTTPMethod:(NSString *)method andDictionary:(NSDictionary *)dictionary {
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[apiEndpoint stringByAppendingString:endpoint]]];
    [urlRequest setValue:[NSString stringWithFormat:@"Basic %@", [MomentsAPIUtilities encodedCredentials]] forHTTPHeaderField:@"Authorization"];
    urlRequest.HTTPMethod = method ? method : @"GET";
    
    if ([method isEqual:@"POST"]) {
        [urlRequest setHTTPBody:[self encodeDictionary:dictionary]];
        [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long) urlRequest.HTTPBody.length] forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }
    
    return urlRequest;
}

@end