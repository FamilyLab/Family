 /*
 This module is licenced under the BSD license.
 
 Copyright (C) 2011 by raw engineering <nikhil.jain (at) raweng (dot) com, reefaq.mohammed (at) raweng (dot) com>.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
//
//  RootView.m
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import "RootViewController.h"
#import "ConciseKit.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "StackScrollViewController.h"
#import "NewsViewController.h"
#import "FamilyViewController.h"
#import "MyHttpClient.h"
#import "ZoneWaterFallView.h"
#import "KGModal.h"
#import "GuideViewController.h"
#import "LoadingView.h"
#import "NSObject+BlocksKit.h"
#define LEFT_MENU_WIDTH 100
@interface UIViewExt : UIView {} 
@end


@implementation UIViewExt
- (UIView *) hitTest: (CGPoint) pt withEvent: (UIEvent *) event 
{   
	
	UIView* viewToReturn=nil;
	CGPoint pointToReturn;
	
	UIView* uiRightView = (UIView*)[[self subviews] objectAtIndex:1];
	
	if ([[uiRightView subviews] objectAtIndex:0]) {
		
		UIView* uiStackScrollView = [[uiRightView subviews] objectAtIndex:0];	
		
		if ([[uiStackScrollView subviews] objectAtIndex:1]) {	 
			
			UIView* uiSlideView = [[uiStackScrollView subviews] objectAtIndex:1];	
			
			for (UIView* subView in [uiSlideView subviews]) {
				CGPoint point  = [subView convertPoint:pt fromView:self];
				if ([subView pointInside:point withEvent:event]) {
					viewToReturn = subView;
					pointToReturn = point;
				}
				
			}
		}
		
	}
	
	if(viewToReturn != nil) {
		return [viewToReturn hitTest:pointToReturn withEvent:event];		
	}
	
	return [super hitTest:pt withEvent:event];	
	
}

@end

@implementation RootViewController
@synthesize menuViewController, stackScrollViewController,familyListController;
/**
 弹出用户指引视图
 @param 无
 @return 无
 */
- (void)presentGuidViewCon
{
    GuideViewController *con = [[GuideViewController alloc] initWithNibName:nil bundle:nil];
    con.father = self;
    con.selector = @selector(overSlideBtnPressed:);
    [self presentModalViewController:con animated:NO];
    return;
}
- (void)bringFamilyListToFront
{
    if ([[self.stackScrollViewController.slideViews subviews]count]==1) {
        [rootView bringSubviewToFront:familyListController.view];
    }
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {		
    }
    return self;
}
- (void)loadTodayTopic
{
    ZoneWaterFallView *view = [[ZoneWaterFallView alloc]initWithFrame:CGRectMake(0, 0, 1024-100, 768)];
    view.contentType = TODAY_TOPIC;
    [view loadDataSource:TODAY_TOPIC];
    [[KGModal sharedInstance] showWithContentView:view andAnimated:YES];
    [self setUpUI];
}
- (void)setUpUI
{
    rootView = [[UIViewExt alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	[rootView setBackgroundColor:[UIColor clearColor]];
	
	leftMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LEFT_MENU_WIDTH, self.view.frame.size.height)];
	leftMenuView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
	[menuViewController viewWillAppear:FALSE];
	[menuViewController viewDidAppear:FALSE];
    [menuViewController viewDidLoad];
    [menuViewController setView:menuViewController.view];
	[leftMenuView addSubview:menuViewController.view];
    [rootView addSubview:leftMenuView];

	familyListController = [[FamilyViewController alloc] initWithNibName:@"FamilyViewController" bundle:nil];
    familyListController.view.frame = CGRectMake(480, 0, familyListController.view.frame.size.width, familyListController.view.frame.size.height);
    // [leftMenuView addSubview:familyListController.view];
	rightSlideView = [[UIView alloc] initWithFrame:CGRectMake(leftMenuView.frame.size.width, 0, rootView.frame.size.width - leftMenuView.frame.size.width, rootView.frame.size.height)];
	rightSlideView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	stackScrollViewController = [[StackScrollViewController alloc] init];
	[stackScrollViewController.view setFrame:CGRectMake(0, 0, rightSlideView.frame.size.width, rightSlideView.frame.size.height)];
	[stackScrollViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight];
	[stackScrollViewController viewWillAppear:FALSE];
	[stackScrollViewController viewDidAppear:FALSE];
    familyListController.view.tag = 100;
    [stackScrollViewController.view addSubview:familyListController.view ];
    
    [rightSlideView addSubview:stackScrollViewController.view];
    
	[rootView addSubview:rightSlideView];
    [menuViewController menuButtonAction:menuViewController.newsButton];

	[self.view setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed:@"backgroundImage_repeat.png"]]];
	[self.view addSubview:rootView];
    if ([ConciseKit userDefaultsObjectForKey:NEW_USER] != nil) {
        GuideViewController *con = [[GuideViewController alloc] initWithNibName:nil bundle:nil];
        con.father = self;
        con.selector = @selector(overSlideBtnPressed:);
        [self presentModalViewController:con animated:YES];
        return;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = bgColor();
    if (MY_HAS_LOGIN) {
        _loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:_loadingView];
        [self performBlock:^(id sender) {
            [_loadingView loadingAnimation];

        } afterDelay:1.5f];
    }
	
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else
        return NO;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[menuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[stackScrollViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[menuViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[stackScrollViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}	
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{

}

@end
