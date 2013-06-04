//
//  TouchTableView.h
//  MultiLayerNavigation
//
//  Created by Aevitx on 13-5-18.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchTableViewDelegate;

@interface TouchTableView : UITableView {
@private
//    id _touchDelegate;
}

@property (nonatomic, assign) IBOutlet id <TouchTableViewDelegate> touchDelegate;

@end


@protocol TouchTableViewDelegate <NSObject>

@optional
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end