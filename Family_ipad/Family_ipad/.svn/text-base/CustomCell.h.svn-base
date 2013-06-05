//
//  MenuCell.h
//  Family
//
//  Created by on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "web_config.h"
#import "MyButton.h"
typedef enum {
    newsListTable,
    familyListTable,
} CellType;

@interface CustomCell : UITableViewCell {
    IBOutlet MyButton *avatar;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *noteLabel;
}

@property(nonatomic) NSInteger indexSection;
@property(nonatomic,assign)CellType cellType;
@property(nonatomic,strong)IBOutlet UILabel *nameLabel;
- (void)setCellData:(NSDictionary *)dict;
@end
