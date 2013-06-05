//
//  BaseTableViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "TableController.h"
#import "HeaderView.h"
#import "MyHttpClient.h"
@interface BaseTableViewController : TableController
{
    IBOutlet HeaderView *header;
}
@property (nonatomic,strong)IBOutlet HeaderView *header;
@end
