//
//  FamilyListCell.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-28.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyListCell : UITableViewCell
{
    IBOutlet UIImageView *headImg;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *noteLbl;
    IBOutlet UILabel *birthLbl;
}

-(void)initData:(NSDictionary*)dict;

@end
