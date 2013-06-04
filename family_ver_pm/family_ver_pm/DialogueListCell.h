//
//  DialogueListCell.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHeadButton.h"

@interface DialogueListCell : UITableViewCell
{
    
}

@property(nonatomic, retain) NSDictionary *dataDic;

@property(nonatomic, retain) IBOutlet MyHeadButton *headBtn;
@property(nonatomic, retain) IBOutlet UILabel *nameLbl;
@property(nonatomic, retain) IBOutlet UILabel *nicknameLbl;

@property(nonatomic, retain) IBOutlet UILabel *unreadLbl;
@property(nonatomic, retain) IBOutlet UIImageView *unreadRightImg;

-(void)init:(NSDictionary *)_dataDic;

@end
