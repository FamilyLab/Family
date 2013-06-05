//
//  FamilyViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableController.h"
@interface FamilyViewController : TableController<NSXMLParserDelegate>
@property (nonatomic,assign)int  fmembers;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic,strong)IBOutlet UILabel *cityLabel;
@property (nonatomic,strong)IBOutlet UILabel *dateLabel;
@property (nonatomic,strong)IBOutlet UILabel *weatherLabel;
@property (nonatomic,strong)IBOutlet UILabel *weekdayLabel;
@property (nonatomic,strong)IBOutlet UIView * cityInfoView;
@property (nonatomic,strong)IBOutlet UIButton *addBtn;
@property (nonatomic,strong)IBOutlet UIImageView *weatherImg;
@property (nonatomic,strong)IBOutlet UILabel *tempertureLbl;    
@property (nonatomic,copy) NSMutableString *xmlStr;
@property (nonatomic,strong)IBOutlet UIImageView *void_familyImg;
@property (nonatomic,strong)IBOutlet UIImageView *void_feedImg;
@property (nonatomic,strong)IBOutlet UIView *postBtnView;
@property (nonatomic,strong)IBOutlet UIButton *postAddBtn;
@property (nonatomic,strong) IBOutlet UIButton *post_photoBtn;
@property (nonatomic,strong) IBOutlet UIButton *post_diaryBtn;
@property (nonatomic,strong) IBOutlet UIButton *post_actBtn;
@property (nonatomic,strong) IBOutlet UIButton *post_pmBtn;
@property (nonatomic,strong) IBOutlet UIButton *post_hiBtn;
- (IBAction)setInfo:(id)sender;
- (IBAction)addAction:(id)sender;
- (IBAction )addFamilyMember:(id)sender;
- (IBAction)showPostViewController:(id)sender;
- (IBAction)expandPostView:(id)sender;
@end
