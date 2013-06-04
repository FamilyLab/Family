//
//  MyHttpClient.m
//  Family
//
//  Created by Walter.Chan on 12-12-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyHttpClient.h"
@implementation MyHttpClient
+(MyHttpClient *)sharedInstance
{
    if (!WEBNEED) {
        return nil;
    }
    static MyHttpClient *sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[MyHttpClient alloc] init];
//        sharedClient = [[MyHttpClient alloc] initWithBaseURL:[NSURL URLWithString:HOME_URL]];
    });
    
    return sharedClient;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        }
    
    return self;
}
- (void)commandWithPathAndParams:(NSString *)path
                          params:(NSMutableDictionary*)params
                         addData:(Datablock)addDataBlock
                    onCompletion:(SuccessBlock)completionBlock
                         failure:(void (^)(NSError *error))failure
{
//    path = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)path, nil, nil, kCFStringEncodingUTF8);
    NSMutableURLRequest *apiRequest = [self multipartFormRequestWithMethod:@"POST" path:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        addDataBlock(formData);
        
    }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        failure([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    [operation start];
}
- (void)commandWithPathAndParams:(NSString *)path
                          params:(NSMutableDictionary*)params 
                    onCompletion:(SuccessBlock)completionBlock 
                         failure:(void (^)(NSError *error))failure
{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSMutableURLRequest *apiRequest = [self requestWithMethod:@"GET" path:SPACE_API parameters:params];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        failure([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    [operation start];
}
- (void)commandWithPath:(NSString *)path
           onCompletion:(SuccessBlock)completionBlock 
                failure:(void (^)(NSError *error))failure
{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSMutableURLRequest *apiRequest = [self requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        failure([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    [operation start];
}
@end

@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
    NSString * s=@"!*'();:@&=+$,/?%#[]";
	NSString * encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (__bridge_retained CFStringRef)self,
                                                                                                     NULL,
                                                                                                     (__bridge_retained CFStringRef)s,
                                                                                                     kCFStringEncodingUTF8 );
	return encodedString;
}

@end
