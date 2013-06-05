//
//  FamilyMemberZoneViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-2-24.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "FamilyMemberZoneViewController.h"
#import "ZoneTableViewController.h"
#import "FamilyViewController.h"
#define ZONE_X 100
#define FAMILY_LIST_X 580
@interface FamilyMemberZoneViewController ()

@end

@implementation FamilyMemberZoneViewController
- (IBAction)dismiss:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else
        return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskLandscape;
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
    CALayer *layer = self.avatarImage.layer;
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
    layer.borderWidth = 1.0f;
    userZone = [[ZoneTableViewController alloc] initWithNibName:@"ZoneTableViewController" bundle:nil];
    userZone.userId = _userId;
    userZone.view.frame = CGRectMake(ZONE_X, 0, userZone.view.frame.size.width, userZone.view.frame.size.height);
    [self.view addSubview:userZone.view];
    userFamilyList = [[FamilyViewController alloc]initWithNibName:@"FamilyViewController" bundle:nil];
    userFamilyList.userId = _userId;
    userFamilyList.view.frame = CGRectMake(FAMILY_LIST_X, 0, userFamilyList.view.frame.size.width, userFamilyList.view.frame.size.height);
    [self.view addSubview:userFamilyList.view];
    userFamilyList.cityInfoView.hidden = YES;
    userFamilyList.addBtn.frame  = CGRectMake(userFamilyList.addBtn.frame.origin.x, userFamilyList.addBtn.frame.origin.y, userFamilyList.addBtn.frame.size.width+100, userFamilyList.addBtn.frame.size.height);
    [[MyHttpClient sharedInstance]commandWithPath:$str(@"%@space.php?m_auth=%@&uid=%@", BASE_URL, GET_M_AUTH, _userId) onCompletion:^(NSDictionary *dict) {
        [_avatarImage setImageWithURL:[NSURL URLWithString:[[dict objectForKey:WEB_DATA] objectForKey:AVATER]] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
        _nameLabel.text = [[dict objectForKey:WEB_DATA] objectForKey:NAME];
    } failure:^(NSError *error) {
        ;
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
