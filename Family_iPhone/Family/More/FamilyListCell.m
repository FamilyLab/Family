//
//  FamilyListCell.m
//  Family
//
//  Created by Aevitx on 13-1-24.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FamilyListCell.h"
#import "Common.h"

@implementation FamilyListCell

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
    if (self.simpleInfoView) {
//        self.simpleInfoView.frame = (CGRect){.origin = self.simpleInfoView.frame.origin, .size.width = self.simpleInfoView.frame.size.width, .size.height = self.frame.size.height - 5};
        [self.simpleInfoView layoutSubviews];
    }
    if (self.accessoryView) {
        self.accessoryView.frame = (CGRect){.origin.x = self.accessoryView.frame.origin.x - 10, .origin.y = self.accessoryView.frame.origin.y - 10, .size = self.accessoryView.frame.size};
    }
}

- (void)initData:(NSDictionary *)_aDict {
//    self.dataDict = _aDict;
    NSString *noteName = @"";
    if (![[_aDict objectForKey:NOTE] isEqual:[NSNull null]] && ![[_aDict objectForKey:NOTE] isEqualToString:@""]) {
        noteName = [NSString stringWithFormat:@"(%@)", [_aDict objectForKey:NOTE]];
    }
    NSString *infoStr = @"";
    if (![[_aDict objectForKey:FAMILY_MEMBERS] isEqual:[NSNull null]]) {
        infoStr =[NSString stringWithFormat:@"%@个家人", [_aDict objectForKey:FAMILY_MEMBERS]];
    }
    if (![[_aDict objectForKey:FAMILY_FEEDS] isEqual:[NSNull null]]) {
        infoStr = [NSString stringWithFormat:@"%@ %@个动态", infoStr, [_aDict objectForKey:FAMILY_FEEDS]];
    }
    self.simpleInfoView.isFamilyList = YES;
    self.simpleInfoView.userId = [_aDict objectForKey:UID];
    [self.simpleInfoView.headBtn setVipStatusWithStr:emptystr([_aDict objectForKey:VIP_STATUS]) isSmallHead:YES];
    [self.simpleInfoView initInfoWithHeadUrlStr:[_aDict objectForKey:AVATAR]
                                        nameStr:[_aDict objectForKey:NAME]
                                    noteNameStr:noteName
                                        infoStr:infoStr
                               andRightImgPoint:CGPointMake(220, 13)
                                       rightImg:@"birthday_b"
                                       rightStr:[_aDict objectForKey:BIRTHDAY]];
}

//- (void)initFamilyListForSelect:(NSDictionary *)_aDict {
//    NSString *noteName = @"";
//    if (![emptystr([_aDict objectForKey:NOTE]) isEqualToString:@""]) {
//        noteName = [NSString stringWithFormat:@"(%@)", [_aDict objectForKey:NOTE]];
//    }
//    NSString *infoStr = @"";
//    if (![[_aDict objectForKey:FAMILY_MEMBERS] isEqual:[NSNull null]]) {
//        infoStr =[NSString stringWithFormat:@"%@个家人", [_aDict objectForKey:FAMILY_MEMBERS]];
//    }
//    if (![[_aDict objectForKey:FAMILY_FEEDS] isEqual:[NSNull null]]) {
//        infoStr = [NSString stringWithFormat:@" %@个动态", [_aDict objectForKey:FAMILY_FEEDS]];
//    }
//    self.simpleInfoView.isFamilyList = YES;
//    self.simpleInfoView.userId = [_aDict objectForKey:UID];
//    [self.simpleInfoView initInfoWithHeadUrlStr:[_aDict objectForKey:AVATAR]
//                                        nameStr:[_aDict objectForKey:NAME]
//                                    noteNameStr:noteName
//                                        infoStr:infoStr
//                               andRightImgPoint:CGPointMake(220, 13)
//                                       rightImg:@"birthday_b"
//                                       rightStr:[_aDict objectForKey:BIRTHDAY]];
//}

+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight {
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(239, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    return height;
}

- (void)initTaskData:(NSDictionary*)aDict {
    self.simpleInfoView.isFromTask = YES;
    [self.simpleInfoView.headBtn setVipStatusWithStr:emptystr([aDict objectForKey:VIP_STATUS]) isSmallHead:YES];
    [self.simpleInfoView initInfoWithHeadUrlStr:[aDict objectForKey:IMAGE]
                                        nameStr:[aDict objectForKey:NAME]
                                    noteNameStr:@""
                                        infoStr:[aDict objectForKey:NOTE]
                               andRightImgPoint:CGPointMake(220, 13)
                                       rightImg:nil
                                       rightStr:@""];
}

- (void)initFamilyListForSelect:(NSDictionary *)_aDict {
//    self.simpleInfoView.isFamilyList = YES;
//    self.simpleInfoView.userId = [_aDict objectForKey:UID];
//    [self.simpleInfoView.headBtn setVipStatusWithStr:emptystr([_aDict objectForKey:VIP_STATUS]) isSmallHead:YES];
//    [self.simpleInfoView initInfoWithHeadUrlStr:[_aDict objectForKey:@"favatar"]
//                                        nameStr:[_aDict objectForKey:@"fname"]
//                                    noteNameStr:@""
//                                        infoStr:@""
//                               andRightImgPoint:CGPointZero
//                                       rightImg:@""
//                                       rightStr:@""];
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
