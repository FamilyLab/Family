//
//  DetailBaseViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "DetailBaseViewController.h"
#import "FamilyNewsCell.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "FamilyCardViewController.h"
#import "MyHttpClient.h"
#import "UIButton+WebCache.h"
#import "InviteFamilyViewController.h"
#import "UIAlertView+BlocksKit.h"
@interface DetailBaseViewController ()

@end

@implementation DetailBaseViewController
- (IBAction)addFamilyAction:(UIButton *)sender
{
    if (_parent) {
        [self backAction:sender];
    }
    else{
        InviteFamilyViewController *detailViewController = [[InviteFamilyViewController alloc] initWithNibName:@"InviteFamilyViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
    }
}
- (void)sendRequest:(id)sender
{
    NSString *requestStr = $str(@"%@space.php?do=fmembers&page=%d&m_auth=%@",BASE_URL,currentPage,GET_M_AUTH);
    [[MyHttpClient sharedInstance] commandWithPath:requestStr
                                      onCompletion:^(NSDictionary *dict) {
                                          [self stopLoading:sender];
                                          [self.header.avatarButton setImageForMyHeadButtonWithUrlStr:[[dict objectForKey:WEB_DATA] objectForKey:AVATER]  plcaholderImageStr:@"head_110.png" size:MIDDLE];
                                          self.header.timeLabelview.text = $str(@"%@个",[[dict objectForKey:WEB_DATA] objectForKey:PESONAL_MEMBER_NUM]);
                                          self.header.nameLabel.text = $str(@"%@",[[dict objectForKey:WEB_DATA] objectForKey:NAME]);

                                          if (needRemoveObjects == YES) {
                                              [dataArray removeAllObjects];
                                              [_tableView reloadData];
                                              needRemoveObjects = NO;
                                          }
                                          NSArray *resultArr = [[dict objectForKey:WEB_DATA] objectForKey:FAMILY_LIST];
                                          [dataArray addObjectsFromArray:resultArr];
                                          [_tableView reloadData];
                                          
                                      }
                                           failure:^(NSError *error) {
                                               NSLog(@"error%@",error);
                                               [self stopLoading:sender];
                                           }];
}
- (IBAction)backAction:(UIButton *)sender
{
    if (_parent){
        
        if (_allowmutilpleSelect) {
            _parent.withFamilyArray = selectedArray;
            [_parent setAvatarForTogether];
            REMOVEDETAIL;

        }
        else{
            _parent.touid = [[selectedArray objectAtIndex:0] objectForKey:UID];
            [sender setTitle:[[selectedArray objectAtIndex:0] objectForKey:NAME] forState:UIControlStateNormal];
            [self dismissModalViewControllerAnimated:YES];

        }
    }
    else
        REMOVEDETAIL;
}
@synthesize header = _header;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _parent = nil;
        selectedArray = [[NSMutableArray alloc] init];
        _allowmutilpleSelect = NO;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_parent) {
        [_acBtn setBackgroundImage:[UIImage imageNamed:@"ok2.png"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Table view data source




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FamilyNewsCellId";
	FamilyNewsCell *cell=(FamilyNewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
		cell = [array objectAtIndex:3];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.editingAccessoryView = _accesssoryView;
    }

    if ([dataArray count]>0) {
        [cell setCellData:[dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_parent) {
        
        FamilyNewsCell *cell = (FamilyNewsCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([selectedArray count]==1&&!_allowmutilpleSelect) {
            
            cell.selectedImage.hidden = !cell.selectedImage.hidden;

            return;
        }
        
        cell.selectedImage.hidden = !cell.selectedImage.hidden;

        //维护保存订阅信息的数组，点击列表项时，有则移除，无则添加
        if ([selectedArray containsObject:[dataArray objectAtIndex:indexPath.row]]) {
            [selectedArray removeObject:[dataArray objectAtIndex:indexPath.row]];
        }
        else
            [selectedArray addObject:[dataArray objectAtIndex:indexPath.row]];
        if ([selectedArray count]>4) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能同时选择超过4个家人"];
            cell.selectedImage.hidden = !cell.selectedImage.hidden;
            [selectedArray removeObject:[dataArray objectAtIndex:indexPath.row]];

            [alert addButtonWithTitle:@"确定" handler:^{
                
            }];
            [alert show];
            return;
        }
        return;
    }
    FamilyCardViewController *detailViewController = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    detailViewController.userId = [[dataArray objectAtIndex:indexPath.row] objectForKey:UID];
    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
    [detailViewController sendRequest:(FamilyNewsCell *)[tableView cellForRowAtIndexPath:indexPath]];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _parent ? NO : YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *tipStr =  @"删除家人..." ;
        [SVProgressHUD showWithStatus:tipStr];
        
        NSString *url = $str(@"%@friend&op=ignore", POST_CP_API);
        NSDictionary *aDict = [dataArray objectAtIndex:indexPath.row];
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[aDict objectForKey:UID], UID,ONE, FRIENDS_SUBMIT, POST_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [SVProgressHUD showWithStatus:@"删除成功..."];
            [SVProgressHUD dismiss];
            [dataArray removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(NSError *error) {
            NSLog(@"error:%@", [error description]);
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
        
    }
}
@end
