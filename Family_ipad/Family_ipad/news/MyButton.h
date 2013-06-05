//
//  MyButton.h
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    SMALL,
    MIDDLE,
    BIG
}HEAD_SIZE;
typedef enum
{
    HEAD_BTN,
    ZONE_BTN
}ButtonType;
@interface MyButton : UIButton
{
    UIImageView *v_logo;
}
@property (nonatomic,copy)NSString *identify;
@property (nonatomic,assign)ButtonType type;
@property (nonatomic,copy)NSString *extraInfo;
@property (nonatomic,strong)UIImageView *v_logo;
- (NSURL *)headImgURLWith:(HEAD_SIZE)size
                      url:(NSString *)url;
- (void)setVipStatusWithStr:(NSString*)vipStatus isSmallHead:(BOOL)isSmallHead;
- (void)setImageForMyHeadButtonWithUrlStr:(NSString*)urlStr
                       plcaholderImageStr:(NSString*)placeholderImageStr
                                     size:(HEAD_SIZE)size;
@end