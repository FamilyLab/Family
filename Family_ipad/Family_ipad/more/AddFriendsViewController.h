//
//  AddFriendsViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-20.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ToolBarView.h"
#import "MySearchBar.h"
@class DetailHeaderView;
@interface AddFriendsViewController : TableController

@property (nonatomic,strong)IBOutlet ToolBarView *toolBarView;
@property (nonatomic,strong)IBOutlet DetailHeaderView *detail_header;
@property (nonatomic,strong)IBOutlet UITextField *searchTextFiled;
@property (nonatomic,strong)IBOutlet UIView *contentView;
@property (nonatomic,strong)IBOutlet UIView *searchView;
@property (nonatomic,strong)IBOutlet MySearchBar *searchBar;
@property (nonatomic,copy)NSString *kw;
- (IBAction)backAction:(id)sender;
- (void)adjustLayout;
- (IBAction)sendRequest:(id)sender;
@end    
