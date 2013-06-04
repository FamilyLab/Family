//
//  MyIssueViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "MyIssueViewController.h"
#import "TopBarView.h"
#import "MyViewCell.h"
#import "JMWhenTapped.h"
#import "MyImagePickerController.h"
#import "SBToolKit.h"

@interface MyIssueViewController ()

@end

#define MAX_NUM_PHOTO           3

@implementation MyIssueViewController
@synthesize theScrollView;
@synthesize curBtn;
@synthesize theTextView;
@synthesize contantView;
@synthesize spaceBtn;
@synthesize whatToPublish;
@synthesize publishBtn;
@synthesize spaceLbl;
@synthesize spaceAlert;
@synthesize spaceArray;
@synthesize photoContantView, photoArray, picIdArray;

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
    self.view.frame = (CGRect){.origin = DEVICE_ORIGIN, .size = DEVICE_SIZE};
    [self setTheTopBarView];
    [self setTheBottomBarView];
    [self addToolbarOnTopOfTextView];
    [self setThePhotoContantView];
    
    currIndex = 0;
    whatToPublish = publishphoto;
    height = 60;
    theTextView.placeholder = @"给图片添加描述吧";
    dropDownBtn = [[NIDropDown alloc] init];
    spaceArray = [[NSMutableArray alloc] init];
    
    
    [spaceBtn addTarget:self action:@selector(sendRequestToMySpace) forControlEvents:UIControlEventTouchUpInside];
    [spaceBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    [spaceBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    [spaceBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    
    theScrollView.frame = CGRectMake(0, 55, DEVICE_SIZE.width, DEVICE_SIZE.height - 55 -49);
    theScrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, 405);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setTheTopBarView
{
    TopBarView *customTopBarView = [[TopBarView alloc] initWithConId:@"2" andTopBarFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 36)];
    customTopBarView.themeLbl.hidden = YES;
    
    [self.view addSubview:customTopBarView];
    [customTopBarView release], customTopBarView = nil;
    
    publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishBtn setFrame:CGRectMake(10, 0, 111, 55)];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:28.0f];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn setTitle:@"发照片" forState:UIControlStateNormal];
    //publishBtn.backgroundColor = [UIColor blackColor]; publish_red.png
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"publish_red.png"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(tapOnThePublishButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishBtn];
    
    indicateImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55, 111, 15)];
    [indicateImg setImage:[UIImage imageNamed:@"publish_push.png"]];
    indicateImg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:indicateImg];
}

-(void) setTheBottomBarView
{
    NSArray *normalImage = [[NSArray alloc] initWithObjects:@"back_a_bottombar.png", @"confirm_a.png", nil];
    NSArray *selectedImage = [[NSArray alloc] initWithObjects:@"back_b_bottombar.png", @"confirm_a.png", nil];
    customBottomBarView = [[BackBottomBarView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height-49, DEVICE_SIZE.width, 49) numOfButton:[normalImage count] andNormalImage:normalImage andSelectedImage:selectedImage backgroundImageView:@"bg_bottombar.png"];
    customBottomBarView.delegate = self;
    [self.view addSubview:customBottomBarView];
    [normalImage release], normalImage = nil;
    [selectedImage release], selectedImage = nil;
}

-(void)userPressTheBottomButton:(BackBottomBarView *)_view andTheButton:(UIButton *)_button
{
    int tag = _button.tag - kTheBottomButtonTag;
    switch (tag) {
        case 0:
        {
//            [self dismissModalViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_POP_TO_MAINVIEW object:nil];
        }
            break;
        case 1:
        {
            currIndex = 0;
            if (whatToPublish == publishphoto) {
                if (numWithoutDefaultImage <= 0) {
                    [SVProgressHUD showErrorWithStatus:@"没有上传照片"];
                    return;
                }else{
                    [SVProgressHUD showWithStatus:@"发表中..."];
                    [self saveImage:[photoArray objectAtIndex:0]];
                }
            }else{
                [SVProgressHUD showWithStatus:@"发表中..."];
                [self uploadResquestToIssue];
            }
        }
            break;
        default:
            break;
    }
}


-(void)tapOnThePublishButton
{
    if(bgrImg == nil){
        bgrImg = [[UIView alloc] initWithFrame:(CGRect){.origin = DEVICE_ORIGIN, .size = DEVICE_SIZE}];
        bgrImg.backgroundColor = [UIColor blackColor];
        bgrImg.alpha = 0.1f;
        bgrImg.userInteractionEnabled = YES;
        //[self.view insertSubview:bgrImg belowSubview:publishBtn];
        [self.view addSubview:bgrImg];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(haveFinishedChoosing)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [bgrImg addGestureRecognizer:tapGesture];
        [tapGesture release],tapGesture = nil;
    }
    
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:@"发照片", @"发文章", nil];
    if (dropDownBtn != nil && !dropDownBtn.selectedState) {
        CGFloat f = 110;
        [dropDownBtn showDropDown:publishBtn :&f :buttonArray];
        dropDownBtn.delegate = self;
        [UIView animateWithDuration:0.5f animations:^{
            [indicateImg setImage:[UIImage imageNamed:@"publish_push_b.png"]];
            indicateImg.frame = CGRectMake(10, 55*3, 111, 15);
        }];
    }else{
        [self haveFinishedChoosing];
    }
}

-(void)haveFinishedChoosing
{
    [bgrImg removeFromSuperview];
    [bgrImg release], bgrImg = nil;
    [dropDownBtn hideDropDown:publishBtn];
    [UIView animateWithDuration:0.5f animations:^{
        [indicateImg setImage:[UIImage imageNamed:@"publish_push.png"]];
        indicateImg.frame = CGRectMake(10, 55, 111, 15);
    }];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    [self haveFinishedChoosing];
    [self changeToChoosing:sender.selectedIndex];
}

-(void)changeToChoosing:(int)_index
{
    if(_index == 0){
        theScrollView.scrollEnabled = YES;
        theTextView.placeholder = @"给照片添加描述吧";
        photoContantView.hidden = NO;
        CGRect nextFrame = CGRectMake(0, 119, 320, 277);
        contantView.frame = nextFrame;
    }else{
        theScrollView.scrollEnabled = NO;
        theTextView.placeholder = @"说说最近的心情^_^";
        photoContantView.hidden = YES;
        CGRect nextFrame = CGRectMake(0, 40, 320, 277);
        contantView.frame = nextFrame;
    }
    whatToPublish = _index;
}


-(void)setThePhotoContantView
{
    
    picIdArray = [[NSMutableArray alloc] init];
    photoArray = [[NSMutableArray alloc] init];
    numWithoutDefaultImage = 0;
    
    [photoArray addObject:[UIImage imageNamed:@"family_add_a.png"]];
    
    JTListView *list = [[JTListView alloc] initWithFrame:CGRectMake(0, 20, 320, 100) layout:JTListViewLayoutLeftToRight];
    self.photoContantView = list;
    photoContantView.delegate = self;
    photoContantView.dataSource = self;
    [theScrollView addSubview:photoContantView];
    [photoContantView reloadData];
}

#pragma mark JTListView delegate
-(NSUInteger)numberOfItemsInListView:(JTListView *)listView
{
    if (numWithoutDefaultImage < 1) {
        return 2;
    }else{
        return [photoArray count];
    }
}

-(UIView *)listView:(JTListView *)listView viewForItemAtIndex:(NSUInteger)index
{
    MyViewCell *cell = (MyViewCell *)[listView dequeueReusableView];
    if (!cell) {
        cell = [[MyViewCell alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, 0, 100, 100);
        [button setImage:[UIImage imageNamed:@"family_add_a.png"] forState:UIControlStateNormal];
        [button whenTapped:^{
            self.curBtn = button;
            NSString *destructiveStr = @"删除此照片";
            if ((numWithoutDefaultImage < 1 && (button.tag - kTheListViewCellButtonTag == 1)) || (numWithoutDefaultImage < MAX_NUM_PHOTO && ([photoArray count] <= MAX_NUM_PHOTO && button.tag - kTheListViewCellButtonTag == [photoArray count]-1))) {
                destructiveStr = nil;
            }
            MyImagePickerController *imagePicker = [[MyImagePickerController alloc] initWithParent:self];
            [imagePicker showImagePickerMenu:@"选择图像" buttonTitle:@"打开相机" destructiveTitle:destructiveStr sender:button otherTitle:nil];
            [imagePicker.ImagePickerMenu setHandler:^{
                [photoArray removeObjectAtIndex:button.tag - kTheListViewCellButtonTag];
                if (numWithoutDefaultImage == MAX_NUM_PHOTO) {
                    [photoArray addObject:[UIImage imageNamed:@"family_add_a.png"]];
                }
                numWithoutDefaultImage--;
                [photoContantView reloadData];
            }forButtonAtIndex:imagePicker.ImagePickerMenu.destructiveButtonIndex];
            [imagePicker.ImagePickerMenu showInView:self.view];
        }];
        cell.button = button;
        [cell addSubview:button];
    }
    cell.button.tag = kTheListViewCellButtonTag + index;
    if (numWithoutDefaultImage < 1 && index == 0) {
        [cell.button setImage:[UIImage imageNamed:@"family_bg.png"] forState:UIControlStateNormal];
        cell.button.userInteractionEnabled = NO;
    }else if (numWithoutDefaultImage < 1 && index == 1) {
        [cell.button setImage:[photoArray objectAtIndex:index-1] forState:UIControlStateNormal];
    }else{
        [cell.button setImage:[photoArray objectAtIndex:index] forState:UIControlStateNormal];
        if (!cell.button.userInteractionEnabled) {
            cell.button.userInteractionEnabled = YES;
        }
    }
    return cell;
}

-(CGFloat)listView:(JTListView *)listView heightForItemAtIndex:(NSUInteger)index
{
    return 100;
}

-(CGFloat)listView:(JTListView *)listView widthForItemAtIndex:(NSUInteger)index
{
    return 106;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    int btnIndex = self.curBtn.tag - kTheListViewCellButtonTag;
    numWithoutDefaultImage++;
    if (numWithoutDefaultImage < 2 && btnIndex == 1 ) {
        [photoArray insertObject:image atIndex:0];
        [photoContantView reloadData];
    }else if(btnIndex >= [photoArray count]-1){
        [curBtn setImage:image forState:UIControlStateNormal];
        [photoArray replaceObjectAtIndex:[photoArray count]-1 withObject:image];
        if ([photoArray count] < MAX_NUM_PHOTO) {
            [photoArray addObject:[UIImage imageNamed:@"family_add_a.png"]];
            [photoContantView reloadData];
            [photoContantView goForward:YES];
        }
    }else{
        [photoArray replaceObjectAtIndex:btnIndex withObject:image];
        [photoContantView reloadData];
    }
    self.curBtn = nil;
}

-(void)sendRequestToMySpace
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url =  [NSString stringWithFormat:@"%@do.php?ac=ajax&op=taglist&m_auth=%@", API_BASE_URL, [SBToolKit getMAuth]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict){
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        if ([spaceArray count] != 0) {
            [spaceArray removeAllObjects];
        }
        [spaceArray addObjectsFromArray:[[dict objectForKey:DATA] objectForKey:TAG_LIST]];
        self.spaceAlert = [MLTableAlert tableAlertWithTitle:@"空间列表" cancelButtonTitle:@"取消"numberOfRows:^NSInteger (NSInteger section)
                           {
                               return [spaceArray count];
                           }
                                                   andCells:^UITableViewCell *(MLTableAlert *alert, NSIndexPath *indexPath)
                           {
                               static NSString *cellIdentifier = @"CellIdentifier";
                               UITableViewCell *cell = (UITableViewCell*)[alert.table dequeueReusableCellWithIdentifier:cellIdentifier];
                               if(cell == nil)
                               {
                                   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                               }
                               
                               
                               cell.textLabel.text = [[spaceArray objectAtIndex:indexPath.row] objectForKey:TAG_NAME];
                               
                               return cell;
                               
                           }];
        
        self.spaceAlert.height = 300;
        
        [self.spaceAlert configureSelectionBlock:^(NSIndexPath *selectedIndexPath)
         {
             spaceLbl.text = [[spaceArray objectAtIndex:selectedIndexPath.row] objectForKey:TAG_NAME];
         }
        andCompletionBlock:^
         {
             
         }];
        
        [self.spaceAlert show];
    }failure:^(NSError *error){
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
    }];
}

#pragma mark keyboard show event
-(void)keyboardWillHide:(NSNotification*)_notification
{
    if ([theTextView isFirstResponder]) {
        NSDictionary *userInfo = [_notification userInfo];
        NSValue *animationDurationValue = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        [UIView animateWithDuration:animationDuration animations:^{
            [theScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
    }
}

-(void)keyboardWillShow:(NSNotification*)_notification
{
    if ([theTextView isFirstResponder]) {
        NSDictionary *userInfo = [_notification userInfo];
        /*
         NSValue *aValue = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
         CGRect keyboardRect = [aValue CGRectValue];
         keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
         */
        if(whatToPublish == publishphoto)
        {
            height = 60;
        }else{
            height = 20;
        }
        NSValue *animationDurationValue = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        if ([theTextView hasText]) {
            CGSize inputSize = [theTextView.text sizeWithFont:[UIFont systemFontOfSize:20.0f]];
            int row = (int) inputSize.width / theTextView.frame.size.width;
            if ((whatToPublish == publishphoto && row < 5) || (whatToPublish == publisharticle && row < 4)) {
                [theScrollView setContentOffset:CGPointMake(0, height + row * inputSize.height) animated:YES];
            }else{
                row = whatToPublish == publishphoto ? 5 : 3;
                [theScrollView setContentOffset:CGPointMake(0, height + row* inputSize.height) animated:YES];
            }
        }else{
            [UIView animateWithDuration:animationDuration animations:^{
                [theScrollView setContentOffset:CGPointMake(0, height) animated:YES];
            }];
        }
        
    }
}

#pragma mark uitextview event
-(void)changTheFrameOfTextView
{
    CGSize inputSize = [theTextView.text sizeWithFont:[UIFont systemFontOfSize:20.0f]];
    int row = (int) inputSize.width / theTextView.frame.size.width;
    if ((whatToPublish == publishphoto && row > 4) || (whatToPublish == publisharticle && row > 3)) {
        return;
    }
    if(whatToPublish == publishphoto)
    {
        height = 60;
    }else{
        height = 20;
    }
    
    [theScrollView setContentOffset:CGPointMake(0, height + row * inputSize.height) animated:YES];
}

-(void)clearTheTextView
{
    theTextView.text = @"";
    if(whatToPublish == publishphoto)
    {
        height = 60;
    }else{
        height = 20;
    }
    [theScrollView setContentOffset:CGPointMake(0, height) animated:YES];
}

-(void)dismissTheTextView
{
    if ([theTextView isFirstResponder]) {
        [theTextView resignFirstResponder];
    }
}

-(void)addToolbarOnTopOfTextView
{
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    topView.barStyle = UIBarStyleBlack;
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearTheTextView)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissTheTextView)];
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:clear, space, cancel, nil];
    [topView setItems:buttonArray];
    [theTextView setInputAccessoryView:topView];
    
    [clear release], clear = nil;
    [space release], space = nil;
    [clear release], clear = nil;
    [buttonArray release], buttonArray = nil;
    [topView release], topView = nil;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self changTheFrameOfTextView];
    return YES;
}

-(NSString*)componentStrFromArray:(NSMutableArray*)array
{
    NSString *finalStr = @"";
    if ([array count] <= 0) {
        return finalStr;
    }
    for (int i=0; i < [array count]; i++) {
        if (i == 0) {
            finalStr = [NSString stringWithFormat:@"%@", [array objectAtIndex:0]];
        }else{
            finalStr = [NSString stringWithFormat:@"%@|%@", finalStr, [array objectAtIndex:i]];
        }
    }
    return finalStr;
}

-(void)saveImage:(UIImage*)_image
{
    NSString *url = [NSString stringWithFormat:@"%@cp.php?ac=upload", API_BASE_URL];
    NSMutableDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:UPLOAD_PHOTO, OP, [SBToolKit getMAuth], M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileData:UIImageJPEGRepresentation(_image, 1.0f) name:@"Filedata" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    }onCompletion:^(NSDictionary *dict){
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [picIdArray addObject:[NSString stringWithFormat:@"%@",[[dict objectForKey:DATA] objectForKey:PICTURE_ID]]];
        currIndex++;
        if (currIndex < numWithoutDefaultImage) {
            [self saveImage:[photoArray objectAtIndex:currIndex]];
        }else{
            [self uploadResquestToIssue];
        }
        //[self adjustThePhotoContantView:_image];
    }failure:^(NSError *error){
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
    }];
}

-(void)uploadResquestToIssue
{
    
    NSString *url = @"";
    NSMutableDictionary *para;
    if (whatToPublish == publishphoto) {
        url = [NSString stringWithFormat:@"%@cp.php?ac=photo", API_BASE_URL];
        para = [NSDictionary dictionaryWithObjectsAndKeys:theTextView.text, MESSAGE, [self componentStrFromArray:picIdArray], PICTURE_IDS, @"", FRIEND, spaceLbl.text, SPACE_TAG, @"", FRIENDS, @"", LAT, @"", LNG, @"", ADDRESS, IPHONE, COME, ONE, MAKE_FEED, ZERO, MAKE_SINA_WEIBO, ZERO, MAKE_QQ_WEIBO, ONE, PHOTO_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil];
    }else{
        url = [NSString stringWithFormat:@"%@cp.php?ac=blog", API_BASE_URL];
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"", SUBJECT, theTextView.text, MESSAGE, @"", PICTURE_IDS, @"1", FRIEND, spaceLbl.text, SPACE_TAG, @"", FRIENDS, @"", LAT, @"", LNG, @"", ADDRESS, IPHONE, COME, ONE, MAKE_FEED, ZERO,MAKE_SINA_WEIBO, ZERO, MAKE_QQ_WEIBO, ONE, BLOG_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil];
    }
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData>formData){
        
    }onCompletion:^(NSDictionary *dict){
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"发布成功!\n+%@积分 +%@经验值",[[dict objectForKey:DATA] objectForKey:CREDIT], [[dict objectForKey:DATA] objectForKey:EXPERIENCE]]];
        [self performBlock:^(id sender){
            [self dismissModalViewControllerAnimated:YES];
        }afterDelay:0.7f];
    }failure:^(NSError *error){
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
    }];
}

-(void)dealloc
{
    [super dealloc];
    [curBtn release], curBtn = nil;
    [photoContantView release], photoContantView = nil;
    [theScrollView release], theScrollView = nil;
    [contantView release], contantView = nil;
    [spaceBtn release], spaceBtn = nil;
    [theTextView release], theTextView = nil;
    [spaceLbl release], spaceLbl = nil;
    [spaceAlert release], spaceAlert = nil;
    [spaceArray release], spaceArray = nil;
    [photoArray release], photoArray = nil;
    [picIdArray release], picIdArray = nil;
    //[bgrImg release], bgrImg = nil;
    //[publishBtn release], publishBtn = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
