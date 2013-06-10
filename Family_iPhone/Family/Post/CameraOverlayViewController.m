//
//  CameraOverlayViewController.m
//  Family
//
//  Created by Aevitx on 13-5-29.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CameraOverlayViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SelectedButton.h"
#import "MyViewCell.h"
#import "SVProgressHUD.h"

#define SHOW_ALBUM_PIC_MAX_NUM  3

@interface CameraOverlayViewController ()

@end

@implementation CameraOverlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _containerView.alpha = 0.0f;
        _countNum = 0;
        _hasTakePicture = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    isOneToOne = YES;
//    imageArray = [[NSMutableArray alloc]init];
//    shadowView = [[ShadowView alloc]initWithRect:CGRectMake(0, 80, 320, 320)];
//    [self.view addSubview:shadowView];
//    [self.view sendSubviewToBack:shadowView];
    
    self.view.frame = DEVICE_BOUNDS;
    _containerView.frame = (CGRect){.origin.x = 0, .origin.y = DEVICE_SIZE.height - _containerView.frame.size.height, .size = _containerView.frame.size};
    [self performBlock:^(id sender) {
        _containerView.alpha = 1.0f;
    } afterDelay:1.6f];
    
    _picArray = [[NSMutableArray alloc] init];
    
    [_okBtn setImage:[UIImage imageNamed:@"right_ok_enable.png"] forState:UIControlStateNormal];
    _okBtn.userInteractionEnabled = NO;
    
    [self setupHorizontalView];
    
//    [self fuck];
//    [self performBlock:^(id sender) {
//        [NSThread detachNewThreadSelector:@selector(getAllPhotoImages) toTarget:self withObject:nil];
//    } afterDelay:0.3f];
    
    [self performBlock:^(id sender) {
        [self getAllPhotoImages];
    } afterDelay:0.2f];
    
//    for (int i = 0; i < [_picArray count]; i++) {
//        SelectedButton *btn = (SelectedButton*)[self.containerView viewWithTag:kTagAlbumImgBtn + i];
//        [btn setImage:[_picArray objectAtIndex:i] forState:UIControlStateNormal];
//    }
}

//- (void)fuck {
//    if ([UIImagePickerController isCameraDeviceAvailable:[_pickerController cameraDevice]]) {
//        [self getAllPhotoImages];
//    } else {
//        [self fuck];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (IBAction)albumBtnPressed:(SelectedButton*)sender {
    sender.selectedImgView.hidden = sender.selected;
    sender.selected = !sender.selected;
    if (sender.selectedImgView.hidden) {
        [_picArray removeObject:sender.imageView.image];
    } else {
        if (sender.imageView.image) {
            [_picArray addObject:sender.imageView.image];
        }
    }
    
    BOOL canCameraBtnSelect = [_picArray count] > 0 ? NO : YES;
    [self canCameraBtnSelect:canCameraBtnSelect];
    
    BOOL canOkBtnSelect = !canCameraBtnSelect;
    [self canOkBtnSelect:canOkBtnSelect];
}

- (void)canCameraBtnSelect:(BOOL)canSelect {
    NSString *cameraImgStr = canSelect ? @"take_photo_able_53_v12.png" : @"take_photo_enable_53_v12";
    [_cameraBtn setImage:[UIImage imageNamed:cameraImgStr] forState:UIControlStateNormal];
    _cameraBtn.userInteractionEnabled = canSelect;
}

- (void)canOkBtnSelect:(BOOL)canSelect {
    NSString *okImgStr = canSelect ? @"right_ok_able.png" : @"right_ok_enable.png";
    [_okBtn setImage:[UIImage imageNamed:okImgStr] forState:UIControlStateNormal];
    _okBtn.userInteractionEnabled = canSelect;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)getAllPhotoImages {
//    return;
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
//    self.assetsArray = collector;
//    return;
    
    ALAssetsLibrary *al = [CameraOverlayViewController defaultAssetsLibrary];
    
    [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
          {
              if (asset && [[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                  [collector addObject:asset];
              }
          }];
         
         self.assetsArray = collector;
         [_jtListView reloadData];
     }
                    failureBlock:^(NSError *error) { NSLog(@"Boom!!!");}
     ];
    return;
    
    //定义读取失败的block
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
        NSLog(@"error occour =%@", [myerror localizedDescription]);
    };
    //定义Asset的枚举block
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        if (result != NULL) {
            //首先判断，获得的资源是photo还是video
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [collector addObject:result];
                
//                if (_countNum < SHOW_ALBUM_PIC_MAX_NUM) {
//                    UIImage *fullImg = [UIImage imageWithCGImage:[result.defaultRepresentation fullScreenImage]];
//////                    int i = [_picArray count];
////                    SelectedButton *btn = (SelectedButton*)[self.containerView viewWithTag:kTagAlbumImgBtn + _countNum];
////                    _countNum++;
////                    [btn setImage:fullImg forState:UIControlStateNormal];
//////                    [_picArray addObject:btn.imageView.image];
//////                    UIImage *img=[UIImage imageWithCGImage:result.thumbnail];
//                } else
//                    return ;
            }
        } else {
            
            self.assetsArray = collector;
            [_jtListView reloadData];
        }
    };
    //定义枚举groups的枚举block
    ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
        if (group == nil) {//如果相簿的组为空,即：相簿里面没有组，也没有图片
            return;
        }
        if (group != nil) {
            //对group做自己的处理
            
//            //继续枚举group下面的Asset
//            for (int i = 0; i < [group numberOfAssets]; i++) {//SHOW_ALBUM_PIC_MAX_NUM
//                [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - (i + 1)] options:0 usingBlock:groupEnumerAtion];//从最新拍的照片开始读取
//            }
//            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1 - _hasLoadPicNum] options:0 usingBlock:groupEnumerAtion];//从最新拍的照片开始读取
//            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:groupEnumerAtion];//从最新拍的照片开始读取
//            [group enumerateAssetsUsingBlock:groupEnumerAtion];//从以前拍的第一张照片开始读取
            [group enumerateAssetsUsingBlock:groupEnumerAtion];
        }
    };
    ALAssetsLibrary *library = [CameraOverlayViewController defaultAssetsLibrary];//[[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:libraryGroupsEnumeration
                         failureBlock:failureblock];
}


#pragma mark JTListView Initialization
- (void)setupHorizontalView {
    if (self.jtListView) {
        [self.jtListView removeFromSuperview];
        self.jtListView = nil;
    }
    JTListView *list = [[JTListView alloc] initWithFrame:CGRectMake(85, 14, 230, 72) layout:JTListViewLayoutLeftToRight];
//    list.scrollEnabled = [_imagesArray count] > MAX_PHOTO_NUM ? YES : NO;//只需要3张图片，所以不需要滑动
	list.delegate = self;
    list.dataSource = self;
    [self.containerView insertSubview:list atIndex:2];
//	[self.containerView addSubview:list];
    [list reloadData];
	self.jtListView = list;
}

#pragma mark - JTListViewDataSource
- (NSUInteger)numberOfItemsInListView:(JTListView *)listView {
    return [self.assetsArray count];
}

- (UIView *)listView:(JTListView *)listView viewForItemAtIndex:(NSUInteger)index {
    MyViewCell *cell = (MyViewCell*)[listView dequeueReusableView];
    if (!cell) {
        cell = [[MyViewCell alloc] init];
        SelectedButton *cellBtn = [SelectedButton buttonWithType:UIButtonTypeCustom];
        cellBtn.frame = CGRectMake(3, 0, 72, 72);
        [cell addSubview:cellBtn];
        cell.selcetBtn = cellBtn;
    }
    
    cell.selcetBtn.selectedImgView.hidden = YES;
    for (int i = 0; i < [_picArray count]; i++) {
        if ([[[_picArray objectAtIndex:i] objectForKey:INDEX_ROW] intValue] == index) {
            cell.selcetBtn.selectedImgView.hidden = NO;
//            cell.selcetBtn.selected = !cell.selcetBtn.selected;
            break;
        }
    }
    
    ALAsset *asset = [self.assetsArray objectAtIndex:[_assetsArray count] - 1 - index];
    [cell.selcetBtn setImage:[UIImage imageWithCGImage:[asset thumbnail]] forState:UIControlStateNormal];
    [cell.selcetBtn whenTapped:^{
//        cell.selcetBtn.selectedImgView.hidden = cell.selcetBtn.selected;
//        cell.selcetBtn.selected = !cell.selcetBtn.selected;
        if (cell.selcetBtn.selectedImgView.hidden) {
            if ([_picArray count] == 3) {
                [SVProgressHUD showErrorWithStatus:@"不能超过3张T_T"];
                return;
            }
            NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
            [aDict setObject:[NSNumber numberWithInt:index] forKey:INDEX_ROW];
            [aDict setObject:[_assetsArray objectAtIndex:[_assetsArray count] - 1 - index] forKey:IMAGE];
            [_picArray addObject:aDict];
        } else {
            if (cell.selcetBtn.imageView.image) {
                for (int i = 0; i < [_picArray count]; i++) {
                    if ([[[_picArray objectAtIndex:i] objectForKey:INDEX_ROW] intValue] == index) {
                        [_picArray removeObjectAtIndex:i];
                        break;
                    }
                }
            }
        }
        
        BOOL canCameraBtnSelect = [_picArray count] > 0 ? NO : YES;
        [self canCameraBtnSelect:canCameraBtnSelect];
        
        BOOL canOkBtnSelect = !canCameraBtnSelect;
        [self canOkBtnSelect:canOkBtnSelect];

        [_jtListView reloadData];
    }];
//    [cell.selcetBtn addTarget:self action:@selector(selectPicFromAlbumWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//- (void)selectPicFromAlbumWithBtn:(SelectedButton*)btn {
//    if ([_picArray count] == 3) {
//        [SVProgressHUD showErrorWithStatus:@"不能超过3张T_T"];
//        return;
//    }
//    [_picArray addObject:btn.imageView.image];
//    [self albumBtnPressed:btn];
//}

#pragma mark - JTListViewDelegate
- (CGFloat)listView:(JTListView *)listView widthForItemAtIndex:(NSUInteger)index {
    return 78;
}

- (CGFloat)listView:(JTListView *)listView heightForItemAtIndex:(NSUInteger)index {
    return 78;
}

//查找拍完照片后右下角的“完成”按钮
- (UIView*)findDoneBarButton:(UIView*)aView {
    Class cl = [aView class];
    NSString *desc = [cl description];
#define DONE_BTN_FRMAE_X      200
    if ([@"PLCropOverlayBottomBarButton" isEqualToString:desc] && aView.frame.origin.x > DONE_BTN_FRMAE_X)
        return aView;
    for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findDoneBarButton:subView];
        if (subView && subView.frame.origin.x > DONE_BTN_FRMAE_X )
            return subView;
    }
    return nil;
}

//拍照按钮
-(IBAction)takeThePic:(UIButton*)sender{
    [_pickerController takePicture];
    _hasTakePicture = YES;
    for (int i = 0; i < 3; i++) {
        UIView *obj = [self.containerView.subviews objectAtIndex:i];
        obj.hidden = YES;
    }
    [self canCameraBtnSelect:NO];
    [self canOkBtnSelect:YES];
    if (!self.doneBtn) {
        self.doneBtn = (UIButton*)[self findDoneBarButton:_theCon.view];
    }
}

//返回
-(IBAction)backBtnPressed:(UIButton*)sender{
    if (_hasTakePicture) {
        _hasTakePicture = NO;
        for (int i = 0; i < 3; i++) {
            UIView *obj = [self.containerView.subviews objectAtIndex:i];
            obj.hidden = NO;
        }
        [self canCameraBtnSelect:YES];
        [self canOkBtnSelect:NO];
        [_retakeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [_pickerController dismissModalViewControllerAnimated:YES];
    }
}

//OK按钮
- (IBAction)okBtnPressed:(id)sender {
    if (_hasTakePicture) {
        [_doneBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        _hasTakePicture = NO;
        [self canCameraBtnSelect:YES];
        [self canOkBtnSelect:NO];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_POST_VIEWCONTROLLER object:_picArray];
    }
}

//更多图片
- (void)buildMorePicBtnBlock:(MorePicBtnPressedBlock)actionBlock {
    self.morePicBtnPressedBlock = actionBlock;
}

- (IBAction)morePicBtnPressed:(UIButton*)sender {
    if (self.morePicBtnPressedBlock) {
        self.morePicBtnPressedBlock(sender);
    }
//    AGImagePickerController *imagePickerController = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
//        if (error == nil) {
////            NSLog(@"User has cancelled.");
////            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
////                [_pickerController.modalViewController dismissModalViewControllerAnimated:YES];
////            } else {
////                [_pickerController.presentedViewController dismissModalViewControllerAnimated:YES];
////            }
//            [_agImgPickerCon dismissModalViewControllerAnimated:YES];
//        } else {
//            NSLog(@"Error: %@", error);
//            // Wait for the view controller to show first and hide it after that
//            double delayInSeconds = 0.5;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self dismissModalViewControllerAnimated:YES];
//            });
//        }
//        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//        
//    } andSuccessBlock:^(NSArray *info) {
//        NSLog(@"Info: %@", info);
//        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
//        for (int i = 0; i < [info count]; i++) {
//            ALAsset *albumSet = (ALAsset*)[info objectAtIndex:i];
//            UIImage *fullImg = [UIImage imageWithCGImage:[albumSet.defaultRepresentation fullScreenImage]];
//            [tmpArray addObject:fullImg];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_POST_VIEWCONTROLLER object:tmpArray];
//        [self dismissModalViewControllerAnimated:YES];
//        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    }];
//    self.agImgPickerCon = imagePickerController;
//    [_pickerController presentModalViewController:imagePickerController animated:YES];
}

@end
