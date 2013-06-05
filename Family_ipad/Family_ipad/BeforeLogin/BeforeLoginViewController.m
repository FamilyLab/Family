//
//  BeforeLoginViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-20.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "BeforeLoginViewController.h"

@interface BeforeLoginViewController ()

@end

@implementation BeforeLoginViewController

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
    inviteFamily = [[InviteFamilyViewController alloc] initWithNibName:@"InviteFamilyViewController" bundle:nil];
    [inviteFamily.view setFrame:CGRectMake(272, 0, 480, 768)];
    [self.view addSubview:inviteFamily.view];
    [inviteFamily adjustLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
