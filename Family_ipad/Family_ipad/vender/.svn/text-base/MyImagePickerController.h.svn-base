//
//  MyImagePickerController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-24.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyImagePickerController : NSObject
@property (nonatomic,strong)UIPopoverController *pickerContainer;
@property (nonatomic,assign)id <UINavigationControllerDelegate,UIImagePickerControllerDelegate> parent;
- (void)showImagePickerMenu:(NSString *)title
                buttonTitle:(NSString *)buttonTitle
                     sender:(UIButton *)sender;
- (id)initWithParent:(id <UINavigationControllerDelegate,UIImagePickerControllerDelegate>)parent;
@end
