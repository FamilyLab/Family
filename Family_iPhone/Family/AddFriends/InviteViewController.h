//
//  InviteViewController.h
//  Family
//
//  Created by Aevitx on 13-6-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TableController.h"
#import "BottomView.h"
#import "TopView.h"
#import "MySearchBar.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CellHeader.h"

@interface InviteViewController : TableController <BottomViewDelegate, ABPeoplePickerNavigationControllerDelegate, UISearchBarDelegate, UITextViewDelegate>

@property (nonatomic, assign) TopViewType topViewType;
@property (nonatomic, strong) IBOutlet UIView *tableFooter;

@property (nonatomic, assign) IBOutlet UITextField *nameTextField;
@property (nonatomic, assign) IBOutlet UITextField *phoneTextField;
@property (nonatomic, assign) IBOutlet UILabel *smsLbl;
//@property (nonatomic, strong) IBOutlet UIButton *showAddressBookBtn;

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *phoneStr;
@property (nonatomic, copy) NSString *smsStr;

@property (nonatomic, copy) NSString *passwordStr;

@property (nonatomic, strong) IBOutlet CellHeader *cellHeader;

@property (nonatomic, strong) MySearchBar *mySearchBar;

@property (nonatomic, strong) NSMutableArray *addressBookArray;

@end
