//
//  HorizontalScrollViewController.m
//  HorizontalScrollView
//
//  Created by pandara on 13-4-23.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "HorizontalScrollViewController.h"
#import "Defines.h"

@interface HorizontalScrollViewController ()

@end

@implementation HorizontalScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.reuseViewQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

//存放可重用view
- (void)pushReuseView:(UIView *)view
{
    [self.reuseViewQueue addObject:view];
}

//弹出可以重用的view
- (MyTableCell *)dequeueReuseView
{
    if ([self.reuseViewQueue count] > 0) {
        MyTableCell *cell = [self.reuseViewQueue lastObject];
        [self.reuseViewQueue removeLastObject];
        return cell;
    }
    return nil;
}

- (MyTableCell *)dequeueReuseViewWithReuseID:(NSString *)reuseID
{
    for (MyTableCell *cell in self.reuseViewQueue) {
        if ([cell.reuseID isEqualToString:reuseID]) {
            [self.reuseViewQueue removeObject:cell];
            NSLog(@"get cell with reuseID %@", reuseID);
            return cell;
        }
    }
    
    return nil;
}

//初始化元素 当取到第一个detailInfo时被调用
- (void)initElementWithScrollViewFrame:(CGRect)frame;
{
    originScrollPage = 0;
    receiveScrollEvent = YES;
    
    firstPage = YES;
    lastPage = NO;
    
    loadPrevPageLock = YES;
    loadNextPageLock = YES;
    loadFirstPageLock = YES;
    
    totalScrollPage = 1;
    currentDataPage = 0;
    totalDataPageFromURLAPI = -1;
    self.subViews = [[NSMutableArray alloc] init];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor whiteColor];
//    self.scrollView.contentSize = CGSizeMake(frame.size.width * totalScrollPage, frame.size.height);
    self.scrollView.contentSize = CGSizeMake(frame.size.width + 1, frame.size.height);
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    //先加载前两页
    [self.subViews addObject:[self loadDataToScrollPage:0 fromDataPage:0]];
//    [self.subViews addObject:[self loadDataToScrollPage:1 fromDataPage:1]];
//    [self loadDataToScrollPage:2 fromDataPage:2];
}

//加载新的一页
- (void)loadNextPage
{
    if (loadNextPageLock) {//不会有两个线程同时进入
        loadNextPageLock = FALSE;

        if (totalScrollPage == 1) {
            NSLog(@"totalScrollPage 为 1");
            totalScrollPage = 2;
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * totalScrollPage, self.scrollView.frame.size.height);
            
            UIView *view = [self loadDataToScrollPage:(totalScrollPage - 1) fromDataPage:(currentDataPage + 1)];
            [self.subViews addObject:view];
            loadNextPageLock = YES;
            
            return;
        }
        
        if (totalScrollPage == 2) {
            totalScrollPage = 3;
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * totalScrollPage, self.scrollView.frame.size.height);
            
            UIView *view = [self loadDataToScrollPage:(totalScrollPage - 1) fromDataPage:(currentDataPage + 1)];
            [self.subViews addObject:view];
            loadNextPageLock = YES;
            
            return;
        }
        
        if (totalScrollPage == 3) {

            [[self.subViews objectAtIndex:0] removeFromSuperview];
            [self pushReuseView:[self.subViews objectAtIndex:0]];
            [self.subViews removeObjectAtIndex:0];
            NSLog(@"删除subview：removeObjectAtIndex0 in loadNextPage");
            NSLog(@"现在的[self.subViews count]:%d", [self.subViews count]);
            
            for (int i = 0; i < [self.subViews count]; i++) {
                UIView *subView = [self.subViews objectAtIndex:i];
                subView.center = CGPointMake(subView.center.x - self.scrollView.frame.size.width, subView.center.y);
            }
            
            [self setScrollViewContentOffset:CGPointMake(self.scrollView.frame.size.width * (totalScrollPage - 2), self.scrollView.contentOffset.y)];
            
            UIView *view = [self loadDataToScrollPage:(totalScrollPage - 1) fromDataPage:(currentDataPage + 1)];
            
            [self.subViews addObject:view];
            NSLog(@"向队列压进一个view，现在的[self.subViews count]:%d", [self.subViews count]);
            loadNextPageLock = YES;
            
            return;
        }
    }
}

//加载前一页
- (void)loadPrevPage
{
    if (loadPrevPageLock) {//不会有两个线程同时进入
        loadPrevPageLock = FALSE;
        
        [[self.subViews objectAtIndex:(totalScrollPage - 1)] removeFromSuperview];
        [self pushReuseView:[self.subViews objectAtIndex:(totalScrollPage - 1)]];
        [self.subViews removeObjectAtIndex:(totalScrollPage - 1)];
        NSLog(@"删除subview：removeObjectAtIndex:%d", (totalScrollPage - 1));
        NSLog(@"现在的[self.subViews count]:%d", [self.subViews count]);
        
        for (int i = 0; i < [self.subViews count]; i++) {
            UIView *subView = [self.subViews objectAtIndex:i];
            subView.center = CGPointMake(subView.center.x + self.scrollView.frame.size.width, subView.center.y);
        }
        
        [self setScrollViewContentOffset:CGPointMake(self.scrollView.frame.size.width * (totalScrollPage - 2), self.scrollView.contentOffset.y)];

        UIView *view = [self loadDataToScrollPage:0 fromDataPage:(currentDataPage - 1)];
        [self.subViews insertObject:view atIndex:0];
        NSLog(@"向队列插入一个view, 现在的[self.subViews count]:%d", [self.subViews count]);
        
        loadPrevPageLock = YES;
    }
}

//重新加载某一页
- (void)reloadDataFromDataPage:(int)page
{
    if (page == 0) {
        [[self.subViews objectAtIndex:0] removeFromSuperview];
        [self.subViews removeObjectAtIndex:0];
        
        [self.subViews addObject:[self loadDataToScrollPage:0 fromDataPage:0]];
    }
}

//重新加载数据
- (void)reloadData
{
    int scurrentDataPage = currentDataPage;
    
    [self.subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.subViews removeAllObjects];
    [self.reuseViewQueue removeAllObjects];
    
    if (currentDataPage == [self numberOfDataPage] - 1) {//到达最后一张数据页，同时滚动到最后一页
        //重新加载所有页
        //(是否有必要reload?)
        if (currentDataPage > 1) {
            [self.subViews addObject:[self loadDataToScrollPage:([self currentScrollPage] - 2) fromDataPage:(currentDataPage - 2)]];
        }
        
        if (currentDataPage > 0) {
            [self.subViews addObject:[self loadDataToScrollPage:([self currentScrollPage] - 1) fromDataPage:currentDataPage - 1]];
        }
        
        [self.subViews addObject:[self loadDataToScrollPage:([self currentScrollPage]) fromDataPage:currentDataPage]];
    } else if (currentDataPage < [self numberOfDataPage] - 1) {
        if ([self currentScrollPage] == totalScrollPage - 1) {//滚动至最后一页（可能发生于数据加载中）
            //将当前页设置为三页中间
            [self setScrollViewContentOffset:CGPointMake(self.scrollView.frame.size.width * (totalScrollPage - 2), 0)];
            currentDataPage = scurrentDataPage;
        }
        
        if (currentDataPage - 1 > 0) {
            [self.subViews addObject:[self loadDataToScrollPage:([self currentScrollPage] - 1) fromDataPage:currentDataPage - 1]];
        }
        
        [self.subViews addObject:[self loadDataToScrollPage:[self currentScrollPage] fromDataPage:currentDataPage]];
        [self.subViews addObject:[self loadDataToScrollPage:([self currentScrollPage] + 1) fromDataPage:currentDataPage + 1]];
    }
}

//返回第一页
- (void)backToFirstPage
{
    if (loadFirstPageLock) {//不会有两个线程同时进入
        loadFirstPageLock = FALSE;
        
        if (totalScrollPage == 3) {//totalScrollPage为2时执行会在回到第一页的时候，加载第二页时出现越界
            [[self.subViews objectAtIndex:(totalScrollPage - 1)] removeFromSuperview];
            [self pushReuseView:[self.subViews objectAtIndex:(totalScrollPage - 1)]];
            [self.subViews removeObjectAtIndex:(totalScrollPage - 1)];
            NSLog(@"删除subview：removeObjectAtIndex:%d", (totalScrollPage - 1));
            NSLog(@"现在的[self.subViews count]:%d", [self.subViews count]);
            
            totalScrollPage -= 1;
        }
        
        [self loadDataToScrollPage:0 fromDataPage:0];
        currentDataPage = 1;

        didScrollToFirst = YES;
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height) animated:YES];

        loadFirstPageLock = YES;
    }
}

//根据当前数据页加载数据
- (UIView *)loadDataToScrollPage:(int)scrollPage fromDataPage:(int)dataPage
{
    NSLog(@"loadDataToScrollPage:%d fromDataPage:%d", scrollPage, dataPage);
    UIView *view = [self viewFromDataPage:dataPage];
    CGPoint point = CGPointMake(self.scrollView.frame.size.width / 2 + (scrollPage % totalScrollPage) * self.scrollView.frame.size.width, view.center.y);
    view.center = point;
    [self.scrollView addSubview:view];
    return view;
}

//更新当前数据页码
- (void)setCurrentDataPageFromScrollDirection:(int)direction
{
    currentDataPage += direction;
    if (currentDataPage == 0) {
        firstPage = YES;
    }
}

//根据滚动contentOffset设置当前数据页
- (void)setCurrentDataPage
{
//    if (abs(self.scrollView.contentOffset.x - originalContentOffset.x) >= self.scrollView.frame.size.width) {
//        if (self.scrollView.contentOffset.x > originalContentOffset.x) {
//            currentDataPage++;
//        } else if (self.scrollView.contentOffset.x < originalContentOffset.x) {
//            currentDataPage--;
//        }
//        NSLog(@"current data page in setCurrentDataPage%d", currentDataPage);
//        originalContentOffset = self.scrollView.contentOffset;
//    }
    if ([self currentScrollPage] != originScrollPage) {
        currentDataPage += ([self currentScrollPage] - originScrollPage);
        originScrollPage = [self currentScrollPage];
        //        NSLog(@"set originScrollPage in setCurrentDataPage:%d", originScrollPage);
    }
}

//当前滚动视图显示的是第几个滚动页 0, 1, 2……
- (int)currentScrollPage
{
    return self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}

//设置contentoffset
- (void)setScrollViewContentOffset:(CGPoint)newContentOffset
{
    receiveScrollEvent = NO;
    [self.scrollView setContentOffset:newContentOffset animated:NO];
    originScrollPage = [self currentScrollPage];
}

//----------------------子类controller中应该重载------------------------
//根据数据页码返回数据view
- (UIView *)viewFromDataPage:(int)dataPage
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = [NSString stringWithFormat:@"%d", dataPage];
    return label;
}

//返回数据总页数
//- (int)numberOfDataPage
//{
//    return 50;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initElementWithScrollViewFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
}

//在取得信息列表之后更新totalScrollPage等参数
- (void)refreshBaseData
{
//    if ([self numberOfTotalDataPage] >= 2) {
//        if ([self numberOfDataPage] >= 2) {
//            [self loadNextPage];
//        }
//    } else {
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOriginDataPage
{
    originDataPage = currentDataPage;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self setOriginDataPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.infoList count] == 1) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    }
}

- (void)scrollPageDidChange:(int)currentScrollPage
{
    NSLog(@"哎呀妈呀！滚动到其他页了！");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (receiveScrollEvent) {
        [self setCurrentDataPage];
        
        //发出滚动页改变通知 并设置originDataPage
        CGFloat scrollViewOffsetX = scrollView.contentOffset.x;
        if (originDataPage != currentDataPage) {
            [self scrollPageDidChange:[self currentScrollPage]];
            [self setOriginDataPage];
        }
        
        //到达最后一个滚动页时加载后一页
        if (scrollView.contentOffset.x >= scrollView.frame.size.width * (totalScrollPage - 1)) {
            if (currentDataPage < [self numberOfDataPage] - 1) {
                [self loadNextPage];
            }
            return;
        }
        
        //到达第一个滚动页是加载前一页
        if (scrollView.contentOffset.x <= 0) {
            if (currentDataPage != 0) {
                [self loadPrevPage];
            }
            if (didScrollToFirst) {
                didScrollToFirst = NO;
                [self loadDataToScrollPage:1 fromDataPage:1];
            }
            
            return;
        }
    } else {
        receiveScrollEvent = YES;
    }
}

@end
