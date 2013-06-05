//
//  NewsOutlineCell.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-11.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "NewsOutlineCell.h"
#import "web_config.h"
#import "Common.h"
#import "UIButton+WebCache.h"
#import "CKMacros.h"
@implementation NewsOutlineCell
+ (NoticeType)whichNoticeType:(NSString*)typeStr {
    if ([typeStr isEqualToString:TYPE_ADD_PHOTO]) {
        return addPhotoType;
    } else if ([typeStr isEqualToString:TYPE_ADD_PHOTO]) {
        return addPhotoType;
    } else if ([typeStr isEqualToString:TYPE_ADD_BLOG]) {
        return addBlogType;
    } else if ([typeStr isEqualToString:TYPE_ADD_VIDEO]) {
        return addVideoType;
    } else if ([typeStr isEqualToString:TYPE_ADD_EVENT]) {
        return addEventType;
    } else if ([typeStr isEqualToString:TYPE_BLOG_COMMENT]) {
        return blogCommentType;
    } else if ([typeStr isEqualToString:TYPE_VIDEO_COMMENT]) {
        return videoCommentType;
    } else if ([typeStr isEqualToString:TYPE_PHOTO_COMMENT]) {
        return photoCommentType;
    } else if ([typeStr isEqualToString:TYPE_ADD_FRIEND]) {
        return addFriendType;
    } else return unknownType;
}

+ (NSString*)buildAMsg:(NSDictionary*)aDict {
    NoticeType type = [NewsOutlineCell whichNoticeType:[aDict objectForKey:@"type"]];
    NSString *typeStr = @"”如果这个出现就见鬼了T_T“";
    switch (type) {
        case addPhotoType:
            typeStr = @"发布了新照片";
            break;
        case addBlogType:
            typeStr = @"发布了新日志";
            break;
        case addVideoType:
            typeStr = @"发布了新视频";
            break;
        case addEventType:
            typeStr = @"发布了新活动";
            break;
        case blogCommentType:
            typeStr = @"评论了你的日志";
            break;
        case videoCommentType:
            typeStr = @"评论了你的视频";
            break;
        case photoCommentType:
            typeStr = @"评论了你的照片";
            break;
        case addFriendType:
            typeStr = @"接受了您的家人邀请";//@"成为了家人";
            break;
        default:
            break;
    }
    NSString *describeStr = @"";
    if (type == addFriendType) {
        describeStr = [NSString stringWithFormat:@"%@ %@", $safe([aDict objectForKey:NOTICE_AUTHOR_NAME]), typeStr];
    } else
        describeStr = [NSString stringWithFormat:@"%@ %@《%@》", $safe([aDict objectForKey:NOTICE_AUTHOR_NAME]), typeStr, $safe([aDict objectForKey:F_TITLE])];
    return describeStr;
}
- (void)initNoticeData:(NSDictionary *)_aDict {
    //    self.noticeDataDict = _aDict;
    self.noticeType = [NewsOutlineCell whichNoticeType:[_aDict objectForKey:TYPE]];
    
    //右下角的未读标志
    self.multiTextTypeView.imgView.hidden = ![[_aDict objectForKey:@"new"] boolValue];
    
    //头像
    [self.multiTextTypeView.headBtn setImageForMyHeadButtonWithUrlStr:[_aDict objectForKey:NOTICE_AUTHOR_AVATAR] plcaholderImageStr:nil size:MIDDLE];
    self.multiTextTypeView.headBtn.type = HEAD_BTN;
    [self.multiTextTypeView.headBtn setVipStatusWithStr:[_aDict objectForKey:VIPSTATUS] isSmallHead:YES];
    self.multiTextTypeView.headBtn.identify = [_aDict objectForKey:AUTHOR_ID];
    //时间
    self.multiTextTypeView.timeLbl.text = [Common dateSinceNow:[_aDict objectForKey:DATELINE]];
    
    //富文本，名字
    //富文本，名字
    self.multiTextTypeView.contentLbl.numberOfLines = 0;
    self.multiTextTypeView.contentLbl.extendBottomToFit = YES;
    NSString *name = emptystr([_aDict objectForKey:NOTICE_AUTHOR_NAME]);
    
    NSDictionary *noteDict = [_aDict objectForKey:NOTE_SPLIT];
    NSString *actionStr = [emptystr([noteDict objectForKey:ACTION_STR]) stringByReplacingOccurrencesOfString:@"，" withString:@""];
    NSString *allNoteText = nil;
    if ([[_aDict objectForKey:TYPE] rangeOfString:COMMENT].location == NSNotFound)
        allNoteText = [NSString stringWithFormat:@"%@ %@ %@", name, actionStr, emptystr([[noteDict objectForKey:OBJ] objectForKey:SUBJECT])];
    else
        allNoteText = [NSString stringWithFormat:@"%@ %@ 《%@》", name, actionStr, emptystr([_aDict objectForKey:F_TITLE])];

    
    NSMutableArray *withFriendsArray = [noteDict objectForKey:WITH_FRIENDS];
    if ([withFriendsArray count] > 0) {
        NSString *friendsNameStr = @"";
        for (int i = 0; i < [withFriendsArray count]; i++) {
            friendsNameStr = $str(@"%@ %@ ", friendsNameStr, [[withFriendsArray objectAtIndex:i] objectForKey:NAME]);
        }
        allNoteText = $str(@"%@, 和 %@在一起", allNoteText, friendsNameStr);
        if ([$emptystr([[withFriendsArray objectAtIndex:0] objectForKey:AC]) isEqualToString:FRIEND]) {//申请成为家人的
            allNoteText = [allNoteText stringByReplacingOccurrencesOfString:@"和 " withString:@""];
            allNoteText = [allNoteText stringByReplacingOccurrencesOfString:@"在一起" withString:@""];
        }
    }
    
    self.multiTextTypeView.contentLbl.text = allNoteText;
    self.multiTextTypeView.contentStr = allNoteText;
    [self.multiTextTypeView fillMultiTypeWithStr:name withColor:color(157, 212, 74, 1.0) withSize:17.0f isBold:NO];
    if ([[_aDict objectForKey:TYPE] rangeOfString:COMMENT].location == NSNotFound)

        [self.multiTextTypeView fillMultiTypeWithStr:emptystr([[noteDict objectForKey:OBJ] objectForKey:SUBJECT]) withColor:color(157, 212, 74, 1.0) withSize:17.0f isBold:NO];
    else
        [self.multiTextTypeView fillMultiTypeWithStr:emptystr($str(@"《%@》",[_aDict objectForKey:F_TITLE])) withColor:color(157, 212, 74, 1.0) withSize:17.0f isBold:NO];

    [self.multiTextTypeView.timeView fillWithPointInImgAndLblView:CGPointMake(370,self.frame.size.height-self.multiTextTypeView.timeView.frame.size.height-25
) withLeftImgStr:@"time.png" withRightText:[Common dateSinceNow:[_aDict objectForKey:DATELINE]] withFont:[UIFont systemFontOfSize:FONT_SIZE] withTextColor:[UIColor lightGrayColor]];
    if ([withFriendsArray count] > 0) {
        for (int i = 0; i < [withFriendsArray count]; i++) {
            NSString *nameStr = [[withFriendsArray objectAtIndex:i] objectForKey:NAME];
            //            NSRange theRange = [nameStr rangeOfString:@"通过申请"];
            UIColor *theColor = [$emptystr([[withFriendsArray objectAtIndex:i] objectForKey:AC]) isEqualToString:FRIEND] ? color(229, 113, 116, 1) : [Common theLblColor];
            [self.multiTextTypeView fillMultiTypeWithStr:nameStr withColor:theColor withSize:17.0f isBold:YES];
        }
    }


}
+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight {
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(310.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    return height;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
