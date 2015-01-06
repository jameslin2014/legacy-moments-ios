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

/**
 * Grabs a user's profile picture from S3 from a username.
 */
//- (void)getUserProfilePictureWithUsername:(NSString *)username completion:(void (^)(UIImage *profilePicture))completion {
//    AFAmazonS3Manager *s3 = [[AFAmazonS3Manager alloc]
//                             initWithAccessKeyID:self.accessKey
//                             secret:self.secret];
//    s3.requestSerializer.region = AFAmazonS3USStandardRegion;
//    s3.requestSerializer.bucket = self.bucket;
//    s3.responseSerializer = [[AFImageResponseSerializer alloc] init];
//    
//    NSString *filename = [NSString stringWithFormat:@"avatars/%@.png", username];
//    NSURL *url = [s3.baseURL URLByAppendingPathComponent:filename];
//    NSMutableURLRequest *originalRequest = [[NSMutableURLRequest alloc] initWithURL:url];
//    NSURLRequest *request = [s3.requestSerializer
//                             requestBySettingAuthorizationHeadersForRequest:originalRequest
//                             error:nil];
//    AFHTTPRequestOperation *operation = [s3 HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        completion((UIImage *)responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error %@", error);
//    }];
//    [s3.operationQueue addOperation:operation];
//}

- (NSURLRequest *)getSignedRequestForFilename:(NSString *)filename {
        AFAmazonS3Manager *s3 = [[AFAmazonS3Manager alloc]
                                 initWithAccessKeyID:self.accessKey
                                 secret:self.secret];
        s3.requestSerializer.region = AFAmazonS3USStandardRegion;
        s3.requestSerializer.bucket = self.bucket;
        s3.responseSerializer = [[AFImageResponseSerializer alloc] init];
    
        NSURL *url = [s3.baseURL URLByAppendingPathComponent:filename];
        NSMutableURLRequest *originalRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        NSURLRequest *request = [s3.requestSerializer
                                 requestBySettingAuthorizationHeadersForRequest:originalRequest
                                 error:nil];

        return request;
}

/*
- (void)getUserProfilePictureWithUsername:(NSString *)username completion:(void (^)(UIImage *))data {
    [[DLImageLoader sharedInstance] loadImageFromUrl:[NSString stringWithFormat:@"https://s3.amazonaws.com/moments-avatars/%@.png",username]
                                           completed:^(NSError *error, UIImage *image) {
                                               
                                               if (nil == error) {
                                                   data(image);
                                                   
                                               } else {
                                                   NSLog(@"Error: %@",error);
                                                   UIImage *errorImage = [UIImage imageNamed:@"captue-button"];
                                                   data(errorImage);
                                               }
                                           }];
}
*/

@end