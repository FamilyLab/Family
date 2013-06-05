//
//  ZoneWaterFallView.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-11.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullPsCollectionView.h"

@interface ZoneWaterFallView : UIView<PSCollectionViewDelegate, PSCollectionViewDataSource,PullPsCollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PullPsCollectionView *collectionView;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy)  NSString *tagID;
@property (nonatomic, assign)BOOL needRemoveObjects;
@property (nonatomic, assign)NSUInteger currentPage;
@property (nonatomic, assign)WaterFallType contentType;
@property (nonatomic, assign)UIViewController *parent;
- (void)loadDataSource:(NSNumber *)sender;
- (void) refreshTable:(NSNumber *)sender;
@end
