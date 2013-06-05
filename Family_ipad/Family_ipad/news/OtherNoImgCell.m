//
//  OtherNoImgCell.m
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "OtherNoImgCell.h"
#import "Common.h"
#import "UIButton+WebCache.h"
@implementation OtherNoImgCell
@synthesize multiTextTypeView;
//@synthesize indexRow, dataDict;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    //self.multiTextTypeView.timeView.frame = (CGRect){.origin.x = self.multiTextTypeView.contentLbl.frame.origin.x, .origin.y = self.multiTextTypeView.contentLbl.frame.origin.y + self.multiTextTypeView.contentLbl.frame.size.height + 2, .size = self.multiTextTypeView.timeView.frame.size};
}
- (void)fillMultiType:(NSDictionary *)feedDict
              allText:(NSString *)allText
           subjectStr:(NSString *)subjectStr{

    //            NSString *allText = @"";
    //            NSString *subjectStr = @"";
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    NSMutableArray *otherArray = [[NSMutableArray alloc] init];
    if ([[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0) {//评论的行为动态
        if ([feedDict objectForKey:COMMENT]) {
            subjectStr = [emptystr([feedDict objectForKey:SUBJECT]) isEqualToString:@""] ? @"无标题" : [feedDict objectForKey:SUBJECT];
            NSDictionary *commentDict = [[feedDict objectForKey:COMMENT] objectAtIndex:0];
            NSString *otherStr = [[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:@"event"].length > 0 ? @"参与了" : @"评论了";//活动的要改为“参与了”
            //                    allText = [NSString stringWithFormat:@"%@ %@ %@%@ %@", emptystr([commentDict objectForKey:COMMENT_AUTHOR_NAME]), otherStr, emptystr([feedDict objectForKey:NAME]), emptystr([feedDict objectForKey:TITLE]), subjectStr];
            if (!isEmptyStr([commentDict objectForKey:COMMENT_AUTHOR_NAME])) {
                [namesArray addObject:[commentDict objectForKey:COMMENT_AUTHOR_NAME]];
            }
            if (!isEmptyStr([feedDict objectForKey:NAME])) {
                [namesArray addObject:[feedDict objectForKey:NAME]];
            }
            [otherArray addObject:otherStr];
            if (!isEmptyStr([feedDict objectForKey:TITLE])) {
                [otherArray addObject:[feedDict objectForKey:TITLE]];
            }
        }else{
            if (!isEmptyStr([feedDict objectForKey:NAME])) {
                [namesArray addObject:[feedDict objectForKey:NAME]];
            }
        }
    } else if ([[feedDict objectForKey:FEED_ID_TYPE] isEqualToString:FRIEND]) {//AA和BB成为了一家人
        //                allText = [NSString stringWithFormat:@"%@ 和 %@ 成为了一家人", [feedDict objectForKey:NAME], [feedDict objectForKey:F_NAME]];
        if (!isEmptyStr([feedDict objectForKey:NAME])) {
            [namesArray addObject:[feedDict objectForKey:NAME]];
        }
        if (!isEmptyStr([feedDict objectForKey:F_NAME])) {
            [namesArray addObject:[feedDict objectForKey:F_NAME]];
        }
        [otherArray addObject:@"和"];
        [otherArray addObject:@"成为了一家人"];
    } else {
        subjectStr = [emptystr([feedDict objectForKey:MESSAGE]) isEqualToString:@""] ? @"无标题" : [feedDict objectForKey:MESSAGE];
        allText = [NSString stringWithFormat:@"%@ %@ %@", emptystr([feedDict objectForKey:NAME]), emptystr([feedDict objectForKey:TITLE]), subjectStr];
        if (!isEmptyStr([feedDict objectForKey:NAME])) {
            [namesArray addObject:[feedDict objectForKey:NAME]];
        }
        if (!isEmptyStr([feedDict objectForKey:F_NAME])) {
            [namesArray addObject:[feedDict objectForKey:F_NAME]];
        }
        if (!isEmptyStr([feedDict objectForKey:TITLE])) {
            [otherArray addObject:[feedDict objectForKey:TITLE]];
        }
    }
    [self.multiTextTypeView fillMultiTypeWithStr:namesArray inText:allText withColor:[Common theLblColor] withSize:FONT_SIZE isBold:YES msgStr:subjectStr otherStr:otherArray];
}


- (void)initData:(NSDictionary *)_aDict {
    //    self.dataDict = _aDict;
    self.userId = [_aDict objectForKey:UID];
    //头像
    NSString *avatarStr = [[_aDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0 ? [[[_aDict objectForKey:COMMENT] objectAtIndex:0] objectForKey:NOTICE_AUTHOR_AVATAR] : [_aDict objectForKey:AVATER];

    [self.multiTextTypeView.headBtn setImageForMyHeadButtonWithUrlStr:avatarStr plcaholderImageStr:nil size:MIDDLE];

    [self.multiTextTypeView.headBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //时间
    [self.multiTextTypeView.timeView fillWithPointInImgAndLblView:CGPointMake(380, 83) withLeftImgStr:@"time.png" withRightText:[Common dateSinceNow:[_aDict objectForKey:DATELINE]] withFont:[UIFont boldSystemFontOfSize:TIME_FONT_SIZE] withTextColor:[UIColor lightGrayColor]];
    
    //富文本，名字
    //    self.multiTextTypeView.contentLbl.extendBottomToFit = YES;//自适应高度
    //    if (![[_aDict objectForKey:NOTE] isEqual:[NSNull null]]) {
    //        name = [NSString stringWithFormat:@"%@(%@)", name, [_aDict objectForKey:NOTE]];
    //    }
    
    //富文本，内容
    self.multiTextTypeView.contentLbl.numberOfLines = 0;
//    if (![[_aDict objectForKey:COME]isEqualToString:@""]) 
//        self.multiTextTypeView.contentLbl.text = [NSString stringWithFormat:@"%@ %@ %@   来自%@", name, [_aDict objectForKey:AD_TITLE],[_aDict objectForKey:MESSAGE],[_aDict objectForKey:COME]];
//    else
//    if ([[_aDict objectForKey:AD_ID_TYPE]isEqualToString:FRIEND]) 
//        self.multiTextTypeView.contentLbl.text = [NSString stringWithFormat:@"%@和 %@ 成为了家人", name, [_aDict objectForKey:F_NAME]];
//    else
//        self.multiTextTypeView.contentLbl.text = [NSString stringWithFormat:@"%@ %@ %@", name, [_aDict objectForKey:AD_TITLE],[_aDict objectForKey:MESSAGE]];
   // [self.multiTextTypeView fillMultiTypeWithStr:name withColor:color(157, 212, 74, 1.0) withSize:15.0f isBold:YES];
    NSString *allText = [self buildAllText:_aDict];
    NSString *subjectStr = [self buildSubjectText:_aDict];
    self.multiTextTypeView.contentLbl.text = allText;
    [self fillMultiType:_aDict allText:allText subjectStr:subjectStr];
    //[self.multiTextTypeView fillColorWithStr:[_aDict objectForKey:MESSAGE] withColor:color(229, 113, 116, 1)];

    //self.multiTextTypeView.contentLbl.attributedText = [_aDict objectForKey:MULTI_TYPE_TEXT];

    //[self.multiTextTypeView fillMultiTypeWithStr:name withColor:color(157, 212, 74, 1.0) withSize:16.0f isBold:YES];
}

@end
