//
//  MySingleSelectionGroup.h
//  label_test
//
//  Created by pandara on 13-5-30.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyToolBarDelegate.h"

@interface MySingleSelectionGroup : UIView<UITableViewDataSource, UITableViewDelegate> {
    void (^selectedBlock)(int selectedIndex);
}

@property (strong, nonatomic) UITableView *mainTableView;
@property (strong, nonatomic) NSArray *selectionTextArray;

- (id)initWithFrame:(CGRect)frame
          textArray:(NSArray *)textArray
      cellRowHeight:(CGFloat)cellRowHeight
   andSelectedBlock:(void (^)(int selectedIndex))sselectedBlock;

@end
