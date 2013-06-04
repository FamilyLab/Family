//
//  MySingleSelectionGroup.m
//  label_test
//
//  Created by pandara on 13-5-30.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "MySingleSelectionGroup.h"
#import "MySingleSelectionCell.h"

@implementation MySingleSelectionGroup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (id)initWithFrame:(CGRect)frame
            textArray:(NSArray *)textArray
        cellRowHeight:(CGFloat)cellRowHeight
     andSelectedBlock:(void (^)(int selectedIndex))sselectedBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionTextArray = textArray;
        selectedBlock = sselectedBlock;
//        self.backgroundColor = [UIColor redColor];
        
        self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.mainTableView.delegate = self;
        self.mainTableView.dataSource = self;
        self.mainTableView.rowHeight = cellRowHeight;
        self.mainTableView.backgroundColor = [UIColor clearColor];
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mainTableView.scrollEnabled = NO;
        [self addSubview:self.mainTableView];
    }
    return self;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.selectionTextArray count] != 0) {
        return [self.selectionTextArray count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySingleSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleSelectionCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MySingleSelectionCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if ([self.selectionTextArray count] == 0) {
        NSLog(@"MySingleSelectionGroup:haven't get the select text array!");
        return cell;
    }
    
    [cell setSelectText:[self.selectionTextArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedBlock(indexPath.row);
}


@end














