//
//  TopicView.m
//  Family
//
//  Created by Aevitx on 13-6-6.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TopicView.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"
#import "UIImageView+WebCache.h"
#import "PostSthViewController.h"

@implementation TopicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bgImgView.userInteractionEnabled = YES;
        [_bgImgView whenTapped:^{
            [self hideTopic:nil];
        }];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _bgImgView.userInteractionEnabled = YES;
        [_bgImgView whenTapped:^{
            [self hideTopic:nil];
        }];
        _isFromMoreCon = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize titleSize = [_titleLbl.text sizeWithFont:_titleLbl.font constrainedToSize:CGSizeMake(285, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    _titleLbl.frame = (CGRect){.origin.x = 18, .origin.y = _topicImgView.frame.origin.y + _topicImgView.frame.size.height, .size = titleSize};
    
    CGSize contentSize = [_contentLbl.text sizeWithFont:_contentLbl.font constrainedToSize:CGSizeMake(285, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    _contentLbl.frame = (CGRect){.origin.x = _titleLbl.frame.origin.x, .origin.y = _titleLbl.frame.origin.y + _titleLbl.frame.size.height, .size = contentSize};
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    self.containerView.frame = CGRectMake(0, -DEVICE_SIZE.height, DEVICE_SIZE.width, DEVICE_SIZE.height);
    self.bgBtn.frame = DEVICE_BOUNDS;
}

- (IBAction)hideTopic:(id)sender {
    [self showOrHideAnimation:sender isShow:NO];
}

- (IBAction)showOrHideAnimation:(id)sender isShow:(BOOL)_isShow {
    [UIView animateWithDuration:0.4 animations:^(void){
        if (_isShow) {
            _bgImgView.alpha = 0.6;
            self.containerView.frame = CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height);
        } else {
            self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1f, 1.1f);
        }
//        CGFloat theY = _isShow ? 0 : -DEVICE_SIZE.height;
//        self.containerView.frame = CGRectMake(0, theY, DEVICE_SIZE.width, DEVICE_SIZE.height);
    } completion:^(BOOL finished){
        [self bounceOutAnimationStopedWithIsShow:_isShow];
    }];
}

- (void)bounceOutAnimationStopedWithIsShow:(BOOL)_isShow  {
    [UIView animateWithDuration:0.1 animations:^(void){
        CGFloat scale = _isShow ? 1.1f : 0.9f;
        self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    } completion:^(BOOL finished){
        [self bounceInAnimationStopedWithIsShow:_isShow];
    }];
}

- (void)bounceInAnimationStopedWithIsShow:(BOOL)_isShow  {
    [UIView animateWithDuration:0.1 animations:^(void){
        CGFloat scale = _isShow ? 0.9f : 1.0f;
        self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
//        CGFloat theY = _isShow ? 0 : -DEVICE_SIZE.height;
//        self.containerView.frame = CGRectMake(0, theY, DEVICE_SIZE.width, DEVICE_SIZE.height);
    } completion:^(BOOL finished){
        [self animationStopedWithIsShow:_isShow];
    }];
}

- (void)animationStopedWithIsShow:(BOOL)_isShow {
    CGFloat time = _isShow ? 0.1f : 0.3f;
    [UIView animateWithDuration:time
                     animations:^{
                         if (_isShow) {
                             self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
                         } else {
                             self.containerView.frame = CGRectMake(0, -DEVICE_SIZE.height, DEVICE_SIZE.width, DEVICE_SIZE.height);
                             _bgImgView.alpha = 0;
                         }
                     } completion:^(BOOL finished) {
                         if (!_isShow) {
                             [self removeFromSuperview];
//                             if (!MY_NOT_FIRST_SHOW) {
//                                 [self skipBtnPressed:nil];
//                                 [ConciseKit setUserDefaultsWithObject:@"notFirstShow" forKey:NOT_FIRST_SHOW];
////                                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_FIRST_SHOW];
////                                 [[NSUserDefaults standardUserDefaults] synchronize];
//                             }
                         }
                     }];
}

//- (IBAction)hide:(id)sender {
//    self.alpha = 0;
//    self.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
//}

#pragma mark - network
- (void)sendRequest:(id)sender {
    self.hidden = YES;
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=topic&page=%d&perpage=%d", BASE_URL, 1, 1];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        self.topicId = [[dict objectForKey:WEB_DATA] objectForKey:TOPIC_ID];
        self.topicTitleStr = [[dict objectForKey:WEB_DATA] objectForKey:SUBJECT];
        self.topicDescribeStr = [[dict objectForKey:WEB_DATA] objectForKey:MESSAGE];
        self.topicImgUrlStr = [[dict objectForKey:WEB_DATA] objectForKey:PIC];
        self.joinType = [[[dict objectForKey:WEB_DATA] objectForKey:JOIN_TYPE] objectAtIndex:0];
        if (!MY_LAST_TOPIC_ID || ![MY_LAST_TOPIC_ID isEqualToString:_topicId]) {
            [ConciseKit setUserDefaultsWithObject:_topicId forKey:LAST_TOPIC_ID];
            [self fillData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

- (void)fillData {
    self.hidden = NO;
    _titleLbl.text = _topicTitleStr;
    _contentLbl.text = _topicDescribeStr;
    [_topicImgView setImageWithProgressViewWithURL:[NSURL URLWithString:_topicImgUrlStr] placeholderImage:nil];
    [self layoutSubviews];
    [self showOrHideAnimation:nil isShow:YES];
//    [_topicImgView setImageWithURL:[NSURL URLWithString:_topicImgUrlStr] placeholderImage:nil];
}

#pragma mark IBAction(s)
- (IBAction)joinBtnPressed:(id)sender {
    if (!MY_HAS_LOGIN) {//未登录
        [SVProgressHUD showErrorWithStatus:@"登录后才能参加T_T"];
        [self hideTopic:nil];
        
//        //    if (!MY_HAS_LOGIN || !MY_AUTO_LOGIN) {//未登录和未选择自动登录时
//        LoginViewController *con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
//        nav.navigationBarHidden = YES;
//        presentAConInView(self, nav);
////        pushAConInView(self, con);
    } else {//去发表页面
        if (self.topicId) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_CUSTOM_CAMERA object:self.topicId];
        }
        
//        PostSthViewController *con = [[PostSthViewController alloc] initWithNibName:@"PostSthViewController" bundle:nil];
//        con.postSthType = postPhoto;
//        con.shouldAddDefaultImage = YES;
//        //        PostViewController *con = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
//        con.topicId = _topicId;
//        pushAConInView(self, con);
    }
}

- (IBAction)skipBtnPressed:(id)sender {//跳过
    if (!MY_HAS_LOGIN) {//未登录时
        //    if (!MY_HAS_LOGIN || !MY_AUTO_LOGIN) {//未登录时
        LoginViewController *con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
        nav.navigationBarHidden = YES;
        presentAConInView(self, nav);
//        pushAConInView(self, con);
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
