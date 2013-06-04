//
//  HorizontalTableView.m
//  family_ver_pm
//
//  Created by pandara on 13-3-21.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "HorizontalTableView.h"

@implementation HorizontalTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.rowHeight = DEVICE_SIZE.width;
        self.transform = CGAffineTransformMakeRotation(-1 * M_PI / 2);
        self.pagingEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSIndexPath *)prevPage:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        [self scrollToRowAtIndexPath:targetIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return targetIndexPath;
    }
    
    return indexPath;
}

- (BOOL)nextPage:(NSIndexPath *)indexPath withTotalPage:(NSInteger)pageCount
{
    if (indexPath.row < pageCount - 1) {
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [self scrollToRowAtIndexPath:targetIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    
    return YES;
}
@end
