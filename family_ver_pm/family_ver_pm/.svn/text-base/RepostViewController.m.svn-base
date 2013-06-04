//
//  RepostViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-5-10.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "RepostViewController.h"
#import "PickerItemView.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SBToolKit.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"

@interface RepostViewController ()

@end

@implementation RepostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    hasShowHUD = NO;
    hasShowPicker = NO;
    isPullingData = NO;
    self.tagNameList = [[NSMutableArray alloc] init];
    
    self.pickerView = [[PickerViewWithToolBar alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height, MYPICKER_SIZE.width, MYPICKER_SIZE.height)];
    [self.pickerView setMyPickerDataSource:self];
    [self.pickerView setMyPickerDelegate:self];
    [self.view addSubview:self.pickerView];
    
    self.bottomView.frame = CGRectMake(0, DEVICE_SIZE.height - self.bottomView.frame.size.height, DEVICE_SIZE.width, self.bottomView.frame.size.height);
    
    self.repostTextField.placeholder = @"对转采的内容说两句吧~";
    self.repostTextField.delegate = self;
    
    [self requestTagNameList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectSpace:(id)sender
{
    if (!isPullingData) {
        [self.repostTextField resignFirstResponder];
        [self showPicker];
    } else {
        [SVProgressHUD showWithStatus:@"稍等一下下~"];
        hasShowHUD = YES;
    }
}

//显示picker
- (void)showPicker
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect = self.pickerView.frame;
        self.pickerView.frame = CGRectMake(0, DEVICE_SIZE.height - MYPICKER_SIZE.height, rect.size.width, rect.size.height);
    }];
    
    if ((DEVICE_SIZE.height - MYPICKER_SIZE.height) - self.mainView.frame.origin.y
        < self.selectSpaceBtn.frame.origin.y + self.selectSpaceBtn.frame.size.height + 10) {
        
        [UIView animateWithDuration:0.2f animations:^{
            CGFloat interval = self.selectSpaceBtn.frame.origin.y + self.selectSpaceBtn.frame.size.height - self.pickerView.frame.origin.y;
            CGRect viewRect = self.mainView.frame;
            
            self.mainView.frame = CGRectMake(viewRect.origin.x, viewRect.origin.y - (interval + 10), viewRect.size.width, viewRect.size.height);
        }];
    }
}

//隐藏picker
- (void)dismissPicker
{
    if (self.mainView.frame.origin.y != 0) {
        [UIView animateWithDuration:0.2f animations:^{
            CGRect mainViewRect = self.mainView.frame;
            self.mainView.frame = CGRectMake(mainViewRect.origin.x, 0, mainViewRect.size.width, mainViewRect.size.height);
        }];
    }
    
    if (self.pickerView.frame.origin.y < DEVICE_SIZE.height) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect rect = self.pickerView.frame;
            self.pickerView.frame = CGRectMake(rect.origin.x, DEVICE_SIZE.height, rect.size.width, rect.size.height);
        }];
    }
}

- (IBAction)back:(id)sender
{
    if (hasShowHUD) {
        [SVProgressHUD dismiss];
    }
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)confirm:(id)sender
{
    [self.delegate confirmToRepostwithMessage:self.repostTextField.text toSpace:self.tagName.text];
}

#pragma mark UIPickerViewDelegate UIPickerViewDataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return REPOST_VIEW_PICKER_ROW_HEIGHT;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return REPOST_VIEW_PICKER_COM_WIDTH;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.tagNameList count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    PickerItemView *pickerItemView = (PickerItemView *)view;
    if (pickerItemView == nil) {
        pickerItemView = [[PickerItemView alloc] initWithFrame:CGRectMake(0, 0, REPOST_VIEW_PICKER_COM_WIDTH, REPOST_VIEW_PICKER_ROW_HEIGHT)];
    }
    
    [pickerItemView setContentLabelText:[self.tagNameList objectAtIndex:row]];
    return pickerItemView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setZoneNameFromPicker];
}

#pragma mark - PickerViewWithToolBarDelegate
//按下完成按钮
- (void)pressFinishBarItem
{
    [self dismissPicker];
    [self setZoneNameFromPicker];
}

- (void)setZoneNameFromPicker
{
    int row = [self.pickerView selectedRowInComponent:0];
    self.tagName.text = [self.tagNameList objectAtIndex:row];
}

#pragma mark - TouchesEvent 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.repostTextField resignFirstResponder];
    [self dismissPicker];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self dismissPicker];
    return YES;
}

//拉取数据
- (void)requestTagNameList
{
    isPullingData = YES;
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:TAG_NAME_LIST_API parameters:[NSDictionary dictionaryWithObject:[SBToolKit getMAuth] forKey:M_AUTH]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (hasShowHUD) {
            [SVProgressHUD dismiss];
        }
        isPullingData = NO;
        NSDictionary *resultDict = [responseObject objectFromJSONData];
        
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            NSDictionary *tagNameDictList = [[resultDict objectForKey:DATA] objectForKey:TAGLIST];
            for (NSDictionary *tagNameDict in tagNameDictList) {
                [self.tagNameList addObject:[tagNameDict objectForKey:TAGNAME]];
            }
            
            [self.pickerView reloadAllComponents];
        } else {
            NSLog(@"获取空间名称错误：%@", resultDict);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取空间名称失败:%@", error);
    }];
    [operation start];
}

@end
