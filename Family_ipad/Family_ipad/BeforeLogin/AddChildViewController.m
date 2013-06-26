//
//  AddChildViewController.m
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "AddChildViewController.h"
#import "InviteFamilyViewController.h"
#import "MyButton.h"
#import "MyHttpClient.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "NSObject+BlocksKit.h"
#import "UIButton+WebCache.h"
#import "CKMacros.h"
#import "NSString+ConciseKit.h"
@interface AddChildViewController ()

@property (nonatomic, strong) IBOutlet MyButton *headBtn;
@property (nonatomic, strong) IBOutlet UIButton *sexBtn;
@property (nonatomic, assign) BOOL isBoy;

@end

@implementation AddChildViewController
@synthesize headBtn, sexBtn, isBoy;
- (IBAction)skipAction:(id)sender
{
    InviteFamilyViewController *con = [[InviteFamilyViewController alloc] initWithNibName:@"InviteFamilyViewController" bundle:nil];
    [self.navigationController pushViewController:con animated:YES];
    [con adjustLayout];
}
- (void)setBabyDataWith:(NSDictionary *)dict
{
    [headBtn setImageWithURL:[NSURL URLWithString:$str(@"%@!120X120",[$safe([dict objectForKey:@"babyavatar"]) delLastStrForYouPai])] placeholderImage:[UIImage imageNamed:@"space_default.jpg"]];
    _nikenameField.text = $safe([dict objectForKey:@"babyname"]);
    _birthdayField.text =$safe([dict objectForKey:@"babybirthday"]);
    isBoy = [$safe([dict objectForKey:@"babysex"]) isEqual:BOY]?YES:NO;
    _badyId = [dict objectForKey:BABY_ID];
    _tagId = [dict objectForKey:TAG_ID];
    UIImage *sexImg = isBoy ? [UIImage imageNamed:@"child_gender_a.png"] : [UIImage imageNamed:@"child_gender_b.png"];
    [sexBtn setImage:sexImg forState:UIControlStateNormal];
}
- (void)adjustLayout
{
    //self.view.frame = [UIScreen mainScreen].bounds;
    self.contentView.frame = CGRectMake(272, 0, 480, 768);
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

    isBoy = YES;
    if (!self.navigationController) {
        _skipButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)

- (IBAction)okBtnPressed:(id)sender {
    if (_nikenameField.text.length == 0 || _birthdayField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"孩子昵称或生日为空T_T"];
        return;
    }
    NSString *tip = _editMode?@"修改孩子资料..":@"添加孩子资料...";
    [SVProgressHUD showWithStatus:tip];
    NSString *url = $str(@"%@baby", POST_CP_API);
    NSString *babysex = isBoy?BOY:GIRL;
    NSMutableDictionary *para  = nil;
    if (!_editMode) {
       para = [NSMutableDictionary dictionaryWithObjectsAndKeys: POST_M_AUTH, M_AUTH,_nikenameField.text,@"babyname",babysex,@"babysex",@"1",BABY_SUBMIT,_birthdayField.text,@"babybirthday",nil];
    }else{
        para = [NSMutableDictionary dictionaryWithObjectsAndKeys: POST_M_AUTH, M_AUTH,_nikenameField.text,@"babyname",babysex,@"babysex",@"1",BABY_EDIT_SUBMIT,_birthdayField.text,@"babybirthday",_badyId,BABY_ID,_tagId,TAG_ID, nil];

    }
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(headBtn.imageView.image, 1.0f) name:@"babyavatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        //保存头像
        NSData *headImgData = UIImageJPEGRepresentation(headBtn.imageView.image, 0.8);
        NSData *encodeHeadImgData = [NSKeyedArchiver archivedDataWithRootObject:headImgData];
        [ConciseKit setUserDefaultsWithObject:encodeHeadImgData forKey:AVATER];
        InviteFamilyViewController *con = [[InviteFamilyViewController alloc] initWithNibName:@"InviteFamilyViewController" bundle:nil];
        [self.navigationController pushViewController:con animated:YES];
        [con adjustLayout];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
    

}

- (IBAction)sexyBtnPressed:(id)sender {
    isBoy = !isBoy;
    UIImage *sexImg = isBoy ? [UIImage imageNamed:@"child_gender_a.png"] : [UIImage imageNamed:@"child_gender_b.png"];// [UIImage imageWithContentsOfFile:@"sex_boy.png"] : [UIImage imageWithContentsOfFile:@"sex_girl.png"];
    [sexBtn setImage:sexImg forState:UIControlStateNormal];
}

- (IBAction)headBtnPressed:(UIButton *)sender {
    //更改头像
    _picker = [[MyImagePickerController alloc]initWithParent:self];
    [_picker showImagePickerMenu:@"孩子照片" buttonTitle:@"给孩子拍一张照片" sender:sender];
}
//生日
- (IBAction)birthdayBtnPressed:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    //note we are using CGRectZero for the dimensions of our picker view,
    //this is because picker views have a built in optimum size,
    //you just need to set the correct origin in your view.
    //
    //position the picker at the bottom
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(didSelectDate:) forControlEvents:UIControlEventValueChanged];
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, datePicker.frame.size.width, 44)];
//    toolbar.barStyle = UIBarStyleBlack;
//    //        UIBarButtonItem *currDateBtn = [[UIBarButtonItem alloc] initWithTitle:@"当前时间" style:UIBarButtonItemStyleBordered target:self action:@selector(currDateBtnPressed)];
//    UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
//        [_datePickerContainer dismissPopoverAnimated:YES];
//    }];
//    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
//        
//        NSDate *selectedDate = [datePicker date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyy-MM-dd";
//        
//        NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:selectedDate]];
//        _birthdayField.text = dateString;
//        [_datePickerContainer dismissPopoverAnimated:YES];
//    
//    }];
//    NSArray *btnArray = [NSArray arrayWithObjects:spaceBtn, cancleBtn, doneBtn, nil];
//    [toolbar setItems:btnArray];
    //datePicker.center = self.view.center;
    //add this picker to our view controller, initially hidden
    //build our custom popover view
    UIViewController* popoverContent = [[UIViewController alloc]                                            init];
    UIView* popoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    popoverView.backgroundColor = [UIColor whiteColor];
    datePicker.frame = CGRectMake(0, 0, 320, 300);
    //[popoverView addSubview:toolbar];
    [popoverView addSubview:datePicker];
    popoverContent.view = popoverView;        //resize the popover view shown        //in the current view to the view&apos;s size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 200);        //create a popover controller
    _datePickerContainer = [[UIPopoverController alloc]                                  initWithContentViewController:popoverContent];        //present the popover view non-modal with a        //refrence to the button pressed within the current view
    CGRect rect = CGRectMake(sender.frame.origin.x/2, sender.frame.origin.y-200, 320, 300) ;
    
    [_datePickerContainer presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(0, screenRect.size.height - size.height , size.width, size.height);//50为tabbar的高度
	return pickerRect;
}


#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    //    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self performSelector:@selector(saveImage:) withObject:myThemeImage afterDelay:0.3f];
    [_picker.pickerContainer dismissPopoverAnimated:YES];
    _picker = nil;
}

- (void)saveImage:(UIImage*)_image {
    [headBtn setImage:_image forState:UIControlStateNormal];
}




- (void)didSelectDate:(UIDatePicker *)pickerView
{
    NSDate *selectedDate = [pickerView date];
    if ([selectedDate compare:[NSDate date]] == NSOrderedDescending) {
        [SVProgressHUD showErrorWithStatus:@"生日不能超过当前时间T_T"];
        return ;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:selectedDate]];
    _birthdayField.text = dateString;
}

@end
