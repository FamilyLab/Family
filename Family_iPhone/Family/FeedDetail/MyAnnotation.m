//
//  MyAnnotation.m
//  Family
//
//  Created by Aevitx on 13-2-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coords {
    if (self = [super init]) {
        _coordinate = coords;
    }
    return self;
}

@end
