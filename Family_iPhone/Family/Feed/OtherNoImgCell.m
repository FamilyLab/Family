//
//  OtherNoImgCell.m
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "OtherNoImgCell.h"
#import "Common.h"
#import "FamilyCardViewController.h"
#import "AppDelegate.h"

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
    self.multiTextTypeView.timeView.frame = (CGRect){.origin.x = self.multiTextTypeView.contentLbl.frame.origin.x, .origin.y = self.multiTextTypeView.contentLbl.frame.origin.y + self.multiTextTypeView.contentLbl.frame.size.height, .size = self.multiTextTypeView.timeView.frame.size};
    self.multiTextTypeView.frame = (CGRect){.origin = self.multiTextTypeView.frame.origin, .size.width = self.multiTextTypeView.frame.size.width, .size.height = self.frame.size.height - 2 * self.multiTextTypeView.frame.origin.y};
    [self.multiTextTypeView setNeedsDisplay];
}

- (void)initData:(NSDictionary *)_aDict {
//    self.dataDict = _aDict;
//    self.userId = [_aDict objectForKey:UID];
    //头像
//    [self.multiTextTypeView.headBtn setImageWithURL:[NSURL URLWithString:[_aDict objectForKey:AVATAR]] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
    self.multiTextTypeView.headBtn.userInteractionEnabled = NO;
    NSString *avatarStr = [[_aDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0 ? [[[_aDict objectForKey:COMMENT] objectAtIndex:0] objectForKey:NOTICE_AUTHOR_AVATAR] : [_aDict objectForKey:AVATAR];
    [self.multiTextTypeView.headBtn setImageForMyHeadButtonWithUrlStr:avatarStr plcaholderImageStr:nil];
    [self.multiTextTypeView.headBtn setVipStatusWithStr:emptystr([_aDict objectForKey:VIP_STATUS]) isSmallHead:YES];
    self.multiTextTypeView.userId = [_aDict objectForKey:UID];
//    [self.multiTextTypeView.headBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //时间
    NSString *timeAndComeStr = $str(@"%@", [Common dateSinceNow:[_aDict objectForKey:DATELINE]]);
//    NSString *timeAndComeStr = $str(@"%@   来自：%@", [Common dateSinceNow:[_aDict objectForKey:DATELINE]], [_aDict objectForKey:COME]);
    [self.multiTextTypeView.timeView fillWithPointInImgAndLblView:CGPointMake(0, 23) withLeftImgStr:@"time.png" withRightText:timeAndComeStr withFont:[UIFont boldSystemFontOfSize:12.0f] withTextColor:[UIColor lightGrayColor]];
    
    self.multiTextTypeView.contentLbl.font = [UIFont boldSystemFontOfSize:15.0f];
    NSString *allCotentStr = self.allText;
    self.multiTextTypeView.contentStr = allCotentStr;
    self.multiTextTypeView.contentLbl.attributedText = [_aDict objectForKey:MULTI_TYPE_TEXT];
    
//    if ([[_aDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0) {//参与活动的
//        if ([_aDict objectForKey:COMMENT]) {
//            NSString *subjectStr = [emptystr([_aDict objectForKey:SUBJECT]) isEqualToString:@""] ? @"无标题" : [_aDict objectForKey:SUBJECT];
//            NSDictionary *commentDict = [[_aDict objectForKey:COMMENT] objectAtIndex:0];
//            NSString *otherStr = [[_aDict objectForKey:FEED_ID_TYPE] rangeOfString:@"event"].length > 0 ? @"参与了" : @"评论了";
//            self.multiTextTypeView.contentStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", emptystr([commentDict objectForKey:COMMENT_AUTHOR_NAME]), otherStr, emptystr([_aDict objectForKey:NAME]), emptystr([_aDict objectForKey:TITLE]), subjectStr];
//            self.multiTextTypeView.contentLbl.attributedText = [_aDict objectForKey:MULTI_TYPE_TEXT];
//        }
//    } else if ([[_aDict objectForKey:FEED_ID_TYPE] isEqualToString:FRIEND]) {
//        allCotentStr = [NSString stringWithFormat:@"%@ 和 %@ 成为了一家人", [_aDict objectForKey:NAME], [_aDict objectForKey:F_NAME]];
//        self.multiTextTypeView.contentStr = allCotentStr;
//        self.multiTextTypeView.contentLbl.attributedText = [_aDict objectForKey:MULTI_TYPE_TEXT];
//    } else {
//        allCotentStr = [NSString stringWithFormat:@"%@ %@ %@", [_aDict objectForKey:NAME], [_aDict objectForKey:TITLE], [_aDict objectForKey:MESSAGE]];
//        self.multiTextTypeView.contentStr = allCotentStr;
//        self.multiTextTypeView.contentLbl.attributedText = [_aDict objectForKey:MULTI_TYPE_TEXT];
//    }
}

//- (void)headBtnPressed:(id)sender {
//    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
//    con.userId = _userId;
//    con.isMyFamily = YES;
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate pushAController:con];
//}

@end
