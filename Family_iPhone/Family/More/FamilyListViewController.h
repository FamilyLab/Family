//
//  FamilyListViewController.h
//  Family
//
//  Created by Aevitx on 13-1-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TableController.h"
#import "TopView.h"
#import "BottomView.h"
#import "CellHeader.h"
#import "InviteCell.h"

typedef enum {
    myFamilyListType        = 0,
    askForMyFamilyListType  = 1,
    taskListType            = 2
} ControllerType;

@interface FamilyListViewController : TableController <TopViewDelegate, BottomViewDelegate, CommonCellDelegate, UIWebViewDelegate> {
    BOOL isFirstShow;
}

@property (nonatomic, strong) TopView *topBarView;
@property (nonatomic, strong) IBOutlet CellHeader *cellHeader;
@property (nonatomic, assign) ControllerType conType;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL canSelect;
//@property (nonatomic, strong) NSMutableArray *togetherArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
//@property (nonatomic, strong) NSMutableDictionary *infoDict;

@property (nonatomic, assign) BOOL isWantToPostPM;//发私信
//@property (nonatomic, strong) IBOutlet UIWebView *web;
@end
