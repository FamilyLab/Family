//
//  AddChildViewController.h
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "MyImagePickerController.h"


@interface AddChildViewController : BaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate>
{

}
@property (nonatomic,strong)MyImagePickerController *picker;
@property (nonatomic,strong)IBOutlet UIButton *skipButton;
@property (nonatomic,strong)IBOutlet UITextField *nikenameField;
@property (nonatomic,strong)IBOutlet UITextField *birthdayField;
@property (nonatomic,strong)UIPopoverController *datePickerContainer;
@property (nonatomic,assign)BOOL editMode;
@property (nonatomic,strong)NSString *badyId;
@property (nonatomic,strong)NSString *tagId;

- (IBAction)birthdayBtnPressed:(id)sender;
- (IBAction)sexyBtnPressed:(id)sender;
- (IBAction)headBtnPressed:(id)sender;
- (IBAction)okBtnPressed:(id)sender;
- (void)adjustLayout;
- (void)setBabyDataWith:(NSDictionary *)dict;
- (IBAction)skipAction:(id)sender;

@end
