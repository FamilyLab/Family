//
//  CommentView.m
//  family_ver_pm
//
//  Created by pandara on 13-3-26.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "CommentView.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "JSONKit.h"
#import "SBKeycahin.h"
#import "BlocksKit.h"
#import "UIButton+Block.h"
#import "SBToolKit.h"

@implementation CommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:self options:nil] objectAtIndex:0];
        self.defaultComment = [[FlowLayoutLabel alloc] initWithFrame:CGRectMake(COMMENT_DEFAULT_ORIGIN.x, COMMENT_DEFAULT_ORIGIN.y, COMMENT_DEFAULT_SIZE.width, COMMENT_DEFAULT_SIZE.height)];
        self.defaultComment.backgroundColor = CLEAR_COLOR;
        self.defaultComment.textColor = WHITE_COLOR;
        [self.defaultComment setMaxWidth:COMMENT_DEFAULT_SIZE.width maxLine:0 font:COMMENT_FONT];
        [self addSubview:self.defaultComment];
        self.frame = frame;
        
        currentCommentPage = 1;
        lastCommentRect = CGRectMake(COMMENT_DEFAULT_ORIGIN.x, COMMENT_DEFAULT_ORIGIN.y - COMMENT_INTERVAL, 0, 0);
        
        self.commentLabelArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//重置评论栏
- (void)reset
{
    [self.defaultComment setTextContent:COMMENT_LOADING];
    if (!self.defaultComment.superview) {
        [self addSubview:self.defaultComment];
    }
    
    if ([self.commentLabelArray count] > 0) {
        [self.commentLabelArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.commentLabelArray removeAllObjects];
    }
    
    if (self.loadMoreButton.superview) {
        [self.loadMoreButton removeFromSuperview];
        if (self.loadMoreButton != nil) {
            self.loadMoreButton = nil;
        }
    }
    
    lastCommentRect = CGRectMake(COMMENT_DEFAULT_ORIGIN.x, COMMENT_DEFAULT_ORIGIN.y - 10, 0, 0);
    self.frame = COMMENT_VIEW_DEFAULT_FRAME;
}

//根据给定的pmFeedList响应评论列表
- (void)requestCommentListFromObjectID:(NSString *)sobjectID andIDtype:(NSString *)sidtype atPage:(int)page withSuccessBlock:(BKSenderBlock)delegateBlock
{
//    if (self.commentLabelArray == nil) {
//        self.commentLabelArray = [[NSMutableArray alloc] init];
//    }
    
    commentSuccessBlock = delegateBlock;
    
    isPullingData = YES;
    [self.defaultComment setTextContent:COMMENT_LOADING];
    
//    NSString *authName = [NSString stringWithFormat:@"%@%@", [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME], KEY_AUTH];
//    NSString *m_auth = [SBKeycahin getPassWordForName:authName];
    NSString *m_auth = [SBToolKit getMAuth];
    
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSString *idtype = [SBToolKit convertReidtypeToidtype:sidtype];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:COMMENT_LIST_API parameters:[NSDictionary dictionaryWithObjectsAndKeys:m_auth, M_AUTH, sobjectID, ID, idtype, IDTYPE, [NSString stringWithFormat:@"%d", page], PAGE, nil]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //成功拉取数据
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        isPullingData = NO;

        NSDictionary *resultDict = [(NSData *)responseObject objectFromJSONData];
        
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            NSArray *commentList = [resultDict objectForKey:DATA];
            commentCount = [commentList count];
            
            //获取并设置评论
            if (commentCount == 0) {
                [self.defaultComment setTextContent:COMMENT_NOTHING];
//                lastCommentRect = self.defaultComment.frame;
            } else {
                if (self.defaultComment.superview) {
                    [self.defaultComment removeFromSuperview];
                }
                
                NSDictionary *commentItem = [commentList objectAtIndex:0];
                NSString *comment = [NSString stringWithFormat:@"%@:%@", [commentItem objectForKey:AUTHORNAME], [commentItem objectForKey:MESSAGE]];
                
                //逐条取评论
                for (int i = 0; i < commentCount; i++) {
                    commentItem = [commentList objectAtIndex:i];
                    comment = [NSString stringWithFormat:@"%@:%@", [commentItem objectForKey:AUTHORNAME], [commentItem objectForKey:MESSAGE]];
                    FlowLayoutLabel *newComment = [CommentView commentWithText:comment];
                    
                    //设置评论位置
                    CGRect rect = newComment.frame;
                    newComment.frame = CGRectMake(lastCommentRect.origin.x, lastCommentRect.origin.y + lastCommentRect.size.height + COMMENT_INTERVAL, rect.size.width, rect.size.height);
                    lastCommentRect = newComment.frame;
                    
                    [self addSubview:newComment];
                    [self.commentLabelArray addObject:newComment];
                }
                
                //如果取得的评论数目为10，加载显示更多按钮
                if (commentCount == 10) {
                    if (self.loadMoreButton == nil) {
                        self.loadMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        self.loadMoreButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                        [self.loadMoreButton setTitle:@"显示更多" forState:UIControlStateNormal];
                        [self.loadMoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        self.loadMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
                        //设置点击事件
                        [self.loadMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{

                            [self requestCommentListFromObjectID:sobjectID andIDtype:sidtype atPage:page+1 withSuccessBlock:delegateBlock];
                        }];
                        
                        [self addSubview:self.loadMoreButton];
                    }
                    self.loadMoreButton.frame = CGRectMake((COMMENT_VIEW_SIZE.width - COMMENT_VIEW_LOAD_MORE_BUTTON_SIZE.width)/2,
                                                           lastCommentRect.origin.y + lastCommentRect.size.height + COMMENT_INTERVAL,
                                                           COMMENT_VIEW_LOAD_MORE_BUTTON_SIZE.width,
                                                           COMMENT_VIEW_LOAD_MORE_BUTTON_SIZE.height);
                } else {
                    [self.loadMoreButton removeFromSuperview];
                    self.loadMoreButton = nil;
                }
                
                //调整commentView.frame.size
                CGRect originRect = self.frame;
                if (self.loadMoreButton == nil) {
                    self.frame = CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, lastCommentRect.origin.y + lastCommentRect.size.height +COMMENT_VIEW_SIZE.height);
                } else {
                    self.frame = CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, lastCommentRect.origin.y + lastCommentRect.size.height + COMMENT_INTERVAL + self.loadMoreButton.frame.size.height + COMMENT_VIEW_SIZE.height);
                }
            }
            
            //回调
            [self performBlock:delegateBlock afterDelay:0];
        } else {
//            NSLog(@"XXXXXXXXXXXXXXXXXrequest commentlist errorXXXXXXXXXXXXXXXXXXXXX\n%@\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", resultDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"??????????????????request commentlist fail????????????????????\n%@\n?????????????????????????????????????????????", error);
    }];
    [operation start];
}

+ (FlowLayoutLabel *)commentWithText:(NSString *)commentText;
{
    FlowLayoutLabel *newComment = [[FlowLayoutLabel alloc] init];
    newComment.textColor = COMMENT_TEXT_COLOR;
    [newComment setMaxWidth:COMMENT_DEFAULT_SIZE.width maxLine:0 font:COMMENT_FONT];
    [newComment setTextContent:commentText];
    newComment.backgroundColor = CLEAR_COLOR;
    newComment.textColor = WHITE_COLOR;
    return newComment;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
