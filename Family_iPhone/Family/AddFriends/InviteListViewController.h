//
//  InviteListViewController.h
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "TableController.h"
#import "BottomView.h"
#import "TopView.h"
#import "InviteCell.h"
#import "CellHeader.h"
#import "MySearchBar.h"
#import "DDAlertPrompt.h"

typedef enum {
    searchInOurWeb   = 0,//搜索本站用户
    searchPhoneNum   = 1 //搜索电话号码（这个电话号码不一定是本站用户）
} SearchWhere;


@interface InviteListViewController : TableController <BottomViewDelegate, CommonCellDelegate, UISearchBarDelegate> {
    BOOL isFirstShow;
}

@property (nonatomic, assign) TopViewType topViewType;
//@property (nonatomic, assign) LoginState loginState;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet CellHeader *cellHeader;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, assign) BOOL canSearch;

@property (nonatomic, strong) MySearchBar *mySearchBar;

@property (nonatomic, assign) SearchWhere searchWhere;

@end
