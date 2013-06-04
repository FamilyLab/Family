//
//  BottomView.h
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    tabBarType      = 0,
    aboutTheme      = 1,
    notAboutTheme   = 2
} BottomViewType;

@protocol BottomViewDelegate;

@interface BottomView : UIView

@property (nonatomic, assign) BottomViewType bottomViewType;
@property (nonatomic, assign) int buttonNum;
@property (nonatomic, strong) NSArray *normalImagesArray;
@property (nonatomic, strong) NSArray *selectedImagesArray;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, copy) NSString *bgImageStr;
//@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, assign) id<BottomViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame
               type:(BottomViewType)_type
          buttonNum:(NSInteger)_num
    andNormalImages:(NSArray*)_normalImages
  andSelectedImages:(NSArray*)_selectedImages
 andBackgroundImage:(NSString*)_bgImageStr;

@end


@protocol BottomViewDelegate <NSObject>

- (void)userPressedTheBottomButton:(BottomView*)_view andButton:(UIButton*)_button;

@end
