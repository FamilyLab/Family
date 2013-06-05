//
//  ApplyFamilyViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "ApplyFamilyViewController.h"
#import "InviteFamilyCell.h"
#import "AppDelegate.h"
#import "StackScrollViewController.h"
#import "RootViewController.h"
#import "MyHttpClient.h"
#import "UIButton+WebCache.h"
@interface ApplyFamilyViewController ()

@end

@implementation ApplyFamilyViewController
-(IBAction)approveRequest:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"同意中..."];
    NSString *url = $str(@"%@friend&op=add", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:$str(@"%d",sender.tag-kBaseInviteCellTag), APPLY_UID, ONE, AGGRE_SUBMIT, POST_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showWithStatus:@"成功..."];
        [SVProgressHUD dismiss];
        [dataArray removeObject:[dataArray objectAtIndex:((InviteFamilyCell *)sender.superview.superview.superview).indexRow]];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}
- (void)sendRequest:(id)sender
{
    NSString *requestStr = $str(@"%@cp.php?ac=friend&op=request&m_auth=%@",BASE_URL,GET_M_AUTH);
    [[MyHttpClient sharedInstance] commandWithPath:requestStr
                                      onCompletion:^(NSDictionary *dict) {
                                          [self stopLoading:sender];
                                          [self.header.avatarButton setBackgroundImageWithURL:[NSURL URLWithString:[[dict objectForKey:WEB_DATA] objectForKey:AVATER]] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
                                          self.header.timeLabelview.text = $str(@"%@个",[[dict objectForKey:WEB_DATA] objectForKey:REQUESTNUM]);
                                          self.header.nameLabel.text = $str(@"%@",[[dict objectForKey:WEB_DATA] objectForKey:NAME]);
                                          if (needRemoveObjects == YES) {
                                              [dataArray removeAllObjects];
                                              [_tableView reloadData];
                                              needRemoveObjects = NO;
                                          }
                                          NSArray *resultArr = [[dict objectForKey:WEB_DATA]objectForKey:REQUEST_LIST];
                                          [dataArray addObjectsFromArray:resultArr];
                                          [_tableView reloadData];
                                          
                                      }
                                           failure:^(NSError *error) {
                                               [self stopLoading:sender];
                                           }];
}
- (IBAction)backAction:(id)sender
{
    REMOVEDETAIL;
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
    
    static NSString *CellIdentifier = @"InviteFamilyCellId";
	InviteFamilyCell *cell=(InviteFamilyCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
		cell = [array objectAtIndex:5];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.inviteButton setImage:[UIImage imageNamed:@"approvefamilybtn.png"] forState:UIControlStateNormal];
    }
    cell.indexRow = indexPath.row;
    if ([dataArray count]>0) {
        NSDictionary *data = [dataArray objectAtIndex:indexPath.row];
        [cell setCellData:data];
        [((UIButton *)[cell viewWithTag:kBaseInviteCellTag+[[data objectForKey:UID] intValue]])addTarget:self action:@selector(approveRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *tipStr =  @"忽略家人邀请..." ;
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
            [SVProgressHUD dismiss];
            [dataArray removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
        
    }
}
@end
