//
//  TopBarView.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-27.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "TopBarView.h"

@implementation TopBarView

@synthesize VConId;
@synthesize rightGreenBgWidth;
@synthesize themeLbl;
@synthesize familyLbl;
@synthesize countPerLbl;

#define TheThemeLblDefaultWith              132
#define TheRightGreenBgDefaultWith          168

-(id) initWithConId:(NSString *) _VConId andTopBarFrame:(CGRect) _frame
{
    self.VConId = _VConId;
    return [self initWithFrame:_frame];
}

-(id) initWithConId:(NSString *)_VConId andTopBarFrame:(CGRect)_frame TheFrameWidth:(NSString *)_width
{
    self.VConId = _VConId;
    self.rightGreenBgWidth = _width;
    return [self initWithFrame:_frame];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:frame];
        [bgImg setImage:[UIImage imageNamed:@"family_bg.png"]];
        [self addSubview:bgImg];
        [bgImg release], bgImg = nil;
        
        familyLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 115, 26)];
        //familyLbl.textColor = [UIColor colorWithRed:(136/255) green:(194/255) blue:(53/255) alpha:1.0f];
        familyLbl.textColor = [UIColor greenColor];
        familyLbl.font = [UIFont boldSystemFontOfSize:19.0f];
        familyLbl.textAlignment = UITextAlignmentLeft;
        familyLbl.backgroundColor = [UIColor clearColor];
        familyLbl.hidden = YES;
        [self addSubview:familyLbl];
        
        countPerLbl = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 130, 26)];
        countPerLbl.textAlignment = UITextAlignmentRight;
        countPerLbl.textColor = [UIColor darkGrayColor];
        countPerLbl.font = [UIFont boldSystemFontOfSize:19.0f];
        countPerLbl.backgroundColor = [UIColor clearColor];
        countPerLbl.hidden = YES;
        [self addSubview:countPerLbl];
        
        switch ([VConId intValue]) {
            case 0:
            case 1:
            case 2:
            {
                NSDictionary *row1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"signin_gray.png", @"bgtopbar", @"signin_logo.png", @"logo", @"line.png", @"line", nil];
                NSDictionary *row2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"bg_topbar.png", @"bgtopbar", @"logo_small_green.png", @"logo", @"line_green_home.png", @"line", nil];
                NSDictionary *row3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"publish_red.png", @"bgtopbar", @"logo_small_red.png", @"logo", @"line_red.png", @"line", nil];
                NSArray *dataArray = [[NSArray alloc] initWithObjects:row1, row2, row3, nil];
                [row1 release], row1 = nil;
                [row2 release], row2 = nil;
                [row3 release], row3 = nil;
                
                int sequence = [VConId intValue];
                
                UIImageView *greenBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 111, 55)];
                [greenBgImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [[dataArray objectAtIndex:sequence] objectForKey:@"bgtopbar"]]]];
                [self addSubview:greenBgImg];
                [greenBgImg release], greenBgImg = nil;
                
                UIImageView *logoBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(248, 8, 64, 34)];
                [logoBgImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [[dataArray objectAtIndex:sequence] objectForKey:@"logo"]]]];
                [self addSubview:logoBgImg];
                [logoBgImg release], logoBgImg = nil;
                
                UIImageView *lineBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(130, 50, 190, 5)];
                [lineBgImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [[dataArray objectAtIndex:sequence] objectForKey:@"line"]]]];
                [self addSubview:lineBgImg];
                [lineBgImg release], lineBgImg = nil;
                
                [dataArray release], dataArray = nil;
                
                themeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, 111, 28)];
                themeLbl.textColor = [UIColor whiteColor];
                themeLbl.textAlignment = UITextAlignmentCenter;
                themeLbl.backgroundColor = [UIColor clearColor];
                themeLbl.font = [UIFont systemFontOfSize:28.0f];
                [self addSubview:themeLbl];
                
            }
                break;
            case 3:
            {
                UIImageView *leftGreenBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 29, 17, 36)];
                [leftGreenBgImg setImage:[UIImage imageNamed:@"greenbg_dialogue.png"]];
                [self addSubview:leftGreenBgImg];
                [leftGreenBgImg release], leftGreenBgImg = nil;
                
                UIImageView *rightGreenBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(320 - [rightGreenBgWidth intValue], 29, [rightGreenBgWidth intValue], 36)];
                [rightGreenBgImg setImage:[UIImage imageNamed:@"greenbg_dialogue.png"]];
                [self addSubview:rightGreenBgImg];
                [rightGreenBgImg release], rightGreenBgImg = nil;
                
                themeLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 26, TheThemeLblDefaultWith + TheRightGreenBgDefaultWith - [rightGreenBgWidth intValue], 39)];
                themeLbl.textColor = [UIColor blackColor];
                themeLbl.font = [UIFont boldSystemFontOfSize:27.0f];
                themeLbl.textAlignment = UITextAlignmentCenter;
                themeLbl.backgroundColor = [UIColor clearColor];
                [self addSubview:themeLbl];
                
                familyLbl.hidden = NO;
                countPerLbl.hidden = NO;
            }
                break;
            default:
                break;
        }
        
    }
    return self;
}


-(void)dealloc
{
    [super dealloc];
    [rightGreenBgWidth release], rightGreenBgWidth = nil;
    [VConId release], VConId = nil;
    [themeLbl release], themeLbl = nil;
    [familyLbl release], familyLbl = nil;
    [countPerLbl release], countPerLbl = nil;
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
