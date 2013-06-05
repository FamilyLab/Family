//
//  ImageAndLabelView.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndLabelView : UIView

//- (id)initWithFrame:(CGRect)frame
//        andTheImage:(UIImage*)_image
//       andLabelText:(NSString*)_text
//           andColor:(UIColor*)_color
//            andSize:(CGFloat)_size;

@property (nonatomic, strong) IBOutlet UIImageView *leftImgView;
@property (nonatomic, strong) IBOutlet UILabel *rightlbl;

- (void)fillWithPointInImgAndLblView:(CGPoint)_point
                      withLeftImgStr:(NSString*)_imgStr
                       withRightText:(NSString*)_text
                            withFont:(UIFont*)_font
                       withTextColor:(UIColor*)_color;

- (void)adjustFrame;

@end
