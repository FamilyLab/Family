//
//  MultiText.m
//  Family
//
//  Created by Aevitx on 13-2-3.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MultiText.h"

@implementation MultiText

- (id)initWithId:(NSString*)userId
            head:(NSString*)head
         content:(NSString*)content
            time:(NSString*)time
         timeImg:(NSString*)timeImg
        rightImg:(NSString*)rightImg
            name:(NSString*)name
       theNewNum:(NSString*)theNewNum {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.head = head;
        self.content = content;
        self.time = time;
        self.timeImg = timeImg;
        self.rightImg = rightImg;
        self.name = name;
        self.theNewNum = theNewNum;
    }
    return self;
}

@end
