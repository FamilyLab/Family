//
//  MyHttpClient.h
//  Family
//
//  Created by Walter.Chan on 12-12-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "web_config.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#define WEBNEED 1
typedef void(^SuccessBlock)(NSDictionary *dict);
typedef void(^FailureBlock)(NSError *error);
typedef void(^Datablock)(id <AFMultipartFormData> formData);


@interface MyHttpClient : AFHTTPClient
+(MyHttpClient *)sharedInstance;
- (void)commandWithPathAndParams:(NSString *)path
                          params:(NSMutableDictionary*)params 
                    onCompletion:(SuccessBlock)completionBlock failure:(void (^)(NSError *error))failure
;
- (void)commandWithPath:(NSString *)path
           onCompletion:(SuccessBlock)completionBlock 
                failure:(void (^)(NSError *error))failure;
- (void)commandWithPathAndParams:(NSString *)path
                          params:(NSMutableDictionary*)params
                         addData:(Datablock)addDataBlock
                    onCompletion:(SuccessBlock)completionBlock
                         failure:(void (^)(NSError *error))failure;
- (void)commandWithPathAndParamsAndNoHUD:(NSString *)path
                                  params:(NSMutableDictionary*)params
                                 addData:(Datablock)addDataBlock
                            onCompletion:(SuccessBlock)completionBlock
                                 failure:(void (^)(NSError *error))failure;
- (void)commandWithPathAndNoHUD:(NSString *)path
                   onCompletion:(SuccessBlock)completionBlock
                        failure:(void (^)(NSError *error))failure;
+ (NSString *)apiString:(NSUInteger)type;
@end
@interface NSString (NSString_Extended)
- (NSString *)urlencode;
@end
