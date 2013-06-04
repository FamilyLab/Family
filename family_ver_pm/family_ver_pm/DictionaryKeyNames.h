//
//  DictionaryKeyNames.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//
//#import "PDKeychainBindings.h"
#ifndef Family_pm_DictionaryKeyNames_h
#define Family_pm_DictionaryKeyNames_h

#define getTheFrame(obj) NSLog(@"%@ x:%.2f, y:%.2f, w:%.2f, h:%.2f", [obj class], obj.frame.origin.x, obj.frame.origin.y, obj.frame.size.width, obj.frame.size.height)

#define iPhone5   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isRetina  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


//ControllerTag
#define kTheBottomButtonTag          20
#define kTheInterfaceButtonTag       30
#define kTheAlertViewTag             40
#define kTheListViewCellButtonTag    50

//
#define DEVICE_FRAME    [[UIScreen mainScreen] applicationFrame]
#define DEVICE_ORIGIN [[UIScreen mainScreen] bounds].origin
//#define DEVICE_SIZE [[UIScreen mainScreen] bounds].size

//NSUserDefaults
#define MY_HAS_LOGIN            [[NSUserDefaults standardUserDefaults] boolForKey:HAS_LOGIN]
#define MY_HEAD_AVATAR_URL      [[NSUserDefaults standardUserDefaults] stringForKey:AVATAR_URL]
#define MY_HEAD_AVATAR          [[NSUserDefaults standardUserDefaults] objectForKey:AVATAR]
#define MY_M_AUTH               [[PDKeychainBindings sharedKeychainBindings] stringForKey:M_AUTH]
#define MY_UID                  [[NSUserDefaults standardUserDefaults] stringForKey:UID]
#define MY_NAME                 [[NSUserDefaults standardUserDefaults] stringForKey:NAME]
//url
#define API_BASE_URL @"http://www.familyday.com.cn/dapi/"
#define POST_API @"http://www.familyday.com.cn/dapi/do.php?ac="
#define SPACE_API @"http://www.familyday.com.cn/dapi/space.php"
#import "TopBarView.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"

//
#define isAuthFailure(dict)           [[(NSDictionary*)dict objectForKey:@"msgkey"] isEqualToString:@"auth_failure"] ? YES : NO 
//
#import "LoginViewController.h"
#define ReloginForAuthFailure(dict)   if(isAuthFailure(dict)){LoginViewController *_con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_con];nav.navigationBarHidden = YES;[self.navigationController presentModalViewController:nav animated:NO];[nav release], nav = nil;[_con release], _con = nil;}

//NSNotificationCenter
#define SEND_REQUEST            @"sendrequest"
#define CLEAR_ALL_DATA          @"clearalldata"
//
#define ZERO                    @"0"
#define ONE                     @"1"
//
#define HAS_LOGIN               @"hasLogin"

#define USER_NAME               @"username"
#define PASSWORD                @"password"
#define ISCOOKIE                @"iscookie"
#define INVITE_CODE             @"invitecode"

#define WEB_ERROR               @"error"
#define WEB_RETURN              @"return"
#define WEB_MSG                 @"msg"
#define WEB_MSGKEY              @"msgkey"

#define ADD_VIDEO               @"addvideo"
#define ADD_EVENT               @"addevent"
#define ADD_BLOG                @"addblog"
#define ADD_PHOTO               @"addphoto"
#define PM_COUNT                @"pmcount"
#define APPLY_COUNT             @"applycount"
#define NOTE_COUNT              @"notecount"

#define DATA                    @"data" //家人
#define M_AUTH                  @"m_auth"
#define UID                     @"uid"
#define FAMILY_UID              @"fuid"
//#define NAME                    @"name"
#define AVATAR                  @"avatar"
#define AVATAR_URL              @"avatarurl"
#define NOTE                    @"note"
#define BIRTHDAY                @"birthday"
#define IS_MY_FAMILY            @"isfamily"
#define FAMILY_LIST             @"fmemberlist"
#define FAMILY_MEMBERS          @"fmembers"
#define PHONE                   @"phone"
#define SPACE_TAG               @"tags"
#define LAST_LOGIN_TIME         @"lastlogin"
#define CHANGENOTE_SUBMIT       @"changenotesubmit"
#define PM_TO_UID               @"touid"
#define MESSAGE                 @"message"
#define LAT                     @"lat"
#define LNG                     @"lng"
#define ADDRESS                 @"address"
#define IPHONE                  @"iphone"
#define COME                    @"come"
#define PM_SUBMIT               @"pmsubmit"

#define SMS_INVITE              @"smsinvite"

#define APPLY_UID               @"applyuid"
#define G_ID                    @"gid"
#define ADD_SUBMIT              @"addsubmit"
#define AGREE_SUBMIT            @"agreesubmit"
#define FRIEND_SUBMIT           @"friendsubmit"

#define REQUEST_NUMBER          @"requestnum"
#define REQUEST_LIST            @"requestlist"


#define CREDIT                  @"credit" //设置
#define TASK_NUMBER             @"tasknum"
#define NAME_SUBMIT             @"namesubmit"
#define MY_BIRTHDAY             @"birth"
#define BIRTHDAY_SUBMIT         @"birthsubmit"
#define AVATAR_SUBMIT           @"avatarsubmit"
#define PERSONAL                @"personal"
#define FAMILY                  @"family"

#define SPACE_LIST              @"spacelist"    //发布
#define SPACE_NAME              @"tagname"
#define TAG_LIST                @"taglist"
#define TAG_NAME                @"tagname"
#define UPLOAD_PHOTO            @"uploadphoto"
#define OP                      @"op"
#define MESSAGE                 @"message"  
#define PICTURE_IDS             @"picids"
#define FRIEND                  @"friend"
#define FRIENDS                 @"friends"
#define MAKE_FEED               @"makefeed"
#define MAKE_SINA_WEIBO         @"makeweibo"
#define MAKE_QQ_WEIBO           @"makeqqweibo"
#define PHOTO_SUBMIT            @"photosubmit"
#define SUBJECT                 @"subject"
#define BLOG_SUBMIT             @"blogsubmit"
#define PICTURE_ID              @"picid"
#define EXPERIENCE              @"experience"

#define PAGE                    @"page"     //私信
#define PER_PAGE                @"perpage"
#define PM_AVATAR               @"msgtoavatar"
#define PM_ID                   @"pmid"
#define PM_TO_NAME              @"msgtoname"
#define VIP_STATUS              @"vipstatus"
#define LAST_DATE_LINE          @"lastdateline"
#define LAST_SUMMARY            @"lastsummary"
#define UNREAD_MESSAGE          @"new"
#define DATE_RANGE              @"daterange"
#define START_TIME              @"starttime"
#define END_TIME                @"endtime"
#define DIALOG                  @"dialog"
#define FROM_USER               @"fromuser"
#define TO_USER                 @"touser"
#define MESSAGE_FROM_ID         @"msgfromid"
#define DATELINE                @"dateline"
#endif