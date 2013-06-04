//
//  InviteFamilyViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-28.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackBottomBarView.h"
#import "SSTextView.h"
#import <AddressBookUI/AddressBookUI.h>
#import "MFMessageComposeViewController+BlocksKit.h"

@interface InviteFamilyViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,BackBottomBarViewDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>
{
    BackBottomBarView *customBackBottomBarView;
}


@property(nonatomic, retain) IBOutlet UIScrollView *theScrollView;
@property(nonatomic, retain) IBOutlet UITextField * nameTextField;
@property(nonatomic, retain) IBOutlet UIButton *addBtn;
@property(nonatomic, retain) IBOutlet UITextField *phoneNumTextField;
@property(nonatomic, retain) NSString *passwordStr;
@property(nonatomic, retain) IBOutlet SSTextView *messageTextView;
@property(nonatomic, retain) IBOutlet UIButton *inviteBtn;
@property(nonatomic, retain) IBOutlet UIView *bgrImg;

@end
