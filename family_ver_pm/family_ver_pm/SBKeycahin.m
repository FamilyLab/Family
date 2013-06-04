//
//  SBKeycahin.m
//  keychain_test
//
//  Created by pandara on 13-4-7.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "SBKeycahin.h"
#import <Security/Security.h>

@implementation SBKeycahin

+ (void)addPassword:(NSString *)passWord withUerName:(NSString *)userName
{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];//确定所属class
    [dataDict setObject:userName forKey:(id)kSecAttrAccount];//确定其他属性attributes
    [dataDict setObject:[passWord dataUsingEncoding:NSUTF8StringEncoding] forKey:kSecValueData];//添加密码 object是nsdata
    OSStatus s = SecItemAdd((CFDictionaryRef)dataDict, NULL);
    NSLog(@"add : %ld", s);
}

+ (BOOL)searchItemForUserName:(NSString *)userName
{
    BOOL getIt = NO;
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               kSecClassGenericPassword, kSecClass,
                               userName, kSecAttrAccount,
                               kCFBooleanTrue, kSecReturnAttributes, nil];
    CFTypeRef result = nil;
    OSStatus s = SecItemCopyMatching((CFDictionaryRef)queryDict, &result);
    NSLog(@"search item for username : %ld", s);
    if (s == noErr) {
        getIt = YES;
    }
    
    return getIt;
}

//某些原因找不到密码将导致崩溃
+ (NSString *)getPassWordForName:(NSString *)userName
{
    NSString *passwd = nil;
    //查找条件 1.class 2.attributes 3.search option
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               kSecClassGenericPassword, kSecClass,
                               userName, kSecAttrAccount,
                               kCFBooleanTrue, kSecReturnAttributes, nil];
    CFTypeRef result = nil;
    //先找到一个item
    OSStatus s = SecItemCopyMatching((CFDictionaryRef)queryDict, &result);
//    NSLog(@"select name : %ld", s); //errSecItemNotFound 就是找不到
    
    if (s == noErr) {
        //继续查找item的secValue
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:result];
        //存储格式
        [dic setObject:(id)kCFBooleanTrue forKey:kSecReturnData];
        //确定class
        [dic setObject:[queryDict objectForKey:kSecClass] forKey:kSecClass];
        NSData *data = nil;
        //查找secValue
        if (SecItemCopyMatching((CFDictionaryRef)dic, (CFTypeRef *)&data) == noErr) {
            passwd = [NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//            NSLog(@"get password%@", passwd);
//            NSLog(@"get result%@", result);
        }
    }
    return passwd;
}

+ (void)deletePassWordForUserName:(NSString *)userName
{
    //删除的条件
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           kSecClassGenericPassword, kSecClass,
                           userName, kSecAttrAccount, nil];
    //SecItemDelete
    OSStatus status = SecItemDelete((CFDictionaryRef)query);
    NSLog(@"delete:%ld", status);//errSecItemNotFound 就是没有
}

+ (void)updatePassWord:(NSString *)passWord ForUserName:(NSString *)userName
{
    //先查找是否存在
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               kSecClassGenericPassword, kSecClass,
                               userName, kSecAttrAccount,
                               kCFBooleanTrue, kSecReturnAttributes, nil];
    CFTypeRef result = nil;
    
    if (SecItemCopyMatching((CFDictionaryRef) queryDict, &result) == noErr) {
        //更新后的数据，基础是搜到的result
        NSMutableDictionary *updateDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)result];
        
        //修改要更新的项 注意先加后删的class项
        [updateDict setObject:[queryDict objectForKey:kSecClass] forKey:kSecClass];
        [updateDict setObject:[passWord dataUsingEncoding:NSUTF8StringEncoding] forKey:kSecValueData];
        [updateDict removeObjectForKey:kSecClass];
        
        //删除模拟器的默认组“test”，否则出错
        [updateDict removeObjectForKey:(id)kSecAttrAccessGroup];
        
        //得到要修改的item，根据result，但要添加class
        NSMutableDictionary *updateItem = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)result];
        [updateItem setObject:[queryDict objectForKey:(id)kSecClass] forKey:(id)kSecClass];
        
        //SecItemUpdate
        OSStatus status = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)updateDict);
        NSLog(@"update:%ld", status);
    }
}


@end
