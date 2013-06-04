//
//  DialogueListViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "DialogueListViewController.h"
#import "DialogueListCell.h"
#import "DialogueDetailViewController.h"
#import "TopBarView.h"
//#import "ConciseKit.h"
#import "SBToolKit.h"

@interface DialogueListViewController ()

@end

@implementation DialogueListViewController


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
    //注册返回此controller消息
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(backToHere) name:NOTIFI_POP_TO_DAILOGLIST object:nil];
    
    self.view.frame = (CGRect){.origin = DEVICE_ORIGIN, .size = DEVICE_SIZE};
    
    [self setTheTopBarView];
    [self setTheBackBottomBarView];
}

- (void)backToHere
{
    [self.navigationController popToViewController:self animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTheTopBarView
{
    customTopBarView = [[TopBarView alloc] initWithConId:@"1" andTopBarFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 36)];
    customTopBarView.themeLbl.text = @"对话";
    
    [self.view addSubview:customTopBarView];
}

-(void) setTheBackBottomBarView
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

-(void)backButtonPressed
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)sendRequest:(id)sender
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = $str(@"%@/dapi/space.php?do=pm&filter=privatepm&m_auth=%@&page=%d", BASE_URL, [SBToolKit getMAuth], currentPage);
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict){
        [self stopLoading:sender];
        if([[dict objectForKey:WEB_ERROR] intValue] != 0){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功！"];
        if (needRemoveAllObject == YES) {
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveAllObject = NO;
        }else if([[dict objectForKey:DATA] count]<= 0){
            [SVProgressHUD showSuccessWithStatus:@"没有更多数据了"];
            return;
        }
        [dataArray addObjectsFromArray:[dict objectForKey:DATA]];
        [_tableView reloadData];
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
        [self stopLoading:sender];
        NSLog(@"error:%@", [error description]);
    }];
}

#pragma mark uitableview delegate
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
    return 79;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dialogueListCell = @"DialogueListCellId";
    DialogueListCell *cell = (DialogueListCell*)[tableView dequeueReusableCellWithIdentifier:dialogueListCell];
    if(cell == nil)
    {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"DialogueListCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell init:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DialogueDetailViewController *_con = [[DialogueDetailViewController alloc] initWithNibName:@"DialogueDetailViewController" bundle:nil];
    _con.toUserId = [[dataArray objectAtIndex:indexPath.row] objectForKey:PM_TO_UID];
    _con.PMId = [[dataArray objectAtIndex:indexPath.row] objectForKey:PM_ID];
//    [self presentModalViewController:_con animated:YES];
    [self.navigationController pushViewController:_con animated:YES];
    [_con release],_con = nil;
}

-(void) dealloc
{
    [super dealloc];
    [customTopBarView release], customTopBarView = nil;
    //[customBarView release],customBarView = nil;
}

@end
