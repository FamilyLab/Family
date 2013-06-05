//
//  TileItemButton.h
//  atFaXian

//  The TileItem used to show the subsvribed items.It should hold 
//  a image at center and a tag at the left bottom.Besides it should 
//  hold a button to repose the user click.

//  Created by Walter.Chan on 12-11-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
@interface TileItemButton : UIView
@property (nonatomic,strong)IBOutlet MyButton *tileImage;
@property (nonatomic,strong)IBOutlet UILabel *tagLabel;
@property (nonatomic,strong)NSString *itemUID;
/**
 set the tile's image and tag title
 
 @param the image object and the string object
 
 @return void
 */
- (void)setUpSubViews:(NSString *)_img
                 _str:(NSString *)_str;
@end
