//
//  RepostPictureViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-5-29.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "RepostPictureViewController.h"
#import "MySingleSelectionGroup.h"
#import "MyToolBarDelegate.h"
#import "MyToolBar.h"

#define REPOST_PICTURE_TEXTFIELD 419
#define REPOST_PICTURE_ALERTVIEW 230

@interface RepostPictureViewController ()

@end

@implementation RepostPictureViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIAlertView *)returnRepostPictureAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"转采" message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = REPOST_PICTURE_ALERTVIEW;
    [alertView show];
    
    UIScrollView *scrollView = nil;
    for (id subView in [alertView subviews]) {
        if ([[subView class] isSubclassOfClass:[UIScrollView class]]) {
            scrollView  = (UIScrollView *)subView;
            break;
        }
    }
    
    if (scrollView != nil) {
        scrollView.scrollEnabled = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        //        UIView *backgroundView = [[scrollView subviews] objectAtIndex:0];//设置UIWebDocumentview的背景颜色
        //        backgroundView.backgroundColor = [UIColor clearColor];
        //设置输入框
        self.repostPictureAlertViewTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, ALERTVIEW_SCROLLVIEW_SIZE_WIDTH - 10, 110)];
        self.repostPictureAlertViewTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.repostPictureAlertViewTextField.placeholder = @"对转采的图片说两句话吧~";
        self.repostPictureAlertViewTextField.font = [UIFont systemFontOfSize:20];
        
        MyToolBar *toolBar = [[MyToolBar alloc] init];
        toolBar.delegateInMyToolBar = self;
        self.repostPictureAlertViewTextField.inputAccessoryView = toolBar;
        [self.repostPictureAlertViewTextField becomeFirstResponder];

        //设置转发默认描述
        NSArray *defaultMsgArray = [[NSArray alloc] initWithObjects:
                                    @"神马都是浮云~~",
                                    @"介个还不错~",
                                    @"常回来一起吃饭!", nil];
        const int singleSelectCellHeight = 34;
        int selectionGroupY = self.repostPictureAlertViewTextField.frame.origin.y + self.repostPictureAlertViewTextField.frame.size.height;
        MySingleSelectionGroup *selectionGroup = [[MySingleSelectionGroup alloc] initWithFrame:CGRectMake(0, selectionGroupY, ALERTVIEW_SCROLLVIEW_SIZE_WIDTH, singleSelectCellHeight * [defaultMsgArray count])
                                                                                     textArray:defaultMsgArray
                                                                                 cellRowHeight:singleSelectCellHeight
                                                                              andSelectedBlock:^(int selectedIndex) {
                                                                                  self.repostPictureAlertViewTextField.text = [defaultMsgArray objectAtIndex:selectedIndex];
                                                                              }];
        
        
        [scrollView addSubview:self.repostPictureAlertViewTextField];
        [scrollView addSubview:selectionGroup];
    } else {
        NSLog(@"alert view 里面没有找到scrollView");
    }
    return alertView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.repostTextField resignFirstResponder];
    [self.repostPictureAlertViewTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self dismissPicker];
    if (textField.tag == REPOST_PICTURE_TEXTFIELD) {
        
    } else {
        [[self returnRepostPictureAlertView] show];
    }
    return NO;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == REPOST_PICTURE_ALERTVIEW) {
        if (buttonIndex == 1) {
            self.repostTextField.text = self.repostPictureAlertViewTextField.text;
        }
    }
}

#pragma mark - MyToolBarDelegate
- (void)tapFinishButtonInMyToolBar
{
    [self.repostPictureAlertViewTextField resignFirstResponder];
    [self.repostTextField resignFirstResponder];
}

@end
