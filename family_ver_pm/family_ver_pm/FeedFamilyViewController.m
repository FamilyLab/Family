//
//  FeedFamilyViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-28.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "FeedFamilyViewController.h"
#import "TopBarView.h"
#import "FamilyApplyListViewController.h"

@interface FeedFamilyViewController ()

@end



@implementation FeedFamilyViewController
@synthesize feedFamilyArray;
@synthesize feedFamilyTableView;
@synthesize fromWhichVC;

#define THeCellButtonTag    1000

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"这里是：%@", [self class]);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册设置family apply count通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFamilyApplyCount:) name:NOTIFI_RETURN_FAMILYAPPLY_COUNT object:nil];
    
    self.view.frame = (CGRect){.origin = DEVICE_ORIGIN, .size = DEVICE_SIZE};
    
    [self setTheTopBarView];
    [self setTheBackBottomBarView];
    
    NSDictionary *row1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"table_top_family.png", @"bgimagename", @"FamilyListViewController", @"classname", @"家人列表",@"lablename", nil];
    NSDictionary *row2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"table_mid_family.png", @"bgimagename", @"InviteFamilyViewController", @"classname", @"邀请家人",@"lablename", nil];
    NSDictionary *row3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"table_mid_family.png", @"bgimagename", @"FamilyApplyListViewController", @"classname", @"搜索",@"lablename", nil];
    NSDictionary *row4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"table_bottom_family.png", @"bgimagename", @"FamilyApplyListViewController", @"classname", @"待审核",@"lablename", nil];
    
    feedFamilyArray = [[NSArray alloc] initWithObjects:row1, row2, row3, row4, nil];
    
    [row1 release], row1 = nil;
    [row2 release], row2 = nil;
    [row3 release], row3 = nil;
    [row4 release], row4 = nil;
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTheTopBarView
{
    TopBarView *customTopBarView = [[TopBarView alloc] initWithConId:@"1" andTopBarFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 36)];
    customTopBarView.themeLbl.text = @"家人";
    
    [self.view addSubview:customTopBarView];
    [customTopBarView release], customTopBarView = nil;
}

-(void)setTheBackBottomBarView
{
    NSArray *normalImage = [[NSArray alloc] initWithObjects:@"back_a_bottombar.png", nil];
    NSArray *selectedImage = [[NSArray alloc] initWithObjects:@"back_b_bottombar.png", nil];
    customBackBottomBarView = [[BackBottomBarView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height-49, DEVICE_SIZE.width, 49) numOfButton:[normalImage count] andNormalImage:normalImage andSelectedImage:selectedImage backgroundImageView:@"bg_bottombar.png"];
    customBackBottomBarView.delegate = self;
    [self.view addSubview:customBackBottomBarView];
    [normalImage release], normalImage = nil;
    [selectedImage release], selectedImage = nil;
}

-(void)userPressTheBottomButton:(BackBottomBarView *)_view andTheButton:(UIButton *)_button
{
//    [self dismissModalViewControllerAnimated:YES];
    POST_NOTI(NOTIFI_POP_TO_MAINVIEW);
}


#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feedFamilyArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *feedFamilyCellId = @"FeedFamilyCellId";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:feedFamilyCellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 309, 53)];
        [bgImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [[feedFamilyArray objectAtIndex:indexPath.row] objectForKey:@"bgimagename"]]]];
        [cell addSubview:bgImg];
        [bgImg release],bgImg = nil;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 134, 28)];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.textColor = [UIColor darkGrayColor];
        titleLbl.font = [UIFont boldSystemFontOfSize:22.0f];
        titleLbl.text = [[feedFamilyArray objectAtIndex:indexPath.row] objectForKey:@"lablename"];
        [cell addSubview:titleLbl];
        [titleLbl release],titleLbl = nil;
        
        UIButton *arrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 0, 309, 53)];
        arrowBtn.tag = THeCellButtonTag + indexPath.row;
        [arrowBtn addTarget:self action:@selector(cellButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
        [arrowBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
        [arrowBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
        [arrowBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
        [cell addSubview:arrowBtn];
        [arrowBtn release];
        if (indexPath.row == 3) {
            UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(176, 11, 100, 31)];
            self.familyApplyCount = tipsLbl;
            POST_NOTI(NOTIFI_REQUEST_FAMILYAPPLY_COUNT);
//            tipsLbl.text = @"3";
            tipsLbl.backgroundColor = [UIColor clearColor];
            tipsLbl.textAlignment = UITextAlignmentRight;
            tipsLbl.font = [UIFont systemFontOfSize:35.0f];
            tipsLbl.textColor = [UIColor redColor];
            [cell addSubview:tipsLbl];
            [tipsLbl release], tipsLbl = nil;
        }
    }
    
    //getTheFrame(cell.accessoryView);
    return cell;
}

//设置家人申请标签
- (void)getFamilyApplyCount:(id)sender
{
    NSDictionary *userInfoDict = [sender userInfo];
    self.familyApplyCount.text = [userInfoDict objectForKey:@"familyapplycount"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2 || indexPath.row ==3)
    {
        FamilyApplyListViewController *_con = [[FamilyApplyListViewController alloc] initWithNibName:@"FamilyApplyListViewController" bundle:nil];
        if (indexPath.row == 2) {
            _con.whichTypeVC = familysearchlistviewcontroller;
        }else{
            _con.whichTypeVC = familyapplylistviewcontroller;
        }
        [self presentModalViewController:_con animated:YES];
        [_con release], _con = nil;
    }else{
        UIViewController * _con = [(UIViewController *)[NSClassFromString([[feedFamilyArray objectAtIndex:indexPath.row] objectForKey:@"classname"]) alloc] initWithNibName:[[feedFamilyArray objectAtIndex:indexPath.row] objectForKey:@"classname"] bundle:nil];
        [self presentModalViewController:_con animated:YES];
        [_con release], _con = nil;
    }
}

-(void)cellButtonPressed:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:feedFamilyTableView];
    NSIndexPath *indexPath = [feedFamilyTableView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath != nil)
    {
        [self tableView:feedFamilyTableView didSelectRowAtIndexPath:indexPath];
    }
}

-(void)dealloc
{
    [super dealloc];
    [feedFamilyArray release], feedFamilyArray = nil;
    [feedFamilyTableView release], feedFamilyTableView = nil;
    [self.familyApplyCount release], self.familyApplyCount = nil;
    //[customBottomBar release], customBottomBar = nil;
}

@end
