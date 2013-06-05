//
//  InviteFamilyViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "TableController.h"
#import "DetailHeaderView.h"
#import "ToolBarView.h"
#import <AddressBookUI/AddressBookUI.h>
#import "MySearchBar.h"
@interface InviteFamilyViewController : TableController<ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate>
{
    IBOutlet DetailHeaderView *detail_header;
    IBOutlet ToolBarView *toolBarView;
    IBOutlet UIView *contentView;
}
@property (nonatomic,strong) DetailHeaderView *detail_header;
@property (nonatomic,strong) ToolBarView *toolBarView;
@property (nonatomic,strong) IBOutlet UITextField *searchTextFiled;
@property (nonatomic,strong)IBOutlet  MySearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UILabel *smsLbl;
@property (nonatomic, copy) NSString *passwordStr;
@property (nonatomic,strong) IBOutlet UIScrollView *scrollerView;
- (void)adjustLayout;
- (IBAction)selectSource:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)inviteAndRegisterBtnPressed:(id)sender ;
- (IBAction)showAddressPicker;
- (IBAction)sendRequest:(id)sender;
- (IBAction)setscrollerviewContentOffset:(id)sender;
@end
