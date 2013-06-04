//
//  PlistManager.m
//  Betit
//
//  Created by apple on 12-12-3.
//
//

#import "PlistManager.h"

@implementation PlistManager
//@synthesize plistName;

//static PlistManager *g_instance = nil;
//
//+ (PlistManager *)sharedInstance
//{
//    @synchronized(self) {
//        if ( g_instance == nil ) {
//            g_instance = [[self alloc] init];
//        }
//    }
//    return g_instance;
//}
//
//- (id)init {
//    self = [super init];
//    if (self) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *path = [paths objectAtIndex:0];
//        NSLog(@"path = %@",path);
//        NSString *filename = [path stringByAppendingPathComponent:@"test.plist"];
//        NSFileManager *fm = [NSFileManager defaultManager];
//        [fm createFileAtPath:filename contents:nil attributes:nil];
//    }
//    return self;
//}

////初始化plist
//- (id)initPlistWithName:(NSString*)_plist {
//    self = [super init];
//    self.plistName = _plist;
//    if (self) {
//        //如果plist文件不存在，将工程中已建起的plist文件写入沙盒中
////        if (![self isPlistFileExists]) {
////            NSString *plistPath = [self getPlistPath];
//        
//            //从自己建立的plist文件 复制到沙盒中 ，方法一
////            NSError *error;
////            NSFileManager *fileManager = [NSFileManager defaultManager];
////            NSString *bundle = [[NSBundle mainBundle] pathForResource:self.plistName ofType:@"plist"];
////            [fileManager copyItemAtPath:bundle toPath:plistPath error:&error];
//            
//            //方法二
////            NSString *path = [[NSBundle mainBundle] pathForResource:self.plistName ofType:@"plist"];
////            NSMutableDictionary *activityDics = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
////            NSMutableDictionary *activityDics = [[NSMutableDictionary alloc] init];
////            [activityDics writeToFile:plistPath atomically:YES];
////            [activityDics release], activityDics = nil;
////        }
//    }
//    return self;
//}

//- (void)dealloc {
//    [plistName release];
//    [super dealloc];
//}

//获得plist路径
+ (NSString*)getPlistPath:(NSString*)plistName {
    //沙盒中的文件路径
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
//    NSString *plistPath =[doucumentsDirectiory stringByAppendingPathComponent:@"betFeed.plist"];
    NSString *plistPath = [doucumentsDirectiory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", plistName]];
//    NSString *plistPath =[doucumentsDirectiory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", self.plistName]];       //根据需要更改文件名
//    NSLog(@"plist path:%@", plistPath);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:plistPath]) {
//        NSString *filename = [doucumentsDirectiory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", plistName]];
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
    }
    
    return plistPath;
}

//判断沙盒中名为plistname的文件是否存在
+ (BOOL)isPlistFileExists:(NSString*)plistName {
//    self.plistName = _plist;
//    NSString *plistPath =[self getPlistPath];
    NSString *plistPath =[self getPlistPath:plistName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if( [fileManager fileExistsAtPath:plistPath] == NO ) {
//        NSLog(@"not exists");
        return NO;
    }else{
        return YES;
    }
}

//判断key的值是否存在
+ (BOOL)isValueExistsForKey:(NSString*)key plistName:(NSString*)plistName {
    //    NSString *plistPath =[self getPlistPath];
    NSString *plistPath =[self getPlistPath:plistName];
    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSMutableDictionary *aDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    if ([aDictionary objectForKey:key]) {
        return YES;
    }else{
        return NO;
    }
}

//根据key值删除对应值
+ (void)removeValueWithKey:(NSString *)key plistName:(NSString*)plistName {
    //    NSString *plistPath =[self getPlistPath];
    NSString *plistPath =[self getPlistPath:plistName];
    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSMutableDictionary *aDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    if (![aDictionary objectForKey:key]) {
        return;
    }
    [aDictionary removeObjectForKey:key];
    [aDictionary writeToFile:plistPath atomically:YES]; //删除后重新写入
//    [aDictionary release], aDictionary = nil;
}

//删除plistPath路径对应的文件
+ (void)deletePlist:(NSString*)plistName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSString *plistPath =[self getPlistPath];
    NSString *plistPath =[self getPlistPath:plistName];
    [fileManager removeItemAtPath:plistPath error:nil];
}

//将dictionary写入plist文件，前提：dictionary已经准备好
+ (void)writePlist:(NSMutableDictionary*)dictionary forKey:(NSString *)key plistName:(NSString*)plistName {
    if ([self isValueExistsForKey:key plistName:plistName]) {
        [self replaceDictionary:dictionary withDictionaryKey:key plistName:plistName];
        return;
    }
    
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *plistDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    //如果已存在则读取现有数据
    if ([self isPlistFileExists:plistName] && [self readPlist:plistName]) {
       plistDictionary = [self readPlist:plistName];
//       [self readPlist:&plistDictionary plistName:plistName];
    }
    //增加一个数据
    [plistDictionary setValue:dictionary forKey:key]; //在plistDictionary增加一个key为...的value
    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *plistPath1 = [paths objectAtIndex:0];
//    
//    //得到完整的文件名
//    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"feeddatadictplist.plist"];
    
    NSString *plistPath = [self getPlistPath:plistName];
    
//    NSString *error;
//    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDictionary  format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
//    if(plistData) {
//        [plistData writeToFile:plistPath atomically:YES];
//    } else {
//        NSLog(@"error:%@", error);
//    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:plistDictionary];
    [data writeToFile:plistPath atomically:YES];
    
//    if([plistDictionary writeToFile:plistPath atomically:YES]){
////        NSLog(@"write ok!");
//    }else{
////        NSLog(@"ddd");
//    }
////    [plistDictionary release], plistDictionary = nil;
}

//读取plist文件内容复制给dictionary
+ (NSMutableDictionary*)readPlist:(NSString*)plistName {
    NSString *plistPath = [self getPlistPath:plistName];
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (resultDictionary) {
        NSData *data = [NSData dataWithContentsOfFile:plistPath];
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else
        return nil;
    
//    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    return resultDictionary;
    
//    return [resultDictionary autorelease];
}

////读取plist文件内容复制给dictionary   备用
//+ (void)readPlist:(NSMutableDictionary **)dictionary plistName:(NSString*)plistName {
//    NSString *plistPath = [self getPlistPath:plistName];
//    *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//}

//删除最旧的一条数据并加一条新的数据在前面
+ (void)deleteTheOldestWithDictionary:(NSMutableDictionary*)newestDict andNewestKey:(NSString*)newestKey plistName:(NSString*)plistName {
    if ([self isValueExistsForKey:newestKey plistName:plistName]) {
        [self replaceDictionary:newestDict withDictionaryKey:newestKey plistName:plistName];
        return;
    }
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    dictionary = [self readPlist:plistName];
//    [self readPlist:&dictionary plistName:plistName];
    NSArray *keyArray = [dictionary allKeys];
    //删除最后一条
    [self removeValueWithKey:[keyArray objectAtIndex:([self getTheCount:plistName] - 1)] plistName:plistName];
    [self writePlist:newestDict forKey:newestKey plistName:plistName];
}

//更改一条数据，就是把dictionary内key重写
+ (void)replaceDictionary:(NSMutableDictionary *)newDictionary withDictionaryKey:(NSString *)key plistName:(NSString *)plistName {
    [self removeValueWithKey:key plistName:plistName];
    [self writePlist:newDictionary forKey:key plistName:plistName];
    
}

//有多少条数据
+ (NSInteger)getTheCount:(NSString *)plistName {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    dictionary = [self readPlist:plistName];
//    [self readPlist:&dictionary plistName:plistName];
    int num = [dictionary count];
//    [dictionary release], dictionary = nil;
    return num;
}

@end
