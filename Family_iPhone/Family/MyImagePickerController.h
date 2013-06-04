//
//  MyImagePickerController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-24.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyImagePickerController : NSObject
@property (nonatomic, strong) UIPopoverController *pickerContainer;
@property (nonatomic, strong) UIActionSheet *ImagePickerMenu;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, unsafe_unretained)UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *parent;
- (void)showImagePickerMenu:(NSString *)title
                buttonTitle:(NSString *)buttonTitle
                     sender:(UIView *)sender;
- (id)initWithParent:(UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>*)parent;

- (void)showImagePickerMenu:(NSString *)title buttonTitle:(NSString *)buttonTitle destructiveTitle:(NSString*)destructiveTitle sender:(UIView *)sender otherTitle:(NSString*)otherTitle, ...;

@end
