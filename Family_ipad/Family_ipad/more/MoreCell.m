//
//  MoreCell.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-24.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "MoreCell.h"
#import "CKMacros.h"
#import "web_config.h"
#define onlyOneCellImgStr @"list_onlyonecell"
#define topCellImgStr     @"list_top_twolines.png"
#define middleCellImgStr  @"list_middle_onlybottomline.png"
#define bottomCellImgStr  @"list_bottom_notopline.png"
#define childNum 3
#define STATE @"已绑定"
#define UNSTATE @"未绑定"
@implementation MoreCell
@synthesize dataDict, indexSection, indexRow;
@synthesize firstBtn, secondBtn, thirdBtn, firstLbl, secondLbl, thirdLbl, rightImgView;
- (IBAction)switchTopicOption:(id)sender
{
    if (_switchTopic.on) 
        [ConciseKit setUserDefaultsWithObject:$bool(1) forKey:TOPIC_MARK];
    else
        [ConciseKit setUserDefaultsWithObject:$bool(0) forKey:TOPIC_MARK];
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

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)initData:(NSDictionary *)_aDict {
    self.dataDict = _aDict;
    int childCount = [[dataDict objectForKey:BABY_LIST] count];

    firstLbl.frame = [firstLbl textRectForBounds:firstLbl.frame limitedToNumberOfLines:1];
    secondLbl.frame = CGRectMake(firstLbl.frame.origin.x +firstLbl.frame.size.width +10, secondLbl.frame.origin.y, secondLbl.frame.size.width, secondLbl.frame.size.height);
    switch (indexSection) {
        case 0:
        {
            //我的个人资料
            if (indexRow==0) 
                secondLbl.text =  [NSString stringWithFormat:@"%@个", [_aDict objectForKey:PESONAL_MEMBER_NUM] ];
            else if (indexRow == 1){
                if ([[_aDict objectForKey:ASK_FOR_FAMILY_NUM] intValue]>0) {
                    secondLbl.textColor = [UIColor redColor];
                }
                secondLbl.text =   [NSString stringWithFormat:@"%@个", [_aDict objectForKey:ASK_FOR_FAMILY_NUM] ];}


            break;
        }
        case 1:
        {
            //孩子资料
            if (self.indexRow != childCount) {
                firstLbl.text = [[[dataDict objectForKey:BABY_LIST]  objectAtIndex:indexRow] objectForKey:BABY_NAME];
                 CGSize nameSize = [firstLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:21.0f] constrainedToSize:CGSizeMake(470, 320) lineBreakMode:UILineBreakModeWordWrap];
                firstLbl.frame = CGRectMake(firstLbl.frame.origin.x, firstLbl.frame.origin.y-3, nameSize.width, nameSize.height);
            }
            break;
           
        }
//        case 2:
//        {
//            //积分
//
//            if (self.indexRow==0){
//                secondLbl.text = [NSString stringWithFormat:@"剩余%@", [_aDict objectForKey:MONEY]];
//            }          
//            break;
//        }   
        case 3:
        {
            if (indexRow==0){
                rightImgView.hidden = YES;
                _switchTopic.hidden = NO;
                if ([TOPIC_SWITCH boolValue])
                    _switchTopic.on =YES;
                else  _switchTopic.on =NO;
                
            }   
            else if(indexRow==1){   
                rightImgView.hidden = YES;
                if ([PUSH_SWITCH boolValue])
                    secondLbl.text = @"已开启";
                else secondLbl.text = @"已关闭";
            }
            else if (indexRow == 2){
                if ([[PDKeychainBindings sharedKeychainBindings] objectForKey:SINA_UID]&&![[_aDict objectForKey:SINA_UID] isEqualToString:@""]){
                    secondLbl.text = STATE;
                    rightImgView.hidden = YES;
                }
                else{
                        secondLbl.text = UNSTATE;
                        rightImgView.hidden = YES;

                }
            }
//            else if (indexRow == 3){
//                if (!isEmptyStr([_aDict objectForKey:QQ_UID])){
//                    secondLbl.text = STATE;
//                    rightImgView.hidden = YES;
//
//                }
//                else{
//                    secondLbl.text = UNSTATE;
//                    rightImgView.hidden = NO;
//
//                }
//            }

            break;
        }
        case 4:
        {
            //设置
            
           
           
            break;
        }
        default:
            break;
    }
}

@end
