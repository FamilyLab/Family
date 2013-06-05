//
//  slideView.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-25.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface slideView : UIView
{
    UIButton *preSelectButton;

}
@property (nonatomic,strong)IBOutlet UIImageView *delter_image;
- (IBAction)switchWantToSay:(id)sender;

@end
