//
//  NSDictionary+BlocksKit.m
//  BlocksKit
//

#import "NSDictionary+BlocksKit.h"

@implementation NSDictionary (BlocksKit)

- (void)each:(BKKeyValueBlock)block {
	NSParameterAssert(block != nil);
	
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		block(key, obj);
	}];
}

- (void)apply:(BKKeyValueBlock)block {
	NSParameterAssert(block != nil);
	
	[self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
		block(key, obj);
	}];
}

- (NSDictionary *)select:(BKKeyValueValidationBlock)block {
	NSParameterAssert(block != nil);
	
	NSMutableDictionary *list = [NSMutableDictionary dictionaryWithCapacity:self.count];
	
	[self each:^(id key, id obj) {
		if (block(key, obj))
			[list setObject:obj forKey:key];
	}];
	
	return list;
}

- (NSDictionary *)reject:(BKKeyValueValidationBlock)block {
	return [self select:^BOOL(id key, id obj) {
		return !block(key, obj);
	}];
}

- (NSDictionary *)map:(BKKeyValueTransformBlock)block {
	NSParameterAssert(block != nil);
	
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];

	[self each:^(id key, id obj) {
		id value = block(key, obj);
		if (!value)
			value = [NSNull null];
		
		[result setObject:value forKey:key];
	}];
	
	return result;
}

//循环遍历dictionary，直到找到所需key为止  By Aevit
//- (NSString*)travelrsalCycleForKey:(NSString*)myKeyStr {
//    __block BOOL hasFindTheKey = NO;
//    __block NSString *theValue = [self objectForKey:myKeyStr];
//    if (!hasFindTheKey) {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
////            NSLog(@"key:%@", key);
//            if ([obj isKindOfClass:[NSDictionary class]]) {
//                [(NSDictionary*)obj travelrsalCycleForKey:myKeyStr];
//                *stop = YES;
//            } else if ([obj intValue] != 0) {
//                hasFindTheKey = YES;
//                theValue = (NSString*)obj;
//                *stop = YES;
//            }
//        }];
//        [pool drain];
//    }
////    NSLog(@"theValue:%@", theValue);
//    return theValue;
//}

@end
