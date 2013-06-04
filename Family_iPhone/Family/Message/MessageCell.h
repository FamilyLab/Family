//
//  MessageCell.h
//  Family
//
//  Created by Aevitx on 13-1-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiTextTypeView.h"

//typedef enum {
//    theDialogType       = 0,//对话
//    theNoticeTpe        = 1,//通知
//} MessageType;

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

@interface MessageCell : UITableViewCell

//@property (nonatomic, strong) NSDictionary *talkDataDict;
//@property (nonatomic, strong) NSDictionary *noticeDataDict;

//@property (nonatomic, assign) MessageType messageType;
@property (nonatomic, strong) IBOutlet MultiTextTypeView *multiTextTypeView;
@property (nonatomic, assign) NoticeType noticeType;

+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight;

- (void)initTalkData:(NSDictionary *)_aDict;
- (void)initNoticeData:(NSDictionary *)_aDict;

@end
