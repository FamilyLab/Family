//
//  TopicCell.m
//  Family
//
//  Created by Aevitx on 13-3-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TopicCell.h"
#import "UIImageView+WebCache.h"
//#import "PostViewController.h"
#import "PostSthViewController.h"
#import "Common.h"

@implementation TopicCell

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

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    if (_indexRow == 0) {
//        _containerView.frame = CGRectMake(10, DEVICE_SIZE.height - 100 - 10, 300, 100);
//        
//        _imgView.frame = (CGRect){.origin = _imgView.frame.origin, .size = CGSizeMake(fminf(_firstPicWidth, self.frame.size.width),fminf(_firstPicHeight, self.frame.size.height))};
//        _imgView.center = self.center;
//    } else {
////        _describeLbl.frame = (CGRect){.origin = _describeLbl.frame.origin.x, .origin.y = self.frame.size.height - _describeLbl.frame.size.height, .size = _describeLbl.frame.size};
//    }
//}

- (void)initData:(NSDictionary*)aDict {
    NSString *picUrl = $str(@"%@%@", [[aDict objectForKey:FEED_IMAGE_1] delLastStrForYouPai], ypFeedBigImg);
    [_imgView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    _describeLbl.text = [aDict objectForKey:SUBJECT];
}

#pragma mark IBAction(s)
- (IBAction)joinBtnPressed:(id)sender {
    if (!MY_HAS_LOGIN) {//未登录
//    if (!MY_HAS_LOGIN || !MY_AUTO_LOGIN) {//未登录和未选择自动登录时
        LoginViewController *con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        pushAConInView(self, con);
    } else {//去发表页面
        if (self.topicId) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_CUSTOM_CAMERA object:_topicId];
        }
//        PostSthViewController *con = [[PostSthViewController alloc] initWithNibName:@"PostSthViewController" bundle:nil];
//        con.shouldAddDefaultImage = YES;
//        con.postSthType = postPhoto;
////        PostViewController *con = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
//        con.topicId = _topicId;
//        pushAConInView(self, con);
    }
}

- (IBAction)skipBtnPressed:(id)sender {//跳过
    if (!MY_HAS_LOGIN) {//未登录时
//    if (!MY_HAS_LOGIN || !MY_AUTO_LOGIN) {//未登录时
        LoginViewController *con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        pushAConInView(self, con);
    } else {//已登录
        if (!_isFromMoreCon) {//APP启动时的
            dismissAConInView(self);//去动态列表
        } else {//从更多页面进来的
            popAConInView(self);//返回
        }
    }
}

- (IBAction)notShowAgainBtnPressed:(UIButton*)sender {
//    sender.selected = !sender.selected;
//    [[NSUserDefaults standardUserDefaults] setBool:!sender.selected forKey:WANT_SHOW_TODAY_TOPIC];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSString *checkImgStr = sender.selected ? @"checked.png" : @"notChecked.png";
//    _checkImgView.image = [UIImage imageNamed:checkImgStr];
    
    //
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WANT_SHOW_TODAY_TOPIC];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self skipBtnPressed:sender];
}

@end
