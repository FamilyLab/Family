//
//  MessageCell.m
//  Family
//
//  Created by Aevitx on 13-1-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MessageCell.h"
//#import "UIButton+WebCache.h"
#import "Common.h"

#define kCellGapInMsg     4

@implementation MessageCell
//@synthesize talkDataDict, noticeDataDict;

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

+ (CGFloat)heightForCellWithTextQuizType:(NSString *)text {
    CGFloat heigh = ceilf([text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:CGSizeMake(315.0f - 54.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    return heigh;
}

+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight {
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:CGSizeMake(235.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    return height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.multiTextTypeView.frame = (CGRect){.origin = self.multiTextTypeView.frame.origin, .size.width = self.multiTextTypeView.frame.size.width, .size.height = self.frame.size.height - kCellGapInMsg * 2};
    [self.multiTextTypeView layoutSubviews];
}

- (void)initTalkData:(NSDictionary *)_aDict {
//    self.talkDataDict = _aDict;
    //右下角的未读标志
    [self.multiTextTypeView.theNewsNumView fillWithPointInImgAndLblView:CGPointMake(289, 36) withLeftImgStr:@"dialogue_new_num.png" withRightText:[_aDict objectForKey:@"new"] withFont:[UIFont boldSystemFontOfSize:10.0f] withTextColor:[UIColor whiteColor]];
    CGRect theFrame = self.multiTextTypeView.theNewsNumView.rightlbl.frame;
    theFrame = (CGRect){.origin.x = 9, .origin.y = 9, .size = theFrame.size};
    self.multiTextTypeView.theNewsNumView.rightlbl.frame = theFrame;
    self.multiTextTypeView.theNewsNumView.rightlbl.textAlignment = UITextAlignmentCenter;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//    self.multiTextTypeView.theNewsNumView.rightlbl.textAlignment = UITextAlignmentCenter;
//#else
//    self.multiTextTypeView.theNewsNumView.rightlbl.textAlignment = NSTextAlignmentCenter;
//#endif
    //头像
//    [self.multiTextTypeView.headBtn setImageWithURL:[NSURL URLWithString:[_aDict objectForKey:PM_TO_AVATAR]] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
    [self.multiTextTypeView.headBtn setImageForMyHeadButtonWithUrlStr:[_aDict objectForKey:PM_TO_AVATAR] plcaholderImageStr:nil];
    [self.multiTextTypeView.headBtn setVipStatusWithStr:emptystr(MY_VIP_STATUS) isSmallHead:YES];
    self.multiTextTypeView.userId = [_aDict objectForKey:PM_TO_UID];
    
    //时间
    self.multiTextTypeView.timeLbl.text = [Common dateSinceNow:[_aDict objectForKey:LAST_DATE_LINE]];
    
    //富文本，名字
//    self.multiTextTypeView.contentLbl.extendBottomToFit = YES;//自适应高度
    
    self.multiTextTypeView.contentLbl.numberOfLines = 0;
    self.multiTextTypeView.contentLbl.extendBottomToFit = YES;
    NSString *name = emptystr([_aDict objectForKey:PM_TO_NAME]);
    if (!isEmptyStr([_aDict objectForKey:NOTE])) {
        name = [NSString stringWithFormat:@"%@(%@)", name, [_aDict objectForKey:NOTE]];
    }
    self.multiTextTypeView.nameLbl.text = name;
    [self.multiTextTypeView fillLblWithStr:emptystr([_aDict objectForKey:PM_TO_NAME]) isNickName:YES];
    
    //富文本，内容
    self.multiTextTypeView.contentLbl.numberOfLines = 0;
    NSString *lastTalkStr = [_aDict objectForKey:LAST_SUMMARY];
    
    if (![[_aDict objectForKey:ADDRESS] isEqual:[NSNull null]] && ![[_aDict objectForKey:ADDRESS] isEqualToString:@""]) {
        lastTalkStr = [NSString stringWithFormat:@"%@  在%@", lastTalkStr, $str(@"%@", [_aDict objectForKey:ADDRESS])];
        self.multiTextTypeView.contentLbl.text = lastTalkStr;
        [self.multiTextTypeView fillLblWithStr:$str(@"在%@", [_aDict objectForKey:ADDRESS]) isNickName:NO];
    } else
        self.multiTextTypeView.contentLbl.text = lastTalkStr;
    self.multiTextTypeView.contentStr = lastTalkStr;
}

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
    NoticeType type = [MessageCell whichNoticeType:[aDict objectForKey:@"type"]];
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
        describeStr = [NSString stringWithFormat:@"%@ %@", emptystr([aDict objectForKey:NOTICE_AUTHOR_NAME]), typeStr];
    } else
        describeStr = [NSString stringWithFormat:@"%@ %@《%@》", emptystr([aDict objectForKey:NOTICE_AUTHOR_NAME]), typeStr, emptystr([aDict objectForKey:F_TITLE])];
    return describeStr;
}

- (void)initNoticeData:(NSDictionary *)_aDict {
//    self.noticeDataDict = _aDict;
    self.noticeType = [MessageCell whichNoticeType:[_aDict objectForKey:TYPE]];
    
    //右下角的未读标志
    self.multiTextTypeView.imgView.hidden = ![[_aDict objectForKey:@"new"] boolValue];
    
    //头像
//    [self.multiTextTypeView.headBtn setImageWithURL:[NSURL URLWithString:[_aDict objectForKey:NOTICE_AUTHOR_AVATAR]] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
    [self.multiTextTypeView.headBtn setImageForMyHeadButtonWithUrlStr:[_aDict objectForKey:NOTICE_AUTHOR_AVATAR] plcaholderImageStr:nil];
    [self.multiTextTypeView.headBtn setVipStatusWithStr:emptystr([_aDict objectForKey:VIP_STATUS]) isSmallHead:YES];
    self.multiTextTypeView.userId = [_aDict objectForKey:NOTICE_AUTHOR_ID];
    
    //时间
    self.multiTextTypeView.timeLbl.text = [Common dateSinceNow:[_aDict objectForKey:DATELINE]];
    
    //富文本，名字
    self.multiTextTypeView.contentLbl.numberOfLines = 0;
    self.multiTextTypeView.contentLbl.extendBottomToFit = YES;
    NSString *name = emptystr([_aDict objectForKey:NOTICE_AUTHOR_NAME]);
//    NSString *note = [Common clearTheHtmlInString:emptystr([_aDict objectForKey:NOTE])];
    
//    NSString *title = [NSString stringWithFormat:@"《%@》", emptystr([_aDict objectForKey:F_TITLE])];
//    self.multiTextTypeView.contentLbl.text = [MessageCell buildAMsg:_aDict];
//    self.multiTextTypeView.contentStr = [MessageCell buildAMsg:_aDict];
    
    NSDictionary *noteDict = [_aDict objectForKey:NOTE_SPLIT];
    NSString *actionStr = [emptystr([noteDict objectForKey:ACTION_STR]) stringByReplacingOccurrencesOfString:@"，" withString:@""];
    NSString *allNoteText = [NSString stringWithFormat:@"%@ %@ %@", name, actionStr, emptystr([[noteDict objectForKey:OBJ] objectForKey:SUBJECT])];
    
    NSMutableArray *withFriendsArray = [noteDict objectForKey:WITH_FRIENDS];
    if ([withFriendsArray count] > 0) {
        NSString *friendsNameStr = @"";
        for (int i = 0; i < [withFriendsArray count]; i++) {
            friendsNameStr = $str(@"%@ %@ ", friendsNameStr, [[withFriendsArray objectAtIndex:i] objectForKey:NAME]);
        }
        allNoteText = $str(@"%@, 和 %@在一起", allNoteText, friendsNameStr);
        if ([emptystr([[withFriendsArray objectAtIndex:0] objectForKey:AC]) isEqualToString:FRIEND]) {//申请成为家人的
            allNoteText = [allNoteText stringByReplacingOccurrencesOfString:@"和 " withString:@""];
            allNoteText = [allNoteText stringByReplacingOccurrencesOfString:@"在一起" withString:@""];
        }
    }
    
    self.multiTextTypeView.contentLbl.text = allNoteText;
    self.multiTextTypeView.contentStr = allNoteText;
    
    [self.multiTextTypeView fillMultiTypeWithStr:name withColor:[Common theLblColor] withSize:14.0f isBold:YES];
    [self.multiTextTypeView fillMultiTypeWithStr:emptystr([[noteDict objectForKey:OBJ] objectForKey:SUBJECT]) withColor:color(229, 113, 116, 1) withSize:14.0f isBold:YES];
    if ([withFriendsArray count] > 0) {
        for (int i = 0; i < [withFriendsArray count]; i++) {
            NSString *nameStr = [[withFriendsArray objectAtIndex:i] objectForKey:NAME];
//            NSRange theRange = [nameStr rangeOfString:@"通过申请"];
            UIColor *theColor = [emptystr([[withFriendsArray objectAtIndex:i] objectForKey:AC]) isEqualToString:FRIEND] ? color(229, 113, 116, 1) : [Common theLblColor];
            [self.multiTextTypeView fillMultiTypeWithStr:nameStr withColor:theColor withSize:14.0f isBold:YES];
        }
    }
}

@end
