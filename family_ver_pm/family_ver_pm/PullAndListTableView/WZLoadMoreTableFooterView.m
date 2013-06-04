//
//  WZLoadMoreTableFooterView.m
//  TableViewPullLift
//
//  Created by zhe wang on 11-7-6.
//  Copyright 2011年 nasawz.com. All rights reserved.
//

#import "WZLoadMoreTableFooterView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface WZLoadMoreTableFooterView (Private)
- (void)setState:(WZLiftLoadMoreState)aState;
@end

@implementation WZLoadMoreTableFooterView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 65.0f - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,65.0f - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, 0.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrowUp.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, 65.0f - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
		[self setState:WZLiftLoadMoreNormal];
		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)loadmoreLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(wzRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate wzLoadMoreTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setAMSymbol:@"AM"];
//		[formatter setPMSymbol:@"PM"];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"WZLoadMoreTableFooterView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(WZLiftLoadMoreState)aState{
	
	switch (aState) {
		case WZLiftLoadMoreLifting:
			
//			_statusLabel.text = NSLocalizedString(@"Release to loadmore...", @"Release to refresh status");
            _statusLabel.text = @"松开加载更多...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case WZLiftLoadMoreNormal:
			
			if (_state == WZLiftLoadMoreLifting) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
//			_statusLabel.text = NSLocalizedString(@"Pull up to loadmore...", @"Pull up to refresh status");
            _statusLabel.text = @"上拉加载更多...";
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self loadmoreLastUpdatedDate];
			
			break;
		case WZLiftLoadMoreLoading:
			
//			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
            _statusLabel.text = @"正在加载...";
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)wzLoadMoreScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == WZLiftLoadMoreLoading) {        
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 65.0f, 0.0f);		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = YES;
		if ([_delegate respondsToSelector:@selector(wzLoadMoreTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate wzLoadMoreTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == WZLiftLoadMoreLifting && scrollView.contentOffset.y + (scrollView.frame.size.height) < (scrollView.contentSize.height) + 65.0f && scrollView.contentOffset.y > 0.0f && !_loading) {
			[self setState:WZLiftLoadMoreNormal];
		} else if (_state == WZLiftLoadMoreNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > (scrollView.contentSize.height) + 65.0f && !_loading) {
			[self setState:WZLiftLoadMoreLifting];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)wzLoadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(wzLoadMoreTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate wzLoadMoreTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y + (scrollView.frame.size.height) > (scrollView.contentSize.height) + 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(wzLoadMoreTableHeaderDidTriggerRefresh:)]) {
			[_delegate wzLoadMoreTableHeaderDidTriggerRefresh:self];
		}
		[self setState:WZLiftLoadMoreLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 65.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)wzLoadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];    
    [self setFrame:CGRectMake(0.0f, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height)];
    
	[UIView commitAnimations];
	
	[self setState:WZLiftLoadMoreNormal];
    
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}

- (void)setStatusLabelColor:(UIColor *)color andFont:(UIFont *)font
{
    if (color != nil) {
        _statusLabel.textColor = color;
//        [color release];
    }
    
    if (font != nil) {
        _statusLabel.font = font;
//        [font release];
    }
}

- (void)setLastUpdateLabelColor:(UIColor *)color andFont:(UIFont *)font
{
    if (color != nil) {
        _lastUpdatedLabel.textColor = color;
//        [color release];
    }
    
    if (font != nil) {
        _lastUpdatedLabel.font = font;
//        [font release];
    }
}

@end
