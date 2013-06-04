//
//  AddChildViewController.m
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "AddChildViewController.h"
#import "AddFriendsViewController.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"
#import "MoreViewController.h"
//#import "UIButton+WebCache.h"
#import "MyHeadButton.h"

#define moveLength  160

@interface AddChildViewController ()

@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;
@property (nonatomic, strong) IBOutlet UIButton *sexBtn;
@property (nonatomic, assign) BOOL isBoy;

@end

@implementation AddChildViewController
@synthesize headBtn, sexBtn, isBoy;
@synthesize topViewType;
@synthesize containerView, cellHeader;
@synthesize nameField;//, birthdayField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isBoy = YES;
        _isAddAZone = NO;
        _isShowChildInfo = NO;
//        _hasChangeButNotPressedOkBtn = NO;
        _canEditChildInfo = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopView];
    [self addBottomView];
    
    if (_isAddAZone) {
        [_birthdayImgView removeFromSuperview];
        [_birthdayLbl removeFromSuperview];
        [sexBtn removeFromSuperview];
        nameField.placeholder = @"空间名称";
    } else {
        _birthdayLbl.userInteractionEnabled = YES;
        [_birthdayLbl whenTapped:^{
            if ([nameField isFirstResponder]) {
                [nameField resignFirstResponder];
            }
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 UIScrollView *scrollView = (UIScrollView*)self.view;
                                 scrollView.contentInset = UIEdgeInsetsMake(-moveLength, 0, 0, 0);
                             }];
            [self showDatePicker];
        }];
    }
    [nameField setInputAccessoryView:[self buildBottomView]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = self.topViewType;
    
    if (self.topViewType == loginOrSignIn) {
        [self.cellHeader removeFromSuperview];
        self.cellHeader = nil;
        [topView leftBg];
        [topView leftText:@"孩子"];
        [topView rightLogo];
        [topView rightLine];
    } else if (self.topViewType == notLoginOrSignIn) {
        [topView leftHeadAndName];
        
        self.containerView.frame = (CGRect){.origin.x = 0, .origin.y = 70, .size = self.containerView.frame.size};
        NSString *headerName = _isAddAZone ? @"创建空间" : @"孩子空间";
        cellHeader.frame = (CGRect){.origin = CGPointMake(0, 50), .size.width = DEVICE_SIZE.width, .size.height = [CellHeader getHeaderHeightWithText:headerName].height};
        [cellHeader initHeaderDataWithMiddleLblText:headerName];
        
        if (_myHeadImage) {
            [topView.leftHeadBtn setImage:_myHeadImage forState:UIControlStateNormal];
        } else {
            [topView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:_myHeadUrl plcaholderImageStr:nil];
            [topView.leftHeadBtn setVipStatusWithStr:emptystr(MY_VIP_STATUS) isSmallHead:YES];
//            [topView.leftHeadBtn setImageWithNoCacheWithURL:[NSURL URLWithString:_myHeadUrl] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
        }
        topView.leftNameLbl.text = _myNameStr;
        [topView setNeedsLayout];
    }
    [self.view addSubview:topView];
}

- (BottomView*)buildBottomView {
    NSArray *normalImages;
    if (self.topViewType == loginOrSignIn) {
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"login_ok", @"login_pass", nil];
    } else
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"login_ok", nil];
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
    BottomView *aView = [self buildBottomView];
    self.bottomView = aView;
    [self.view addSubview:aView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    switch (_button.tag - kTagBottomButton) {
        case 0:
        {
//            NSString *sexStr = isBoy ? @"男" : @"女";
//            if (_theImage || ![_preNameStr isEqualToString:nameField.text] || ![_preBirthdayStr isEqualToString:_birthdayLbl.text] || ![_preSexStr isEqualToString:sexStr]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已更改了孩子信息，是否放弃此次更改?"];
//                [alert addButtonWithTitle:@"修改" handler:^{
//                    [self okBtnPressed:nil];
//                }];
//                [alert setCancelButtonWithTitle:@"取消" handler:^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                    return ;
//                }];
//                [alert show];
//            } else {
                [self.navigationController popViewControllerAnimated:YES];
//            }
            break;
        }
        case 1:
        {
            if (_isAddAZone) {
                [self addZonePressed:nil];
            } else {
                [self bgBtnPressed:nil];
                [self okBtnPressed:nil];
            }
            break;
        }
        case 2:
        {
            AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
            con.topViewType = self.topViewType;
            [self.navigationController pushViewController:con animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         UIScrollView *scrollView = (UIScrollView*)self.view;
                         scrollView.contentInset = UIEdgeInsetsMake(-moveLength, 0, 0, 0);
                         
                         if (_datePicker) {
                             CGRect pickerFrame = _datePicker.frame;
                             pickerFrame.origin.y = DEVICE_SIZE.height;
                             _datePicker.frame = pickerFrame;
                         }
                     } completion:^(BOOL finished) {
                         if (_datePicker) {
                             [_datePicker removeFromSuperview];
                             _datePicker = nil;
                         }
                     }];
}

- (void)showDatePicker {
    if (_datePicker) {
        return;
    }
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self.datePicker = picker;
    _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //note we are using CGRectZero for the dimensions of our picker view,
    //this is because picker views have a built in optimum size,
    //you just need to set the correct origin in your view.
    //
    //position the picker at the bottom
    _datePicker.datePickerMode = UIDatePickerModeDate;
    CGSize pickerSize = [_datePicker sizeThatFits:CGSizeZero];
    _datePicker.frame = [self pickerFrameWithSize:pickerSize];
    
    __block UILabel *blockBirthdayLbl = _birthdayLbl;
    [_datePicker removeEventHandlersForControlEvents:UIControlEventValueChanged];
    [_datePicker addEventHandler:^(id sender) {
        UIDatePicker *currDatePicker = (UIDatePicker*)sender;
        NSDate *selectedDate = [currDatePicker date];
        if ([selectedDate compare:[NSDate date]] == NSOrderedDescending) {
            [SVProgressHUD showErrorWithStatus:@"生日不能超过当前时间T_T"];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [dateFormatter stringFromDate:selectedDate];
        blockBirthdayLbl.text = dateString;
        blockBirthdayLbl.textColor = [UIColor darkGrayColor];
        
    } forControlEvents:UIControlEventValueChanged];
    
//    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    topView.barStyle = UIBarStyleBlack;
//    //        UIBarButtonItem *currDateBtn = [[UIBarButtonItem alloc] initWithTitle:@"当前时间" style:UIBarButtonItemStyleBordered target:self action:@selector(currDateBtnPressed)];
//    UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
//        [self bgBtnPressed:nil];
//    }];
//    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
//        
//        NSDate *selectedDate = [_datePicker date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyy-MM-dd";
//        
//        NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:selectedDate]];
//        _birthdayLbl.text = dateString;
//        _birthdayLbl.textColor = [UIColor darkGrayColor];
//        [self bgBtnPressed:nil];
//    }];
//    NSArray *btnArray = [NSArray arrayWithObjects:spaceBtn, cancleBtn, doneBtn, nil];
//    [topView setItems:btnArray];
//    [_datePicker addSubview:topView];
    
    _bottomView.frame = CGRectMake(0, DEVICE_SIZE.height - _datePicker.frame.size.height - _bottomView.frame.size.height + moveLength, DEVICE_SIZE.width, _bottomView.frame.size.height);
    
    //add this picker to our view controller, initially hidden
    [self.view addSubview:_datePicker];
}

// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(0, screenRect.size.height - size.height + moveLength, size.width, size.height);
	return pickerRect;
}

#pragma mark - my method(s)
//增加空间
- (void)addZonePressed:(id)sender {
    if (nameField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    [SVProgressHUD showWithStatus:@"创建空间中..."];
    [SVProgressHUD changeDistance:-60];
    if (_theImage) {
        [self uploadImage:_theImage];
    } else
        [self uploadRequestToAddZone];
}

- (void)uploadRequestToAddZone {
//    AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
//    con.topViewType = self.topViewType;
//    [self.navigationController pushViewController:con animated:YES];
//    return;
    
    NSString *url = $str(@"%@tag", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:nameField.text, TAG_NAME, @"1", TAGS_SUBMIT, emptystr(self.picUrlForAddZone), PIC, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:UIImageJPEGRepresentation(_theImage, 0.8f) name:@"Filedata" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
        [SVProgressHUD changeDistance:-60];
        if (topViewType == loginOrSignIn) {
            AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
            con.topViewType = self.topViewType;
            [self.navigationController pushViewController:con animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}

//添加孩子
- (void)okBtnPressed:(id)sender {
    if (!_canEditChildInfo) {
        [self uploadRequestToAddChild];
    } else {//从“更多”页面进来的
        if (_theImage) {
            [self uploadImage:_theImage];
        } else {
            [self uploadRequestToChangeChildInfo];
        }
    }
}

//添加孩子
- (void)uploadRequestToAddChild {
//    AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
//    con.topViewType = self.topViewType;
//    [self.navigationController pushViewController:con animated:YES];
//    return;
    
    if (nameField.text.length == 0 || [_birthdayLbl.text isEqualToString:@"生日"]) {
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    [SVProgressHUD showWithStatus:@"增加孩子信息中..."];
    [SVProgressHUD changeDistance:-60];
    NSString *url = $str(@"%@baby", POST_CP_API);
    NSString *sexStr = isBoy ? @"男" : @"女";
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:nameField.text, @"babyname", sexStr, @"babysex", _birthdayLbl.text, @"babybirthday", @"1", BABY_SUBMIT, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(_theImage, 0.8f) name:@"Filedata" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"增加成功"];
        [SVProgressHUD changeDistance:-60];
        if (topViewType == loginOrSignIn) {
            AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
            con.topViewType = self.topViewType;
            [self.navigationController pushViewController:con animated:YES];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MORE_CON object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            //            [self performBlock:^(id sender) {
            //            } afterDelay:0.5f];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}

- (IBAction)sexBtnPressed:(id)sender {
    isBoy = !isBoy;
    UIImage *sexImg = isBoy ? [UIImage imageNamed:@"sex_boy.png"] : [UIImage imageNamed:@"sex_girl.png"];// [UIImage imageWithContentsOfFile:@"sex_boy.png"] : [UIImage imageWithContentsOfFile:@"sex_girl.png"];
    [sexBtn setImage:sexImg forState:UIControlStateNormal];
}

- (IBAction)headBtnPressed:(id)sender {
    //更改头像
    MyImagePickerController *picker = [[MyImagePickerController alloc] initWithParent:self];
    [picker showImagePickerMenu:@"孩子照片" buttonTitle:@"给孩子拍一张照片" sender:sender];
    [picker.ImagePickerMenu showInView:self.view];
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
}

- (IBAction)bgBtnPressed:(id)sender {
    [nameField resignFirstResponder];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         UIScrollView *scrollView = (UIScrollView*)self.view;
                         scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                         
                         if (_datePicker) {
                             CGRect pickerFrame = _datePicker.frame;
                             pickerFrame.origin.y = DEVICE_SIZE.height;
                             _datePicker.frame = pickerFrame;
                         }
                         if (_bottomView.frame.origin.y != DEVICE_SIZE.height - 40) {
                             _bottomView.frame = CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40);
                         }
                     } completion:^(BOOL finished) {
                         if (_datePicker) {
                             [_datePicker removeFromSuperview];
                             _datePicker = nil;
                         }
                     }];
}

//- (void)resignKeyboardInView:(UIView *)view   {
//    for (UIView *v in view.subviews) {
//        if ([v.subviews count] > 0) {
//            [self resignKeyboardInView:v];
//        }
//        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
//            [v resignFirstResponder];
//        }
//    }
//}

#pragma mark - child info
- (void)fillChildInfo:(NSDictionary*)dict {
//    [headBtn setImageWithURL:[NSURL URLWithString:[dict objectForKey:AVATAR]] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    NSString *headUrl = @"http://www.familyday.com.cn/template/aifaxian/image/familyday.jpg";
    if (![headUrl isEqualToString:[dict objectForKey:BABY_AVATAR]]) {
        headUrl = $str(@"%@%@", [emptystr([dict objectForKey:BABY_AVATAR]) delLastStrForYouPai], ypZoneCover);
    }
    [headBtn setImageForMyHeadButtonWithUrlStr:headUrl plcaholderImageStr:@"space_default_2.jpg"];
        
    nameField.text = [dict objectForKey:BABY_NAME];
    _birthdayLbl.textColor = [UIColor darkGrayColor];
    _birthdayLbl.text = [dict objectForKey:BABY_BIRTHDAY];
        
    isBoy = [[dict objectForKey:BABY_SEX] isEqualToString:@"男"] ? YES : NO;
    UIImage *sexImg = isBoy ? [UIImage imageNamed:@"sex_boy.png"] : [UIImage imageNamed:@"sex_girl.png"];
    [sexBtn setImage:sexImg forState:UIControlStateNormal];
    
    self.preNameStr = nameField.text;
    self.preBirthdayStr = _birthdayLbl.text;
    self.preSexStr = [dict objectForKey:BABY_SEX];
    
    self.babyId = [dict objectForKey:BABY_ID];
    self.tagId = [dict objectForKey:TAG_ID];
}

#pragma mark - 修改孩子资料
//上传单张图片
- (void)uploadImage:(UIImage *)_image {
    if (!_isAddAZone && (nameField.text.length == 0 || [_birthdayLbl.text isEqualToString:@"生日"])) {
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    if (!_isAddAZone) {
        [SVProgressHUD showWithStatus:@"修改孩子信息中..."];
        [SVProgressHUD changeDistance:-60];
    }
    NSString *url = $str(@"%@upload", POST_CP_API);
    NSString *opStr = UPLOAD_PHOTO;
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:opStr, OP, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(_image, 1.0f) name:@"Filedata" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        if (_isAddAZone) {
            self.picUrlForAddZone = [[dict objectForKey:WEB_DATA] objectForKey:PIC];
            [self uploadRequestToAddZone];
        } else {
            self.picId = $str(@"%d", [[[dict objectForKey:WEB_DATA] objectForKey:PIC_ID] intValue]);
            [self uploadRequestToChangeChildInfo];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}

- (void)uploadRequestToChangeChildInfo {
    if (nameField.text.length == 0 || [_birthdayLbl.text isEqualToString:@"生日"]) {
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    [SVProgressHUD showWithStatus:@"修改孩子信息中..."];
    [SVProgressHUD changeDistance:-60];
    NSString *sexStr = isBoy ? @"男" : @"女";
    if (!_theImage && [_preNameStr isEqualToString:nameField.text] && [_preBirthdayStr isEqualToString:_birthdayLbl.text] && [_preSexStr isEqualToString:sexStr]) {
        [SVProgressHUD showErrorWithStatus:@"孩子信息未更改过"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    NSString *url = $str(@"%@baby", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:nameField.text, @"babyname", sexStr, @"babysex", _birthdayLbl.text, @"babybirthday", @"1", BABY_EDIT_SUBMIT, _babyId, BABY_ID, _tagId, TAG_ID, emptystr(_picId), PIC_ID, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [SVProgressHUD changeDistance:-60];
        self.preNameStr = nameField.text;
        self.preBirthdayStr = _birthdayLbl.text;
        self.preSexStr = sexStr;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MORE_CON object:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}






@end
