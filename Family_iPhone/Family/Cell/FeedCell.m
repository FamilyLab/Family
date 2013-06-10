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
#import "ThemeManager.h"
//#import "UIButton+WebCache.h"
#import "FamilyCardViewController.h"
#import "AppDelegate.h"
#import "UIView+BlocksKit.h"
#import "ZoneDetailViewController.h"

@implementation FeedCell
@synthesize cellType, indexRow, dataDict;
@synthesize headView;
@synthesize albumView;
//@synthesize bigImgView, bigImgLbl;
@synthesize firstComment, secondComment;
//@synthesize lineImgView;
//@synthesize firstImgView, secondImgView, thirdImgView, imgsNumLbl, describeLbl;

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

+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight andLblMaxWidth:(CGFloat)maxWidth {
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:[UIFont boldSystemFontOfSize:15.0f] constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);//235
    return height;
}

+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight andLblMaxWidth:(CGFloat)maxWidth andFont:(UIFont*)font {
    if (!font) {
        font = [UIFont boldSystemFontOfSize:14.0f];
    }
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);//235
    return height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.lineImgView.frame = (CGRect){.origin.x = 0, .origin.y = self.frame.size.height - 1, .size = lineImgView.frame.size};
    if (cellType == otherNoImgType || cellType == otherHasImgType) {
        return;
    }
    
//FUCK_NUM_0、FUCK_NUM_1、FUCK_NUM_2（FUCK_NUM_1和FUCK_NUM_2的值一样）都改为0，再将评论的背景图片_commentBgImgView改为：@"feed_comment_bg_v12.png"(@"feed_comment_bg_short_v12.png"的为短的)，就可以让评论的那背景框宽度为300。
//#define FUCK_NUM_0  48
    if (self.commentBgImgView) {
        _commentBgImgView.image = [UIImage imageNamed:@"feed_comment_bg_short_v12.png"];//改这里
    }
    
    [headView layoutSubviews];
    [_typeView layoutSubviews];
    albumView.frame = (CGRect){.origin.x = albumView.frame.origin.x, .origin.y = _typeView.frame.origin.y + _typeView.frame.size.height, .size = albumView.frame.size};
    [albumView layoutSubviews];
    
    if (!_loverView.hidden) {
        CGSize loverSize = [_loverView.contentLbl.text sizeWithFont:_loverView.contentLbl.font constrainedToSize:CGSizeMake(LOVE_MAX_WIDTH - FUCK_NUM_1, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        loverSize.height += 10 * 2;
//        loverSize.height = loverSize.height < LOVE_MIN_HEIGHT ? LOVE_MIN_HEIGHT : loverSize.height;
        _loverView.frame = (CGRect){.origin = CGPointMake(0, 10), .size.width = DEVICE_SIZE.width - FUCK_NUM_0, .size.height = loverSize.height};
//        _loverView.frame = (CGRect){.origin = CGPointMake(0, 10), .size.width = loverSize.width, .size.height = loverSize.height};
        [_loverView layoutSubviews];
    }
    if (!firstComment.hidden) {
        CGFloat y = _loverView.hidden ? 10 : _loverView.frame.origin.y + _loverView.frame.size.height;
        CGSize firstCommentSize = [firstComment.contentLbl.text sizeWithFont:firstComment.contentLbl.font constrainedToSize:CGSizeMake(COMMENT_MAX_WIDTH - FUCK_NUM_1, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        firstCommentSize.height += 10 * 2;//firstCommentSize.height < COMMENT_MIN_HEIGHT ? COMMENT_MIN_HEIGHT : firstCommentSize.height + 10 * 2;
        firstComment.frame = (CGRect){.origin.x = 0, .origin.y = y, .size.width = DEVICE_SIZE.width - FUCK_NUM_0, .size.height = firstCommentSize.height};
        [firstComment layoutSubviews];
    }
    if (!secondComment.hidden) {
        CGSize secondCommentSize = [secondComment.contentLbl.text sizeWithFont:secondComment.contentLbl.font constrainedToSize:CGSizeMake(COMMENT_MAX_WIDTH - FUCK_NUM_1, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        secondCommentSize.height += 10 * 2;//secondCommentSize.height < COMMENT_MIN_HEIGHT ? COMMENT_MIN_HEIGHT : secondCommentSize.height + 10 * 2;
        secondComment.frame = (CGRect){.origin.x = 0, .origin.y = firstComment.frame.origin.y + firstComment.frame.size.height, .size.width = DEVICE_SIZE.width - FUCK_NUM_0, .size.height = secondCommentSize.height};
        [secondComment layoutSubviews];
        
        _totalComentNum.frame = (CGRect){.origin.x = 0, .origin.y = secondComment.frame.origin.y + secondComment.frame.size.height - 2, .size.width = secondComment.frame.size.width, .size.height = _totalComentNum.frame.size.height};
    }
    
    CGFloat loverH = _loverView.hidden ? 0 : _loverView.frame.size.height;
    CGFloat firstCommentH = firstComment.hidden ? 0 : firstComment.frame.size.height;
    CGFloat secondCommentH = secondComment.hidden ? 0 : secondComment.frame.size.height;
    CGFloat numH = _totalComentNum.hidden ? 0 : _totalComentNum.frame.size.height;
    _forCommentView.frame = (CGRect){.origin.x = 0 + FUCK_NUM_0, .origin.y = albumView.frame.origin.y + albumView.frame.size.height, .size.width = DEVICE_SIZE.width - FUCK_NUM_0, .size.height = loverH + firstCommentH + secondCommentH + numH + 10};
    [_forCommentView layoutSubviews];
    if (!_commentBgImgView.hidden) {
        _commentBgImgView.image = [_commentBgImgView.image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        _commentBgImgView.frame = (CGRect){.origin.x = 10, .origin.y = 0, .size.width = DEVICE_SIZE.width - 10 * 2 - FUCK_NUM_0, .size.height = _forCommentView.frame.size.height};
//        _commentBgImgView.frame = (CGRect){.origin.x = 10, .origin.y = 0, .size.width = DEVICE_SIZE.width - 10 * 2, .size.height = _forCommentView.frame.size.height};
    }
    _cellBgImgView.image = [_cellBgImgView.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    _cellBgImgView.frame = (CGRect){.origin = _cellBgImgView.frame.origin, .size.width = _cellBgImgView.frame.size.width, .size.height = albumView.frame.origin.y + albumView.frame.size.height - _cellBgImgView.frame.origin.y + 1};
//    firstComment.frame = (CGRect){.origin.x = 0, .origin.y = albumView.frame.origin.y + albumView.frame.size.height, .size = CGSizeMake(DEVICE_SIZE.width, h)};
//    [firstComment layoutSubviews];
//    
//    secondComment.frame = (CGRect){.origin.x = 0, .origin.y = albumView.frame.origin.y + albumView.frame.size.height + firstComment.frame.size.height, .size = CGSizeMake(DEVICE_SIZE.width, 55)};
//    [secondComment layoutSubviews];
    
}

//公共部分
- (void)initCommonData:(NSDictionary*)aDict {
    if (cellType == otherNoImgType || cellType == otherHasImgType) {
        return;
    }
    //头部
//    [headView.headBtn setImageWithURL:[NSURL URLWithString:[aDict objectForKey:AVATAR]] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
    [headView.headBtn setImageForMyHeadButtonWithUrlStr:[aDict objectForKey:AVATAR] plcaholderImageStr:nil];
    [headView.headBtn setVipStatusWithStr:emptystr([aDict objectForKey:VIP_STATUS]) isSmallHead:YES];
    [headView.headBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    headView.nameLbl.textColor = [Common theLblColor];
    headView.nameLbl.text = [aDict objectForKey:NAME];
    if (_isRepost) {
        headView.repostView.hidden = NO;
        [headView.repostView fillWithPointInImgAndLblView:CGPointMake(headView.nameLbl.frame.origin.x, headView.nameLbl.frame.origin.y + headView.nameLbl.frame.size.height) withLeftImgStr:@"repost_new" withRightText:[aDict objectForKey:F_NAME] withFont:[UIFont boldSystemFontOfSize:13.0f] withTextColor:[UIColor lightGrayColor]];
//        headView.repostLbl.text = [NSString stringWithFormat:@"转载自 @%@", [aDict objectForKey:F_NAME]];
//        headView.repostLbl.font = [UIFont boldSystemFontOfSize:14.0f];
//        headView.repostLbl.userInteractionEnabled = YES;
//        [headView.repostLbl whenTapped:^{
//            FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
//            con.userId = [aDict objectForKey:F_UID];
//            con.isMyFamily = YES;
//            pushAConInView(self, con);
//        }];
    } else {
        headView.repostView.hidden = YES;
//        headView.repostLbl.text = [aDict objectForKey:TITLE];
//        headView.repostLbl.userInteractionEnabled = NO;
    }
//    [headView.timeView fillWithPointInImgAndLblView:CGPointMake(260, 16) withLeftImgStr:@"time.png" withRightText:[Common dateSinceNow:[aDict objectForKey:DATELINE]] withFont:[UIFont boldSystemFontOfSize:11.0f] withTextColor:[UIColor lightGrayColor]];
    
    //album那一行
//    [albumView.albumBtn setImage:ThemeImage(@"album_bg_a") forState:UIControlStateNormal];
//    [albumView.albumBtn setImage:ThemeImage(@"album_bg_b") forState:UIControlStateHighlighted];
    
    [albumView.albumBtn addTarget:self action:@selector(albumBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.tagId = [[aDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [NSString stringWithFormat:@"%d", [[[aDict objectForKey:TAG] objectForKey:TAG_ID] intValue]] : @"";
    NSString *tagName = [[aDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [[aDict objectForKey:TAG] objectForKey:TAG_NAME] : @"";
    tagName = [NSString stringWithFormat:@"   %@", tagName];
    [albumView.albumBtn changeLblWithText:tagName andColor:[UIColor lightGrayColor] andSize:15.0f theX:25];
//    albumView.albumBtn.btnLbl.textAlignment = UITextAlignmentCenter;
//    albumView.albumLeft.image = ThemeImage(@"album");
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//    albumView.albumBtn.btnLbl.textAlignment = UITextAlignmentCenter;
//#else
//    albumView.albumBtn.btnLbl.textAlignment = NSTextAlignmentCenter;
//#endif
//    albumView.albumBtn.btnLbl.frame = (CGRect){.origin.x = 23, .origin.y = 0, .size = CGSizeMake(100, 40)};
    
    NSString *timeStr = [Common dateSinceNow:[aDict objectForKey:DATELINE]];
    self.comeLbl.text = $str(@"%@   来自：%@", timeStr, emptystr([aDict objectForKey:COME]));
//    albumView.comeLbl.text = $str(@"%@   来自：%@", timeStr, emptystr([aDict objectForKey:COME]));
    [albumView.likeitBtn setImage:[UIImage imageNamed:@"03a.png"] forState:UIControlStateNormal];//likeit_a.png
    [albumView.likeitBtn setImage:[UIImage imageNamed:@"03c.png"] forState:UIControlStateHighlighted];//likeit_b.png
    [albumView.likeitBtn setImage:[UIImage imageNamed:@"03c.png"] forState:UIControlStateSelected];//likeit_b.png
    [albumView.repostBtn setImage:[UIImage imageNamed:@"12.png"] forState:UIControlStateHighlighted];
    [albumView.commentBtn setImage:[UIImage imageNamed:@"02b.png"] forState:UIControlStateHighlighted];
    [albumView.albumBtn setImage:[UIImage imageNamed:@"Albums'name-bg2.png"] forState:UIControlStateHighlighted];
//    [albumView.repostBtn changeLblWithText:[aDict objectForKey:FEED_REBLOG_NUM] andColor:[UIColor whiteColor] andSize:12.0f theX:25];
//    [albumView.likeitBtn changeLblWithText:[aDict objectForKey:FEED_LOVE_NUM] andColor:[UIColor whiteColor] andSize:12.0f theX:25];
//    [albumView.commentBtn changeLblWithText:[aDict objectForKey:FEED_REPLY_NUM] andColor:[UIColor whiteColor] andSize:12.0f theX:25];
    
    albumView.likeitBtn.selected = [[aDict objectForKey:MY_LOVE] boolValue];
    
    //评论
#warning 接口里，转载的帖子的replynum一直为0
    self.commentNum = fmaxf([[aDict objectForKey:FEED_REPLY_NUM] intValue], [[aDict objectForKey:COMMENT] count]);
    if ([_loveArray count] == 0 && self.commentNum == 0) {
        _forCommentView.hidden = YES;
        return;
    }
    _forCommentView.hidden = NO;
    _loverView.commentType = leftIsImage;
    if ([_loveArray count] == 0) {
        _loverView.hidden = YES;
    } else {
        _loverView.hidden = NO;
        _loverView.contentLbl.text = [_loveArray objectAtIndex:0];
        for (int i = 1; i < [_loveArray count]; i++) {
            _loverView.contentLbl.text = $str(@"%@，%@", _loverView.contentLbl.text, [_loveArray objectAtIndex:i]);
        }
    }
    
    _loverView.lineImgView.hidden = NO;
    firstComment.hidden = YES;
    secondComment.hidden = YES;
    _totalComentNum.hidden = YES;
    if (_commentNum == 0) {
        _loverView.lineImgView.hidden = YES;
        [self setNoComment];
    } else if (_commentNum == 1) {
        [self setTheFirstComment:[[aDict objectForKey:COMMENT] objectAtIndex:0]];
    } else {
        [self setTheFirstComment:[[aDict objectForKey:COMMENT] objectAtIndex:0]];
        [self setTheSecondComment:[[aDict objectForKey:COMMENT] objectAtIndex:1]];
        if (_commentNum > 2) {
            _totalComentNum.hidden = NO;
            _totalComentNum.text = $str(@"共%d条", _commentNum);
        }
    }
}

- (void)initData:(NSDictionary*)aDict {
}

- (void)setNoComment {
//    [self.firstComment setWhichType:onlyALabelType];
//    self.firstComment.contentLbl.text = @"给你的家人写条评论吧～";
    
    self.firstComment.hidden = YES;
    self.secondComment.hidden = YES;
}

- (void)setTheFirstComment:(NSDictionary*)commentDict {
    self.firstComment.hidden = NO;
    [firstComment fillCommentData:commentDict];
}

- (void)setTheSecondComment:(NSDictionary*)commentDict {
    self.secondComment.hidden = NO;
    [secondComment fillCommentData:commentDict];
}

- (void)headBtnPressed:(id)sender {
    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    con.userId = _authorUserId;
    con.isMyFamily = YES;
    //    pushACon(con);
    pushAConInView(self, con);
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate pushAController:con];
}

- (void)albumBtnPressed:(id)sender {
    if ([_tagId isEqualToString:@""]) {
        return;
    }
//    ZoneDetailViewController *con = [[ZoneDetailViewController alloc] initWithNibName:@"ZoneDetailViewController" bundle:nil];
    FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
    con.hidesBottomBarWhenPushed = YES;
    con.tagId = _tagId;
    con.userId = _authorUserId;
    con.isFromZone = YES;
//    con.isToShowAlbumDetail = YES;
    //    pushACon(con);
    pushAConInView(self, con);
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate pushAController:con];
}





@end
