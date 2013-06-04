//
//  MultiText.h
//  Family
//
//  Created by Aevitx on 13-2-3.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiText : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *timeImg;//可选（是否有那个 小闹钟 的图片）

@property (nonatomic, copy) NSString *rightImg;//可选（在“动态”列表里有）

@property (nonatomic, copy) NSString *name;//可选（在“对话”列表里有）

@property (nonatomic, copy) NSString *theNewNum;//可选（在“对话”、“通知”有）


- (id)initWithId:(NSString*)userId
            head:(NSString*)head
         content:(NSString*)content
            time:(NSString*)time
         timeImg:(NSString*)timeImg
        rightImg:(NSString*)rightImg
            name:(NSString*)name
       theNewNum:(NSString*)theNewNum;

@end
