//
//  PictureViewTableCell.h
//  family_ver_pm
//
//  Created by pandara on 13-3-23.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "HorizontalTableCell.h"
#import "PictureViewController.h"
#import "TitleBarView.h"
#import "CommentView.h"
#import "TapToEnlargeImageView.h"
#import "TapToEnlargeImageViewDelegate.h"
#import "FlowLayoutLabel.h"
#import "MyTableCell.h"

@interface PictureViewTableCell : MyTableCell<TapToEnlargeImageViewDelegate>

@property (strong, nonatomic) FlowLayoutLabel *content;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIViewController *delegate;
//@property (strong, nonatomic) CommentView *commentView;
@property (strong, nonatomic) TitleBarView *titleBarView;
@property (strong, nonatomic) NSMutableArray *addPictureViewList;

- (void)setTitleLabelMaxWidth:(int)smaxWidth
                      maxLine:(int)smaxLine
                         font:(UIFont *)sfont;
- (void)enlargeImage;
- (void)closeEnlargedImage;
- (void)reblogEnlargedImage;
- (void)downloadEnlargedImage;
- (void)setTitleLable:(NSString *)titleString;
- (void)initElement;
- (void)reset;
- (void)refleshCommentViewLayout;
- (void)refleshScrollContentSize;
- (void)refleshContentLayout;
- (void)setDataFromPhotoDetailDict:(NSDictionary *)photoDetailDict
                 withPhotoInfoList:(NSArray *) photoInfoList
                  atPhotoInfoIndex:(int)index;

@end
