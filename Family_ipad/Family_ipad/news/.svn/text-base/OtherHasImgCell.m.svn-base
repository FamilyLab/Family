//
//  OtherHasImgCell.m
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "OtherHasImgCell.h"
#import "UIButton+WebCache.h"
#import "Common.h"
#import "NSString+ConciseKit.h" 
@implementation OtherHasImgCell
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

- (void)layoutSubviews {
    [super layoutSubviews];
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
    [_rightImg setImageWithURL:[NSURL URLWithString:$str(@"%@!190X190",[[_aDict objectForKey:FEED_IMAGE_1]delLastStrForYouPai]])placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    //头像
     NSString *avatarStr = [[_aDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0 ? [[[_aDict objectForKey:COMMENT] objectAtIndex:0] objectForKey:NOTICE_AUTHOR_AVATAR] : [_aDict objectForKey:AVATER];

     [self.multiTextTypeView.headBtn setImageForMyHeadButtonWithUrlStr:avatarStr plcaholderImageStr:nil size:MIDDLE];

    [self.multiTextTypeView.headBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //时间
    [self.multiTextTypeView.timeView fillWithPointInImgAndLblView:CGPointMake(380, 84) withLeftImgStr:@"time.png" withRightText:[Common dateSinceNow:[_aDict objectForKey:DATELINE]] withFont:[UIFont boldSystemFontOfSize:TIME_FONT_SIZE] withTextColor:[UIColor lightGrayColor]];
    
    //富文本，名字

    //富文本，内容
    self.multiTextTypeView.contentLbl.numberOfLines = 0;
     NSString *allText = [self buildAllText:_aDict];
     NSString *subjectStr = [self buildSubjectText:_aDict];

     self.multiTextTypeView.contentLbl.text = allText;
     
     [self fillMultiType:_aDict allText:allText subjectStr:subjectStr];


     
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
