//
//  CommentView.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CommentView.h"
#import "web_config.h"
#import "Common.h"
#define CONTAINTER_FRAME_NO_HEAD        CGRectMake(0, 0, 480, 35)
#define CONTENT_LABEL_FRAME CGRectMake(83, 8, 299, 21)
#define CONTENTLOVE_LABEL_FRAME CGRectMake(55+78, 15, 299, 21)
#define CONTENT_ONLY_LABEL_FRAME CGRectMake(90, 14, 299, 21)

#define CONTAINTER_FRAME_ONLY_A_LABEL   CGRectMake(0, 0, 480, 55)
#define NAME_X 106
@implementation CommentView
@synthesize headImgView, headBtn, containerView, nameLbl, contentLbl, timeView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        contentLbl.numberOfLines = 1;
    }
    return self;
}

- (void)setWhichType:(CommentType)_type {
    [self.headImgView removeFromSuperview];
    //self.nameLbl.font = [UIFont boldSystemFontOfSize:16.0f];
    self.commentType = _type;

    switch (_type) {
        case hasHeadType:
        {
            self.containerView.frame = CONTAINTER_FRAME_NO_HEAD;

            self.contentLbl.frame = CONTENTLOVE_LABEL_FRAME;
            self.contentLbl.textAlignment = UITextAlignmentLeft;

            self.nameLbl.hidden = YES;
            self.headImgView.hidden = NO;

            break;
        }
        case noHeadType:
        {
//            [self.headImgView removeFromSuperview];
//            [self.headBtn removeFromSuperview];
            self.headImgView.hidden = YES;
            self.headBtn.hidden = YES;
            self.nameLbl.hidden = NO;
            self.timeView.hidden = NO;
            self.containerView.frame = CONTAINTER_FRAME_NO_HEAD;
            self.contentLbl.frame = CONTENT_LABEL_FRAME;
            self.contentLbl.textAlignment = UITextAlignmentLeft;
            //self.contentLbl.font = [UIFont systemFontOfSize:18.0f];
            self.contentLbl.textColor = [UIColor darkGrayColor];
            break;
        }
        case onlyALabelType:
        {
            self.headImgView.hidden = YES;
            self.headBtn.hidden = YES;
            self.nameLbl.hidden = YES;
            self.timeView.hidden = YES;
            self.containerView.frame = CONTAINTER_FRAME_NO_HEAD;

            self.contentLbl.frame = CONTENT_ONLY_LABEL_FRAME;
            self.contentLbl.textAlignment = UITextAlignmentCenter;
            self.contentLbl.font = [UIFont boldSystemFontOfSize:16.0f];
            self.contentLbl.textColor = [UIColor grayColor];
            
            break;
        }
            case commentNum:
        {
            self.contentLbl.frame = CGRectMake(130, -3, self.contentLbl.frame.size.width, self.contentLbl.frame.size.height);
            self.contentLbl.textAlignment = UITextAlignmentCenter;
            self.headImgView.hidden = YES;
            self.contentLbl.font = [UIFont systemFontOfSize:12.0f];


            break;
        }
        default:
            break;
    }
}

- (void)changeContainerViewFrame {
    CGRect theFrame = self.containerView.frame;
    theFrame.origin.x = 0;
    theFrame.size.width = 480;
    self.containerView.frame = theFrame;
}

//+ (CGFloat)commentViewHeight {
//    
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_commentType == noHeadType) {
        
        CGSize nameSize = [nameLbl.text sizeWithFont:nameLbl.font constrainedToSize:CGSizeMake(DEVICE_SIZE.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        nameSize.height = nameSize.height < 20 ? 20 : nameSize.height;
        //        nameLbl.frame = (CGRect){.origin = nameLbl.frame.origin, .size = CGSizeMake(40, 30)};
        

        CGFloat maxWidth = self.frame.size.width - 15 - nameLbl.frame.origin.x - nameLbl.frame.size.width - 45;
        CGSize infoSize = [contentLbl.text sizeWithFont:contentLbl.font constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (_isfirstComment){
            CGFloat y = infoSize.height/2>20?infoSize.height/2:20;
            y=22;
            nameLbl.frame = (CGRect){.origin.x=NAME_X, .origin.y = y, .size = nameSize};}
        else
            nameLbl.frame = (CGRect){.origin.x=NAME_X, .origin.y = 11 , .size = nameSize};
        contentLbl.frame = (CGRect){.origin.x = nameLbl.frame.origin.x + nameSize.width + 2, .origin.y = nameLbl.frame.origin.y+1, .size = infoSize};
        int frameHeight = floorf(contentLbl.frame.origin.y+contentLbl.frame.size.height+4>20?contentLbl.frame.origin.y+contentLbl.frame.size.height+4:20);
    
        self.frame = (CGRect){.origin = self.frame.origin,.size.width = self.frame.size.width,.size.height = frameHeight};
        self.bgImage.image = [self.bgImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];

        if (_bgImage) {
            CGRect frame = self.bgImage.frame;
            frame.size.height = self.frame.size.height;
            self.bgImage.frame = frame;

            
        }
        containerView.frame = (CGRect){.origin.x = containerView.frame.origin.x, .origin.y = (self.frame.size.height - containerView.frame.size.height) / 2-4, .size=self.frame.size};

        
    }else if(_commentType ==hasHeadType){
        CGSize size =  CGSizeMake(480, 41);
        self.frame =  (CGRect){.origin = self.frame.origin,.size = size};
        self.bgImage.image = [self.bgImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:50];

        if (_bgImage) {
            CGRect frame = self.bgImage.frame;
            frame.size.height = self.frame.size.height;
            self.bgImage.frame = frame;
            
        }
    }


}
- (void)fillcommentNum:(NSString *)str{
    self.contentLbl.text = str;
}
- (void)fillLoveData:(NSArray  *)arr{
    NSString *str ;
    UIImageView *imageview= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"small_heart.png" ]];
    imageview.frame = CGRectMake(28+83+22-27, 17, 15, 15);
    self.headImgView = imageview;
    [self.containerView addSubview:headImgView];

    for (int i=0; i<[arr count]; i++) {
        if ([arr count]==1) {
            str = $str(@"%@",[[arr objectAtIndex:i] objectForKey:NAME]);
        }else{
            
            if (i==0) {
                str = $str(@"%@",[[arr objectAtIndex:i] objectForKey:NAME]);
            }else{
                NSString *temp = str;
                str = $str(@"%@,%@",temp,[[arr objectAtIndex:i] objectForKey:NAME]);
            }
            
        }
    }
    self.contentLbl.text = str;


}
- (void)fillCommentData:(NSDictionary*)aDict {
    [self setWhichType:noHeadType];
    
    self.nameLbl.text = [aDict objectForKey:COMMENT_AUTHOR_NAME];

    self.contentLbl.text = [NSString stringWithFormat:@":%@", [aDict objectForKey:COMMENT_MESSAGE]];
    self.contentLbl.textColor = [UIColor grayColor];
    
    //[self.timeView fillWithPointInImgAndLblView:CGPointMake(379, 7) withLeftImgStr:@"time.png" withRightText:[Common dateSinceNow:[aDict objectForKey:DATELINE]] withFont:[UIFont boldSystemFontOfSize:TIME_FONT_SIZE] withTextColor:[UIColor lightGrayColor]];
}
@end
