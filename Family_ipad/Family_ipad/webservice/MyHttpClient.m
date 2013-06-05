//
//  MyHttpClient.m
//  Family
//
//  Created by Walter.Chan on 12-12-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyHttpClient.h"
#import "iToast.h"
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
+ (NSString *)apiString:(NSUInteger)type
{
    return $str(@"%@/space.php?do=setup&m_auth=%@",BASE_URL,GET_M_AUTH);
}
//循环遍历dictionary，直到找到@"credit"这个key为止
- (NSString*)travelrsalCycleInDict:(NSDictionary*)dict {
    __block NSString *_resultStr;
    if (!_resultStr) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"key:%@", key);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [self travelrsalCycleInDict:(NSDictionary*)obj];
                *stop = YES;
            } else if ([key isEqualToString:@"credit"] && [obj intValue] != 0) {
                //[SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"金币 +%d", [obj intValue]]];
                _resultStr = [NSString stringWithFormat:@"%d", [obj intValue]];
                //                _hasFindCreditKey = YES;
                NSLog(@"result:%@", _resultStr);
                *stop = YES;
            }
        }];
    }
    NSLog(@"re:%@", emptystr(_resultStr));
    return emptystr(_resultStr);
}
- (void)commandWithPathAndParamsAndNoHUD:(NSString *)path
                          params:(NSMutableDictionary*)params
                         addData:(Datablock)addDataBlock
                    onCompletion:(SuccessBlock)completionBlock
                         failure:(void (^)(NSError *error))failure
{
    
    NSMutableURLRequest *apiRequest = [self multipartFormRequestWithMethod:@"POST" path:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        addDataBlock(formData);
        
    }];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        //NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
//        if ([[responseObject objectForKey:WEB_DATA] isKindOfClass:[NSDictionary class]]) {
//            NSArray *keyArray = [[responseObject objectForKey:WEB_DATA] allKeys];
//            if ([keyArray containsObject:MONEY]) {
//                [[[[iToast makeText:$str(@"奖励%@个金币",[[responseObject objectForKey:WEB_DATA] objectForKey:MONEY])] setGravity:iToastGravityTop] setDuration:iToastDurationNormal ] show];
//            }
//            else if([keyArray containsObject:REWARD]){
//                [[[[iToast makeText:$str(@"奖励%@个金币",[[[responseObject objectForKey:WEB_DATA] objectForKey:REWARD] objectForKey:MONEY])] setGravity:iToastGravityTop] setDuration:iToastDurationNormal ] show];
//            }
//            else if([keyArray containsObject:SELFREWARD]){
//                [[[[iToast makeText:$str(@"奖励%@个金币",[[[responseObject objectForKey:WEB_DATA] objectForKey:SELFREWARD] objectForKey:MONEY])] setGravity:iToastGravityTop] setDuration:iToastDurationNormal ] show];
//            }
//        }
        
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);
        
        failure([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    [operation start];
}
- (void)commandWithPathAndParams:(NSString *)path
                          params:(NSMutableDictionary*)params
                         addData:(Datablock)addDataBlock
                    onCompletion:(SuccessBlock)completionBlock
                         failure:(void (^)(NSError *error))failure
{
    [SVProgressHUD showWithStatus:@"加载中"] ;//maskType:SVProgressHUDMaskTypeGradient];

    NSMutableURLRequest *apiRequest = [self multipartFormRequestWithMethod:@"POST" path:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        addDataBlock(formData);
        
    }];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        //[SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:API_MSG]];
//        if ([[responseObject objectForKey:WEB_DATA] isKindOfClass:[NSDictionary class]]) {
//            NSArray *keyArray = [[responseObject objectForKey:WEB_DATA] allKeys];
//            if ([keyArray containsObject:MONEY]) {
//                [[[[iToast makeText:$str(@"奖励%@个金币",[[responseObject objectForKey:WEB_DATA] objectForKey:MONEY])] setGravity:iToastGravityTop] setDuration:iToastDurationNormal ] show];
//            }
//            else if([keyArray containsObject:REWARD]){
//               [[[[iToast makeText:$str(@"奖励%@个金币",[[[responseObject objectForKey:WEB_DATA] objectForKey:REWARD] objectForKey:MONEY])] setGravity:iToastGravityTop] setDuration:iToastDurationNormal ] show];
//            }
//            else if([keyArray containsObject:SELFREWARD]){
//                [[[[iToast makeText:$str(@"奖励%@个金币",[[[responseObject objectForKey:WEB_DATA] objectForKey:SELFREWARD] objectForKey:MONEY])] setGravity:iToastGravityTop] setDuration:iToastDurationNormal ] show];
//            }
//        }
        
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);

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
- (void)commandWithPathAndNoHUD:(NSString *)path
           onCompletion:(SuccessBlock)completionBlock
                failure:(void (^)(NSError *error))failure
{
    
    NSMutableURLRequest *apiRequest = [self requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error%@",[error description]);
        
        failure([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    [operation start];
}
- (void)commandWithPath:(NSString *)path
           onCompletion:(SuccessBlock)completionBlock 
                failure:(void (^)(NSError *error))failure
{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeGradient];

    NSMutableURLRequest *apiRequest = [self requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:API_MSG]];
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error%@",[error description]);

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
