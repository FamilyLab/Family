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
//  MenuViewController.h
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "MyButton.h"
#import "TileItemButton.h"
#import "NewsViewController.h"
#import "MessageViewController.h"
#import "MoreViewController.h"
#import "ZoneTableViewController.h"
@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView*  _tableView;
    UIButton *preSelectButton;
    IBOutlet UIButton *newsButton;
    IBOutlet UIButton *zoneButton;
    IBOutlet UIButton *messageButton;
    IBOutlet UIButton *moreButton;
    IBOutlet UIButton *postButton;
    IBOutlet UILabel *lineLabel;
    
}
- (id)initWithFrame:(CGRect)frame;
- (IBAction)menuButtonAction:(UIButton *)sender;
- (void)showPostViewController:(id)sender;
@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)IBOutlet UIButton *newsButton;
@property(nonatomic, strong)IBOutlet UIButton *messageButton;
@property(nonatomic, strong)IBOutlet UIButton *moreButton;
@property(nonatomic, strong)NSArray *titles;
@property(nonatomic, strong)IBOutlet TileItemButton *UserInfo;
@property(nonatomic, strong)NewsViewController *newsViewController;
@property(nonatomic, strong)ZoneTableViewController *zonetableViewController;
@property(nonatomic, strong)MessageViewController *messageViewController;
@property(nonatomic, strong)MoreViewController *moreViewController;
@end
