//
//  BottomBarView.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackBottomBarViewDelegate;

@interface BackBottomBarView : UIView

@property(nonatomic, assign) NSInteger buttonNum;
@property(nonatomic, retain) NSArray *normalImg;
@property(nonatomic, retain) NSArray *selectedImg;
@property(nonatomic, retain) NSString *bgImageView;
@property(nonatomic, assign) id <BackBottomBarViewDelegate> delegate;

- (id)initWithFrame:(CGRect)_frame
        numOfButton:(NSInteger)_num
     andNormalImage:(NSArray*)_normalImage
   andSelectedImage:(NSArray*)_selectedImage
backgroundImageView:(NSString*)_bgImg;
@end

@protocol BackBottomBarViewDelegate <NSObject>

-(void)userPressTheBottomButton:(BackBottomBarView*)_view andTheButton:(UIButton*)_button;

@end