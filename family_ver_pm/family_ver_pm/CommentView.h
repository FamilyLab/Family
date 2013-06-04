//
//  CommentView.h
//  family_ver_pm
//
//  Created by pandara on 13-3-26.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowLayoutLabel.h"
#import "BlocksKit.h"

@interface CommentView : UIView {
    BOOL isPullingData;
    int commentCount;
    CGRect lastCommentRect;
    int currentCommentPage;
    BKSenderBlock commentSuccessBlock;
}

@property (strong, nonatomic) NSString *commentSuccessTib;
@property (strong, nonatomic) IBOutlet FlowLayoutLabel *titleLabel;
@property (strong, nonatomic) FlowLayoutLabel *defaultComment;
@property (strong, nonatomic) UIButton *loadMoreButton;
@property (strong, nonatomic) NSMutableArray *commentLabelArray;

- (void)setTitle:(NSString *)title;
- (void)requestCommentListFromObjectID:(NSString *)sobjectID
                             andIDtype:(NSString *)sidtype
                                atPage:(int)page
                      withSuccessBlock:(BKSenderBlock)delegateBlock;
- (void)reset;

@end
