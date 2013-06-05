//
//  LeftTabbarViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "LeftTabbarViewController.h"
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
@interface LeftTabbarViewController ()

@end

@implementation LeftTabbarViewController
- (void)showPostViewController:(id)sender{
    PostBaseView *postView = [[[NSBundle mainBundle]loadNibNamed:@"PostBaseViewController" owner:self options:nil] objectAtIndex:0];
    [[KGModal sharedInstance] showWithContentViewInMiddle:postView andAnimated:YES];
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
        return;
    }
    preSelectButton.selected = NO;
    sender.selected = !sender.selected;
    preSelectButton = sender;
    if (sender == zoneButton) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             lineLabel.frame = CGRectMake(lineLabel.frame.origin.x, zoneButton.frame.origin.y-12, lineLabel.frame.size.width, lineLabel.frame.size.height);
                         }];
        ZoneTableViewController *leftViewController = [[ZoneTableViewController alloc] initWithNibName:@"ZoneTableViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:leftViewController invokeByController:self isStackStartView:TRUE];
        
    }
    if (sender == _newsButton) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             lineLabel.frame = CGRectMake(lineLabel.frame.origin.x, 150, lineLabel.frame.size.width, lineLabel.frame.size.height);
                         }];
        NewsViewController *leftViewController = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:leftViewController invokeByController:self isStackStartView:TRUE];
        
    }
    if (sender == messageButton){
        [UIView animateWithDuration:0.2f
                         animations:^{
                             lineLabel.frame = CGRectMake(lineLabel.frame.origin.x, messageButton.frame.origin.y-12, lineLabel.frame.size.width, lineLabel.frame.size.height);
                         }];
        MessageViewController *leftViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:leftViewController invokeByController:self isStackStartView:TRUE];
        
    }
    if (sender == moreButton) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             lineLabel.frame = CGRectMake(lineLabel.frame.origin.x, moreButton.frame.origin.y-12, lineLabel.frame.size.width, lineLabel.frame.size.height);
                         }];
        MoreViewController *leftViewController = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:leftViewController invokeByController:self isStackStartView:TRUE];
        
    }
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    preSelectButton = nil;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postWindowClosed) name:@"POST_END" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
