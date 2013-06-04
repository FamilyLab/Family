//
//  WZRefreshTableHeaderView.h
//  TableViewPullLift
//
//  Created by zhe wang on 11-7-6.
//  Copyright 2011年 nasawz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	WZPullRefreshPulling = 0,
	WZPullRefreshNormal,
	WZPullRefreshLoading,	
} WZPullRefreshState;

@protocol WZRefreshTableHeaderDelegate;
@interface WZRefreshTableHeaderView : UIView {
	id _delegate;
	WZPullRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;    
}

@property(nonatomic,assign) id <WZRefreshTableHeaderDelegate> delegate;
- (void)setStatusLabelColor:(UIColor *)color andFont:(UIFont *)font;
- (void)setLastUpdateLabelColor:(UIColor *)color andFont:(UIFont *)font;

- (void)refreshLastUpdatedDate;
- (void)wzRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)wzRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)wzRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol WZRefreshTableHeaderDelegate
- (void)wzRefreshTableHeaderDidTriggerRefresh:(WZRefreshTableHeaderView*)view;
- (BOOL)wzRefreshTableHeaderDataSourceIsLoading:(WZRefreshTableHeaderView*)view;
@optional
- (NSDate*)wzRefreshTableHeaderDataSourceLastUpdated:(WZRefreshTableHeaderView*)view;
@end