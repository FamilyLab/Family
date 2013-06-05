//
//  PSBroView.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 This is an example of a subclass of PSCollectionViewCell
 */

#import "PSBroView.h"
#import "UIImageView+AFNetworking.h"
#import "WaterFallCommentView.h"
#import "web_config.h"
#import "Common.h"
#import "NSString+ConciseKit.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "PostBaseViewController.h"
#import "PostBaseView.h"
#import "KGModal.h"
#import "StackScrollViewController.h"
#import "SVProgressHUD.h"
#define TOPIC_PIC_BGCOLOR   [UIColor colorWithRed:158/255.0f green:213/255.0f blue:75/255.0f alpha:1]

#define MARGIN 12.5
#define ITEM_MARGIN 18.0
#define IMGAND_TEXT_MARGIN 10.0
#define TEXTANDCOMMENT_MARGIN 30.0
#define JOIN_BUTTON_HEIGHT  60.0
#define PIC_SIZE @"376"
@interface PSBroView ()

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *captionLabel;
@property (nonatomic, retain) WaterFallCommentView *commentView;
@property (nonatomic, copy) NSString *topicID;

@end

@implementation PSBroView

@synthesize
imageView = _imageView,
captionLabel = _captionLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        
        self.captionLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.captionLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.captionLabel.textColor = [UIColor darkGrayColor];
        self.captionLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.captionLabel.numberOfLines = 2;
        [self addSubview:self.captionLabel];
        self.commentView = [[[NSBundle mainBundle]loadNibNamed:@"WaterFallCommentView" owner:self options:nil]objectAtIndex:0];
        self.commentView.frame = CGRectZero;
        self.commentView.clipsToBounds = YES;
        [self addSubview:self.commentView];
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.captionLabel.text = nil;
    [self.commentView clearText];
}

- (void)dealloc {
    self.imageView = nil;
    self.captionLabel = nil;
    self.commentView = nil;
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width - MARGIN * 2;
    CGFloat top = MARGIN;
    CGFloat left = MARGIN;
    
    // Image
    if ([[self.object objectForKey:@"imagesize"]isKindOfClass:[NSDictionary class]]) {
        CGFloat objectWidth = ceil([[[self.object objectForKey:@"imagesize"] objectForKey:WIDTH] floatValue]);
        //CGFloat objectWidth = [PIC_SIZE floatValue];
        CGFloat objectHeight = ceil([[[self.object objectForKey:@"imagesize"] objectForKey:HEIGHT] floatValue]);
        CGFloat scaledHeight = ceil(objectHeight / (objectWidth / width));
        self.imageView.frame = CGRectMake(left, top, width, scaledHeight);
        self.imageView.hidden = NO;
    }
    else
    {
        self.imageView.frame = CGRectZero;
        self.imageView.hidden = YES;
    }
    
    
    // Label
    CGSize labelSize = CGSizeZero;
    labelSize = [self.captionLabel.text sizeWithFont:self.captionLabel.font constrainedToSize:CGSizeMake(width, 38) lineBreakMode:self.captionLabel.lineBreakMode];
    top = self.imageView.frame.origin.y + self.imageView.frame.size.height + IMGAND_TEXT_MARGIN;
    
    self.captionLabel.frame = CGRectMake(ceil(left), ceil(top), ceil(labelSize.width), ceil(labelSize.height));
    if ([self.object objectForKey:@"topicid"]) {
        //self.imageView.userInteractionEnabled = NO;
        self.topicID = [self.object objectForKey:@"topicid"];
        self.backgroundColor = TOPIC_PIC_BGCOLOR;
        self.captionLabel.backgroundColor = [UIColor clearColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"join_topicbtn.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, top+self.captionLabel.frame.size.height+MARGIN+3, self.frame.size.width, JOIN_BUTTON_HEIGHT);
        [button.titleLabel setTextAlignment:UITextAlignmentCenter ];
        [button addTarget:self action:@selector(joinTopic) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = YES;
        [self addSubview:button];
    }
    else{
        self.backgroundColor = [UIColor whiteColor];
        //self.imageView.userInteractionEnabled = YES;
        for (UIView *btn in self.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn removeFromSuperview];
            }
        }
    }
    //comment
    if ([[self.object objectForKey:COMMENT_LIST] count]>0) {
        self.commentView.hidden = NO;
        
        NSUInteger comment_y = self.frame.size.height-COMMENT_HEIGHT;
        self.commentView.frame = CGRectMake(0, comment_y,self.frame.size.width, COMMENT_HEIGHT);
    }
    else
        self.commentView.hidden = YES;
    
}

- (void)fillViewWithObject:(id)object {
    [super fillViewWithObject:object];
    [self.imageView setImageWithURL:[NSURL URLWithString:$str(@"%@!%@",[[object objectForKey:@"image_1"]delLastStrForYouPai],PIC_SIZE)] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    
    self.captionLabel.text = [object objectForKey:MESSAGE];
    if ([[self.object objectForKey:COMMENT_LIST] count]>0) {
        NSDictionary *dict = [[self.object objectForKey:COMMENT_LIST] objectAtIndex:0];
        if ([dict objectForKey:@"authorname"]&&!isEmptyStr([dict objectForKey:@"authorname"])) {
            self.commentView.authorLabel.text =[dict objectForKey:@"authorname"] ;
        }else{
            self.commentView.authorLabel.text =[dict objectForKey:@"author"] ;

        }
        self.commentView.timeLabel.text = [Common dateSinceNow:[dict objectForKey:DATELINE]];
        self.commentView.commentLabel.text = [dict objectForKey:MESSAGE];
    }
}

+ (CGFloat)heightForViewWithObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    // Image
    if ([[object objectForKey:@"imagesize"]isKindOfClass:[NSDictionary class]]) {
        CGFloat objectWidth = ceil([[[object objectForKey:@"imagesize"] objectForKey:WIDTH]  floatValue]);
        //CGFloat objectWidth = [PIC_SIZE floatValue];
        CGFloat objectHeight = ceil([[[object objectForKey:@"imagesize"] objectForKey:HEIGHT]   floatValue]);
        CGFloat scaledHeight = ceil(objectHeight / (objectWidth / width));
        height += scaledHeight;
    }
    
    // Label
    NSString *caption = [object objectForKey:@"message"];
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:15.0];
    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, 38) lineBreakMode:UILineBreakModeWordWrap];
    height += labelSize.height;
    //comment
    if ([[object objectForKey:COMMENT_LIST] count]>0) {
        height += COMMENT_HEIGHT;
        
    }
    
    if ([object objectForKey:@"topicid"]) {
        height += JOIN_BUTTON_HEIGHT;
    }
    height += MARGIN*2;
    
    return height;
}
-(void)joinTopic
{
    [[KGModal sharedInstance]closeAction:nil];

    if ([ConciseKit userDefaultsObjectForKey:HAS_LOGIN]) {
        REMOVEDETAIL;
        
        PostBaseViewController *con = [[PostBaseViewController alloc]initWithNibName:@"PostBaseViewController" bundle:nil];
        
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:[[AppDelegate instance].rootViewController.stackScrollViewController.viewControllersStack objectAtIndex:0] isStackStartView:FALSE];
        
        [con.postView initPostView:nil];
        con.postView.topicID = self.topicID;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请登录后再进行操作.."];
    }
    

   
}
@end
