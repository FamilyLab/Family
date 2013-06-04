//
//  MyImagePickerController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-24.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "MyImagePickerController.h"
#import "UIActionSheet+BlocksKit.h"
static BOOL isDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}
@implementation MyImagePickerController
@synthesize ImagePickerMenu;
- (id)initWithParent:(UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>*)parent
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
            [_parent presentModalViewController:picker animated:YES];
            picker = nil;
        }
        else{
            if (isDeviceIPad()) {
                _pickerContainer = [[UIPopoverController alloc] initWithContentViewController:picker];
                
                [_pickerContainer presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:_parent.
                 view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
                [_parent presentModalViewController:picker animated:YES];
            picker = nil;
        }
    }
    else{
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if (isDeviceIPad()) {
            _pickerContainer = [[UIPopoverController alloc] initWithContentViewController:picker];
            CGRect rect = CGRectMake(sender.frame.origin.x+sender.frame.size.width/2, sender.frame.origin.y+sender.frame.size.height, 300, 300) ;
            [_pickerContainer presentPopoverFromRect:rect inView:_parent.
             view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
            [_parent presentModalViewController:picker animated:YES];
        picker = nil;
    }
}
- (void)showImagePickerMenu:(NSString *)title
                buttonTitle:(NSString *)buttonTitle
                     sender:(UIButton *)sender
{
    UIActionSheet *tmp = [UIActionSheet actionSheetWithTitle:title];
    [tmp addButtonWithTitle:buttonTitle handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
    }];
    [tmp addButtonWithTitle:@"本地图库" handler:^{
//        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary sender:sender];
        [self showImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:sender];
    }];
    [tmp setCancelButtonWithTitle:@"取消" handler:^{
        return;
    }];
    self.ImagePickerMenu = tmp;
//    [ImagePickerMenu showInView:_parent.view];
}

- (void)showImagePickerMenu:(NSString *)title buttonTitle:(NSString *)buttonTitle destructiveTitle:(NSString*)destructiveTitle sender:(UIButton *)sender otherTitle:(NSString*)otherTitle, ... {
    
    UIActionSheet *tmp = [UIActionSheet actionSheetWithTitle:title];
    
    if (destructiveTitle && ![destructiveTitle isEqualToString:@""]) {
        [tmp setDestructiveButtonWithTitle:destructiveTitle handler:^{
            ;
        }];
    }
    
    [tmp addButtonWithTitle:buttonTitle handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
    }];
    [tmp addButtonWithTitle:@"本地图库" handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:sender];
    }];
    
    va_list list;
    va_start(list, otherTitle);
    id arg;
    if (otherTitle) {
        [tmp addButtonWithTitle:otherTitle];
        
        while ((arg = va_arg(list, id))) {
            if (arg) {
                [tmp addButtonWithTitle:arg];
            }
        }
        va_end(list);
    }
    
    [tmp setCancelButtonWithTitle:@"取消" handler:^{
        return;
    }];
    self.ImagePickerMenu = tmp;
//    [ImagePickerMenu showInView:_parent.view];
}

@end
