//
//  PictureViewTableCell.m
//  family_ver_pm
//
//  Created by pandara on 13-3-23.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "PictureViewTableCell.h"
#import "EnlargeImageBottomBar.h"
#import "TitleBarView.h"
#import "PinchImageView.h"
#import "TapToEnlargeImageView.h"
#import "FlowLayoutLabel.h"
#import "SVProgressHUD.h"
#import "SBToolKit.h"
#import "UIImageView+AFNetworking.h"

@implementation PictureViewTableCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"initWithFrame in PictureViewtablecell");
        self.backgroundColor = [UIColor whiteColor];
        self.reuseID = PHOTO;
    }
    return self;
}

- (void)initElement
{
    //config scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    [self addSubview:self.scrollView];
    
    //config commentView
    self.commentView = [[CommentView alloc] initWithFrame:COMMENT_VIEW_DEFAULT_FRAME];
    [self.scrollView addSubview:self.commentView];
    
    //config titlebar
    self.titleBarView = [[TitleBarView alloc] initWithFrame:CGRectMake(0, 0, TITLE_BAR_DEFAULT_SIZE.width, TITLE_BAR_DEFAULT_SIZE.height)];
    [self.scrollView addSubview:self.titleBarView];
    
    //config contentView
    self.content = [[FlowLayoutLabel alloc] initWithFrame:CGRectMake(PICTURE_VIEW_CONTENT_DEFAULT_ORIGIN.x, PICTURE_VIEW_CONTENT_DEFAULT_ORIGIN.y, 100, 100)];
    [self.scrollView addSubview:self.content];
    
    //config photoList
    self.addPictureViewList = [[NSMutableArray alloc] init];
}

//重新设置contentSize
//去掉多余图片
//重设commentView
- (void)reset
{
    //重置scrollView
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = PICTURE_VIEW_DEFAULT_CONTENTSIZE;
    
    //重置commentView
    [self.commentView reset];

    //重置content frame
    self.content.frame = CGRectMake(PICTURE_VIEW_CONTENT_DEFAULT_ORIGIN.x, PICTURE_VIEW_CONTENT_DEFAULT_ORIGIN.y, PICTURE_VIEW_DEFAULT_IMAGE_SIZE.width, PICTURE_VIEW_DEFAULT_IMAGE_SIZE.height);
    
    //重置图片数组
    [self.addPictureViewList makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.addPictureViewList removeAllObjects];
}

- (void)reblogEnlargedImage
{
    NSLog(@"reblog Image");
}

- (void)downloadEnlargedImage
{
    NSLog(@"download Image");
}

- (void)setTitleLabelMaxWidth:(int)smaxWidth maxLine:(int)smaxLine font:(UIFont *)sfont
{
    [self.titleBarView setTitleLabelMaxWidth:smaxWidth maxLine:smaxLine font:sfont];
}

- (void)setTitleLable:(NSString *)titleString
{
    [self.titleBarView setTitle:titleString];
}

//刷新所有布局
- (void)refleshLayout
{
    [self refleshPictureLayout];
    [self refleshContentLayout];
    [self refleshCommentViewLayout];
    [self refleshScrollContentSize];
}

//刷新所有图片布局
- (void)refleshPictureLayout
{
    int pictureCount = [self.addPictureViewList count];
    if (pictureCount > 1) {
        for (int i = 1; i < pictureCount; i++) {
            CGRect prevPictureFrame = [[self.addPictureViewList objectAtIndex:i-1] frame];
            CGRect originFrame = [[self.addPictureViewList objectAtIndex:i] frame];
            
            if (originFrame.origin.y != prevPictureFrame.origin.y + prevPictureFrame.size.height + PICTURE_VIEW_IMAGE_INTERVAL) {
                [[self.addPictureViewList objectAtIndex:i] setFrame:CGRectMake(originFrame.origin.x, prevPictureFrame.origin.y + prevPictureFrame.size.height + PICTURE_VIEW_IMAGE_INTERVAL, originFrame.size.width, originFrame.size.height)];
            }
        }
    }
}

//刷新content布局
- (void)refleshContentLayout
{
    CGRect frame = self.content.frame;
    CGRect lastImageFrame = [self lastImageRect];
    self.content.frame = CGRectMake(frame.origin.x, lastImageFrame.origin.y + lastImageFrame.size.height + PICTURE_VIEW_IMAGE_INTERVAL, frame.size.width, frame.size.height);
}

//刷新contentSize
- (void)refleshScrollContentSize
{
//    CGRect commentRect = self.commentView.frame;
    self.scrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, self.commentView.frame.origin.y + self.commentView.frame.size.height + BOTTOM_BAR_SIZE.height);
}

//刷新评论布局
- (void)refleshCommentViewLayout
{
    CGRect frame = self.commentView.frame;
    self.commentView.frame = CGRectMake(frame.origin.x, self.content.frame.origin.y + self.content.frame.size.height + PICTURE_VIEW_IMAGE_INTERVAL, frame.size.width, frame.size.height);
}

//获取图片
int pictureCount = 1;
- (void)setDataFromPhotoDetailDict:(NSDictionary *)photoDetailDict//包含照片详情
                 withPhotoInfoList:(NSArray *) photoInfoList//用于评论获取
                  atPhotoInfoIndex:(int)index
{
    //设置标题bar
    NSString *title = [(NSString *)[photoDetailDict objectForKey:SUBJECT] isEqualToString: @"" ]? TITLE_DEFAULT_TEXT:(NSString *)[photoDetailDict objectForKey:SUBJECT];
    [self setTitleLabelMaxWidth:TITLE_TEXT_MAX_WIDTH maxLine:2 font:[UIFont systemFontOfSize:TITLE_FONT_SIZE]];
    [self setTitleLable:title];
    NSString *name = [photoDetailDict objectForKey:NAME];
    [self.titleBarView setAuthor:name];
    [self.titleBarView setDate:[SBToolKit dateSinceNow:[photoDetailDict objectForKey:DATELINE]]];
    
    //设置图片
    if ([[photoDetailDict objectForKey:PICLIST] count] != 0) {//picList字段里信息数量不为零
        //取出列表中的图片
        NSArray *picList = [photoDetailDict objectForKey:PICLIST];
        pictureCount = [picList count];
        
        for (int i = 0; i < pictureCount; i++) {
            TapToEnlargeImageView *imageView = [[TapToEnlargeImageView alloc]
                                                initWithFrame:CGRectMake(PICTURE_VIEW_DEFAULT_IMAGE_ORIGIN.x,
                                                                         self.titleBarView.frame.origin.y + self.titleBarView.frame.size.height + PICTURE_VIEW_IMAGE_INTERVAL + (PICTURE_VIEW_DEFAULT_IMAGE_SIZE.height + PICTURE_VIEW_IMAGE_INTERVAL) * i, PICTURE_VIEW_DEFAULT_IMAGE_SIZE.width, PICTURE_VIEW_DEFAULT_IMAGE_SIZE.height)];
            imageView.delegate = self;
            [self.addPictureViewList addObject:imageView];
            [self.scrollView addSubview:imageView];
            [self refleshLayout];
            //拉取图片
            //??一边设置以便获取数据还是先设置好布局再获取数据？
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:(NSString *)[[picList objectAtIndex:i] objectForKey:FILEPATH]]] placeholderImage:PICTUREVIEW_PLACEHOLDER_IMG success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [imageView stopActivityView];
                imageView.image = image;
                //按比例伸缩图片
                int height = imageView.frame.size.width / image.size.width * image.size.height;
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, height);
                
                [self refleshLayout];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"get image faile with error:%@ and request:%@", error, request);
                [SVProgressHUD showErrorWithStatus:@"网络不好。。"];
            }];
            NSLog(@"从这个request取图片:%@", [NSURLRequest requestWithURL:[NSURL URLWithString:(NSString *)[[picList objectAtIndex:i] objectForKey:FILEPATH]]]);
        }//for
    } else {//picList字段里信息数量为零
        TapToEnlargeImageView *imageView = [[TapToEnlargeImageView alloc] initWithFrame:CGRectMake(PICTURE_VIEW_DEFAULT_IMAGE_ORIGIN.x, self.titleBarView.frame.origin.y + self.titleBarView.frame.size.height + PICTURE_VIEW_IMAGE_INTERVAL, PICTURE_VIEW_DEFAULT_IMAGE_SIZE.width, PICTURE_VIEW_DEFAULT_IMAGE_SIZE.height)];
        imageView.delegate = self;
        [self.addPictureViewList addObject:imageView];        //获取图片成功后
        [self.scrollView addSubview:imageView];
        [self refleshLayout];
        
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:(NSString *)[photoDetailDict objectForKey:PIC]]] placeholderImage:PICTUREVIEW_PLACEHOLDER_IMG success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [imageView stopActivityView];
            imageView.image = image;
            
            //按比例伸缩图片
            int height = imageView.frame.size.width / image.size.width * image.size.height;
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, height);
            [self refleshLayout];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"getting image failed %@", error);
        }];
    }
    
    //设置内容布局，当图片正在加载或者无网络连接时
    NSString *content = [(NSString *)[photoDetailDict objectForKey:MESSAGE] isEqualToString:@""]? PICTURE_VIEW_CONTENT_EMPTY_TEXT:[photoDetailDict objectForKey:MESSAGE];
    [self.content setMaxWidth:DEVICE_SIZE.width maxLine:0 font:[UIFont systemFontOfSize:PICTURE_VIEW_CONTENT_FONT_SIZE]];
    [self.content setTextContent:content];
    
    //设置评论布局(作用于当网络无连接时的布局)
    CGRect commentFrame = self.commentView.frame;
    self.commentView.frame = CGRectMake(commentFrame.origin.x, self.content.frame.origin.y + self.content.frame.size.height + PICTURE_VIEW_IMAGE_INTERVAL, commentFrame.size.width, commentFrame.size.height);
    
    NSString *itemID = [photoDetailDict objectForKey:PHOTOID];
    if (itemID == nil) {
        itemID = [photoDetailDict objectForKey:ID];
    }
    [self.commentView requestCommentListFromObjectID:itemID
                                           andIDtype:PHOTOID
                                              atPage:1
                                    withSuccessBlock:^(id sender) {
                                         [self refleshLayout];
                                    }];
    
}

- (CGRect)lastImageRect
{
    return [[self.addPictureViewList lastObject] frame];
}

#pragma mark TapToEnlargeImageViewDelegate
- (void)addEnlargeImageView:(UIView *)enlargeView
{
    [self.delegate.view addSubview:enlargeView];
    [UIView animateWithDuration:0.3f animations:^{enlargeView.alpha = 1;}];
}

@end
