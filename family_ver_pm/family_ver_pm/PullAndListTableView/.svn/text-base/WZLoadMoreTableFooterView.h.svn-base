//
//  WZLoadMoreTableFooterView.h
//  TableViewPullLift
//
//  Created by zhe wang on 11-7-6.
//  Copyright 2011年 nasawz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	WZLiftLoadMoreLifting = 0,
	WZLiftLoadMoreNormal,
	WZLiftLoadMoreLoading,	
} WZLiftLoadMoreState;

@protocol WZLoadMoreTableFooterDelegate;
@interface WZLoadMoreTableFooterView : UIView {
	id _delegate;
	WZLiftLoadMoreState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;      
}
@property(nonatomic,assign) id <WZLoadMoreTableFooterDelegate> delegate;

- (void)setStatusLabelColor:(UIColor *)color andFont:(UIFont *)font;
- (void)setLastUpdateLabelColor:(UIColor *)color andFont:(UIFont *)font;

- (void)loadmoreLastUpdatedDate;
- (void)wzLoadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)wzLoadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)wzLoadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@end

@protocol WZLoadMoreTableFooterDelegate
- (void)wzLoadMoreTableHeaderDidTriggerRefresh:(WZLoadMoreTableFooterView*)view;
- (BOOL)wzLoadMoreTableHeaderDataSourceIsLoading:(WZLoadMoreTableFooterView*)view;
@optional
- (NSDate*)wzLoadMoreTableHeaderDataSourceLastUpdated:(WZLoadMoreTableFooterView*)view;
@end