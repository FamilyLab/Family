//
//  DictionaryKeyNames.h
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#ifndef Family_DictionaryKeyNames_h
#define Family_DictionaryKeyNames_h

//tag
#define kTagWhichBottomView  10  //何种bottom view
#define kTagBottomButton     60  //tabbar button
#define kTagAddFriendsButton 70  //添加家人页面的按钮
#define kTagBtnInTopBarView  80  //topBarView上的按钮
#define kTagBtnInMoreCon     100 //”更多“页面上的按钮
#define kTagLblInMoreCon     120 //”更多“页面上的有颜色的label
#define kTagBtnInExpandView  130 //ExpandView的按钮
#define kTagBtnInThemeView   140 //主题界面的按钮
#define kTagBtnInFeedDetail  150 //动态详情界面的”评论“、”参与“按钮
#define kTagConViewInZoneDetail 160//空间详情界面上的scrollview的三个子view
#define kTagMembersBtnInZoneList 500//空间列表界面上家人那个section的头像按钮
#define kTagBtnOfListViewCell  200//发表照片界面的横向tableview上每个button的tag
#define kTagTogetherImgViewOfPostView   210//发表界面的和谁在一起的头像imageview
#define kTagBtnOfFace       220//动态详情的表态按钮
#define kTagNoneFeed        230//没有动态时的空白页图片
#define kTagNoneDialog      231//没有对话时的空白页图片
#define kTagNoneFamilies    232//没有家人时的空白页图片
#define kTagBgBtnOfPostPhot 235//发表照片页面，当有键盘时加上去的背景按钮
#define kTagAlbumImgBtn     250//相机页面下面的相册里的图片

//又拍云
#define ypUrlStr            @"upaiyun.com"//属于又拍的url
#define ypFeedSomeImgs      @"!190X190"//用于动态列表的多图样式
#define ypFeedBigImg        @"!580X400"//用于动态列表大图样式
#define ypFeedForImgAndText @"!200X280"//用于动态列表有一张图片和有文字的样式
#define ypFeedOtherType     @"!90X90"//用于动态列表里行为动态类型右边的图片

#define ypZoneTheme         @"!600X720"//用于空间列表主题
#define ypZoneCover         @"!220X220"//用于空间列表

#define ypFeedDetail        @"!580"//宽580 高度自适应  用于动态详情的大图

#define ypHeadSize          @"!120X120"


//新浪微博
#define kAppKey             @"2925976517"
#define kAppSecret          @"4a1f95e70805f08facc3bcf74f6b9cd3"
#define kAppRedirectURI     @"http://www.familyday.com.cn"
#define SINA_AUTH_DATA      @"SinaWeiboAuthData"

//微信
#define WeiXin_APP_ID       @"wxa0c847f269d4c5e2"
#define WeiXin_APP_KEY      @"c0ecb63cee20373b91f3cb67964a542b"

//友盟
#define UMENG_APP_KEY       @"5151df6b56240bba24005ef6"

#define kNoCommentHeight    55
#define COMMENT_MAX_WIDTH   224
#define COMMENT_MIN_HEIGHT  44
#define LOVE_MAX_WIDTH      250
#define LOVE_MIN_HEIGHT     37

//FUCK_NUM_0、FUCK_NUM_1、FUCK_NUM_2（FUCK_NUM_1和FUCK_NUM_2的值一样）都改为0，再将评论的背景图片_commentBgImgView改为：@"feed_comment_bg_v12.png"(@"feed_comment_bg_short_v12.png"的为短的)，就可以让评论的那背景框宽度为300。
#define FUCK_NUM_0  48
#define FUCK_NUM_1  33

//判断是否为空字段并做处理
#define emptystr(obj)  !obj ? @"" : (((NSNull *)(obj) == [NSNull null] ? @"" : (obj)))
#define isEmptyStr(obj) [emptystr(obj) isEqualToString:@""] ? YES : NO

//判断是否auth_failure
#define isAuthFailure(dict) [[(NSDictionary *)dict objectForKey:@"msgkey"] isEqualToString:@"auth_failure"] ? YES : NO

//auth_failure的话重新登录
#import "LoginViewController.h"
#define reLoginForAuthFailure(dict) if (isAuthFailure(dict)) {LoginViewController *con =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:con];loginNav.navigationBarHidden = YES;[self.navigationController presentModalViewController:loginNav animated:NO];}

//#import "AppDelegate.h"
//#define pushACon(con) {AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate; [appDelegate pushAController:con];}
//
//#define popACon {AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;[appDelegate popAController];}

#import "Common.h"
//在uiview里push
#define pushAConInView(view, con) {[[Common viewControllerOfView:view].navigationController pushViewController:con animated:YES];}
//在uiview里pop
#define popAConInView(view) {[[Common viewControllerOfView:view].navigationController popViewControllerAnimated:YES];}


//在uiview里present
#define presentAConInView(view, con) {[[Common viewControllerOfView:view].navigationController presentModalViewController:con animated:YES];}
//在uiview里dismiss
#define dismissAConInView(view) {[[Common viewControllerOfView:view].navigationController dismissModalViewControllerAnimated:YES];}

//push前的controller（如果self是从tabbarcontroller的某个controller进来的，这里得到的只是tabbarcontroller,而得不到具体的哪个controller）
#define preController [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2]

#define myTabBarController [self.navigationController.viewControllers objectAtIndex:0]

//米色的背景
#define bgColor() [UIColor colorWithRed:245/255.0f green:244/255.0f blue:239/255.0f alpha:1]

#define NUM_PER_ROW 6 //空间界面，我的家人section，每一行有6个头像

#define MY_LOGIN_TYPE   [[NSUserDefaults standardUserDefaults] integerForKey:WHICH_LOGIN_TYPE]//登录的类型,-1为未登录，0为新浪微博登录，1为QQ微博登录

//notification
#define CLEAR_ALL_DATA                  @"clearAllData"
#define SEND_REQUEST                    @"sendRequest"
#define REFRESH_MORE_CON                @"refreshMoreCon"
#define REFRESH_FEED_LIST               @"refreshFeedList"
#define REFRESH_FEED_LIST_FOR_DELETE    @"refreshFeedListForDelete"
#define REFRESH_MESSAGE_NUM             @"refreshNewNumOfMsgCon"
#define REFRESH_MORE_NUM                @"refreshNewNumOfMoreCon"
#define REFRESH_TALK_LIST_READ_STATE    @"refreshTalkListReadState"
#define REFRESH_FEED_LOVE_NUM           @"refreshFeedLoveNum"
#define REFRESH_TOPIC_CON               @"refrestTopicViewController"
#define GET_FAMILY_AND_ZONE_LIST        @"getFamilyAndZoneListForPostViewCon"
#define PUSH_FOR_DIALOG_DETAIL          @"pushForDialogDetail"
//#define PUSH_FOR_FEED_DETAIL            @"pushForFeedDetail"
#define PRESENT_POST_VIEWCONTROLLER     @"presendtPostViewController"
#define DISMISS_CUSTOM_CAMERA           @"dismissCustomCamera"
#define SHOW_CUSTOM_CAMERA              @"showCustomCamera"

#define REFRESH_COUNT_NUM   @"wo zhi shi yao shua xin tong ji jie kou a a a a a"//刷新统计接口
//#define ADD_MSG_NUM         @"addMsgNum"
//#define ADD_NOTIE_NUM       @"addNoticeNum"

//push
#define PUSH_PM             @"pmid"//私信
#define PUSH_COMMENT        @"comment"//评论
#define PUSH_FEED_FRIEND    @"feedfriend"//对方加我好友，我审核通过
#define PUSH_FRIEND         @"friend"//请求加好友

#define PUSH_PHOTO          @"photo"//
#define PUSH_BLOG           @"blog"//
#define PUSH_EVENT          @"event"//
#define PUSH_VIDEO          @"video"//

#define PUSH_REPHOTO        @"rephoto"//
#define PUSH_REBLOG         @"reblog"//
#define PUSH_REEVENT        @"reevent"//
#define PUSH_REVIDEO        @"revideo"//


//function
#define getTheFrame(tipsStr, object) NSLog(@"%@, x:%.2f y:%.2f w:%.2f h:%.2f class:%@", tipsStr, object.frame.origin.x, object.frame.origin.y, object.frame.size.width, object.frame.size.height, [object class])
//#define getTheFrame(object) NSLog(@"%@ x:%.2f y:%.2f w:%.2f h:%.2f", [object class], object.frame.origin.x, object.frame.origin.y, object.frame.size.width, object.frame.size.height)

#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//#define DEVICE_BOUNDS [[UIScreen mainScreen] bounds]
//#define DEVICE_SIZE [[UIScreen mainScreen] bounds].size

#define DEVICE_BOUNDS [[UIScreen mainScreen] applicationFrame]
#define DEVICE_SIZE [[UIScreen mainScreen] applicationFrame].size

#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//theme
#define kKeyTheme       @"keyForTheme"
#define DEFAULT_THEME   @"default"
#define SPRING_THEME    @"spring"
#define SUMMER_THEME    @"summer"
#define AUTUMN_THEME    @"autumn"
#define WINTER_THEME    @"winter"
#define THEME_CHANGE    @"themeChange"

//NSUserDefault
#define MY_AUTO_LOGIN    [[NSUserDefaults standardUserDefaults] boolForKey:AUTO_LOGIN]
#define MY_HAS_LOGIN    [[NSUserDefaults standardUserDefaults] boolForKey:HAS_LOGIN]
//#define MY_M_AUTH       [[NSUserDefaults standardUserDefaults] stringForKey:M_AUTH]
#define MY_UID          [[NSUserDefaults standardUserDefaults] stringForKey:UID]
#define MY_HEAD_AVATAR_URL [[NSUserDefaults standardUserDefaults] stringForKey:AVATAR_URL]
#define MY_HEAD_AVATAR  [[NSUserDefaults standardUserDefaults] objectForKey:AVATAR]
#define MY_VIP_STATUS   [[NSUserDefaults standardUserDefaults] objectForKey:VIP_STATUS]
#define MY_NAME         [[NSUserDefaults standardUserDefaults] stringForKey:NAME]//真实的名字，昵称
//#define MY_USER_NAME    [[NSUserDefaults standardUserDefaults] stringForKey:USER_NAME] //登录的帐号
//#define NEED_Clear_Head_Cache   @"needClearHeadCache"  
#define MY_SPACE_IMAGE_DATA     [[NSUserDefaults standardUserDefaults] objectForKey:SPACE_IMAGE]
#define MY_WANT_SHOW_TODAY_TOPIC    [[NSUserDefaults standardUserDefaults] boolForKey:WANT_SHOW_TODAY_TOPIC]
#define MY_NOT_FIRST_SHOW       [[NSUserDefaults standardUserDefaults] objectForKey:NOT_FIRST_SHOW]
#define MY_HAS_BIND_SINA_WEIBO  [[NSUserDefaults standardUserDefaults] boolForKey:HAS_BIND_SINA_WEIBO]
#define MY_HAS_BIND_QQ_WEIBO    [[NSUserDefaults standardUserDefaults] boolForKey:HAS_BIND_QQ_WEIBO]
#define MY_HAS_BIND_WEIXIN      [[NSUserDefaults standardUserDefaults] boolForKey:HAS_BIND_WEIXIN]
#define MY_SHARE_TO_SINA_WEIBO  [[NSUserDefaults standardUserDefaults] boolForKey:SHARE_TO_SINA_WEIBO]
#define MY_LAST_TOPIC_ID        [[NSUserDefaults standardUserDefaults] objectForKey:LAST_TOPIC_ID]

//keychain
#import "PDKeychainBindings.h"
#define MY_M_AUTH       [[PDKeychainBindings sharedKeychainBindings] stringForKey:M_AUTH]
#define MY_USER_NAME    [[PDKeychainBindings sharedKeychainBindings] stringForKey:USER_NAME]
#define MY_PASSWORD     [[PDKeychainBindings sharedKeychainBindings] stringForKey:PASSWORD]
#define MY_DEVICE_TOKEN [[PDKeychainBindings sharedKeychainBindings] stringForKey:DEVICE_TOKEN]


#define AVATAR_URL              @"avatarUrl"
#define LAST_ZONE_NAME          @"lastPostInZoneName"
#define LAST_TOPIC_ID           @"lastTopicId"

#define WANT_SHOW_TODAY_TOPIC   @"wantToShowTodayTopicWhenLoadApp"
#define NOT_FIRST_SHOW          @"notFirstShow"

#define HAS_BIND_SINA_WEIBO     @"is_sina_bind"
#define HAS_BIND_QQ_WEIBO       @"is_qq_bind"
#define HAS_BIND_WEIXIN         @"hasBindWeixin"

#define SHARE_TO_SINA_WEIBO     @"shareToSinaWeibo"

#define DEVICE_TOKEN    @"deviceToken"

#define AUTO_LOGIN      @"autoLogin"

#define HAS_LOGIN       @"hasLogin"
#define USER_NAME       @"username"
#define PASSWORD        @"password"
#define THE_NEW_PWD1    @"newpasswd1"
#define THE_NEW_PWD2    @"newpasswd2"
//#define M_AUTH          @"m_auth"
#define INVITE_CODE     @"invitecode"
#define SEC_CODE        @"seccode"


#define SPACE_IMAGE     @"spaceimage"

#define DATA            @"data"
#define NAME_SUBMIT     @"namesubmit"
#define AVATAR_SUBMIT   @"avatarsubmit"
#define BIRTH_SUBMIT    @"birthsubmit"
#define BABY_SUBMIT     @"babysubmit"
#define ADD_SUBMIT      @"addsubmit"
#define AGGRE_SUBMIT    @"agreesubmit"
#define PM_SUBMIT       @"pmsubmit"
#define TAGS_SUBMIT     @"tagsubmit"
#define FRIENDS_SUBMIT  @"friendsubmit"
#define PHOTO_SUBMIT    @"photosubmit"
#define BLOG_SUBMIT     @"blogsubmit"
#define SAY_SUBMIT      @"isaysubmit"
#define EVENT_SUBMIT    @"eventsubmit"
#define DELETE_SUBMIT   @"deletesubmit"
#define PWD_SUBMIT      @"pwdsubmit"
#define BABY_EDIT_SUBMIT    @"babyeditsubmit"
#define CHANGE_NOTE_SUBMIT  @"changenotesubmit"
#define LOST_PWD_SUBMIT     @"lostpwsubmit"
#define RESET_SUBMIT        @"resetsubmit"
#define DELETE_SUBMIT       @"deletesubmit"

#define ICON            @"icon"
#define CLICK_ID        @"clickid"

#define INVITE          @"invite"
#define SMS_INVITE      @"smsinvite"

#define UPLOAD_PHOTO            @"uploadphoto"
#define UPLOAD_PHOTO_ON_DIARY   @"uploadpic"
//#define PHONE_NUM       @"phonenum"

#define LOCATION        @"location"
#define START_TIME      @"starttime"

#define IS_COOKIE       @"iscookie"

#define APPLY_UID   @"applyuid"
#define G_ID        @"gid"

#define BABY_LIST   @"babylist"
#define MONEY       @"credit"
#define REWARD      @"reward"
#define TASK_ID     @"taskid"
#define TASK_LIST   @"tasklist"
#define TASK_NUM    @"tasknum"

#define ASK_FOR_FAMILY_NUM  @"frequests"
#define BABY_NAME           @"babyname"
#define BABY_BIRTHDAY       @"babybirthday"
#define BABY_SEX            @"babysex"
#define DO                  @"do"
#define ID                  @"id"
#define OLD_ID              @"oldid"


#define ZERO    @"0"
#define ONE     @"1"
#define TWO     @"2"
#define THREE   @"3"
#define FOUR    @"4"
#define FIVE    @"5"
#define SIX     @"6"
#define SEVEN   @"7"
#define EIGHT   @"8"
#define NINE    @"9"


//xiao
#import "CKMacros.h"
#import "ConciseKit.h"
#define HOME_URL @"http://www.familyday.com.cn"
#define BASE_URL @"http://www.familyday.com.cn/dapi/"
#define SPACE_API @"http://www.familyday.com.cn/dapi/space.php"
#define INFO_API @"http://www.familyday.com.cn/dapi/info.php"
#define POST_API @"http://www.familyday.com.cn/dapi/do.php?ac="
#define POST_CP_API @"http://www.familyday.com.cn/dapi/cp.php?ac="

//common
#define UID         @"uid"
#define LNG         @"lng"
#define LAT         @"lat"
#define PAGE        @"page"
#define PER_PAGE    @"perpage"
#define AVATAR      @"avatar"
#define NAME        @"name"
#define BIRTHDAY    @"birthday"
#define BIRTH       @"birth"
#define ACTION      @"do"
#define ACTION_STR  @"action"
#define NOTE        @"note"
#define OBJ         @"obj"
#define NOTE_HTML   @"notehtml"
#define M_AUTH      @"m_auth"
#define ADDRESS     @"address"
#define COME        @"come"
#define NEW         @"new"
#define PHONE       @"phone"
#define DATELINE    @"dateline"
#define IMAGE       @"image"
#define BABY_AVATAR @"babyavatar"
#define BABY_ID     @"babyid"
#define AC          @"ac"

#define WITH_FRIENDS    @"withfriends"

#define VIP_STATUS  @"vipstatus"

#define MEMBERS     @"members"
#define IS_FAMILY   @"isfamily"
#define MY_LOVE     @"mylove"
#define LOVE_NUM    @"lovenum"

#define OP          @"op"
#define DONE        @"done"

#define PIC_ID      @"picid"
#define PIC_ID_S    @"picids"
#define FRIEND      @"friend"
#define FRIEND_S    @"friends"
#define IPHONE      @"iPhone"
#define MAKE_FEED   @"makefeed"
#define MAKE_SINA_WEIBO  @"makeweibo"
#define MAKE_QQ_WEIBO   @"makeqqweibo"

#define PM_COUNT        @"pmcount"
#define NOTICE_COUNT    @"notecount"
#define APPLY_COUNT     @"applycount"

#define PLIST_FEED_TOP_DATA   @"feeddatadict"
#define PLIST_FEED_COMMENT    @"feedcomment"
#define PLIST_FAMILY_LIST     @"familylist"
#define PLIST_ZONE_LIST       @"zonelist"

#define LOVE_USER       @"loveuser"
#define OLD_SUBJECT     @"fsubject"
#define OLD_MESSAGE     @"fmessage"

/**
 data:        下行接口中代表客户端真正需要的数据。
 msgkey: 代表服务器针对该次请求的信息提示key，客户端可以根据此信息自己再定义信息。
 msg:        代表服务器针对该次请求的辅助信息提示。
 error:        代表是否获取数据错误状态， 1 失败， 0成功。
 return: 返回的状态码，-1：用户名或者密码为空   -2：用户名或者密码错误   1：登录成功
 **/
#define WEB_DATA        @"data"
#define WEB_MSGKEY      @"msgkey"
#define WEB_MSG         @"msg"
#define WEB_ERROR       @"error"
#define WEB_RETURN      @"return"
/**
 
 http://www.familyday.com.cn/dapi/info.php?ac=ad
 【返回值】
 title              广告标题
 imagesrc       广告图片url
 idtype       广告对应的帖子类型
 id              帖子id
 **/
#define AD_TITLE        @"title"
#define AD_IMAGESRC     @"imagesrc"
#define AD_ID_TYPE      @"idtype"
#define AD_ID           @"id"

/**
 http://www.familyday.com.cn/dapi/space.php?do=topic
 【返回值】
 subject:                     标题
 message:                     内容
 dateline:                     发布时间
 endtime：      结束时间
 **/
#define TITLE           @"title"
#define SUBJECT         @"subject"
#define TOPIC_SUBJECT   @"subject"
#define TOPIC_MESSAGE   @"message"
#define TOPIC_ID        @"topicid"
#define TOPIC_DATELINE  @"dateline"
#define TOPIC_ENDTIME   @"endtime"
/**
 【参数】
 do:              home
 uid:              用户id
 perpage: 分页大小， 默认10
 page:       当前页
 【调用方式】
 http://www.familyday.com.cn/dapi/space.php?do=home&uid=1
 【返回值】
 1）多维数组：
 avatar:               发布用户头像url
 name:               用户昵称
 note :               关系备注
 dateline:               动态时间
 id:                      动态id
 idtype:               动态类型(
 eventid:                      发布活动
 reeventid：      转采活动
 eventcomment：   活动评论
 blogid:                      发布更新日志
 reblogid：       转采日志
 blogcomment：    日志评论
 photoid：        上传图片
 photocomment：    评论图片
 rephotoid：      转采图片
 videoid：         发布视频
 revideoid：      转采视频
 videocomment：   视频评论
 profield:                      更新资料
 avatar:                       更新头像
 )
 2）转采
 fuid                                   原作者uid
 fname                            原作者名称
 3) 普通动态
 title:                             动态标题
 image_1 – image_4:        动态带的图片和内容附图的数量, 如果有图片则有值，否则为空值
 message:                            动态简介文字
 id:                                   原文id
 fuid:                                   原文所属于的空间id
 fname:                            原文所属于的空间名称
 4） 活动动态
 lng:                                   活动地点的经度
 lat:                                   活动地点的纬度
 location:                            活动地点的地名
 5） 行为动态
 uid:                                   行为人uid
 name:                            行为人名字
 fuid:                                   对象人uid
 fname:                            对象人名字
 ？？：            被操作的对象名称
 id：                                   被操作的id
 idtype：                            被操作的类型
 6) 发布渠道
 come:                             发布的渠道
 7） 最新的两条评论
 comment：          数组
 authorid：      评论人的uid
 authorname:              评论人的名字
 message：      评论内容
 dateline：      评论时间
 **/
#define FEEDID              @"feedid"
#define FEED_AVATAR         @"avatar"
#define FEED_NAME           @"name"
#define FEED_NOTE           @"note"
#define FEED_DATELINE       @"dateline"
#define FEED_ID             @"id"
#define FEED_COMMENT_ID     @"feedcommentid"
#define INDEX_ROW           @"indexRow"
#define FEED_ID_TYPE        @"idtype"
#define FEED_EVENT_ID       @"eventid"
#define FEED_RE_EVENT_ID    @"reeventid"
#define FEED_BLOG_ID        @"blogid"
#define FEED_RE_BLOG_ID     @"reblogid"
#define FEED_BLOG_COMMENT   @"blogcomment"
#define FEED_PHOTO_ID       @"photoid"
#define FEED_PHOTO_COMMENT  @"photocomment"
#define FEED_RE_PHOTO_ID    @"rephotoid"
#define FEED_VIDEO_ID       @"videoid"
#define FEED_RE_VIDEO_ID    @"revideoid"
#define FEED_VIDEO_COMMENT  @"videocomment"
#define FEED_PROFIELD       @"profield"
#define FEED_IMAGE_1        @"image_1"
#define FEED_IMAGE_2        @"image_2"
#define FEED_IMAGE_3        @"image_3"
#define FEED_IMAGE_4        @"image_4"
#define COMMENT             @"comment"
#define DATA_DICT           @"datadict"

#define PIC_NUM             @"picnum"

#define CONTENT             @"content"
#define IMAGE_SIZE          @"imagesize"
#define PIC_LIST            @"piclist"
#define FILE_NAME           @"filename"
#define WIDTH               @"width"
#define HEIGHT              @"height"
//
#define FEED_RE_ID          @"fuid"
#define FEED_RE_NAME        @"fname"

#define FEED_RE_EVENT_NUM   @"reeventnum"
#define FEED_REBLOG_NUM     @"reblognum"
#define FEED_REPLY_NUM      @"replynum"
#define FEED_LOVE_NUM       @"love"
//
#define FEED_EVENT_TITLE    @"title"
#define FEED_EVENT_DETAIL   @"detail"
#define FEED_EVENT_DATELINE @"dateline"
#define FEED_EVENT_LOG      @"lng"
#define FEED_EVENT_LAT      @"lat"
#define FEED_EVENT_LOCATION @"location"
//
#define FEED_TOGETHER       @"together"
#define FEED_TOGETHER_UID   @"uid"
#define FEED_TOGETHER_NAME  @"name"
#define FEED_TOGETHER_AVATAR  @"avatar"
#define FEED_TOGETHER_MESSAGE  @"message"
//
#define FEED_COME           @"come"

#define FEED_NUM            @"feednum"
#define FEED_LIST           @"feedlist"
#define EVENT_DETAIL        @"eventdetail"
#define POSTER              @"poster"
#define CREDIT              @"credit"


#define kFirstPhotoY    30
#define kPhotoSnap      15
#define kPhotoX         15
#define kPhotoHeight    200
#define KPhotoWidth     290

/**
 【参数】
 do:              comment
 id:              被评论的对象id
 idtype:       被评论的类型(photoid: 照片,  'eventid': 活动, 'blogid'：日志, 'videoid'：视频)
 page:       当前页，默认1
 perpage:       每页数量，默认10
 【调用方式】
 http://www.familyday.com.cn/dapi/space.php?do=comment&id=293&idtype=photoid
 【返回值】
 authored:              评论用户uid、
 avatar:              头像url
 authorname:       评论用户名
 note:                     关系备注
 message:              评论内容
 dateline:              评论时间
 lng:                     经度
 lat:                     纬度
 address:              地名
 come:              发布来源
 **/
#define COMMENT_AUTHOR      @"authored"
#define COMMENT_AVATAR      @"avatar"
#define COMMENT_AUTHOR_ID   @"authorid"
#define COMMENT_AUTHOR_NAME @"authorname"
#define COMMENT_NOTE        @"note"
#define COMMENT_MESSAGE     @"message"
#define COMMENT_DATELINE    @"dateline"
#define COMMENT_ADDRESS     @"address"
#define COMMENT_COME        @"come"
/**
 【参数】
 uid:         自己的uid
 page:       家庭成员的当前页，默认1
 perpage:       家庭成员的分页数, 默认10
 【调用方式】
 http://www.familyday.com.cn/dapi/space.php?uid=1
 【返回值】
 1）
 uid:                     用户id
 name:              用户名字
 avatar:              用户头像url
 fmembers:       家人数量
 feeds:              动态数量
 birthday：   生日
 2）家人列表
 fmemberlist：   家人列表数组
 uid:              家人uid
 name:       家人名字
 avatar:       家人头像
 note：       关系备注
 3) 空间列表
 spacelist:              数组
 uid:              空间id
 name:       空间名称
 avatar:       空间头像
 latestpic:       空间最新一张图片
 blogs:       空间日志数
 photos:       空间照片数
 events:       空间活动数
 videos:       空间视频数
 **/
#define PESONAL_FMEMBER @"fmemberlist"
#define PESONAL_UID     @"uid"
#define PESONAL_NAME    @"name"
#define PESONAL_AVATAR  @"avatar"
#define PESONAL_MEMBER_NUM  @"fmembers"
#define PESONAL_FEED_NUM    @"feeds"
#define PESONAL_BIRTHDAY    @"birthday"
#define PESONAL_NOTE    @"note"
#define PESONAL_SPACE_LIST    @"spacelist"
#define PESONAL_LAST_PIC    @"latestpic"
#define PESONAL_BLOGS   @"blogs"
#define PESONAL_PHOTOS  @"photos"
#define PESONAL_EVENTS  @"events"
#define PESONAL_VIDEOS  @"videos"
/*
 【参数】
 uid:			用户id
 page:		当前页, 默认1
 perpage:		分页大小，默认10
 【调用方式】
 http://www.familyday.com.cn/dapi/space.php?do=notice&uid=4
 【返回值】
 1）
 authorid:			通知的用户uid
 authouravatar:		头像url
 authourname:		name
 note:				通知详情
 2）	通知详情内如果包含其他用户的话
 fuid:				其他用户uid
 fname:			name
 3）	通知详情内如果包含某个帖子
 fid:				其它帖子的id
 ftitle:			其他帖子的标题
 4）	通知的阅读状况
 new:				0已读, 1未读
 */

#define NOTICE_AUTHOR_ID        @"authorid"
#define NOTICE_AUTHOR_AVATAR    @"authoravatar"
#define NOTICE_AUTHOR_NAME      @"authorname"
#define NOTICE_AUTHOR_NOTE      @"note"
#define NOTICE_OTHER_UID        @"fuid"
#define NOTICE_OTHER_NAME       @"fname"
#define NOTICE_OTHER_FID        @"fid"
#define NOTICE_OTHER_FTITLE     @"ftitle"
#define NOTICE_IS_NEW           @"new"
#define NOTE_SPLIT              @"notesplit"

#define TYPE_ADD_PHOTO       @"addphoto"     //添加照片
#define TYPE_ADD_BLOG        @"addblog"      //添加日志
#define TYPE_ADD_VIDEO       @"addvideo"     //添加视频
#define TYPE_ADD_EVENT       @"addevent"     //添加活动
#define TYPE_BLOG_COMMENT    @"blogcomment"  //日志评论
#define TYPE_VIDEO_COMMENT   @"videocomment" //视频评论
#define TYPE_PHOTO_COMMENT   @"photocomment" //照片评论
#define TYPE_EVENT_COMMENT   @"eventcomment" //活动评论
#define TYPE_ADD_FRIEND      @"friend"    //成为家人

#define TYPE            @"type"
#define F_UID           @"fuid"
#define F_NAME          @"fname"
#define F_ID            @"fid"
#define F_TITLE         @"ftitle"

#define VIDEO_URL       @"videourl"
/*
 【参数】
 uid:		用户id
 【调用方式】
 http://www.familyday.com.cn/dapi/space.php?do=fmembers&uid=1
 【返回值】
 uid:			自己的用户id
 name:		自己的昵称
 avatar:		自己的头像
 fmembers：	自己的家人数量
 fmemberlist：	家人列表【数组】
 uid			家人的用户id
 name		家人的昵称
 avatar：		家人的头像
 note:			家人关系备注
 feeds:		家人动态数量
 fmembers：	家人的家人数量
 birthday：	家人的生日
 tags：      家人的空间数量
 */
#define FAMILY_MEMBERS  @"fmembers"
#define FAMILY_LIST     @"fmemberlist"
#define FAMILY_FEEDS    @"feeds"
#define FAMILY_NOTE     @"note"
#define FAMILY_TAGS     @"tags"
#define LAST_LOGIN      @"lastlogin"
/**
 【参数】
 uid:  	自己的uid
 page:	家庭成员的当前页，默认1
 perpage:	家庭成员的分页数, 默认10
 【调用方式】
 http://www.familyday.com.cn/dapi/space.php?uid=1
 【返回值】
 1）
 uid:			用户id
 name:		用户名字
 avatar:		用户头像url
 fmembers:	家人数量
 feeds:		动态数量
 birthday：	生日
 2）家人列表
 fmemberlist：	家人列表数组
 uid:		家人uid
 name:	家人名字
 avatar:	家人头像
 note：	关系备注
 3) 空间列表
 spacelist:		数组
 uid:		空间id
 name:	空间名称
 avatar:	空间头像
 latestpic:	空间最新一张图片
 blogs:	空间日志数
 photos:	空间照片数
 events:	空间活动数
 videos:	空间视频数
 **/
#define SPACE_LIST  @"spacelist"
#define TAG         @"tag"
#define TAG_S       @"tags"
#define TAG_ID      @"tagid"
#define TAG_LIST    @"taglist"
#define TAG_NAME    @"tagname"
#define LATEST_PIC  @"pic"
#define PIC         @"pic"
#define BLOG_NUM    @"blognum"
#define BLOG_ID     @"blogid"
#define PHOTO_NUM   @"photonum"
#define PHOTO_ID	@"photoid"
#define EVENT_NUM   @"eventnum"
#define EVENT_ID    @"eventid"
#define VIDEO_NUM   @"videonum"
#define VIDEO_ID    @"videoid"
#define FRIEND_LIST @"friendlist"
#define JOIN_TYPE   @"jointype"

/*
 1．11、	对话列表接口
 【参数】
 uid:		用户id
 page:	当前页, 默认1
 perpage:	分页大小，默认10
 【调用方式】
 http://www.familyday.com.cn/dapi/space.php?do=pm&filter=privatepm&uid=1
 【返回值】
 data:		数组
 msgfromid:			对话对方用户uid
 msgfromname:		对话对方name
 msgfromavatar:		对方对方的头像url
 note:					备注名
 lastdateline:			最后对话的时间
 lastsummary:			最后对话的内容
 lng:					最后对话纬度
 lat:					最后对话经度
 address:				最后对话地点
 come:				最后对话发布来源
 new:					这个对话中有几个未读消息的数量
 */
#define DIALOG          @"dialog"
#define PM_ID           @"pmid"

#define PM_FROM_USER    @"fromuser"
#define PM_FROM_UID     @"msgfromid"
#define PM_FROM_NAME    @"msgfromname"
#define PM_FROM_AVATAR  @"msgfromavatar"

#define PM_TO_USER      @"touser"
#define PM_TO_UID       @"touid"
#define PM_TO_NAME      @"msgtoname"
#define PM_TO_AVATAR    @"msgtoavatar"

#define LAST_DATE_LINE  @"lastdateline"
#define LAST_SUMMARY    @"lastsummary"
#define MESSAGE         @"message"

#define MULTI_TYPE_TEXT     @"multiTypeText"

#define LAST_MSG_TIME   @"lastmsgtime"
#define START_TIME      @"starttime"
#define CLASS_ID        @"classid"
#define DETAIL          @"detail"
#define EVENT_START_TIME    @"eventstarttime"
/*
 1．18、	家人申请接口
 【参数】
 uid:			用户id
 【调用方式】
 http://www.familyday.com.cn/dapi/cp.php?ac=friend&op=request
 【返回值】
 uid:			自己的用户id
 name:		自己的昵称
 avatar:		自己的头像
 fmembers：	自己的家人数量
 requestlist:	申请人列表【数组】
 uid:			用户id
 phone:		电话号码
 name:		用户昵称
 avatar:		用户头像
 dateline:		申请时间
 */
#define REQUEST_LIST @"requestlist"


//表态id
//照片
#define CLICK_PHOTO_FUN         @"6"//开心
#define CLICK_PHOTO_GOOD        @"7"//赞
#define CLICK_PHOTO_CRY         @"32"//伤心
#define CLICK_PHOTO_SMILE       @"9"//微笑
#define CLICK_PHOTO_SUR         @"10"//惊讶

//日志
#define CLICK_BLOG_FUN          @"1"//开心
#define CLICK_BLOG_GOOD         @"2"//赞
#define CLICK_BLOG_CRY          @"29"//伤心
#define CLICK_BLOG_SMILE        @"4"//微笑
#define CLICK_BLOG_SUR          @"5"//惊讶

//活动
#define CLICK_EVENT_FUN         @"11"//开心
#define CLICK_EVENT_GOOD        @"12"//赞
#define CLICK_EVENT_CRY         @"13"//伤心
#define CLICK_EVENT_SMILE       @"14"//微笑
#define CLICK_EVENT_SUR         @"15"//惊讶

//视频
#define CLICK_VIDEO_FUN         @"16"//开心
#define CLICK_VIDEO_GOOD        @"17"//赞
#define CLICK_VIDEO_CRY         @"33"//伤心
#define CLICK_VIDEO_SMILE       @"19"//微笑
#define CLICK_VIDEO_SUR         @"20"//惊讶


#endif
