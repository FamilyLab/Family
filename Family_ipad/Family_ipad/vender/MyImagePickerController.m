//
//  MyImagePickerController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-24.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "MyImagePickerController.h"
#import "UIActionSheet+BlocksKit.h"
#import "PostBaseView.h"
#import "AppDelegate.h"
#import "RootViewController.h"
static BOOL isDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}
@implementation MyImagePickerController
- (id)initWithParent:(id  <UINavigationControllerDelegate,UIImagePickerControllerDelegate>)parent
{
    self = [super init];
    if (self) {
        _parent = parent;
    }
    return self;
}
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceTye
                 sender:(UIButton *)sender

{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate = _parent;
    picker.allowsEditing = YES;
    if (sourceTye == UIImagePickerControllerSourceTypeCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([_parent isKindOfClass:[UIViewController class]]) {
                [(UIViewController *)_parent presentModalViewController:picker animated:YES];
            }
            else if  ([_parent isKindOfClass:[UIView class]]){
                [[AppDelegate instance].rootViewController presentModalViewController:picker animated:YES];
            }
            picker = nil;
        }
        else{
            if (isDeviceIPad()) {
                _pickerContainer = [[UIPopoverController alloc] initWithContentViewController:picker];
                if ([_parent isKindOfClass:[UIViewController class]])
                    [_pickerContainer presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:((UIViewController *) _parent).
                 view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                else if  ([_parent isKindOfClass:[UIView class]])
                    [_pickerContainer presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:(UIView *)_parent permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else{
                if ([_parent isKindOfClass:[UIViewController class]])
                        [(UIViewController *)_parent presentModalViewController:picker animated:YES];
                }
            picker = nil;
        }
    }
    else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (isDeviceIPad()) {
            _pickerContainer = [[UIPopoverController alloc] initWithContentViewController:picker];
            CGRect rect = CGRectMake(sender.frame.origin.x+sender.frame.size.width/2, sender.frame.origin.y+sender.frame.size.height, 300, 300) ;
            if ([_parent isKindOfClass:[UIViewController class]])
                [_pickerContainer presentPopoverFromRect:rect inView:((UIViewController *) _parent).
                 view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            else if  ([_parent isKindOfClass:[UIView class]])
                [_pickerContainer presentPopoverFromRect:rect inView:(UIView *)_parent permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else{
            if ([_parent isKindOfClass:[UIViewController class]])
            [(UIViewController *)_parent presentModalViewController:picker animated:YES];
        }
        picker = nil;
    }
}
- (void)showImagePickerMenu:(NSString *)title
                buttonTitle:(NSString *)buttonTitle
                     sender:(UIButton *)sender
{
    UIActionSheet *ImagePickerMenu = [UIActionSheet actionSheetWithTitle:title];
    [ImagePickerMenu addButtonWithTitle:buttonTitle handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
    }];
    [ImagePickerMenu addButtonWithTitle:@"本地图库" handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary sender:sender];
    }];
    if ([_parent isKindOfClass:[UIViewController class]])
        [ImagePickerMenu showInView:((UIViewController *)_parent).view];
    else if  ([_parent isKindOfClass:[UIView class]])
        [ImagePickerMenu showInView:(UIView *)_parent];

    

}
@end
