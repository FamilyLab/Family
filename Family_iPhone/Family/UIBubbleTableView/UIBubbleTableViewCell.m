//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"
#import "UIView+BlocksKit.h"
#import "FamilyCardViewController.h"
#import "AppDelegate.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+JMImageCache.h"

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
//@property (nonatomic, retain) UIImageView *avatarImage;
@property (nonatomic, retain) MyHeadButton *avatarBtn;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
//@synthesize avatarImage = _avatarImage;
@synthesize avatarBtn = _avatarBtn;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImage = nil;
//    self.avatarImage = nil;
    self.avatarBtn = nil;
    [super dealloc];
}
#endif

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
#if !__has_feature(objc_arc)
        self.bubbleImage = [[[UIImageView alloc] init] autorelease];
#else
        self.bubbleImage = [[UIImageView alloc] init];        
#endif
        [self addSubview:self.bubbleImage];
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
//        [self.avatarImage removeFromSuperview];
//        [self.avatarBtn removeFromSuperview];
//#if !__has_feature(objc_arc)
//        self.avatarImage = [[[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"head_70.png"])] autorelease];
//#else
//        self.avatarImage = [[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"head_70.png"])];
//#endif
        self.avatarBtn = [MyHeadButton buttonWithType:UIButtonTypeCustom];
        [self.avatarBtn setImage:self.data.avatar forState:UIControlStateNormal];
        
        if (self.data.headStr) {
//            [self.avatarImage setImageWithURLByJM:[NSURL URLWithString:self.data.headStr] placeholder:[UIImage imageNamed:@"head_70.png"]];
            [self.avatarBtn setImageForMyHeadButtonWithUrlStr:self.data.headStr plcaholderImageStr:@"head_70.png"];
        }
        if (self.data.userId) {
//            self.avatarImage.userInteractionEnabled = YES;
//            [self.avatarImage whenTapped:^{
//                FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
//                con.isMyFamily = YES;
//                con.userId = self.data.userId;
//                //                pushACon(con);
//                pushAConInView(self, con);
////                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
////                [appDelegate pushAController:con];
//            }];
            [self.avatarBtn whenTapped:^{
                FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                con.isMyFamily = YES;
                con.userId = self.data.userId;
                pushAConInView(self, con);
            }];
        }
//        self.avatarImage.layer.cornerRadius = 9.0;
//        self.avatarImage.layer.masksToBounds = YES;
//        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
//        self.avatarImage.layer.borderWidth = 1.0;
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 12 : self.frame.size.width - 47;
//        CGFloat avatarY = self.frame.size.height - 50;
        CGFloat avatarY = 0;
        
//        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 35, 35);
//        [self addSubview:self.avatarImage];
        
        self.avatarBtn.frame = CGRectMake(avatarX, avatarY, 35, 35);
        [self addSubview:self.avatarBtn];
        [self.avatarBtn setVipStatusWithStr:emptystr(self.data.vipStatus) isSmallHead:YES];
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        
        if (type == BubbleTypeSomeoneElse) x += 54;
        if (type == BubbleTypeMine) x -= 54;
    }

    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, 10, width, height);//y:y + self.data.insets.top - 20
    [self.contentView addSubview:self.customView];

    if (type == BubbleTypeSomeoneElse)
    {
//        self.bubbleImage.image = [[UIImage imageNamed:@"dialogue_left_bg.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        self.bubbleImage.image = [[UIImage imageNamed:@"dialogue_left_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:40];
    }
    else {
//        self.bubbleImage.image = [[UIImage imageNamed:@"dialogue_right_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
        self.bubbleImage.image = [[UIImage imageNamed:@"dialogue_right_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:40];
    }

    self.bubbleImage.frame = CGRectMake(x, 0, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
}

@end
