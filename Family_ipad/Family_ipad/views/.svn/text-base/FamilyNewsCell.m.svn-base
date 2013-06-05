//
//  FamilyNewsCell.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "FamilyNewsCell.h"
@implementation FamilyNewsCell
//给“对话”列表用的
- (void)fillLblWithStr:(NSString*)_text {
	/**(1)** Build the NSAttributedString *******/
    OHAttributedLabel *pointLbl =  self.nameAndNoteLabel;
	NSMutableAttributedString* attrStr = [pointLbl.attributedText mutableCopy];
    
    // Change the paragraph attributes, like textAlignment, lineBreakMode and paragraph spacing
    [attrStr modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.textAlignment = kCTLeftTextAlignment;// kCTCenterTextAlignment;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        paragraphStyle.paragraphSpacing = 8.f;
        paragraphStyle.lineSpacing = 3.f;
    }];
    //昵称部分根据主题变色
    NSRange theRange = [pointLbl.text rangeOfString:_text];
    UIColor *theColor = color(157, 212, 74, 1.0);
	[attrStr setTextColor:theColor range:theRange];
    CGFloat theSize = 23.0f;
    [attrStr setFontFamily:@"helvetica" size:theSize bold:YES italic:NO range:theRange];
	
	/**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
	pointLbl.attributedText = attrStr;
	pointLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    //    pointLbl.centerVertically = YES;
    
#if ! __has_feature(objc_arc)
	[attrStr release];
#endif
}
- (void)setCellData:(NSDictionary *)dict
{
    [super setCellData:dict];
    
    _feedsLabel.text = $safe($str(@"%@个动态",[dict objectForKey:FAMILY_FEEDS]));
    _fmembersLabel.text = $safe($str(@"%@个家人",[dict objectForKey:FAMILY_MEMBERS]));
    if ([$safe($str([dict objectForKey:BIRTHDAY]))isEqualToString:@""]) {
        _birthDayLabel.hidden =YES;
        _birthdayLogo.hidden = YES;
    }
    else
    { _birthDayLabel.hidden =NO;
        _birthdayLogo.hidden = NO;
        _birthDayLabel.text = $safe($str([dict objectForKey:BIRTHDAY]));
    }
    _uid = [dict objectForKey:UID];
    avatar.identify = [dict objectForKey:UID];
    NSString *name = emptystr([dict objectForKey:NAME]);
    if (!isEmptyStr([dict objectForKey:NOTE])) {
        name = [NSString stringWithFormat:@"%@ (%@)", name, [dict objectForKey:NOTE]];
    }
    _nameAndNoteLabel.text = name;
    [self fillLblWithStr:[dict objectForKey:NAME]];
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
   

}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    
    [super willTransitionToState:state];
    
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        
        for (UIView *subview in self.subviews) {
            
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                
                subview.hidden = YES;
                subview.alpha = 0.0;
            }
        }
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
    
    [super didTransitionToState:state];
    
    if (state == UITableViewCellStateShowingDeleteConfirmationMask || state == UITableViewCellStateDefaultMask) {
        for (UIView *subview in self.subviews) {
            
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                
                UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
                CGRect f = deleteButtonView.frame;
                f.origin.x -= 20;
                f.origin.y +=10;
                deleteButtonView.frame = f;
                
                subview.hidden = NO;
                
                [UIView beginAnimations:@"anim" context:nil];
                subview.alpha = 1.0;
                [UIView commitAnimations];
            }
        }
    }
}
@end
