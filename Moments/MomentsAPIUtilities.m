//
//  MomentsAPIUtilities.m
//  Moments
//
//  Created by Damon Jones on 1/2/15.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MomentsAPIUtilities.h"

@implementation MomentsAPIUtilities

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc
{
    // implement -dealloc & remove abort() when refactoring for
    // non-singleton use.
    abort();
}

/**
 * Sends a request to the API to check if the intended username has already been registered
 */
- (void)isRegisteredUsername:(NSString *)username completion:(void (^)(BOOL))completion {
    NSMutableURLRequest *urlRequest = [self URLRequestForEndpoint:[NSString stringWithFormat:@"/exists/%@", username]
                                                   withHTTPMethod:@"GET"
                                                    andDictionary:nil];
    
    [self addAuthHeaderWithUsername:self.apiUsername password:self.apiPassword request:urlRequest];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completion([[dictionary objectForKey:@"exists"] boolValue]);
        }
    }];
}

/**
 * Sends a request to the API to check if the user can login with this username and password
 */
- (void)verifyUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(NSDictionary *))completion {
    NSMutableURLRequest *urlRequest = [self URLRequestForEndpoint:@"/login/"
                                                   withHTTPMethod:@"POST"
                                                    andDictionary:[NSDictionary dictionaryWithObjectsAndKeys:username, @"name", password, @"password", nil]];

    [self addAuthHeaderWithUsername:self.apiUsername password:self.apiPassword request:urlRequest];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completion(dictionary);
        }
    }];
}

/**
 * Sends a request to the API which returns the data for a given user
 */
- (void)getAllUserDataWithUsername:(NSString *)username completion:(void (^)(NSDictionary *))completion {
    NSMutableURLRequest *urlRequest = [self URLRequestForEndpoint:[NSString stringWithFormat:@"/%@", username]
                                                   withHTTPMethod:@"GET"
                                                    andDictionary:nil];
    
    [self addAuthHeaderWithToken:self.user.token request:urlRequest];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
        }
    }];
}

/**
 * Sends a request to the API which returns an array of usernames which contain the search text
 */
- (void)searchForUsersLikeUsername:(NSString *)searchText completion:(void (^)(NSDictionary *))completion {
    NSMutableURLRequest *urlRequest = [self URLRequestForEndpoint:[NSString stringWithFormat:@"/search/%@", searchText]
                                                   withHTTPMethod:@"GET"
                                                    andDictionary:nil];
    
    [self addAuthHeaderWithUsername:self.apiUsername password:self.apiPassword request:urlRequest];
    
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
    NSMutableURLRequest *urlRequest = [self URLRequestForEndpoint:@"/"
                                                   withHTTPMethod:@"POST"
                                                    andDictionary:[NSDictionary dictionaryWithObjectsAndKeys:name, @"name", email, @"email", password, @"password", nil]];
    
    [self addAuthHeaderWithUsername:self.apiUsername password:self.apiPassword request:urlRequest];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
        }
    }];
}

/**
 * Sends a request to the API to subscribe to a user's video content
 */
- (void)followUser:(NSString *)user completion:(void (^)(NSDictionary *))completion {
    NSMutableURLRequest *urlRequest = [self URLRequestForEndpoint:@"/follow/"
                                                   withHTTPMethod:@"POST"
                                                    andDictionary:[NSDictionary dictionaryWithObjectsAndKeys:user, @"user", nil]];
    
    [self addAuthHeaderWithToken:self.user.token request:urlRequest];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
        }
    }];
}

/**
 * Sends a request to the API to unsubscribe from a user's video content
 */
- (void)unfollowUser:(NSString *)user completion:(void (^)(NSDictionary *))completion {
    NSMutableURLRequest *urlRequest = [self URLRequestForEndpoint:@"/follow/"
                                                   withHTTPMethod:@"DELETE"
                                                    andDictionary:[NSDictionary dictionaryWithObjectsAndKeys:user, @"user", nil]];
    
    [self addAuthHeaderWithToken:self.user.token request:urlRequest];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
        }
    }];
}

/**
 * Encode credentials using base64 encoding (for HTTP Basic Authentication)
 */
- (void)addAuthHeaderWithUsername:(NSString *)username password:(NSString *)password request:(NSMutableURLRequest *)request {
    NSString *credentials = [NSString stringWithFormat:@"%@:%@", username, password];
    NSString *encodedCredentials = [[credentials dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", encodedCredentials];
    
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
}

- (void)addAuthHeaderWithToken:(NSString *)token request:(NSMutableURLRequest *)request {
    NSString *authHeader = [NSString stringWithFormat:@"Token %@", token];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
}

/**
 * Encode a dictionary into a percent-encoded query string name=value&name2=value2, etc.
 */
- (NSData *)encodeDictionary:(NSDictionary *)dictionary {
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
 * Return a URL request for server endpoints (with HTTP method and optional body data)
 */
- (NSMutableURLRequest *)URLRequestForEndpoint:(NSString *)endpoint withHTTPMethod:(NSString *)method andDictionary:(NSDictionary *)dictionary {
    
    // Create a URL from the base URL and the endpoint
    NSString *urlString = [self.apiUrl stringByAppendingString:endpoint];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // Set the HTTP Method (defaults to GET)
    urlRequest.HTTPMethod = method ? method : @"GET";
    
    // If the HTTP Method is POST, set the request body from the dictionary
    if (![method isEqual:@"GET"]) {
        NSData *bodyData = [self encodeDictionary:dictionary];
        [urlRequest setHTTPBody:bodyData];
        [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long) bodyData.length] forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }
    
    return urlRequest;
}

@end