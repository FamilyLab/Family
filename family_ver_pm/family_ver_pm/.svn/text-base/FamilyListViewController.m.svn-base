//
//  FamilyListViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-28.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "FamilyListViewController.h"
#import "FamilyListCell.h"
#import "FamilyCardViewController.h"
#import "TopBarView.h"
#import "InviteFamilyViewController.h"
#import "SBToolKit.h"

@interface FamilyListViewController ()

@end

@implementation FamilyListViewController
@synthesize userId, userName;

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
    self.view.frame = (CGRect){.origin = DEVICE_ORIGIN, .size = DEVICE_SIZE};
    _tableView.loadMoreView.hidden = YES;
    [self setTheTopBarView];
    [self setTheBackBottomBarView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setTheTopBarView
{
    customTopBarView = [[TopBarView alloc] initWithConId:@"3" andTopBarFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 65) TheFrameWidth:@"168"];
    customTopBarView.themeLbl.text = @"我的家人";
    //customTopBarView.familyLbl.text = @"杜拉拉";
    //customTopBarView.countPerLbl.text = @"共12人";
    [self.view addSubview:customTopBarView];
}

-(void)setTheBackBottomBarView
{
    NSArray *normalImage = [[NSArray alloc] initWithObjects:@"back_a_bottombar.png", @"family_add_a.png", nil];
    NSArray *selectedImage = [[NSArray alloc] initWithObjects:@"back_b_bottombar.png", @"family_add_b.png", nil];
    customBackBottomBarView = [[BackBottomBarView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height-49, DEVICE_SIZE.width, 49) numOfButton:[normalImage count] andNormalImage:normalImage andSelectedImage:selectedImage backgroundImageView:@"bg_bottombar.png"];
    customBackBottomBarView.delegate = self;
    [self.view addSubview:customBackBottomBarView];
    [normalImage release], normalImage = nil;
    [selectedImage release], selectedImage = nil;
}

-(void)userPressTheBottomButton:(BackBottomBarView *)_view andTheButton:(UIButton *)_button
{
    int tag = _button.tag - kTheBottomButtonTag;
    if (tag == 0) {
        [self dismissModalViewControllerAnimated:YES];
    }else if(tag == 1){
        InviteFamilyViewController *_con = [[InviteFamilyViewController alloc] initWithNibName:@"InviteFamilyViewController" bundle:nil];
        [self presentModalViewController:_con animated:YES];
        [_con release], _con = nil;
    }
}

#pragma mark sendrequesttofamilylistdetail
-(void)sendRequest:(id)sender
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = @"";
    if (userId) {
        url = [NSString stringWithFormat:@"%@/dapi/space.php?do=fmembers&perpage=50&m_auth=%@&uid=%@", BASE_URL, [SBToolKit getMAuth], self.userId];
    }else{
        url = [NSString stringWithFormat:@"%@/dapi/space.php?do=fmembers&perpage=50&m_auth=%@", BASE_URL, [SBToolKit getMAuth]];
    }
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict){
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        [self stopLoading:sender];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:WEB_MSG];
            return ;
        }
        if (needRemoveAllObject == YES) {
            //NSLog(@"%d",[dataArray count]);
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveAllObject = NO;
        }else if([[dict objectForKey:DATA] count] <= 0){
            [SVProgressHUD showWithStatus:@"没有更多数据了！"];
            return ;
        }
        NSDictionary *dataDict = [[NSDictionary alloc] initWithDictionary:[dict objectForKey:DATA]];
//        NSLog(@"家人数据字典：%@", dataDict);
        customTopBarView.familyLbl.text = [dataDict objectForKey:NAME];
        self.userNickName = [dataDict objectForKey:NAME];//保存用户昵称
        customTopBarView.countPerLbl.text = [NSString stringWithFormat:@"共%@人", [dataDict objectForKey:FAMILY_MEMBERS]];
        
        [dataArray addObjectsFromArray:[dataDict objectForKey:FAMILY_LIST]];
        [_tableView reloadData];
        [dataDict release], dataDict = nil;
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
        [self stopLoading:sender];
        NSLog(@"error:%@",[error description]);
    }];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * familyListCell = @"FamilyListCellId";
    FamilyListCell * cell = (FamilyListCell *)[tableView dequeueReusableCellWithIdentifier:familyListCell];
    if (cell == nil) {
        NSArray * cellArray = [[NSBundle mainBundle] loadNibNamed:@"FamilyListCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initData:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyCardViewController *_con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    _con.userId = [[dataArray objectAtIndex:indexPath.row] objectForKey:UID];
    _con.userName = self.userName == nil ? MY_NAME : self.userName;
    _con.delegate = self;
    [self presentModalViewController:_con animated:YES];
    [_con release], _con = nil;
}

#pragma mark - FamilyCardViewControllerDelegate
- (NSString *)returnUserNickName
{
    return self.userNickName;
}

-(void)dealloc
{
    [super dealloc];
    [userId release], userId = nil;
    [userName release], userName = nil;
    [customTopBarView release], customTopBarView = nil;
    [self.userNickName release], self.userNickName = nil;
}

@end
