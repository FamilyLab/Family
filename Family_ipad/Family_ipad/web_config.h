//
//  web_config.h
//  Family
//
//  Created by Walter.Chan on 12-12-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Family_web_config_h
#define Family_web_config_h
#import "CKMacros.h"
#import "ConciseKit.h"
#import "PDKeychainBindings.h"
#define DEBUGMOD 0

#define COME_VERSION @"iPad"
#define BASE_URL    @"http://www.familyday.com.cn/dapi/"
#define SPACE_API   @"http://www.familyday.com.cn/dapi/space.php"
#define INFO_API    @"http://www.familyday.com.cn/dapi/info.php"
#define POST_API    @"http://www.familyday.com.cn/dapi/do.php?ac="
#define POST_CP_API @"http://www.familyday.com.cn/dapi/cp.php?ac="
#define DEVICE_SIZE [[UIScreen mainScreen] applicationFrame].size
#define emptystr(obj)  !obj ? @"" : (((NSNull *)(obj) == [NSNull null] ? @"" : (obj)))

#define GET_M_AUTH  [[[PDKeychainBindings sharedKeychainBindings] stringForKey:M_AUTH] urlencode]
#define POST_M_AUTH  [[PDKeychainBindings sharedKeychainBindings] stringForKey:M_AUTH]
#define SAVED_USERNAME  [[PDKeychainBindings sharedKeychainBindings] stringForKey:USER_NAME]
#define SAVED_PASSWORD  [[PDKeychainBindings sharedKeychainBindings] stringForKey:PASSWORD]
#define MY_DEVICE_TOKEN [[PDKeychainBindings sharedKeychainBindings] stringForKey:DEVICE_TOKEN]

#define MY_UID          [[NSUserDefaults standardUserDefaults] stringForKey:UID]
#define MY_HEAD_AVATAR_URL [[NSUserDefaults standardUserDefaults] stringForKey:AVATAR_URL]
#define MY_HEAD_AVATAR  [[NSUserDefaults standardUserDefaults] objectForKey:AVATAR]
#define MY_NAME         [[NSUserDefaults standardUserDefaults] stringForKey:NAME]
#define MY_LATITUDE     [[NSUserDefaults standardUserDefaults] objectForKey:LATITUDE]
#define MY_LONGITUDE    [[NSUserDefaults standardUserDefaults] objectForKey:LONGITUDE]
#define PUSH_SWITCH    [[NSUserDefaults standardUserDefaults] objectForKey:PUSH_MARK]
#define TOPIC_SWITCH    [[NSUserDefaults standardUserDefaults] objectForKey:TOPIC_MARK]
#define IS_FIRST_SHOW   [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_SHOW_MARK]
#define COUNT_DICT      [ConciseKit userDefaultsObjectForKey:ELDER_COUNT]
#define MY_HAS_LOGIN    [[NSUserDefaults standardUserDefaults] boolForKey:HAS_LOGIN]
#define MY_AUTO_LOGIN    [[NSUserDefaults standardUserDefaults] boolForKey:IS_COOKIE]

#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//米色的背景
#define bgColor() [UIColor colorWithRed:245/255.0f green:244/255.0f blue:239/255.0f alpha:1]
//浅黑色背景
#define mwbgColor() [UIColor colorWithRed:49/255.0f green:58/255.0f blue:63/255.0f alpha:1]

#define FIRST_SHOW_MARK @"firstshow"
#define DEVICE_TOKEN    @"deviceToken"
#define TOKEN           @"token"
#define AUTO_LOGIN      @"autoLogin"

//common
//more
#define DRAFT           @"DRAFT"

#define SMS_INVITE      @"smsinvite"
#define VIPSTATUS         @"vipstatus"
#define TITLE           @"title"
#define SUBJECT         @"subject"
#define SINA_UID    @"sina_uid"
#define SINA_TOKEN    @"sina_token"
#define LOST_PWD_SUBMIT     @"lostpwsubmit"
#define DELETE_SUBMIT       @"deletesubmit"
#define LOGIN_TYPE          @"logintype"
#define QQ_UID      @"is_qq_bind"
#define TOPIC_MARK @"topicmark"
#define PUSH_MARK @"pushmark"
#define COMMENT_HOLDER  @"随便说点啥"
#define ONE   @"1"
#define ZERO   @"0"
#define TWO     @"2"
#define THREE     @"3"
#define FOUR     @"4"
#define FIVE     @"5"
#define SIX     @"6"
#define SEVEN     @"7"
#define EIGHT     @"8"
#define NINE     @"9"
#define AVATAR_URL      @"avatarUrl"
#define FAVATAR     @"favatar"
#define HAS_LOGIN       @"hasLogin"
#define LATITUDE        @"latitude"
#define LONGITUDE       @"longitutde"
#define BOY     @"男"
#define GIRL    @"女"
#define FONT_SIZE 17.0f
#define TIME_FONT_SIZE 14.0f
#define UID @"uid"
#define LNG @"lng"
#define LAT @"lat"
#define PAGE @"page"
#define PER_PAGE @"perpage"
#define AVATER  @"avatar"
#define NAME @"name"
#define AC          @"ac"
#define BIRTHDAY @"birthday"
#define ACTION @"do"
#define ACTION_STR  @"action"
#define CITY        @"city"
#define NOTE     @"note"
#define DATELINE  @"dateline"
#define M_AUTH @"m_auth"
#define ADDRESS @"address"
#define COME @"come"
#define NEW @"new"
#define PHONE @"phone"
#define DATELINE @"dateline"
#define API_MSG @"msg"
#define IS_COOKIE  @"iscookie"
#define ASK_FOR_FAMILY_NUM  @"frequests"
#define MONEY       @"credit"
#define TASK_NUM    @"tasknum"
#define TAG @"tag"
#define BABY_NAME   @"babyname"
#define USER_NAME       @"username"
#define PASSWORD        @"password"
#define SECCODE         @"seccode"
#define VIDEO_URL       @"videourl"
#define LAST_LOGIN  @"lastlogin"
#define BABY_LIST   @"babylist"
#define NAME_SUBMIT     @"namesubmit"
#define AVATAR_SUBMIT   @"avatarsubmit"
#define BABY_SUBMIT        @"babysubmit"
#define ID_                 @"id"
#define IS_FAMILY   @"isfamily"
#define MAKE_WEIBO  @"makeweibo"
#define MAKE_QQ_WEIBO   @"makeqqweibo"
#define FRIENDS     @"friends"
#define FRIEND     @"friend"
#define SAY_SUBMIT         @"isaysubmit"
#define BLOG_SUBMIT         @"blogsubmit"
#define PHOTO_SUBMIT        @"photosubmit"
#define EVENT_SUBMIT        @"eventsubmit"
#define PM_SUBMIT           @"pmsubmit"
#define FRIENDS_SUBMIT      @"friendsubmit"
#define BIRTH @"birth"
#define BIRTH_SUBMIT    @"birthsubmit"
#define MAKE_FEED   @"makefeed"
#define OP      @"op"
#define PIC_TITLE   @"pic_title"
#define TO_PIC_ID   @"topicid"
#define CLASSID     @"classid"
#define PICIDS      @"picids"
#define PHOTO_ID	@"photoid"
#define PICID      @"picid"
#define TAGLIST     @"taglist"
#define FIRENDLIST @"friendlist"
#define APPLY_UID   @"applyuid"
#define AGGRE_SUBMIT    @"agreesubmit"
#define CLASS_ID        @"classid"
#define DETAIL          @"detail"
#define EVENT_START_TIME    @"eventstarttime"
#define EVENT_DETAIL        @"eventdetail"
#define OBJ         @"obj"
#define WITH_FRIENDS    @"withfriends"
#define NEW_USER        @"newuser"
#define PERSONAL        @"personal"
#define REWARD          @"reward"
#define SELFREWARD         @"selfreward"

#define THE_NEW_PWD1    @"newpasswd1"
#define THE_NEW_PWD2    @"newpasswd2"
#define RESET_SUBMIT        @"resetsubmit"
#define PWD_SUBMIT      @"pwdsubmit"

/**
 data:        下行接口中代表客户端真正需要的数据。
 msgkey: 代表服务器针对该次请求的信息提示key，客户端可以根据此信息自己再定义信息。
 msg:        代表服务器针对该次请求的辅助信息提示。
 error:        代表是否获取数据错误状态， 1 失败， 0成功。
 **/
#define WEB_DATA        @"data"
#define WEB_MSGKEY      @"msgkey"
#define WEB_MSG         @"msg"
#define WEB_ERROR       @"error"
#define REQUESTNUM      @"requestnum"
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
#define POSTER              @"poster"

/**
 http://www.familyday.com.cn/dapi/space.php?do=topic
 【返回值】
 subject:                     标题
 message:                     内容
 dateline:                     发布时间
 endtime：      结束时间
 **/

#define TOPIC_SUBJECT   @"subject"
#define TOPIC_MESSAGE   @"message"
#define TOPIC_DATELINE  @"dateline"
#define TOPIC_ENDTIME   @"endtime"
#define MONEY       @"credit"
#define TASK_ID     @"taskid"
#define TASK_LIST   @"tasklist"
#define TASK_NUM    @"tasknum"
#define IMAGE       @"image"

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
#define COMMENT_LIST        @"commentlist"
#define FILE_NAME           @"filename"
#define WIDTH               @"width"
#define HEIGHT              @"height"
#define PIC_LIST            @"piclist"
#define FILE_NAME           @"filename"
//
#define PIC_NUM             @"picnum"

#define FEED_RE_ID          @"fuid"
#define FEED_RE_NAME        @"fname"

#define FEED_RE_EVENT_NUM   @"reeventnum"
#define FEED_REBLOG_NUM     @"reblognum"
#define FEED_REPLY_NUM      @"replynum"
#define FEED_LOVE_NUM       @"love"
#define MY_LOVE     @"mylove"

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
#define PESONAL_AVATER  @"avatar"
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
#define SPACE_LIST  @"spacelist"
#define TAG_NAME    @"tagname"
#define TAG_ID      @"tagid"
#define TAGS        @"tags"
#define LATEST_PIC  @"pic"
#define PIC         @"pic"
#define BLOG_NUM    @"blognum"
#define PHOTO_NUM   @"photonum"
#define EVENT_NUM   @"eventnum"
#define VIDEO_NUM   @"videonum"
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
#define AUTHOR_ID   @"authorid"
#define NOTICE_AUTHOR_ID @"authorid"
#define NOTICE_AUTHOR_AVATAR @"authoravatar"
#define NOTICE_AUTHOR_NAME @"authorname"
#define NOTICE_AUTHOR_NOTE @"note"
#define NOTICE_OTHER_UID   @"fuid"
#define NOTICE_OTHER_NAME   @"fname"
#define NOTICE_OTHER_FID    @"fid"
#define NOTICE_OTHER_FTITLE @"ftitle"
#define NOTICE_IS_NEW       @"new"

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

#define NOTICE_AUTHOR_ID @"authorid"
#define NOTICE_AUTHOR_AVATAR @"authoravatar"
#define NOTICE_AUTHOR_NAME @"authorname"
#define NOTICE_AUTHOR_NOTE @"note"
#define NOTICE_OTHER_UID   @"fuid"
#define NOTICE_OTHER_NAME   @"fname"
#define NOTICE_OTHER_FID    @"fid"
#define NOTICE_OTHER_FTITLE @"ftitle"
#define NOTICE_IS_NEW       @"new"
#define NOTE_SPLIT              @"notesplit"

#define TYPE_ADD_PHOTO       @"addphoto"     //添加照片
#define TYPE_ADD_BLOG        @"addblog"      //添加日志
#define TYPE_ADD_VIDEO       @"addvideo"     //添加视频
#define TYPE_ADD_EVENT       @"addevent"     //添加活动
#define TYPE_BLOG_COMMENT    @"blogcomment"  //日志评论
#define TYPE_VIDEO_COMMENT   @"videocomment" //视频评论
#define TYPE_PHOTO_COMMENT   @"photocomment" //照片评论
#define TYPE_EVENT_COMMENT   @"eventcomment" //活动评论
#define TYPE_ADD_FRIEND      @"addfriend"    //成为家人
#define SINA_AUTH_DATA      @"SinaWeiboAuthData"

#define TYPE            @"type"
#define F_UID           @"fuid"
#define F_NAME          @"fname"
#define F_ID            @"fid"
#define F_TITLE         @"ftitle"
#define G_ID        @"gid"
#define ADD_SUBMIT      @"addsubmit"
#define TAG_SUBMIT  @"tagsubmit"

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

 */
#define FAMILY_MEMBERS  @"fmembers"
#define FAMILY_LIST     @"fmemberlist"
#define FAMILY_FEEDS    @"feeds"
#define FAMILY_NOTE     @"note"
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
#define SPACE_LIST @"spacelist"
#define LASTEST_PIC @"latestpic"
#define BLOGS       @"blogs"
#define PHOTOS      @"photos"
#define EVENTS      @"events"
#define VIDEOS      @"videos"
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
 address;				最后对话地点
 come:				最后对话发布来源
 new:					这个对话中有几个未读消息的数量
*/
#define DIALOG          @"dialog"
#define PM_FROM_USER    @"fromuser"
#define PM_FROM_UID     @"msgfromid"
#define PM_FROM_NAME    @"msgfromname"
#define PM_FROM_AVATAR  @"msgfromavatar"

#define PM_TO_USER      @"touser"
#define PM_TO_UID       @"touid"
#define PM_ID           @"pmid"
#define PM_TO_NAME      @"msgtoname"
#define PM_TO_AVATAR    @"msgtoavatar"

#define LAST_DATE_LINE  @"lastdateline"
#define LAST_SUMMARY    @"lastsummary"
#define MESSAGE         @"message"
#define START_TIME      @"starttime"
#define MULTI_TYPE_TEXT     @"multiTypeText"

#define LAST_MSG_TIME   @"lastmsgtime"
#define VIDEO_ID    @"videoid"

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
#define BLOG_ID     @"blogid"
#define EVENT_ID    @"eventid"
#define CLICK_ID        @"clickid"

//照片
#define REFRESH_FEED_LIST   @"refreshFeedList"
#define PM_COUNT    @"pmcount"
#define NOTE_COUNT  @"notecount"
#define APPLY_CONT  @"applycount"
#define ELDER_COUNT @"eldercount"
#define VOID_FEED_NOTIFICATION @"voidfeednotification"
#define LOVEUSER @"loveuser"
#endif
