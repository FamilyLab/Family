//
//  ZoneCell.m
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ZoneCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "FamilyCardViewController.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "Common.h"
//#import "UIButton+WebCache.h"

@implementation ZoneCell
@synthesize dataDict;

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

- (void)setFamilyMemberHeadBtn:(MyHeadButton*)_btn withHeadStr:(NSString*)_str {
//    [_btn setImageWithURL:[NSURL URLWithString:_str] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
    [_btn setImageForMyHeadButtonWithUrlStr:_str plcaholderImageStr:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.simpleInfoView) {
        [self.simpleInfoView layoutSubviews];
    }
}

- (void)initFamilyMemberHeadBtn {
    UIImageView *nonFamiliesImgView = (UIImageView*)[self viewWithTag:kTagNoneFamilies];
    if ([_memberArray count] > 0) {
        for (int i = 0; i < [_memberArray count]; i++) {
            MyHeadButton *btn = (MyHeadButton*)[self viewWithTag:kTagMembersBtnInZoneList + i];
            if (_indexRow * NUM_PER_ROW + i < [_memberArray count]) {
                [self setFamilyMemberHeadBtn:btn withHeadStr:[[_memberArray objectAtIndex:_indexRow * NUM_PER_ROW + i] objectForKey:AVATAR]];
                [btn setVipStatusWithStr:emptystr([[_memberArray objectAtIndex:_indexRow * NUM_PER_ROW + i] objectForKey:VIP_STATUS]) isSmallHead:YES];
                btn.hidden = NO;
            } else {
                btn.hidden = YES;
            }
        }
        if (nonFamiliesImgView) {
            [nonFamiliesImgView removeFromSuperview];
            nonFamiliesImgView = nil;
        }
    } else {//[_memberarray count]为0时
        for (int i = 0; i < NUM_PER_ROW; i++) {
            MyHeadButton *btn = (MyHeadButton*)[self viewWithTag:kTagMembersBtnInZoneList + i];
            btn.hidden = YES;
        }
        if (!nonFamiliesImgView) {
            UIImage *noneFeedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"none_families" ofType:@"png"]];
            UIImageView *nonFamiliesImgView = [[UIImageView alloc] initWithImage:noneFeedImage];
            nonFamiliesImgView.tag = kTagNoneFamilies;
            nonFamiliesImgView.frame = (CGRect){.origin.x = 20, .origin.y = 5, .size = nonFamiliesImgView.frame.size};//50为customTabBar的高度
            [self addSubview:nonFamiliesImgView];
        }
    }
}

- (void)initData:(NSDictionary *)_aDict {
    self.dataDict = _aDict;
    if (![[dataDict objectForKey:LATEST_PIC] isEqual:[NSNull null]]) {
        NSString *urlStr = [dataDict objectForKey:LATEST_PIC];
        urlStr = [urlStr rangeOfString:ypUrlStr].length > 0 ? $str(@"%@%@", [[dataDict objectForKey:LATEST_PIC] delLastStrForYouPai], ypZoneCover) : urlStr;
        [_latestPicImgView setImageForAevitWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"space_default_2.jpg"]];
//        [_latestPicImgView setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:LATEST_PIC]] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    } else {
        _latestPicImgView.image = [UIImage imageNamed:@"space_default_2.jpg"];
    }
    _albumNameLbl.text = [dataDict objectForKey:TAG_NAME];
    _photoNumLbl.text = [dataDict objectForKey:PHOTO_NUM];
    _diaryNumLbl.text = [dataDict objectForKey:BLOG_NUM];
    _activityNumLbl.text = [dataDict objectForKey:EVENT_NUM];
    _videoNumLbl.text = [dataDict objectForKey:VIDEO_NUM];
}

- (IBAction)familyMemberBtnPressed:(UIButton*)sender {
    int btnTag = sender.tag - kTagMembersBtnInZoneList;
    NSString *userId = [[_memberArray objectAtIndex:_indexRow * NUM_PER_ROW + btnTag] objectForKey:UID];
    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    con.isMyFamily = YES;
    con.userId = userId;
    //    pushACon(con);
    pushAConInView(self, con);
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate pushAController:con];
}


@end
