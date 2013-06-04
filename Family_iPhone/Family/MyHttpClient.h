//
//  MyHttpClient.h
//  Family
//
//  Created by Walter.Chan on 12-12-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "web_config.h"
#import "DictionaryKeyNames.h"
#import "AFNetworking.h"
#define WEBNEED 1

typedef void(^SuccessBlock)(NSDictionary *dict);
typedef void(^FailureBlock)(NSError *error);
typedef void(^Datablock)(id <AFMultipartFormData> formData);


@interface MyHttpClient : AFHTTPClient {
     
}

@property (nonatomic, assign) BOOL hasFindCreditKey;
@property (nonatomic, retain) NSString *resultStr;

+(MyHttpClient *)sharedInstance;


- (void)commandWithPathAndParams:(NSString *)path
                          params:(NSMutableDictionary*)params 
                    onCompletion:(SuccessBlock)completionBlock failure:(void (^)(NSError *error))failure;


- (void)commandWithPath:(NSString *)path
           onCompletion:(SuccessBlock)completionBlock 
                failure:(void (^)(NSError *error))failure;


- (void)commandWithPathAndParams:(NSString *)path
                          params:(NSMutableDictionary*)params
                         addData:(Datablock)addDataBlock
                    onCompletion:(SuccessBlock)completionBlock
                         failure:(void (^)(NSError *error))failure;
@end



@interface NSString (NSString_Extended)
- (NSString *)urlencode;
@end
