//
//  OperateView.h
//  Family
//
//  Created by Aevitx on 13-1-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"

typedef void (^BtnPressedBlock)(int tag);//定义块类型BtnPressedBlock: 点击按钮时的回调

@interface OperateView : UIView {
    //int currIndex;
    //IBOutlet UIImageView *delter_image;
}

//@property (nonatomic, copy) BtnPressedBlock btnPressedBlock;
//@property (nonatomic, assign) int btnNum;
//@property (nonatomic, strong) UIImageView *arrowImgView;
//@property (nonatomic, strong) IBOutlet MyButton *albumBtn;
//@property (nonatomic, strong) IBOutlet UIButton *commentBtn;
//@property (nonatomic, strong) IBOutlet UIButton *joinBtn;
@property (nonatomic,strong)IBOutlet UILabel *infoLabel;
@property (nonatomic,strong)IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)IBOutlet UILabel *comeLabel;
- (void)initWithBtnNum:(int)_num everyBtnSize:(CGSize)_size btnTexts:(NSArray*)_textArray withAction:(BtnPressedBlock)_block;
- (IBAction)switchComment:(UIButton *)sender;
@end
