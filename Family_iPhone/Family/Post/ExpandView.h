//
//  ExpandView.h
//  Family
//
//  Created by Aevitx on 13-1-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExpandViewDelegate;

typedef enum {
    postHitError    = -1,
    postPhoto       = 0,
    postDiary       = 1,
    postPrivateMsg  = 2,
    postActivity    = 3,
    postVideo       = 4,
    postWantToSay   = 5
} PostType;


@interface ExpandView : UIView

@property (nonatomic, assign) PostType postType;

@property (nonatomic, strong) IBOutlet UIButton *selectTypeBtn;
@property (nonatomic, strong) IBOutlet UILabel *currTypeLbl;
@property (nonatomic, strong) IBOutlet UIView *typeContainerView;
@property (nonatomic, strong) IBOutlet UIImageView *bgImgView;
@property (nonatomic, strong) IBOutlet UIButton *directBtn;

@property (nonatomic, assign) id<ExpandViewDelegate>delegate;

- (void)fillTheme;
//- (PostType)getPostTypeWithBtnTitle:(NSString*)_title;
- (void)selecteWantToSayThroughOtherView:(UIButton*)sender;
- (void)expand;
- (void)changeTypeAndTextWithButton:(UIButton*)sender;

@end


@protocol ExpandViewDelegate <NSObject>

- (void)userPressedTheSelectBtn:(ExpandView*)_expandView;

@end