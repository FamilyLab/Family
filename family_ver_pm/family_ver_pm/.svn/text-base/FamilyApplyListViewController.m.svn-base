//
//  FamilyApplyListViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-4-4.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "FamilyApplyListViewController.h"
#import "TopBarView.h"
#import "FamilyCardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DDAlertPrompt.h"

@interface FamilyApplyListViewController ()

@end

@implementation FamilyApplyListViewController
@synthesize whichTypeVC;
@synthesize searchBtn;
@synthesize searchTextView;
@synthesize contantView, cancelBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isFirstShow = YES;
        NSLog(@"这里是：%@", [self class]);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = (CGRect){.origin = DEVICE_ORIGIN, .size = DEVICE_SIZE};
    [self setTheTopBarView];
    [self setTheBackBottomBarView];
    [self setInterfaceButton];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    /*
    for (int i=0; i<12; i++) {
        [dataArray addObject:@"example"];
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTheTopBarView
{
    customTopBarView = [[TopBarView alloc] initWithConId:@"3" andTopBarFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 65) TheFrameWidth:@"168"];
    customTopBarView.familyLbl.text = MY_NAME;
    if (whichTypeVC == familyapplylistviewcontroller) {
        customTopBarView.themeLbl.text = @"待审核";
        customTopBarView.countPerLbl.hidden = NO;
    }else if(whichTypeVC == familysearchlistviewcontroller){
        _tableView.refreshView.hidden = YES;
        customTopBarView.themeLbl.text = @"搜索家人";
    }
    
    [self.view addSubview:customTopBarView];
    [customTopBarView release], customTopBarView = nil;
}

-(void)setTheBackBottomBarView
{
    NSArray *normalImage = [[NSArray alloc] initWithObjects:@"back_a_bottombar.png", nil];
    NSArray *selectedImage = [[NSArray alloc] initWithObjects:@"back_b_bottombar.png", nil];
    customBackBottomBarView = [[BackBottomBarView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height-49, DEVICE_SIZE.width, 49) numOfButton:[normalImage count] andNormalImage:normalImage andSelectedImage:selectedImage backgroundImageView:@"bg_bottombar.png"];
    customBackBottomBarView.delegate = self;
    [self.view addSubview:customBackBottomBarView];
    [normalImage release], normalImage = nil;
    [selectedImage release], selectedImage = nil;
}

-(void)setInterfaceButton
{
    
    _tableView.loadMoreView.hidden = YES;
    if (whichTypeVC == familyapplylistviewcontroller) {
        contantView.hidden = YES;
        _tableView.frame = CGRectMake(0, 70, DEVICE_SIZE.width, DEVICE_SIZE.height - 70 -49);
    }else if(whichTypeVC == familysearchlistviewcontroller){
        //[self addToolbarOnTopOfTextView];
        contantView.hidden = NO;
        _tableView.frame = CGRectMake(0, 121, DEVICE_SIZE.width, DEVICE_SIZE.height - 121 -49);
        searchTextView.text = @"";
        searchTextView.returnKeyType = UIReturnKeySearch;
        searchTextView.placeholder = @"输入姓名或手机号码";
    }
    
    searchBtn.tag = kTheInterfaceButtonTag;
    [searchBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    cancelBtn.tag = kTheInterfaceButtonTag + 1;
    [cancelBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)userPressTheBottomButton:(BackBottomBarView *)_view andTheButton:(UIButton *)_button
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)buttonPressed:(UIButton*)_button
{
    if (_button.tag - kTheInterfaceButtonTag == 0) {
        if (![searchTextView isFirstResponder]) {
            [searchTextView becomeFirstResponder];
        }
    }else if(_button.tag - kTheInterfaceButtonTag == 1){
        if ([searchTextView isFirstResponder]) {
            [searchTextView resignFirstResponder];
        }
    }
}

#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *familyApplyListCellId = @"FamilyApplyListCellId";
    FamilyApplyListCell *cell = (FamilyApplyListCell *)[tableView dequeueReusableCellWithIdentifier:familyApplyListCellId];
    if(cell == nil)
    {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"FamilyApplyListCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
    }
    cell.whichTypeVC = whichTypeVC;
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initData:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyCardViewController *_con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    _con.userId = [[dataArray objectAtIndex:indexPath.row] objectForKey:UID];
    [self presentModalViewController:_con animated:YES];
    [_con release], _con = nil;
}

#pragma mark uitextview delegate
-(void)dismissTheTextView
{
    if ([searchTextView isFirstResponder]) {
        [searchTextView resignFirstResponder];
    }
}

-(void)clearTheTextView
{
    searchTextView.text = @"";
}

-(void)addToolbarOnTopOfTextView
{
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    topView.barStyle = UIBarStyleBlack;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissTheTextView)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearTheTextView)];
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:clear, space, cancel, nil];
    [topView setItems:buttonArray];
    [searchTextView setInputAccessoryView:topView];
    
    [cancel release];
    [clear release];
    [space release];
    [buttonArray release];
    [topView release];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect nextFrame = cancelBtn.frame;
    nextFrame.origin.x = nextFrame.origin.x - 60;
    [UIView animateWithDuration:0.1f animations:^{
        [cancelBtn setFrame:nextFrame];
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"] && [searchTextView isFirstResponder])
    {
        if (searchTextView.text == nil) {
            [SVProgressHUD showErrorWithStatus:@"请输入关键字"];
            return YES;
        }
        [searchTextView resignFirstResponder];
        [self sendRequest:_tableView];
        return NO;
    }
    return YES;
}


-(void)keyboardWillShow:(NSNotification*)notification
{
    if (![searchTextView isFirstResponder]) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    /*
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.duration = animationDuration;
    animation.autoreverses = NO;
    animation.toValue = [NSNumber numberWithFloat:-60.0];
    [self.cancelBtn.layer addAnimation:animation forKey:@"transform.translation.x"];
     */
    
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    /*
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.duration = animationDuration;
    animation.autoreverses = NO;
    animation.toValue = [NSNumber numberWithFloat:60.0];
    [self.cancelBtn.layer addAnimation:animation forKey:@"transform.translation.x"];
    */
    CGRect nextFrame = cancelBtn.frame;
    nextFrame.origin.x = nextFrame.origin.x + 60;
    [UIView animateWithDuration:0.1f animations:^{
        [cancelBtn setFrame:nextFrame];
    }];
}

#pragma mark sendRequest
-(void)sendRequest:(id)sender
{
    if (isFirstShow && whichTypeVC == familysearchlistviewcontroller) {
        isFirstShow = NO;
        return;
    }
    NSString *url = @"";
    NSString *status = @"";
    if (whichTypeVC == familyapplylistviewcontroller) {
        status = @"加载中...";
        url = $str(@"%@/dapi/cp.php?ac=friend&op=request&m_auth=%@", BASE_URL, [SBToolKit getMAuth]);
    }else{
        status = @"搜索中...";
        url = $str(@"%@/dapi/space.php?do=fmembers&m_auth=%@&fsearch=1&kw=%@", BASE_URL, [SBToolKit getMAuth], searchTextView.text);
    }
    [SVProgressHUD showWithStatus:status];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict){
        [self stopLoading:sender];
        isFirstShow = NO;
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [dataArray removeAllObjects];
        if (whichTypeVC == familyapplylistviewcontroller) {
            if ([[[dict objectForKey:DATA] objectForKey:REQUEST_NUMBER] intValue] <= 0) {
                [SVProgressHUD showErrorWithStatus:@"没有家人申请哦"];
                return;
            }else
                [SVProgressHUD dismiss];
            customTopBarView.countPerLbl.text = [NSString stringWithFormat:@"共%@人", [[dict objectForKey:DATA] objectForKey:REQUEST_NUMBER]];
            [dataArray addObjectsFromArray:[[dict objectForKey:DATA] objectForKey:REQUEST_LIST]];
            
        }else{
            
            //if ([[[dict objectForKey:DATA] objectForKey:FAMILY_MEMBERS] intValue] <= 0) {
            if ([[[dict objectForKey:DATA] objectForKey:FAMILY_LIST] count] <= 0) {
                [SVProgressHUD showErrorWithStatus:@"没有符合的结果"];
                return;
            }else
                [SVProgressHUD dismiss];
            [dataArray addObjectsFromArray:[[dict objectForKey:DATA] objectForKey:FAMILY_LIST]];
        }
        [_tableView reloadData];
    }failure:^(NSError *error){
        [self stopLoading:sender];
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
        NSLog(@"error:%@",[error description]);
    }];
}

-(void)userDidPressedTheCellButtonOfView:(FamilyApplyListCell *)cell andButton:(UIButton *)button
{
    //NSString *url;
    //NSMutableDictionary *para;
    if (button.tag - kTheListViewCellButtonTag == 0) {
        if (whichTypeVC == familyapplylistviewcontroller) {
            NSString *url = $str(@"%@/dapi/cp.php?ac=friend&op=add", BASE_URL);
            NSMutableDictionary *para = $dict([[dataArray objectAtIndex:cell.index] objectForKey:UID], APPLY_UID, ONE, G_ID, ONE, AGREE_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil);
            [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
                
            }onCompletion:^(NSDictionary *dict){
                if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                    [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                     return ;
                }
                [SVProgressHUD showSuccessWithStatus:@"已经通过申请"];
                [self sendRequest:_tableView];
            }failure:^(NSError *error){
                [SVProgressHUD showErrorWithStatus:@"网络不好"];
                NSLog(@"error:%@", [error description]);
            }];
        }else if(whichTypeVC == familysearchlistviewcontroller){
            if ([[[dataArray objectAtIndex:cell.index] objectForKey:UID] isEqualToString:MY_UID]) {
                [SVProgressHUD showErrorWithStatus:@"这是你自己，不要玩了"];
                return;
            }
            //NSLog(@"%d", cell.index);
            DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
            alertPrompt.theTextView.text = [NSString stringWithFormat:@"你好！我是%@,我想申请成为你的家人。", MY_NAME];
            [alertPrompt addButtonWithTitle:@"确认" handler:^{
                [SVProgressHUD showWithStatus:@"发送申请中..."];
                NSString *url = $str(@"%@/dapi/cp.php?ac=friend&op=add", BASE_URL);
                NSMutableDictionary *para = $dict([[dataArray objectAtIndex:cell.index] objectForKey:UID], APPLY_UID, ONE, G_ID, alertPrompt.theTextView.text, NOTE, ONE, ADD_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil);
                [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
                    
                }onCompletion:^(NSDictionary *dict){
                    if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                        [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                         return ;
                    }
                    [SVProgressHUD showSuccessWithStatus:@"申请发送成功，等待对方验证。"];
                }failure:^(NSError *error){
                    [SVProgressHUD showErrorWithStatus:@"网络不好"];
                    NSLog(@"error:%@", [error description]);
                }];
            }];
            [alertPrompt show];
            [alertPrompt release], alertPrompt = nil;
        }
    }else if(button.tag - kTheListViewCellButtonTag == 1){
        NSLog(@"no");
        NSString *url = $str(@"%@/dapi/cp.php?ac=friend&op=ignore&uid=%@&m_auth=%@", BASE_URL, [[dataArray objectAtIndex:cell.index] objectForKey:UID], [SBToolKit getMAuth]);
        NSMutableDictionary *para = $dict([[dataArray objectAtIndex:cell.index] objectForKey:UID], UID, ONE, FRIEND_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil);
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
            
        }onCompletion:^(NSDictionary *dict){
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [SVProgressHUD showSuccessWithStatus:@"已经取消申请"];
            [self sendRequest:_tableView];
        }failure:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"网络不好"];
            NSLog(@"error:%@", [error description]);
        }];
    }
}

-(void)dealloc
{
    [super dealloc];
    [searchBtn release], searchBtn = nil;
    [searchTextView release], searchTextView = nil;
    [contantView release], contantView = nil;
    [cancelBtn release], cancelBtn = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
