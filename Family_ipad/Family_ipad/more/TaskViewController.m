//
//  TaskViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-3-22.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "TaskViewController.h"
#import "MessageCell.h"
#import "MyHttpClient.h"
#import "DetailHeaderView.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h" 
#import "StackScrollViewController.h"
#import "RootViewController.h"
@interface TaskViewController ()

@end

@implementation TaskViewController
- (IBAction)backAction:(UIButton *)sender
{
    REMOVEDETAIL;
}
- (void)sendRequest:(id)sender
{
    
    dataArray = [ConciseKit userDefaultsObjectForKey:DRAFT];
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
	// Do any additional setup after loading the view.
    _tableView.loadMoreView.hidden = YES;
    [_header setViewDataWithLocal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([dataArray count]>0) {
        NSDictionary  *dataDict = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
        
        NSString *contentStr = [NSString stringWithFormat:@"%@", [dataDict objectForKey:NOTE]];
        
        return [MessageCell heightForCellWithText:contentStr andOtherHeight:80.0f];
    }
    else
        return  99;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"taskidcell";
    MessageCell *cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [array objectAtIndex:1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if ([dataArray count]>0) {
        cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row]objectForKey:MESSAGE];
    }
    return cell;

    
}

@end
