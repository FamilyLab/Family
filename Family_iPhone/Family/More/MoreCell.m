//
//  MoreCell.m
//  Family
//
//  Created by Aevitx on 13-1-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MoreCell.h"
#import "Common.h"

#define onlyOneCellImgStr @"list_onlyonecell"
#define topCellImgStr     @"list_top_twolines.png"
#define middleCellImgStr  @"list_middle_onlybottomline.png"
#define bottomCellImgStr  @"list_bottom_notopline.png"

#define GOTO_FRAME      CGRectMake(270, 15, 8, 15)
#define ADD_FRAME       CGRectMake(266, 15, 15, 15)
#define PUSH_FRAME      CGRectMake(260, 13, 30, 17)

@implementation MoreCell
@synthesize dataDict, indexRow;// indexSection, indexRow;
@synthesize firstBtn, secondBtn, thirdBtn, firstLbl, secondLbl, thirdLbl, rightImgView;

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

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)initData:(NSDictionary *)_aDict {
    self.dataDict = _aDict;
    int childCount = [[dataDict objectForKey:BABY_LIST] count];
    
    //设置每一行cell右边的图片
    NSString *rightImgStr = @"goto_a";
    if (self.seciontType == childSection && self.indexRow == childCount) {//self.indexRow == childCount 为最后一行
//    if (self.indexSection == 1 && self.indexRow == childCount) {//self.indexRow == childCount 为最后一行
        rightImgStr = @"addchild";
        self.rightImgView.frame = ADD_FRAME;
    } else if (self.seciontType == settingSection) {
//    } else if (self.indexSection == 4) {
        if (self.indexRow == 1) {
            rightImgStr = [[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone ? @"on_a" : @"on_b";
            self.rightImgView.frame = PUSH_FRAME;
        } else if (self.indexRow == 2) {
            rightImgStr = MY_WANT_SHOW_TODAY_TOPIC ? @"on_b" : @"on_a";
            self.rightImgView.frame = PUSH_FRAME;
        } else if (self.indexRow == 4) {
            rightImgStr = MY_HAS_BIND_SINA_WEIBO && MY_SHARE_TO_SINA_WEIBO ? @"on_b" : @"on_a";
            self.rightImgView.frame = PUSH_FRAME;
        } else if (self.indexRow == 5) {
            rightImgStr = MY_HAS_BIND_WEIXIN ? @"on_b" : @"on_a";
            self.rightImgView.frame = PUSH_FRAME;
        } else
            self.rightImgView.frame = GOTO_FRAME;
    } else {
        self.rightImgView.frame = GOTO_FRAME;
    }
    self.rightImgView.image = ThemeImage(rightImgStr);
    
    //填充数据
    if (self.numLbl) {
        self.numLbl.textColor = [UIColor lightGrayColor];
    }
    switch (self.seciontType) {
//    switch (self.indexSection) {
        case familySection://家人
        {
            if (self.indexRow == 0) {
                self.numLbl.text = [NSString stringWithFormat:@"%d个", [emptystr([_aDict objectForKey:FAMILY_MEMBERS]) intValue]];
                self.numLbl.hidden = NO;
            } else if (self.indexRow == 1) {
                int applyNum = [emptystr([_aDict objectForKey:ASK_FOR_FAMILY_NUM]) intValue];
                if (applyNum > 0) {
                    self.numLbl.textColor = [UIColor redColor];
                }
                self.numLbl.text = [NSString stringWithFormat:@"%d个", applyNum];
                self.numLbl.hidden = NO;
            } else self.numLbl.hidden = YES;
            break;
        }
        case childSection://孩子资料
        {
            self.numLbl.hidden = YES;
            if (self.indexRow != childCount) {
                self.tipsLbl.text = [[[dataDict objectForKey:BABY_LIST] objectAtIndex:indexRow] objectForKey:BABY_NAME];
            }
            break;
        }
//        case creditSection://积分
//        {
//            if (self.indexRow == 0) {
//                self.numLbl.text = [NSString stringWithFormat:@"剩余%d", [emptystr([_aDict objectForKey:MONEY]) intValue]];
//                self.numLbl.hidden = NO;
////            }
////            else if (self.indexRow == 1) {
////                self.numLbl.text = [NSString stringWithFormat:@"%d", [emptystr([_aDict objectForKey:TASK_NUM]) intValue]];
////                self.numLbl.hidden = NO;
//            } else
//                self.numLbl.hidden = YES;
//            break;
//        }
        case watchSection://查看
        {
            if (self.indexRow == 0) {
                self.numLbl.hidden = NO;
                self.numLbl.text = [NSString stringWithFormat:@"%d个", [emptystr([_aDict objectForKey:LOVE_NUM]) intValue]];
            } else {
                self.numLbl.hidden = YES;
            }
            break;
        }
        case settingSection://设置
        {
            self.numLbl.hidden = YES;
            if (self.indexRow == 0) {
                self.tipsLbl.text = [NSString stringWithFormat:@"主题  %@", [Common theThemeName]];
            }
            break;
        }
        case aboutSection://关于
        {
            self.numLbl.hidden = YES;
            break;
        }
        default:
            break;
    }
    
    
    
//    return;
//    switch (indexSection) {
//        case 0:
//        {
//            //我的个人资料
//            firstLbl.text = @"周子若";
//            secondLbl.text = @"189-1234-5678";
//            thirdLbl.text = @"1990-04-13";
//            break;
//        }
//        case 1:
//        {
//            //家人
//            firstLbl.text = @"6个";
//            secondLbl.text = @"8个";
//            break;
//        }
//        case 2:
//        {
//            //孩子资料
//            NSString *rightImgStr = self.indexRow == childCount ? @"addchild" : @"goto_a";//self.indexRow == child 为最后一行
//            UIImage *rightImg = ThemeImage(rightImgStr);
//            self.rightImgView.frame = (CGRect){.origin = self.rightImgView.frame.origin, .size = rightImg.size};
//            self.rightImgView.image = rightImg;
//            
//            if (childCount < 1) {
//                self.bgImgView.image = [UIImage imageNamed:onlyOneCellImgStr];
//            } else  {
//                if (indexRow == 0) {//第一行
//                    self.bgImgView.image = [UIImage imageNamed:topCellImgStr];
//                    self.firstLbl.text = @"周家俊";
//                } else if (indexRow == childCount) {//最后一行
//                    self.bgImgView.image = [UIImage imageNamed:bottomCellImgStr];
//                    self.firstLbl.text = @"我还有一个孩子";
//                } else {
//                    self.bgImgView.image = [UIImage imageNamed:middleCellImgStr];
//                    self.firstLbl.text = @"周永康";
//                }
//            }
//            break;
//        }
//        case 3:
//        {
//            //积分
//            firstLbl.text = @"剩余230";
//            secondLbl.text = @"3";
//            break;
//        }
//        case 4:
//        {
//            //设置
//            self.rightImgView.image = ThemeImage(@"on_b");//根据userDefault
//            break;
//        }
//        default:
//            break;
//    }
}




@end
