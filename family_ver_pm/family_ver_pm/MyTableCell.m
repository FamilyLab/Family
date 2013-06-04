//
//  MyTableCell.m
//  family_ver_pm
//
//  Created by pandara on 13-5-5.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "MyTableCell.h"

@implementation MyTableCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCommentList:) name:NOTIFI_REFRESH_COMMENT object:nil];
    }
    return self;
}

- (void)refreshCommentList:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    if ([self.objectID isEqualToString:[userInfo objectForKey:ID]] && [self.idtype isEqualToString:[userInfo objectForKey:IDTYPE]]) {
        [self.commentView reset];
        [self refleshLayout];
        [self.commentView requestCommentListFromObjectID:self.objectID andIDtype:self.idtype atPage:1 withSuccessBlock:^(id sender) {
            [self refleshLayout];
        }];
    }
}

//设置objectID与idtype
- (void)setObjectID:(NSString *)objectID andIdtype:(NSString *)idtype
{
    self.objectID = objectID;
    self.idtype = idtype;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
