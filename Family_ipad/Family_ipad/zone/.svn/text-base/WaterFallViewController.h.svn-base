//
//  WaterFallViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-3-27.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullPsCollectionView.h"

@interface WaterFallViewController : UIViewController<PSCollectionViewDelegate, PSCollectionViewDataSource,PullPsCollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PullPsCollectionView *collectionView;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy)  NSString *tagID;
@property (nonatomic, assign)BOOL needRemoveObjects;
@property (nonatomic, assign)NSUInteger currentPage;
@property (nonatomic, assign)WaterFallType contentType;
@property (nonatomic, assign)UIViewController *parent;
@property (nonatomic, strong)IBOutlet UIButton *btn;
- (void)loadDataSource:(NSNumber *)sender;
- (void) refreshTable:(NSNumber *)sender;
- (IBAction)backAction:(id)sender;
@end
