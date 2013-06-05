//
//  SignInMyInfoViewController.h
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "MyImagePickerController.h"
@interface SignInMyInfoViewController : BaseViewController < UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong)MyImagePickerController *picker;
@property (nonatomic,strong)IBOutlet UITextField *nickName;
@property (nonatomic,assign)BOOL didPickImage;
- (IBAction)okBtnPressed:(id)sender;

@end
