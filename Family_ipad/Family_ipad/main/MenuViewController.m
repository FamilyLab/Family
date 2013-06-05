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
//  MenuViewController.m
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import "MenuViewController.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "ZoneTableViewController.h"
#import "AppDelegate.h"
#import "KGModal.h"
#import "NewsViewController.h"
#import "MessageViewController.h"
#import "MoreViewController.h"  
#import "FamilyViewController.h"
#import "PostBaseView.h"
#import "PostBaseViewController.h"
#import "MyHttpClient.h"
#import "ConciseKit.h"
#import "UIButton+WebCache.h"
#import "JSBadgeView.h"
@implementation MenuViewController
@synthesize tableView = _tableView;
@synthesize newsButton = _newsButton;
@synthesize messageButton = messageButton;
@synthesize moreButton = moreButton;
- (void)showPostViewController:(id)sender{
//    PostBaseView *postView = [[[NSBundle mainBundle]loadNibNamed:@"PostBaseViewController" owner:self options:nil] objectAtIndex:0];
//    [[KGModal sharedInstance] showWithContentViewInMiddle:postView andAnimated:YES];
//    [postView initPostView:nil];
    REMOVEDETAIL;
    PostBaseViewController *con = [[PostBaseViewController alloc]initWithNibName:@"PostBaseViewController" bundle:nil];
    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
    [((PostBaseView*)con.view) initPostView:nil];

    
}
- (void)postWindowClosed{
    postButton.selected = NO;
}
- (void) showStackView:(TableController *)_controller{
    ZoneTableViewController *dataViewController = [[ZoneTableViewController alloc] initWithNibName:@"ZoneTableViewController" bundle:nil];
    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:dataViewController invokeByController:self isStackStartView:TRUE];
    ZoneTableViewController *zataViewController = [[ZoneTableViewController alloc] initWithFrame:CGRectMake(0, 0, 440, self.view.frame.size.height)];
    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:zataViewController invokeByController:self isStackStartView:FALSE];
}
- (IBAction)postAction:(id)sender{
    postButton.selected = YES;
    [self showPostViewController:postButton];
}
- (IBAction)menuButtonAction:(UIButton *)sender{
    if (preSelectButton==sender) {
        if (sender == _newsButton) {
            [_newsViewController._tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    else{
        _zonetableViewController = nil;
        _moreViewController = nil;
        _newsViewController = nil;
        _messageViewController = nil;
        preSelectButton.selected = NO;
        sender.selected = !sender.selected;
        preSelectButton = sender;
        if (sender == zoneButton) {
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 lineLabel.frame = CGRectMake(lineLabel.frame.origin.x, zoneButton.frame.origin.y-12, lineLabel.frame.size.width, lineLabel.frame.size.height);
                             }];
            _zonetableViewController = [[ZoneTableViewController alloc] initWithNibName:@"ZoneTableViewController" bundle:nil];
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_zonetableViewController invokeByController:self isStackStartView:TRUE];
            
        }
        if (sender == _newsButton) {
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 lineLabel.frame = CGRectMake(lineLabel.frame.origin.x, 150, lineLabel.frame.size.width, lineLabel.frame.size.height);
                             }];
            _newsViewController    = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_newsViewController invokeByController:self isStackStartView:TRUE];
            
        }
        if (sender == messageButton){
            for (UIView *view in messageButton.subviews) {
                if ([view isKindOfClass:[JSBadgeView class]]) {
                    view.hidden = YES;
                    break;
                }
            }
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 lineLabel.frame = CGRectMake(lineLabel.frame.origin.x, messageButton.frame.origin.y-12, lineLabel.frame.size.width, lineLabel.frame.size.height);
                             }];
            _messageViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_messageViewController invokeByController:self isStackStartView:TRUE];
            
        }
        if (sender == moreButton) {
            for (UIView *view in moreButton.subviews) {
                if ([view isKindOfClass:[JSBadgeView class]]) {
                    view.hidden = YES;
                    break;
                }
            }
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 lineLabel.frame = CGRectMake(lineLabel.frame.origin.x, moreButton.frame.origin.y-12, lineLabel.frame.size.width, lineLabel.frame.size.height);
                             }];
            _moreViewController = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_moreViewController invokeByController:self isStackStartView:TRUE];
            
        }

    }
    
}
- (void)showAction:(id)sender{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 200)];
    
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"Welcome to KGModal!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text = @"KGModal is an easy drop in control that allows you to display any view "
    "in a modal popup. The modal will automatically scale to fit the content view "
    "and center it on screen with nice animations!";
    infoLabel.numberOfLines = 6;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    FamilyViewController *leftViewController = [[FamilyViewController alloc] initWithNibName:@"FamilyViewController" bundle:nil];
    
    [[KGModal sharedInstance] showWithContentView:leftViewController.view andAnimated:YES];
}
#pragma mark -
#pragma mark View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
		[self.view setFrame:frame];
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
		[_tableView setDelegate:self];
		[_tableView setDataSource:self];
		[_tableView setBackgroundColor:[UIColor clearColor]];
        
        UIView* footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
		_tableView.tableFooterView = footerView;
        
		[self.view addSubview:_tableView];
		
		UIView* verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, -5, 1, self.view.frame.size.height)];
		[verticalLineView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
		[verticalLineView setBackgroundColor:[UIColor whiteColor]];
		[self.view addSubview:verticalLineView];
		[self.view bringSubviewToFront:verticalLineView];
		
	}
    return self;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    preSelectButton = nil;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postWindowClosed) name:@"POST_END" object:nil];
    [_UserInfo.tileImage setVipStatusWithStr:[ConciseKit userDefaultsObjectForKey:VIPSTATUS] isSmallHead:NO];
    _UserInfo.tagLabel.text = [ConciseKit userDefaultsObjectForKey:NAME];
      [_UserInfo.tileImage setImageForMyHeadButtonWithUrlStr:[ConciseKit userDefaultsObjectForKey:AVATAR_URL] plcaholderImageStr:nil size:MIDDLE];
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:messageButton alignment:JSBadgeViewAlignmentTopRight];
    JSBadgeView *moreBadgeView = [[JSBadgeView alloc] initWithParentView:moreButton alignment:JSBadgeViewAlignmentTopRight];
    [[MyHttpClient sharedInstance]commandWithPathAndNoHUD:$str(@"%@?do=elder&m_auth=%@",SPACE_API,GET_M_AUTH) onCompletion:^(NSDictionary *dict) {
        NSString  *messageNews =$str(@"%d",[[[dict objectForKey: WEB_DATA] objectForKey:PM_COUNT] intValue]+[[[dict objectForKey: WEB_DATA]  objectForKey:APPLY_CONT] intValue]);
        badgeView.badgeText = messageNews;
        badgeView.hidden = [messageNews isEqualToString:ZERO];
        NSString *moreNews = $str(@"%d",[[[dict objectForKey: WEB_DATA] objectForKey:APPLY_CONT] intValue]);
        moreBadgeView.badgeText = moreNews;
        moreBadgeView.hidden = [moreNews isEqualToString:ZERO];

    } failure:^(NSError *error) {
        ;
    }];


}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_titles count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	cell.textLabel.text =  $str(@"%@",[_titles objectAtIndex:indexPath.row]);


    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        [self showAction:nil];
    }
    else{
        ZoneTableViewController *dataViewController = [[ZoneTableViewController alloc] initWithNibName:@"ZoneTableViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:dataViewController invokeByController:self isStackStartView:TRUE];
        ZoneTableViewController *zataViewController = [[ZoneTableViewController alloc] initWithFrame:CGRectMake(0, 0, 440, self.view.frame.size.height)];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:zataViewController invokeByController:self isStackStartView:FALSE];
    }
 
}
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}




@end

