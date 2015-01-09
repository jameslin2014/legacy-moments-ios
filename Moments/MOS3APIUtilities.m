//
//  MOS3APIUtilities.m
//  Moments
//
//  Created by Douglas Bumby on 2015-01-03.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOS3APIUtilities.h"
#import "AFAmazonS3Manager.h"

@implementation MOS3APIUtilities

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

- (void)putAvatarForUsername:(NSString *)username image:(UIImage *)image {
    NSURLRequest *request = [self URLRequestForPath:[self pathForUsername:username] withHTTPMethod:@"PUT" data:UIImagePNGRepresentation(image) responseSerializer:nil];
    
    NSLog(@"%@", request.HTTPMethod);
    
    AFAmazonS3Manager *s3 = [self getManager];
    AFHTTPRequestOperation *operation = [s3 HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Avatar uploaded");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
    }];
    [s3.operationQueue addOperation:operation];
}

- (NSURLRequest *)avatarRequestForUsername:(NSString *)username {
    return [self URLRequestForPath:[self pathForUsername:username] withHTTPMethod:@"GET" data:nil responseSerializer:[[AFImageResponseSerializer alloc] init]];
}

- (NSString *)pathForUsername:(NSString *)username {
    return [NSString stringWithFormat:@"avatars/%@.png", username];
}

- (AFAmazonS3Manager *)getManager {
    AFAmazonS3Manager *s3 = [[AFAmazonS3Manager alloc]
                             initWithAccessKeyID:self.accessKey
                             secret:self.secret];
    s3.requestSerializer.region = AFAmazonS3USStandardRegion;
    s3.requestSerializer.bucket = self.bucket;
    
    return s3;
}

- (NSURLRequest *)URLRequestForPath:(NSString *)path withHTTPMethod:(NSString *)method data:(NSData *)data responseSerializer:(AFHTTPResponseSerializer *)responseSerializer {
    AFAmazonS3Manager *s3 = [self getManager];
    
    if (responseSerializer) {
        s3.responseSerializer = responseSerializer;
    }
    
    NSURL *url = [s3.baseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *originalRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    originalRequest.HTTPMethod = method ? method : @"GET";
    
    if (data) {
        originalRequest.HTTPBody = data;
    }
    
    NSURLRequest *request = [s3.requestSerializer
                             requestBySettingAuthorizationHeadersForRequest:originalRequest
                             error:nil];

    return request;
}

@end