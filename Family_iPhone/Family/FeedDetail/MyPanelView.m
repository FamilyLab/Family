//
//  MyPanelView.m
//  Family
//
//  Created by Aevitx on 13-3-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MyPanelView.h"
#import "DetailFeedCell.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "FeedDetailViewController.h"
#import "FamilyCardViewController.h"
#import "PlistManager.h"
#import "UILabel+VerticalAlign.h"

@implementation MyPanelView
//@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (!_dataArray) {
            _dataArray = [[NSMutableArray alloc] init];
        }
        if (!_dataDict) {
            _dataDict = [[NSMutableDictionary alloc] init];
        }
        _currentPage = 1;
//        _isRefreshDataFromNet = NO;
//        _isLoadMoreDataFromNet = NO;
        _isFirstShownComment = YES;
    }
    return self;
}

- (void)addPullTableView {
    CellHeader *header = [[CellHeader alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 20)];
    self.cellHeader = header;
    if (!_pullTable) {
        _pullTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pullTable.delegate = self;
        _pullTable.dataSource = self;
        _pullTable.pullDelegate = self;
        _pullTable.backgroundColor = bgColor();
        
        
        _pullTable.separatorStyle = UITableViewCellEditingStyleNone;
        _pullTable.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
        _pullTable.pullBackgroundColor = [UIColor clearColor];
        _pullTable.pullTextColor = [UIColor blackColor];
        
        TopView *aView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
        aView.topViewType = notLoginOrSignIn;
        [aView leftHeadAndName];
        [aView rightLblAndImgStr:@"time.png"];
        
        [aView.leftHeadBtn setImage:[UIImage imageNamed:@"head_70.png"] forState:UIControlStateNormal];//假数据
        aView.leftNameLbl.text = @"";//假数据
        aView.leftNameLbl.numberOfLines = 0;
        [aView.leftNameLbl alignTop];
        aView.rightLbl.text = @"";//假数据
        aView.rightLbl.font = [UIFont boldSystemFontOfSize:12.0f];//假数据
        [aView.leftHeadBtn addTarget:self action:@selector(topViewHeadBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [aView leftOtherTextLbl:@""];
        
        self.topView = aView;
        _pullTable.tableHeaderView = _topView;
        
        [self addSubview:_pullTable];
        
//        [_pullTable reloadData];
    }
    if (!self.ssLoading) {
        SSLoadingView *ss = [[SSLoadingView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        ss.backgroundColor = [UIColor clearColor];
        ss.center = self.pullTable.center;
        [self addSubview:ss];
        [self bringSubviewToFront:ss];
        self.ssLoading = ss;
    }
}

- (void)topViewHeadBtnPressed:(id)sender {
    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    con.isMyFamily = YES;
    con.userId = [_dataDict objectForKey:UID];
    pushAConInView(self, con);
//    [self.navigationController pushViewController:con animated:YES];
}

//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    [super willMoveToSuperview:newSuperview];
//}

- (void)stopLoading:(id)sender {
    if ([sender isKindOfClass:[PullTableView class]]) {
        ((PullTableView *)sender).pullTableIsRefreshing = NO;
        ((PullTableView *)sender).pullTableIsLoadingMore = NO;
        ((PullTableView *)sender).pullLastRefreshDate = [NSDate date];
    }
}

/**
 * 发送更新信息，标记needRemoveObjects设置为yes,currentPage重置为第一页
 * @param  无
 * @return 无
 */
- (void)refresh:(id)sender {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    _needRemoveObjects = YES;
    _currentPage = 1;
    [self sendRequest:self.pullTable];
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

/**
 * 外部调用，请求数据，根据currentPage，已有数据来判断是否需要发送请求。
 * @param  无
 * @return 无
 */
- (void)requestData {
    if ([_dataArray count] > 0) {
        return;
    } else {
        _currentPage = 1;
        [self sendRequest:self.pullTable];
    }
}

/**
 * 请求下一页的数据
 * @param  无
 * @return 无
 */
- (void)requestNextPage:(id)sender {
    _currentPage++;
    [self sendRequest:self.pullTable];
}

/**
 * 重置列表数据
 * @param  无
 * @return 无
 */
- (void)reloadData {
    if ([_dataDict objectForKey:PIC_LIST] && ![[_dataDict objectForKey:PIC_LIST] isEqual:[NSNull null]]) {
        [_dataArray removeAllObjects];
        [self requestData];
    }
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    _isRefreshDataFromNet = YES;
    [self performSelector:@selector(refresh:) withObject:pullTableView];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    _isLoadMoreDataFromNet = YES;
    [self performSelector:@selector(requestNextPage:) withObject:pullTableView];
}

#pragma mark -
#pragma mark Table view data source
+ (FeedDetailType)whichDetailType:(NSString*)typeStr {
    if ([typeStr rangeOfString:FEED_PHOTO_ID].location != NSNotFound) {
        return photoDetailType;
    } else if ([typeStr rangeOfString:FEED_BLOG_ID].location != NSNotFound) {
        return blogDetailType;
    } else if ([typeStr rangeOfString:FEED_VIDEO_ID].location != NSNotFound) {
        return videoDetailType;
    } else if ([typeStr rangeOfString:FEED_EVENT_ID].location != NSNotFound) {
        return eventDetailType;
    } else {
        return unknownDetailType;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int commentNum = [self.dataArray count] == 0 ? 1 : [self.dataArray count];
    if ([MyPanelView whichDetailType:_idType] == photoDetailType) {
        NSArray *picArray = [_dataDict objectForKey:PIC_LIST];
        if (picArray && ![picArray isEqual:[NSNull null]]) {
            return 1 + [picArray count] + 1 + commentNum;
        } else
            return _isFromZone ? 1 : 1 + commentNum;
    }
    return 1 + commentNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedDetailType type = [MyPanelView whichDetailType:_idType];
    if (type == photoDetailType) {
        NSArray *picArray = [_dataDict objectForKey:PIC_LIST];
        int thePicNum = _dataDict ? ([picArray isEqual:[NSNull null]] ? 0 : [picArray count]) : 1;
        if (indexPath.row == 0) {
            return 30;
        } else if (indexPath.row <= thePicNum) {
            CGFloat currImageHeight = [[[picArray objectAtIndex:indexPath.row - 1] objectForKey:HEIGHT] intValue];
            CGFloat currImageWidth = [[[picArray objectAtIndex:indexPath.row - 1] objectForKey:WIDTH] intValue];
            if (currImageWidth > KPhotoWidth) {
                currImageHeight = (float)(KPhotoWidth / currImageWidth) * (float)currImageHeight;
                currImageWidth = KPhotoWidth;
            }
            CGFloat subjectHeight = [DetailFeedCell heightForPhotoSubject:emptystr([[picArray objectAtIndex:indexPath.row - 1] objectForKey:TITLE]) andOtherHeight:10];
            return currImageHeight + subjectHeight;
        } else if (indexPath.row == thePicNum + 1) {
            CGFloat theHeight = [DetailFeedCell heightForPhotoSubject:emptystr([_dataDict objectForKey:MESSAGE]) andOtherHeight:15];
            return theHeight + 35;//35为oprateView的高度
        } else {
            if ([self.dataArray count] == 0) {
                //            if ([dataArray count] == 0) {
                return 40;
            } else {
                return [self heightForCellWithIndexRow:indexPath.row - thePicNum - 1 andType:type];
            }
        }
    } else {
        if (indexPath.row == 0) {
            if (type == blogDetailType) {
                return 70 + _theWebView.frame.size.height;// 290;
            } else if (type == videoDetailType) {
                return 290 + [DetailFeedCell heightForPhotoSubject:[_dataDict objectForKey:MESSAGE]andOtherHeight:0];
            } else if (type == eventDetailType) {
                return 145 + _theWebView.frame.size.height;
//                return [DetailFeedCell heightForPhotoSubject:[_dataDict objectForKey:DETAIL] andOtherHeight:253];//275
            } else
                return 290;
        } else {//评论列表
            FeedDetailType type = [MyPanelView whichDetailType:_idType];
            if ([self.dataArray count] == 0) {
                //            if ([dataArray count] == 0) {
                return 40;
            } else {
                return [self heightForCellWithIndexRow:indexPath.row andType:type];
            }
        }
    }
    //    return 65;
}

- (CGFloat)heightForCellWithIndexRow:(int)tableIndexRow andType:(FeedDetailType)type {
    //    NSDictionary *dict = (type == eventDetailType && !isCommentCell) ? [_joinMemberArray objectAtIndex:indexRow - 1] : [dataArray objectAtIndex:indexRow - 1];
    NSDictionary *dict = [self.dataArray objectAtIndex:tableIndexRow - 1];
    //    NSDictionary *dict = [dataArray objectAtIndex:indexRow - 1];
    NSString *name = [dict objectForKey:NAME];
    CGSize nameSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:15.0f] constrainedToSize:CGSizeMake(DEVICE_SIZE.width, 320) lineBreakMode:UILineBreakModeWordWrap];
    //    NSString *text = (type == eventDetailType && !isCommentCell) ? @"参与了活动" : [dict objectForKey:MESSAGE];
    NSString *text = [dict objectForKey:MESSAGE];
    CGFloat theHeight = [DetailFeedCell heightForCellWithText:text andOtherHeight:43 withNameX:53 withNameWidth:nameSize.width];
    return fmaxf(theHeight, 65);// theHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.userId isEqualToString:MY_UID]) {
        UIButton *delBtn = nil;
        for (id obj in self.cellHeader.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                delBtn = (UIButton*)obj;
                break;
            }
        }
//        if (!delBtn) {
//            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            delBtn.frame = CGRectZero;
//            [delBtn setImage:[UIImage imageNamed:@"down_arrow.png"] forState:UIControlStateNormal];
//            [delBtn whenTapped:^{
//                UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"是否删除?"];
//                [as setDestructiveButtonWithTitle:@"删除" handler:^{
//                    NSString *deleteTypeStr = [self.idType stringByReplacingOccurrencesOfString:@"re" withString:@""];
//                    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"delete", OP, self.feedId, deleteTypeStr, ONE, DELETE_SUBMIT, MY_M_AUTH, M_AUTH, nil];
//                    [self uploadRequestToDeleteWithPara:para];
//                }];
//                [as setCancelButtonWithTitle:@"取消" handler:^{
//                    ;
//                }];
//                [as showInView:self];
//            }];
//            [self.cellHeader addSubview:delBtn];
//        }
    }
    return self.cellHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *titleText;// = _dataDict ? [_dataDict objectForKey:SUBJECT] : @"      ";
    FeedDetailType type = [MyPanelView whichDetailType:_idType];
    if (type == eventDetailType) {
        titleText = _dataDict ? [_dataDict objectForKey:TITLE] : @"      ";
    } else {
        titleText = _dataDict ? [_dataDict objectForKey:SUBJECT] : @"      ";
    }
    if ([titleText isEqualToString:@""]) {
        titleText = @"无标题";
    }
    self.cellHeader.frame = (CGRect){.origin = CGPointZero, .size.width = DEVICE_SIZE.width, .size.height = [CellHeader getHeaderHeightWithText:titleText].height};
    [self.cellHeader initHeaderDataWithMiddleLblText:titleText];
    
    return self.cellHeader.frame.size.height; //+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailFeedCell *cell;
    static NSString *detailFeedCellId = @"detailFeedCellId";
    static NSString *webViewCellId = @"webViewCellId";
    static NSString *eventDetailFeedCellId = @"eventDetailFeedCellId";
    static NSString *commentCellId = @"commentCellId";
    static NSString *detailPhotoCellId = @"detailPhotoCellId";
    static NSString *detailOtherCellId = @"detailOtherCellId";
    FeedDetailType detailType = [MyPanelView whichDetailType:_idType];
    int thePicNum = _dataDict ? ([[_dataDict objectForKey:PIC_LIST] isEqual:[NSNull null]] ? 0 : [[_dataDict objectForKey:PIC_LIST] count]) : 1;
    
    
    if (detailType == photoDetailType) {//照片详情
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:detailFeedCellId];
        } else if (indexPath.row <= thePicNum) {
            cell = [tableView dequeueReusableCellWithIdentifier:detailPhotoCellId];
        } else if (indexPath.row == thePicNum + 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:detailOtherCellId];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
        }
    } else {//非照片详情
        if (indexPath.row == 0) {
            if (detailType == eventDetailType) {
                cell = [tableView dequeueReusableCellWithIdentifier:eventDetailFeedCellId];
            }else {// if (detailType == videoDetailType) {
                cell = [tableView dequeueReusableCellWithIdentifier:webViewCellId];
            }
        } else
            cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
    }
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DetailFeedCell" owner:self options:nil];
        if (detailType == photoDetailType) {//照片详情
            if (indexPath.row == 0) {
                cell = [array objectAtIndex:0];
            } else if (indexPath.row <= thePicNum) {
                cell = [array objectAtIndex:4];
            } else if (indexPath.row == thePicNum + 1) {
                cell = [array objectAtIndex:5];
                [cell.operateView initWithBtnNum:1 everyBtnSize:CGSizeMake(50, 30) btnTexts:[NSArray arrayWithObjects:@"评论", nil] withAction:^(int tag) {
                    if (tag == kTagBtnInFeedDetail + 1) {//相册按钮
//                        ZoneDetailViewController *con = [[ZoneDetailViewController alloc] initWithNibName:@"ZoneDetailViewController" bundle:nil];
                        FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
                        con.hidesBottomBarWhenPushed = YES;
                        con.tagId = [[_dataDict objectForKey:TAG] objectForKey:TAG_ID];
                        con.userId = [_dataDict objectForKey:UID];
                        con.isFromZone = YES;
                        pushAConInView(self, con);
//                        [self.navigationController pushViewController:con animated:YES];
                    }
                }];
            } else
                cell = [array objectAtIndex:3];
        } else {//非照片详情
            if (indexPath.row == 0) {
                if (detailType == videoDetailType) {
                    cell = [array objectAtIndex:1];
                } else if (detailType == blogDetailType) {
                    cell = [array objectAtIndex:1];
                } else if (detailType == eventDetailType) {
                    cell = [array objectAtIndex:2];
                }
                NSString *text = detailType == eventDetailType ? @"参与" : @"评论";
                [cell.operateView initWithBtnNum:1 everyBtnSize:CGSizeMake(50, 30) btnTexts:[NSArray arrayWithObjects:text, nil] withAction:^(int tag) {
                    if (tag == kTagBtnInFeedDetail + 1) {//相册按钮
//                        ZoneDetailViewController *con = [[ZoneDetailViewController alloc] initWithNibName:@"ZoneDetailViewController" bundle:nil];
                        FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
                        con.hidesBottomBarWhenPushed = YES;
                        con.tagId = [[_dataDict objectForKey:TAG] objectForKey:TAG_ID];
                        con.userId = [_dataDict objectForKey:UID];
                        con.isFromZone = YES;
                        pushAConInView(self, con);
//                        [self.navigationController pushViewController:con animated:YES];
                    }
                }];
            } else {
                cell = [array objectAtIndex:3];
            }
        }
    }
    
    if (detailType == photoDetailType) {//照片详情
        cell.feedDetailType = photoDetailType;
        if (self.dataDict) {
            if (indexPath.row == 0) {
                [cell initPhotoFirstCellData:_dataDict];
            } else if (indexPath.row <= thePicNum) {//图片的cell
                NSArray *picArray = [_dataDict objectForKey:PIC_LIST];
                [cell initPicsCellData:[picArray objectAtIndex:indexPath.row - 1]];
                cell.photoImgView.userInteractionEnabled = YES;
                [cell.photoImgView whenTapped:^{
                    if (self.photosArray) {
                        [self.photosArray removeAllObjects];
                        self.photosArray = nil;
                    }
                    self.photosArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [picArray count]; i++) {
                        [_photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[[[picArray objectAtIndex:i] objectForKey:PIC] delLastStrForYouPai]]]];
                    }
                    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
                    browser.wantsFullScreenLayout = YES;
                    browser.displayActionButton = YES;
                    [browser setInitialPageIndex:indexPath.row - 1];
                
                    if ([_idType isEqualToString:FEED_EVENT_ID]) {
                        [SVProgressHUD showErrorWithStatus:@"活动不能转载T_T"];
                        return;
                    }
                    if ([_idType isEqualToString:FEED_VIDEO_ID]) {
                        [SVProgressHUD showErrorWithStatus:@"视频不能转载T_T"];
                        return;
                    }
                    if (_dataDict && _idType) {
                        browser.dataDict = _dataDict;
                        browser.idType = _idType;
                    }
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
                    nav.navigationBarHidden = YES;
                    presentAConInView(self, nav);
                }];
            } else if (indexPath.row == thePicNum + 1) {//operateView的cell
                [cell initOperateViewData:_dataDict];
                
            } else {//评论
                cell.isLoadingFirstCell = _isFirstShow;
                if ([self.dataArray count] == 0) {
                    [cell initCommentData:nil];
                } else
                    [cell initCommentData:[self.dataArray objectAtIndex:indexPath.row - thePicNum - 2]];
            }
        } else {
            if (indexPath.row == 0) {
                cell.hotLbl.text = @"转发(0) 收藏(0) 评论(0)";//假数据
            }
            cell.picNum = 1;//假数据
        }
    } else {//非照片详情
        if (indexPath.row == 0) {
            if (detailType == blogDetailType || detailType == eventDetailType) {
                if (detailType == blogDetailType) {
                    cell.infoLbl.hidden = _hasLoaded;
                }
                for (UIView *obj in cell.contentView.subviews) {
                    if ([obj isKindOfClass:[UIWebView class]]) {
                        UIWebView *web = (UIWebView*)obj;
                        [web removeFromSuperview];
                        web = nil;
                        break;
                    }
                }
                [cell.contentView addSubview:self.theWebView];
            }
            if (self.dataDict) {
                cell.feedDetailType = detailType;
                if (detailType == photoDetailType) {
                    //                cell.picNum = [[_dataDict objectForKey:PIC_LIST] count];
                    cell.picNum = [[_dataDict objectForKey:PIC_LIST] isEqual:[NSNull null]] ? 0 : [[_dataDict objectForKey:PIC_LIST] count];
                }
            } else {
                cell.hotLbl.text = @"转发(0) 收藏(0) 评论(0)";//假数据
                cell.feedDetailType = detailType;
                if (detailType == photoDetailType) {
                    cell.picNum = 1;//假数据
                }
            }
            [cell initFirstCellData:_dataDict];
        } else {
            cell.isLoadingFirstCell = _isFirstShow;
            if ([self.dataArray count] == 0) {
                [cell initCommentData:nil];
            } else
                [cell initCommentData:[self.dataArray objectAtIndex:indexPath.row - 1]];
            if (detailType == eventDetailType) {
            }
        }
    }
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - webview delegate
//webview委托   高度自适应
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    NSString *width = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth;"];
    //    NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    
    CGSize actualSize = [webView sizeThatFits:CGSizeMake(290, MAXFLOAT)];
    CGRect theFrame = webView.frame;
    theFrame.size.height = actualSize.height;
    webView.frame = theFrame;
    _hasLoaded = YES;
    [self.pullTable reloadData];
}

//#warning webview
////让webview响应touch事件
//- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSString *requestString = [[request URL] absoluteString];
//    NSArray *components = [requestString componentsSeparatedByString:@":"];
//    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"myweb"]) {
//        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
//        {
//            NSLog(@"%@",[components objectAtIndex:2]);
//        }
//        return NO;
//    }
//    return YES;
//}

#pragma mark - request
- (void)sendRequest:(id)sender {
    if (self.currentPage == 1) {
        [self sendRequestToDetail:sender];
    }
    [self sendRequestToComment:sender];
}

//- (NSMutableDictionary*)saveAllDataFromDict:(NSDictionary*)aDictionary {
//    NSMutableDictionary *answer = [NSMutableDictionary dictionary];
//    
//    for (NSString *key in [aDictionary allKeys]) {
//        id value = [aDictionary valueForKey:key];
//        if (value && value != [NSNull null]) {
//            [answer setObject:value forKey:key];
//        }
//    }
//    return [NSMutableDictionary dictionaryWithDictionary:answer];
//}

- (void)sendRequestToDetail:(id)sender {
    if (self.ssLoading) {
//    if (_isFromZone && self.ssLoading) {
        self.ssLoading.hidden = NO;
        [self.ssLoading.activityIndicatorView startAnimating];
    }
    
    if (self.currentPage == 1) {
//        self.pullTable.pullTableIsRefreshing = _isFromZone ? NO : YES;
    }
    NSString *doTypeStr = _idType;
    if ([doTypeStr hasPrefix:@"re"]) {
        doTypeStr = [doTypeStr substringFromIndex:2];//2为“re”两个字母
    }
    if ([doTypeStr hasSuffix:@"id"]) {
        doTypeStr = [doTypeStr substringToIndex:(doTypeStr.length - 2)];//2为“id”两个字母
    }
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=%@&id=%@&uid=%@&m_auth=%@", BASE_URL, doTypeStr, _feedId, _userId, [MY_M_AUTH urlencode]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        _isFirstShow = NO;
        if (self.ssLoading) {
//        if (_isFromZone && self.ssLoading) {
            [_ssLoading.activityIndicatorView stopAnimating];
            self.ssLoading.hidden = YES;
        }
        
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (_isFromZone) {
            [SVProgressHUD dismiss];
        }
        self.isRefreshDataFromNet = NO;
        self.dataDict = [dict objectForKey:WEB_DATA];
        
        NSMutableDictionary *fuckDict = [[NSMutableDictionary alloc] init];
        fuckDict = [Common copyAllDataFromDict:_dataDict];
        [PlistManager writePlist:fuckDict forKey:_feedId plistName:PLIST_FEED_TOP_DATA];
        
//        if ([PlistManager isValueExistsForKey:$str(@"%d", _indexRow) plistName:PLIST_FEED_TOP_DATA]) {
//            [PlistManager replaceDictionary:fuckDict withDictionaryKey:$str(@"%d", _indexRow) plistName:PLIST_FEED_TOP_DATA];
//        } else {
//        }
        
        [self fillDataForDetail];
        [_pullTable reloadData];

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);
        [self stopLoading:sender];
    }];
}

- (void)fillDataForDetail {
    [_topView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:[_dataDict objectForKey:AVATAR] plcaholderImageStr:nil];
    [_topView.leftHeadBtn setVipStatusWithStr:emptystr([_dataDict objectForKey:VIP_STATUS]) isSmallHead:YES];
    _topView.leftNameLbl.text = [_dataDict objectForKey:NAME];
    _topView.rightLbl.text = [Common dateSinceNow:[_dataDict objectForKey:DATELINE]];
    _topView.rightLbl.font = [UIFont boldSystemFontOfSize:12.0f];
    [_topView setNeedsLayout];
    
    FeedDetailType type = [MyPanelView whichDetailType:_idType];
    NSString *firstStr = [_idType hasPrefix:@"re"] ? @"转载了" : @"发表了";
    NSString *otherText = type == photoDetailType ? @"照片" : (type == blogDetailType ? @"日志" : (type == videoDetailType ? @"视频" : (type == eventDetailType ? @"活动" : @"")));
    otherText = $str(@"%@%@", firstStr, otherText);
    _topView.leftOtherLbl.text = otherText;
    
    FeedDetailViewController *con = (FeedDetailViewController*)[Common viewControllerOfView:self];
    UIButton *loveBtn = (UIButton*)[con.bottomView viewWithTag:kTagBottomButton + 2];
    loveBtn.selected = [[_dataDict objectForKey:MY_LOVE] boolValue];
    
    if (type == blogDetailType || type == eventDetailType) {
        _hasLoaded = NO;
        
        if (self.theWebView) {
            [self.theWebView removeFromSuperview];
            self.theWebView = nil;
        }
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 30, 290, 200)];
        webView.delegate = self;
        webView.opaque = NO;
        [webView setScalesPageToFit:NO];
        //                webView.userInteractionEnabled = NO;
        webView.backgroundColor = bgColor();
        self.theWebView = webView;
        
        NSString *webData = type == blogDetailType ? MESSAGE : DETAIL;
        [_theWebView loadHTMLString:[_dataDict objectForKey:webData] baseURL:nil];
    }
}

- (void)sendRequestToComment:(id)sender {
    NSString *doTypeStr = [_idType stringByReplacingOccurrencesOfString:@"re" withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=comment&id=%@&idtype=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, _feedCommentId, doTypeStr, _currentPage, 10, [MY_M_AUTH urlencode]];
    //    NSString *url = [NSString stringWithFormat:@"%@space.php?do=comment&id=%@&idtype=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, _feedCommentId, doTypeStr, currentPage, 10, [MY_M_AUTH urlencode]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (_isFromZone) {
            [SVProgressHUD dismiss];
        }
        if (self.needRemoveObjects == YES) {
            [self.dataArray removeAllObjects];
            [self.pullTable reloadData];
            self.needRemoveObjects = NO;
        } else if ([[dict objectForKey:WEB_DATA] count] <=0) {
            if (!_isFromZone && !_isFirstShownComment) {
                [SVProgressHUD showSuccessWithStatus:@"没有更多评论了T_T"];
            }
        }
        _isFirstShownComment = NO;
        if (self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        self.isLoadMoreDataFromNet = NO;
        [self.dataArray addObjectsFromArray:[dict objectForKey:WEB_DATA]];
        
        NSMutableArray *fuckArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *commentDict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [_dataArray count]; i++) {
            NSMutableDictionary *each = [_dataArray objectAtIndex:i];
            [fuckArray addObject:[Common copyAllDataFromDict:each]];
        }
        [commentDict setObject:fuckArray forKey:COMMENT];
        [PlistManager writePlist:commentDict forKey:_feedId plistName:PLIST_FEED_COMMENT];
        
//        if ([PlistManager isValueExistsForKey:$str(@"%d", _indexRow) plistName:PLIST_FEED_COMMENT]) {
//            [PlistManager replaceDictionary:_dataDict withDictionaryKey:$str(@"%d", _indexRow) plistName:PLIST_FEED_COMMENT];
//        } else {
//            [PlistManager writePlist:commentDict forKey:$str(@"%d", _indexRow) plistName:PLIST_FEED_COMMENT];
//        }
        
        [self.pullTable reloadData];
 
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);
        [self stopLoading:sender];
        self.currentPage--;
    }];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photosArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photosArray.count)
        return [_photosArray objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photosArray objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return captionView;
//}

//#pragma mark - 删除帖子的接口
//- (void)uploadRequestToDeleteWithPara:(NSMutableDictionary*)para {
//    NSString *tipsStr = @"删除中...";//isCommentCell ? @"发送评论中..." : @"参与活动中...";
//    [SVProgressHUD showWithStatus:tipsStr];
//    NSString *acStr = [self.idType stringByReplacingOccurrencesOfString:@"re" withString:@""];
//    acStr = [acStr stringByReplacingOccurrencesOfString:@"id" withString:@""];
//    NSString *url = $str(@"%@%@", POST_CP_API, acStr);
//    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
//    } onCompletion:^(NSDictionary *dict) {
//        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            popAConInView(self);
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//            return ;
//        }
//        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
//        if (!_isFromZone) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_FEED_LIST_FOR_DELETE object:[NSNumber numberWithInt:_indexRowInFeedList]];
//            FeedDetailViewController *con = (FeedDetailViewController*)[Common viewControllerOfView:self];
//            [con.navigationController popViewControllerAnimated:YES];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"error:%@", [error description]);
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//    }];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
