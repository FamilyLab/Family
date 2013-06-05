//
//  SignInMyInfoViewController.m
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SignInMyInfoViewController.h"
#import "AddChildViewController.h"
#import "MyImagePickerController.h"
#import "MyHttpClient.h"
#import "NSObject+BlocksKit.h"
#import "Common.h"
@interface SignInMyInfoViewController ()

@property (nonatomic, strong) IBOutlet UIButton *headBtn;

@end

@implementation SignInMyInfoViewController
@synthesize headBtn;
- (void)uploadAvatar{
    NSString *url = $str(@"%@avatar", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys: ONE, AVATAR_SUBMIT, POST_M_AUTH,M_AUTH , nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(headBtn.imageView.image, 1.0f) name:@"Filedata" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [ConciseKit setUserDefaultsWithObject:[[[dict objectForKey:WEB_DATA] objectForKey:@"url"] objectForKey:@"small"] forKey:AVATAR_URL];

    }failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)


- (IBAction)okBtnPressed:(id)sender {
    if (DEBUGMOD) {
        AddChildViewController *con = [[AddChildViewController alloc] initWithNibName:@"AddChildViewController" bundle:nil];
        [self.navigationController pushViewController:con animated:YES];
        [con adjustLayout];
    }
    else{
        if (_nickName.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"昵称不能为空T_T"];
            return;
        }
        NSString *url = $str(@"%@name", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_nickName.text, NAME, ONE, NAME_SUBMIT, POST_M_AUTH,M_AUTH , nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [self performBlock:^(id sender) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                AddChildViewController *con = [[AddChildViewController alloc] initWithNibName:@"AddChildViewController" bundle:nil];
                [self.navigationController pushViewController:con animated:YES];
                [con adjustLayout];
            } afterDelay:0.5f];
            //保存昵称
            [ConciseKit setUserDefaultsWithObject:_nickName.text forKey:NAME];
            if (_didPickImage) {
                [self uploadAvatar];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
        

    }
}

- (IBAction)headBtnPressed:(UIButton *)sender {
    //更改头像
    _picker = [[MyImagePickerController alloc]initWithParent:self];
    [_picker showImagePickerMenu:@"上传头像" buttonTitle:@"拍一张新的照片" sender:sender];
}



#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    //    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self performSelector:@selector(saveImage:) withObject:myThemeImage afterDelay:0.3f];
    [_picker.pickerContainer dismissPopoverAnimated:YES];
    _picker = nil;
    _didPickImage = YES;
}

- (void)saveImage:(UIImage*)_image {
    [headBtn setImage:_image forState:UIControlStateNormal];
}





@end
