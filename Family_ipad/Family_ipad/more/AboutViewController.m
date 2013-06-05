//
//  AboutViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-4-3.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _type = vip_image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    switch (_type) {
        case vip_image:
            _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_intro.jpg"]];
            break;
        case money_image:
            _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money_intro.jpg"]];
            break;
        case about_image:
            _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about_family.jpg"]];
            break;
        default:
            break;
    }
    [_scrollerView addSubview:_imageView];
    _scrollerView.contentSize = _imageView.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
