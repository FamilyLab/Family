//
//  AddFriendsViewController.h
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

//#import "BaseViewController.h"
#import "TableController.h"
#import "BottomView.h"
#import "TopView.h"
#import "CellHeader.h"
#import "TableController.h"
#import "InviteCell.h"
#import "MySearchBar.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface AddFriendsViewController : TableController <BottomViewDelegate, UISearchBarDelegate, CommonCellDelegate, ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate>

//@property (nonatomic, strong) IBOutlet MySearchBar *searchBar;
@property (nonatomic, assign) TopViewType topViewType;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet CellHeader *cellHeader;

@property (nonatomic, strong) MySearchBar *mySearchBar;

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UILabel *smsLbl;
//@property (nonatomic, strong) IBOutlet UIButton *showAddressBookBtn;

@property (nonatomic, copy) NSString *passwordStr;

@end
