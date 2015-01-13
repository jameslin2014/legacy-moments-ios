//
//  MOS3APIUtilities.m
//  Moments
//
//  Created by Douglas Bumby on 2015-01-03.
//  Copyright (c) 2015 Cosmic. All rights reserved.
//

#import "MOS3APIUtilities.h"

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
    [self initManager];
    
    NSURLRequest *request = [self URLRequestForPath:[self pathForUsername:username] withHTTPMethod:@"PUT" data:UIImagePNGRepresentation(image) mimeType:@"image/png" responseSerializer:nil];

    AFHTTPRequestOperation *operation = [self.s3 HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Avatar uploaded");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
    }];
    [self.s3.operationQueue addOperation:operation];
}

- (void)getAvatarForUsername:(NSString *)username completion:(void (^)(UIImage *))completion {
    [self initManager];
    
    NSURLRequest *request = [self URLRequestForPath:[self pathForUsername:username] withHTTPMethod:@"GET" data:nil mimeType:nil responseSerializer:nil];
    AFHTTPRequestOperation *operation = [self.s3 HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Avatar dowloaded");
        
      completion((UIImage *) responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
        
        completion(nil);
    }];
    [self.s3.operationQueue addOperation:operation];
}

- (NSString *)pathForUsername:(NSString *)username {
    return [NSString stringWithFormat:@"avatars/%@.png", username];
}

- (void)initManager {
    self.s3 = [[AFAmazonS3Manager alloc] initWithAccessKeyID:self.accessKey secret:self.secret];
    self.s3.requestSerializer.region = AFAmazonS3USStandardRegion;
    self.s3.requestSerializer.bucket = self.bucket;
    self.s3.responseSerializer = [[AFImageResponseSerializer alloc] init];
}

- (NSURLRequest *)URLRequestForPath:(NSString *)path withHTTPMethod:(NSString *)method data:(NSData *)data mimeType:(NSString *)mimeType responseSerializer:(AFHTTPResponseSerializer *)responseSerializer {
    if (responseSerializer) {
        self.s3.responseSerializer = responseSerializer;
    }
    
    NSURL *url = [self.s3.baseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *originalRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    originalRequest.HTTPMethod = method ? method : @"GET";
    
    if (data) {
        originalRequest.HTTPBody = data;
    }
    
    if (mimeType) {
        [originalRequest setValue:mimeType forHTTPHeaderField:@"Content-Type"];
    }
    
    NSURLRequest *request = [self.s3.requestSerializer
                             requestBySettingAuthorizationHeadersForRequest:originalRequest
                             error:nil];
    
    return request;
}

@end