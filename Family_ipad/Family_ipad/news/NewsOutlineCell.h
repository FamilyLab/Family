//
//  NewsOutlineCell.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-11.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCell.h"
#import "MultiTextTypeView.h"
typedef enum {
    unknownType         = -1,//未知
    addPhotoType        = 0,//添加照片
    addBlogType         = 1,//添加日志
    addVideoType        = 2,//添加视频
    addEventType        = 3,//添加活动
    blogCommentType     = 4,//日志评论
    videoCommentType    = 5,//视频评论
    photoCommentType    = 6,//照片评论
    eventCommentType    = 7,//活动评论
    addFriendType       = 8//成为家人
} NoticeType;
@interface NewsOutlineCell : MessageCell

@property (nonatomic,strong)IBOutlet UIImageView *targetImage;
@property (nonatomic, assign) NoticeType noticeType;
- (void)initNoticeData:(NSDictionary *)_aDict;

@end
