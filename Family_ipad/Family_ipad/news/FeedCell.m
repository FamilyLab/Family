//
//  FeedCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedCell.h"
#import "Common.h"
#import "CommentView.h"
#import "web_config.h"
#import "UIButton+WebCache.h"
#import "FamilyCardViewController.h"
#import "AppDelegate.h"
#import "StackScrollViewController.h"
#import "RootViewController.h"
#import "UIView+BlocksKit.h"
@implementation FeedCell
@synthesize cellType, indexRow, dataDict;
@synthesize headView;
@synthesize albumView;
//@synthesize bigImgView, bigImgLbl;
@synthesize firstComment, secondComment,commentNumView,thirdComment;
@synthesize lineImgView;
//@synthesize firstImgView, secondImgView, thirdImgView, imgsNumLbl, describeLbl;


- (NSString*)buildAllText:(NSDictionary *)feedDict  {
    //    NSDictionary *aDict = [dataArray objectAtIndex:index];
    //    NSMutableDictionary *feedDict = [[NSMutableDictionary alloc] initWithDictionary:aDict];
    NSString *allText = @"";
    NSString *subjectStr = [self buildSubjectText:feedDict];
    if ([[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0) {//评论的行为动态
        if ([feedDict objectForKey:COMMENT]) {
            NSDictionary *commentDict = [[feedDict objectForKey:COMMENT] objectAtIndex:0];
            NSString *otherStr = [[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:@"event"].length > 0 ? @"参与了" : @"评论了";
            allText = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", emptystr([commentDict objectForKey:COMMENT_AUTHOR_NAME]), otherStr, emptystr([feedDict objectForKey:NAME]), emptystr([feedDict objectForKey:TITLE]), subjectStr];
        }
        else{
            if ([[feedDict objectForKey:AD_ID_TYPE]isEqualToString:FRIEND])
                    allText = [NSString stringWithFormat:@"%@和 %@ 成为了家人", emptystr([feedDict objectForKey:NAME]), [feedDict objectForKey:F_NAME]];
                else
                    allText = [NSString stringWithFormat:@"%@ 评论了 %@", emptystr([feedDict objectForKey:NAME]), subjectStr];
        }
    } else if ([[feedDict objectForKey:FEED_ID_TYPE] isEqualToString:FRIEND]) {//AA和BB成为了一家人
        allText = [NSString stringWithFormat:@"%@ 和 %@ 成为了一家人", [feedDict objectForKey:NAME], [feedDict objectForKey:F_NAME]];
    } else {//其他，如 xxx说了句xxx等
        allText = [NSString stringWithFormat:@"%@ %@ %@", emptystr([feedDict objectForKey:NAME]), emptystr([feedDict objectForKey:TITLE]), subjectStr];
    }
    return allText;
}

- (NSString*)buildSubjectText:(NSDictionary *)feedDict {
    NSString *subjectStr = @"";
    if ([[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0) {//评论的行为动态
        if ([feedDict objectForKey:COMMENT]) {
            if ([feedDict objectForKey:SUBJECT]&&!isEmptyStr([feedDict objectForKey:SUBJECT])) {
                subjectStr = [emptystr([feedDict objectForKey:SUBJECT]) isEqualToString:@""] ? @"无标题" : [feedDict objectForKey:SUBJECT];
            }
            else{
                NSString *key = [[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:@"event"].length > 0 ? SUBJECT : MESSAGE;
                subjectStr = [emptystr([feedDict objectForKey:key]) isEqualToString:@""] ? @"无标题" : [feedDict objectForKey:key];
            }
            
            if (subjectStr.length > 12) {
                subjectStr = [subjectStr substringToIndex:12];
                subjectStr = $str(@"%@...", subjectStr);
            }
        }
    else{
        subjectStr =  emptystr([feedDict objectForKey:SUBJECT]);

    }
    } else if ([[feedDict objectForKey:FEED_ID_TYPE] isEqualToString:FRIEND]) {//AA和BB成为了一家人
        subjectStr = @"";
    } else {//其他，如 xxx说了句xxx，更新了资料，更新了头像，创建了家等。其中只有 xxx说了句xxx有message
        subjectStr = ([emptystr([feedDict objectForKey:MESSAGE]) isEqualToString:@""] && [[feedDict objectForKey:FEED_ID_TYPE] isEqualToString:@"isayid"]) ? @"无标题" : [feedDict objectForKey:MESSAGE];
    }
    return subjectStr;
}
- (NSUInteger)whichDetailType:(NSString*)typeStr {
    if ([typeStr rangeOfString:FEED_PHOTO_ID].location != NSNotFound) {
        return 1;
    } else if ([typeStr rangeOfString:FEED_BLOG_ID].location != NSNotFound) {
        return 2;
    } else if ([typeStr rangeOfString:FEED_VIDEO_ID].location != NSNotFound) {
        return 3;
    } else if ([typeStr rangeOfString:FEED_EVENT_ID].location != NSNotFound) {
        return 4;
    } else {
        return 5;
    }
}
- (NSURL *)genreateImgURL:(NSString*)row_url
                  size:(NSString*)size
{
    NSString *url = [row_url stringByReplacingOccurrencesOfString:@"!600" withString:@""];
    return [NSURL URLWithString:$str(@"%@%@",url,size)];

}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _picArray = $marrnew;
    }
    return self;
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
    //headView.frame = CGRectMake(0, 5, 320, 39);

    firstComment.frame = (CGRect){.origin.x = 0, .origin.y = albumView.frame.origin.y + albumView.frame.size.height+5, .size = firstComment.frame.size};
    secondComment.frame = (CGRect){.origin.x = 0, .origin.y = albumView.frame.origin.y + albumView.frame.size.height + firstComment.frame.size.height+5, .size = firstComment.frame.size};
    thirdComment.frame = (CGRect){.origin.x = 0, .origin.y = secondComment.frame.origin.y+secondComment.frame.size.height, .size = secondComment.frame.size};
    commentNumView.frame = (CGRect){.origin.x = 0, .origin.y = thirdComment.frame.origin.y+thirdComment.frame.size.height, .size.height =15,.size.width = 480 };

    self.lineImgView.frame = (CGRect){.origin.x = 0, .origin.y = self.frame.size.height - 1, .size = lineImgView.frame.size};
    self.lineImgView.hidden= YES;
    [firstComment layoutSubviews];
    [secondComment layoutSubviews];
    [thirdComment layoutSubviews];
    [commentNumView layoutSubviews];
    
}

- (void)initData:(NSDictionary*)_aDict {
}
- (void)setLoveNoComment{
    self.secondComment.hidden= YES;
    //[self.secondComment setWhichType:onlyALabelType];
    //self.secondComment.contentLbl.text = @"给你的家人写条评论吧～";
    self.thirdComment.hidden= YES;
    self.commentNumView.hidden = YES;
}
- (void)setNoComment {
    self.firstComment.hidden = YES;
    //[self.firstComment setWhichType:onlyALabelType];
   // self.firstComment.contentLbl.text = @"给你的家人写条评论吧～";
    self.secondComment.hidden = YES;
    self.thirdComment.hidden = YES;
    self.commentNumView.hidden = YES;
}

- (void)setTheFirstComment {
    [firstComment setWhichType:noHeadType];
   // firstComment.nameLbl.textColor = [Common theLblColor];
    firstComment.nameLbl.text = @"大瑞恩";
    firstComment.contentLbl.text = [NSString stringWithFormat:@":%@", @"妈妈真有创意"];
    self.secondComment.hidden = YES;
    self.thirdComment.hidden =YES;
    self.commentNumView.hidden = YES;
}

- (void)setTheSecondComment {
    [secondComment setWhichType:noHeadType];
    //secondComment.nameLbl.textColor = [Common theLblColor];
    secondComment.nameLbl.text = @"林美新";
    secondComment.contentLbl.text = [NSString stringWithFormat:@":%@", @"不吵醒BB拍照，真有难度啊"];
    self.secondComment.hidden = NO;
}

- (IBAction)headBtnPressed:(id)sender {
}

//公共部分
- (void)initCommonData:(NSDictionary*)aDict {
    if (cellType == otherNoImgType || cellType == otherHasImgType) {
        return;
    }
   
    //头部
    headView.headBtn.type = HEAD_BTN;
    headView.headBtn.identify = [aDict objectForKey:UID];
    
    [headView.headBtn setVipStatusWithStr:[aDict objectForKey:VIPSTATUS] isSmallHead:YES];
    //[headView.headBtn setImageWithURL:[headView.headBtn headImgURLWith:MIDDLE url:[aDict objectForKey:AVATER]] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
    [headView.headBtn setImageForMyHeadButtonWithUrlStr:[aDict objectForKey:AVATER] plcaholderImageStr:@"head_220.png" size:MIDDLE];

    //
    //[headView.headBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    headView.nameLbl.text = [aDict objectForKey:FEED_NAME];
    headView.nameLbl.frame = [headView.nameLbl textRectForBounds:headView.nameLbl.frame limitedToNumberOfLines:1];

    NSUInteger type = [self whichDetailType:[aDict objectForKey:AD_ID_TYPE]];
    if (type) {
        if (_isRepost) {
            headView.actionImage.frame = CGRectMake(headView.nameLbl.frame.origin.x, headView.nameLbl.frame.origin.y+headView.nameLbl.frame.size.height+5, headView.actionImage.frame.size.width, headView.actionImage.frame.size.height);
            [headView addSubview:headView.actionImage];
            headView.actionLabel.frame = CGRectMake(headView.actionImage.frame.origin.x+headView.actionImage.frame.size.width +3, headView.nameLbl.frame.origin.y+headView.nameLbl.frame.size.height-2, 1000, headView.nameLbl.frame.size.height);
            [headView addSubview:headView.actionLabel];

            headView.actionLabel.text = [NSString stringWithFormat:@"%@", [aDict objectForKey:F_NAME]];
            headView.actionLabel.userInteractionEnabled = NO;
            [headView.actionLabel whenTapped:^{
                REMOVEDETAIL;
                FamilyCardViewController *detailViewController = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:[AppDelegate instance].rootViewController isStackStartView:FALSE];
                [detailViewController sendRequestWith:[aDict objectForKey:F_UID]];
            }];
        }
        else{
            NSString *otherText = type == 1 ? @"发表了照片" : (type == 2 ? @"发表了日志" : (type == 3 ? @"发表了视频" : (type == 4 ? @"发表了活动" : @"")));
            headView.actionLabel.text = otherText;
            headView.actionImage.hidden = YES;
            headView.actionLabel.hidden = YES;
        }
       // headView.actionLabel.frame = [headView.actionLabel textRectForBounds:headView.actionLabel.frame limitedToNumberOfLines:1];

    }
    //[headView.timeView fillWithPointInImgAndLblView:CGPointMake(380, 26) withLeftImgStr:@"time.png" withRightText:[Common dateSinceNow:[aDict objectForKey:DATELINE]] withFont:[UIFont systemFontOfSize:TIME_FONT_SIZE] withTextColor:[UIColor lightGrayColor]];
    [self.timeLabel setText:[Common dateSinceNow:[aDict objectForKey:DATELINE]]];
    _timeLabel.frame = CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y,101,1000);
    _comeFromeLabel.text = $str(@"来自: %@",[aDict objectForKey:COME]);
    
    self.timeLabel.frame = [self.timeLabel textRectForBounds:self.timeLabel.frame limitedToNumberOfLines:0];
    self.comeFromeLabel.frame = (CGRect){.origin.x = self.timeLabel.frame.origin.x+self.timeLabel.frame.size.width+2, .origin.y = self.timeLabel.frame.origin.y, .size = self.comeFromeLabel.frame.size};

    albumView.albumBtn.type = ZONE_BTN;
    //album那一行
  //  [albumView.albumBtn setTitle:$str(@"   %@",[[aDict objectForKey:TAG] objectForKey:TAG_NAME]) forState:UIControlStateNormal];
    albumView.albumBtn.identify = [[aDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [[aDict objectForKey:TAG] objectForKey:TAG_ID] : @"";
    albumView.albumBtn.extraInfo = [aDict objectForKey:UID];
    NSString *tagName = [[aDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [[aDict objectForKey:TAG] objectForKey:TAG_NAME] : @"";

    [albumView.albumBtn setTitle:$str(@"%@",tagName) forState:UIControlStateNormal];
   // [albumView.repostBtn setTitle:$str(@"   %@",[aDict objectForKey:FEED_REBLOG_NUM]) forState:UIControlStateNormal];
  //  [albumView.likeitBtn setTitle:$str(@"%@",[aDict objectForKey:FEED_LOVE_NUM]) forState:UIControlStateNormal];
    albumView.hasLoved = [[aDict objectForKey:MY_LOVE] boolValue];
    albumView.likeitBtn.selected = albumView.hasLoved;//1为我已收藏，0为我未收藏

   // [albumView.commentBtn setTitle:$str(@"%@",[aDict objectForKey:FEED_REPLY_NUM]) forState:UIControlStateNormal];

    
    //评论
    int theCommentNum = [[aDict objectForKey:COMMENT] count];
    //收藏
    int loveNum = [[aDict objectForKey:@"loveuser"]count];
    self.thirdComment.hidden = YES;
    self.commentNumView.hidden = YES;

    if (loveNum == 0) {
        if (theCommentNum == 0) {
            [self setNoComment];
        } else if (theCommentNum == 1) {
            [self setTheFirstComment:[[aDict objectForKey:COMMENT] objectAtIndex:0]];
        } else if (theCommentNum == 2) {
            [self setTheFirstComment:[[aDict objectForKey:COMMENT] objectAtIndex:0]];
            [self setTheSecondComment:[[aDict objectForKey:COMMENT] objectAtIndex:1]];
        }else if (theCommentNum >2){
            [self setTheFirstComment:[[aDict objectForKey:COMMENT] objectAtIndex:0]];
            [self setTheSecondComment:[[aDict objectForKey:COMMENT] objectAtIndex:1]];
            [self setTheThirdComment:[[aDict objectForKey:COMMENT] objectAtIndex:2]];

        }
    }else{
        [self setLoveView:[aDict objectForKey:@"loveuser"]];
        if (theCommentNum == 0) {
            [self setLoveNoComment];
        } else if (theCommentNum == 1) {
            [self setTheSecondComment:[[aDict objectForKey:COMMENT] objectAtIndex:0]];
        } else if (theCommentNum >= 2) {
            [self setTheSecondComment:[[aDict objectForKey:COMMENT] objectAtIndex:0]];
            [self setTheThirdComment:[[aDict objectForKey:COMMENT] objectAtIndex:1]];
            if (theCommentNum>2) {
                [self setFourthComment:$str(@"共%d条",theCommentNum)];

            }
        }

    }
    
    
}


- (void)setLoveView:(NSArray *)loveDict
{
    [self.firstComment setWhichType:hasHeadType];
    [firstComment fillLoveData:loveDict];
    //self.secondComment.hidden = YES;

}
- (void)setTheFirstComment:(NSDictionary*)commentDict {
    self.firstComment.hidden= NO;
    [firstComment fillCommentData:commentDict];
    self.secondComment.hidden = YES;
    self.thirdComment.hidden = YES;
    self.commentNumView.hidden = YES;
}

- (void)setTheSecondComment:(NSDictionary*)commentDict {
    [secondComment fillCommentData:commentDict];
    self.secondComment.hidden = NO; 
    self.thirdComment.hidden = YES;
    self.commentNumView.hidden = YES;
}

- (void)setTheThirdComment:(NSDictionary *)commentDict{
    [thirdComment fillCommentData:commentDict];
    self.thirdComment.hidden = NO;
    self.commentNumView.hidden = YES;
}
- (void)setFourthComment:(NSString *)str{
    [self.commentNumView setWhichType:commentNum];

    self.commentNumView.hidden = NO;
    [self.commentNumView fillcommentNum:str];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _picArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _picArray.count)
        return [_picArray objectAtIndex:index];
    return nil;
}
@end
