//
//  SignInMyInfoViewController.m
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SignInMyInfoViewController.h"
#import "AddChildViewController.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "CKMacros.h"
#import "MyHeadButton.h"

@interface SignInMyInfoViewController ()

@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;

@end

@implementation SignInMyInfoViewController
@synthesize headBtn;
@synthesize topViewType;
@synthesize nameField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isHeadChanged = NO;
        isNameChanged = NO;
        isFirstShow = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopView];
    [self addBottomView];
    
    self.nameStr = @"";
    [nameField setInputAccessoryView:[self buildBottomView]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = loginOrSignIn;
    [topView leftBg];
    [topView leftText:@"设置"];
    [topView rightLogo];
    [topView rightLine];
    [self.view addSubview:topView];
}

- (BottomView*)buildBottomView {
    NSArray *normalImages;
    if (isFirstShow) {
        normalImages = [[NSArray alloc] initWithObjects:@"login_ok", nil];
    } else {
        normalImages = [[NSArray alloc] initWithObjects:@"login_ok", @"nextStep", nil];
    }
    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                          type:notAboutTheme
                                                     buttonNum:[normalImages count]
                                               andNormalImages:normalImages
                                             andSelectedImages:nil
                                            andBackgroundImage:@"login_bg"];
    aView.delegate = self;
    return aView;
}

- (void)addBottomView {
    if (self.bottomView) {
        [_bottomView removeFromSuperview];
        _bottomView = nil;
    }
    self.bottomView = [self buildBottomView];
    [self.view addSubview:[self buildBottomView]];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    int btnTag = _button.tag - kTagBottomButton;
    switch (btnTag) {
        case 0:
        {
            [self bgBtnPressed:nil];
            [self okBtnPressed:nil];
            break;
        }
        case 1:
        {
            [self gotoAddChildCon];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)headBtnPressed:(id)sender {
    //更改头像
    MyImagePickerController *picker = [[MyImagePickerController alloc] initWithParent:self];
    [picker showImagePickerMenu:@"选择头像" buttonTitle:@"打开相机" sender:sender];
    [picker.ImagePickerMenu showInView:self.view];
}

#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.view.frame = CGRectMake(0, -105, self.view.frame.size.width, self.view.frame.size.height);
                     }];
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         UIScrollView *scrollView = (UIScrollView*)self.view;
//                         scrollView.contentInset = UIEdgeInsetsMake(-105, 0, 0, 0);
//                     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:self.nameStr]) {
        isNameChanged = NO;
    } else {
        self.nameStr = textField.text;
        isNameChanged = YES;
    }
}

#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    //    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self performSelector:@selector(saveImage:) withObject:myThemeImage afterDelay:0.3f];
}

- (void)saveImage:(UIImage*)_image {
    [headBtn setImage:_image forState:UIControlStateNormal];
    self.theImage = _image;
    isHeadChanged = YES;
}

- (void)gotoAddChildCon {
    AddChildViewController *con = [[AddChildViewController alloc] initWithNibName:@"AddChildViewController" bundle:nil];
    con.topViewType = self.topViewType;
    con.myHeadImage = self.theImage;
    con.myNameStr = nameField.text;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)okBtnPressed:(id)sender {
//    [self gotoAddChildCon];
//    return;
    
    
    if (nameField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称T_T"];
        [SVProgressHUD changeDistance:-60];
        [nameField becomeFirstResponder];
        return;
    }
    
    if (!isFirstShow && !isHeadChanged && !isNameChanged) {
        [self gotoAddChildCon];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"提交中..."];
    [SVProgressHUD changeDistance:-60];
    if (isHeadChanged) {
        [self postHead];
    } else if (isNameChanged) {
        [self postName];
    }
}

- (void)postHead {
    NSString *url = $str(@"%@avatar", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", AVATAR_SUBMIT, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(_theImage, 0.8f) name:@"Filedata" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        isHeadChanged = NO;
        //保存头像
        [Common saveImage:_theImage withQuality:1.0f saveKey:AVATAR];
        if (isNameChanged) {
            [self postName];
        } else {
            [SVProgressHUD dismiss];
            [self gotoAddChildCon];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
        isHeadChanged = YES;
    }];
}

- (void)postName {
//    if (nameField.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"请输入昵称T_T"];
//        return;
//    }
    NSString *url = $str(@"%@name", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:nameField.text, NAME, @"1", NAME_SUBMIT, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        isNameChanged = NO;
        self.theImage = nil;
        
        [ConciseKit setUserDefaultsWithObject:@"默认空间" forKey:LAST_ZONE_NAME];
        
        //保存昵称
        [ConciseKit setUserDefaultsWithObject:nameField.text forKey:NAME];
        [SVProgressHUD dismiss];
        if (isFirstShow) {
            isFirstShow = NO;
//            [self addBottomView];
        }
        [self gotoAddChildCon];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
        isNameChanged = YES;
    }];
}

- (IBAction)bgBtnPressed:(id)sender {
    [self resignKeyboardInView:self.view];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }];
    
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         UIScrollView *scrollView = (UIScrollView*)self.view;
//                         scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//                     }];
}

- (void)resignKeyboardInView:(UIView *)view   {
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyboardInView:v];
        }
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}




@end
