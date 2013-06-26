//
//  FeedCell.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndLabelView.h"
#import "FeedCellHeadView.h"
#import "FeedCellAlbumView.h"
#import "CommentView.h"
#import "MultiTextTypeView.h"
#import "web_config.h"
#import "UIImageView+AFNetworking.h"
#import "MWPhotoBrowser.h"

typedef enum {
    bigImgType          = 0,
    someImgsType        = 1,
    imgAndTextType      = 2,
    onlyTextType        = 3,
    locationType        = 4,
    otherHasImgType    = 5,
    otherNoImgType     = 6
} FeedCellType;

@interface FeedCell : UITableViewCell<MWPhotoBrowserDelegate>
{
    CommentView *commentNumView;
}
@property (nonatomic, assign) FeedCellType cellType;
@property (nonatomic, assign) int indexRow;
@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, strong) IBOutlet FeedCellHeadView *headView;

@property (nonatomic, strong) IBOutlet FeedCellAlbumView *albumView;


@property (nonatomic, strong) IBOutlet CommentView *firstComment;
@property (nonatomic, strong) IBOutlet CommentView *secondComment;
@property (nonatomic, strong) IBOutlet CommentView *thirdComment;
@property (nonatomic, strong) IBOutlet CommentView *commentNumView;
@property (nonatomic, strong) IBOutlet UIImageView *lineImgView;
@property (nonatomic, strong) IBOutlet UILabel *comeFromeLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) NSMutableArray *picArray;

@property (nonatomic, assign) BOOL isRepost;
@property (nonatomic, copy) NSString *authorUserId;

- (void)initData:(NSDictionary*)_aDict;
- (void)initCommonData:(NSDictionary*)aDict;
- (NSURL *)genreateImgURL:(NSString*)row_url
                     size:(NSString*)size;
- (NSString*)buildAllText:(NSDictionary *)feedDict;
- (NSString*)buildSubjectText:(NSDictionary *)feedDict;
- (void)setTapAction:(UIImageView *)sender
                 url:(NSURL *)url
               index:(NSUInteger)index;
@end
