//
//  CommentView.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndLabelView.h"
#import "MyHeadButton.h"

typedef enum {
    hasHeadType      = 0,
    noHeadType       = 1,
    onlyALabelType   = 2,
    
    leftIsImage      = 3,
    leftIsText       = 4
} CommentType;

@interface CommentView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *headImgView;
@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *contentLbl;
@property (nonatomic, strong) IBOutlet ImageAndLabelView *timeView;

@property (nonatomic, strong) IBOutlet UIButton *frontBtn;
@property (nonatomic, strong) IBOutlet UIImageView *lineImgView;

@property (nonatomic, assign) CommentType commentType;

//- (void)setWhichType:(CommentType)_type;

- (void)fillCommentData:(NSDictionary*)aDict;

@end
