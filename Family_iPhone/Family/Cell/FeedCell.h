//
//  FeedCell.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndLabelView.h"
#import "MyButton.h"
#import "FeedCellHeadView.h"
#import "FeedCellAlbumView.h"
#import "CommentView.h"
#import "MultiTextTypeView.h"
#import "UIImageView+WebCache.h"
#import "PreContentView.h"
//#import "UIButton+WebCache.h"

typedef enum {
    bigImgType          = 0,//大图
    someImgsType        = 1,//多图
    imgAndTextType      = 2,//图文
    onlyTextType        = 3,//纯文本
    locationType        = 4,//地点
    otherHasImgType     = 5,//other，右侧带有图片
    otherNoImgType      = 6 //other，右侧没有图片
} FeedCellType;

@interface FeedCell : UITableViewCell

@property (nonatomic, assign) FeedCellType cellType;
@property (nonatomic, assign) int indexRow;
@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, strong) IBOutlet FeedCellHeadView *headView;
@property (nonatomic, strong) IBOutlet UILabel *timeLbl;

@property (nonatomic, strong) IBOutlet UILabel *comeLbl;

@property (nonatomic, strong) IBOutlet FeedCellAlbumView *albumView;

//BigImgCell
//@property (nonatomic, strong) IBOutlet UIImageView *bigImgView;
//@property (nonatomic, strong) IBOutlet UILabel *bigImgLbl;

@property (nonatomic, strong) IBOutlet UIView *forCommentView;
@property (nonatomic, strong) IBOutlet UIImageView *commentBgImgView;
@property (nonatomic, strong) IBOutlet CommentView *loverView;
@property (nonatomic, strong) IBOutlet CommentView *firstComment;
@property (nonatomic, strong) IBOutlet CommentView *secondComment;
@property (nonatomic, strong) IBOutlet UILabel *totalComentNum;

//@property (nonatomic, strong) IBOutlet UIImageView *lineImgView;

@property (nonatomic, copy) NSString *authorUserId;
@property (nonatomic, assign) int commentNum;

@property (nonatomic, assign) BOOL isRepost;

@property (nonatomic, copy) NSString* tagId;


@property (nonatomic, copy) NSString *allText;
@property (nonatomic, copy) NSString *subjectStr;

@property (nonatomic, strong) NSMutableArray *loveArray;

@property (nonatomic, strong) IBOutlet PreContentView *preContentView;
@property (nonatomic, strong) IBOutlet UIImageView *cellBgImgView;
@property (nonatomic, strong) IBOutlet UIView *typeView;

@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSMutableArray *picArray;

//SomeImgsCell
//@property (nonatomic, strong) IBOutlet UIImageView *firstImgView;
//@property (nonatomic, strong) IBOutlet UIImageView *secondImgView;
//@property (nonatomic, strong) IBOutlet UIImageView *thirdImgView;
//@property (nonatomic, strong) IBOutlet UILabel *imgsNumLbl;
//@property (nonatomic, strong) IBOutlet UILabel *describeLbl;

//LocationCell
//@property (nonatomic, strong) IBOutlet UILabel *dateLbl;
//@property (nonatomic, strong) IBOutlet UILabel *locationLbl;

//other
//@property (nonatomic, strong) IBOutlet MultiTextTypeView *multiTextTypeView;

+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight andLblMaxWidth:(CGFloat)maxWidth;
+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight andLblMaxWidth:(CGFloat)maxWidth andFont:(UIFont*)font;
- (void)initData:(NSDictionary*)aDict;
- (void)initCommonData:(NSDictionary*)aDict;

@end
