//
//  PlistManager.h
//  Betit
//
//  Created by apple on 12-12-3.
//
//

#import <Foundation/Foundation.h>

@interface PlistManager : NSObject

//@property (nonatomic, copy) NSString *plistName;

//+ (PlistManager *)sharedInstance;

////初始化plist
//- (id)initPlistWithName:(NSString*)_plist;

//获得plist路径
+ (NSString*)getPlistPath:(NSString*)plistName;

//判断沙盒中名为plistname的文件是否存在
+ (BOOL)isPlistFileExists:(NSString*)plistName;

//判断key的值是否存在
+ (BOOL)isValueExistsForKey:(NSString*)key plistName:(NSString*)plistName;

//根据key值删除对应值
+ (void)removeValueWithKey:(NSString *)key plistName:(NSString*)plistName;

//删除plistPath路径对应的文件
+ (void)deletePlist:(NSString*)plistName;

//将dictionary写入plist文件，前提：dictionary已经准备好
+ (void)writePlist:(NSMutableDictionary*)dictionary forKey:(NSString *)key plistName:(NSString*)plistName;

//读取plist文件内容复制给dictionary
+ (NSMutableDictionary*)readPlist:(NSString*)plistName;

////读取plist文件内容复制给dictionary   备用
//+ (void)readPlist:(NSMutableDictionary **)dictionary plistName:(NSString*)plistName;

//删除最旧的一条数据并加一条新的数据在前面
+ (void)deleteTheOldestWithDictionary:(NSMutableDictionary*)newestDict andNewestKey:(NSString*)newestKey plistName:(NSString*)plistName;

//更改一条数据，就是把dictionary内key重写
+ (void)replaceDictionary:(NSMutableDictionary *)newDictionary withDictionaryKey:(NSString *)key plistName:(NSString *)plistName;

//有多少条数据
+ (NSInteger)getTheCount:(NSString *)plistName;

@end
