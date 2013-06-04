//
//  Defines.h
//  family_ver_pm
//
//  Created by pandara on 13-3-18.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#ifndef family_ver_pm_Defines_h
#define family_ver_pm_Defines_h

#define DEVICE_BOUNDS [[UIScreen mainScreen] applicationFrame]
#define DEVICE_SIZE [[UIScreen mainScreen] applicationFrame].size
#define KEYBOARD_HEIGHT 216
#define TEXTFIELD_ORIGIN_IN_ALERTVIEW CGPointMake(20, 40)
#define TEXTFIELD_WIDTH_IN_ALERVIEW 245
#define BOOT_PAGE_COUNT 3

//file type
#define PNG @"png"

//color
#define CLEAR_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0]
#define WHITE_COLOR [UIColor whiteColor]

//main page
#define MAIN_PAGE_HEAD_SIZE CGSizeMake(320, 120)
#define MAIN_CELL_SIZE CGSizeMake(300, 60)
#define MAIN_CELL_ID @"mainCell"
#define MAIN_CELL_COUNT 9

#define PICTUREVIEW_CONTROLLER 0
#define DAILYVIEW_CONTROLLER 1
#define ACTIVITYVIEW_CONTROLLER 2
#define VEDIOVIEW_CONTROLLER 3
#define SPACEVIEW_CONTROLLER 4

//title bar
#define TITLE_TEXT_MAX_WIDTH 230
#define TITLE_FONT_SIZE 31
#define TITLE_DEFAULT_TEXT @"无标题"
#define TITLE_LABEL_PADDING 10

//user default
#define AUTO_LOGIN @"auto_login"

//function
#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//base control
#define PREV_BTN_SIZE CGSizeMake(25, 75)
#define NEXT_BTN_SIZE CGSizeMake(25, 75)
#define BOTTOM_BAR_SIZE CGSizeMake(320, 45)

#define TITLE_BAR_DEFAULT_SIZE CGSizeMake(320, 75)
#define TITLE_BAR_DEFAULT_ORIGIN CGPointMake(0, 40)
#define TITLELABLE_ORIGIN CGPointMake(10, 40)
#define TITLELABLE_DEFAULT_SIZE CGSizeMake(136, 35)

#define MODULE_TITLE_BAR_SIZE CGSizeMake(320, 50)
#define MODULE_BOTTOM_BAR_SIZE CGSizeMake(320, 45)
#define LOADING_ANIMATION_DUR 0.5f
#define LOADING_ANIMATION_COUNT 5
#define END_LOADING_ANIMATION_DUR 1

#define TABLE_HEADER_BACKCOLOR [UIColor whiteColor]
#define TABLE_FOOTER_BACKCOLOR [UIColor whiteColor]

#define PICKER_VIEW_SIZE CGSizeMake(320, 216)

#define ALERTVIEW_SCROLLVIEW_SIZE_WIDTH 262

//boot view
#define BOOT_VIEW_BUTTON_ORIGIN CGPointMake(182, 33)
#define BOOT_VIEW_BUTTON_SIZE CGSizeMake(110, 32)
#define BOOT_VIEW_BUTTON_FRAME CGRectMake(BOOT_VIEW_BUTTON_ORIGIN.x, BOOT_VIEW_BUTTON_ORIGIN.y, BOOT_VIEW_BUTTON_SIZE.width, BOOT_VIEW_BUTTON_SIZE.height)

//天气view
#define WEATHER_VIEW_ORIGIN CGPointMake(205, 0)
#define WEATHER_VIEW_SIZE CGSizeMake(115, 119)
#define WEATHER_SUGGESTION_VIEW_SIZE CGSizeMake(300, 400)

//picture view
#define PICTUREVIEWTABLECELL_ID @"pictureViewTableCell"
#define PICTUREVIEW_PLACEHOLDER_IMG [UIImage imageNamed:@"pic_default.png"]

#define PICTURE_VIEW_DEFAULT_CONTENTSIZE CGSizeMake(320, TITLE_BAR_DEFAULT_SIZE.height + PICTURE_VIEW_IMAGE_INTERVAL + PICTURE_VIEW_DEFAULT_IMAGE_SIZE.height + PICTURE_VIEW_IMAGE_INTERVAL + PICTURE_VIEW_CONTENT_DEFAULT_SIZE.height + PICTURE_VIEW_IMAGE_INTERVAL + COMMENT_VIEW_DEFAULT_FRAME.size.height + BOTTOM_BAR_SIZE.height)

#define PICTURE_VIEW_DEFAULT_IMAGE_SIZE CGSizeMake(DEVICE_SIZE.width, 225)
#define PICTURE_VIEW_DEFAULT_IMAGE_ORIGIN CGPointMake(0, TITLE_BAR_DEFAULT_SIZE.height)
#define PICTURE_VIEW_IMAGE_INTERVAL 10.0f
#define ENLARGE_VIEW_BOTTOM_VIEW_SIZE CGSizeMake(320, 45)

#define PICTURE_VIEW_DEFAULT_LASTIMAGEFRAME CGRectMake(PICTURE_VIEW_DEFAULT_IMAGE_ORIGIN.x, PICTURE_VIEW_DEFAULT_IMAGE_ORIGIN.y, PICTURE_VIEW_DEFAULT_IMAGE_SIZE.width, PICTURE_VIEW_DEFAULT_IMAGE_SIZE.height)
//content
#define PICTURE_VIEW_CONTENT_DEFAULT_ORIGIN CGPointMake(10, PICTURE_VIEW_DEFAULT_LASTIMAGEFRAME.origin.y + PICTURE_VIEW_DEFAULT_LASTIMAGEFRAME.size.height + PICTURE_VIEW_IMAGE_INTERVAL)
#define PICTURE_VIEW_CONTENT_DEFAULT_SIZE CGSizeMake(DEVICE_SIZE.width - 20, 20)
#define PICTURE_VIEW_CONTENT_FONT_SIZE 18
#define PICTURE_VIEW_CONTENT_EMPTY_TEXT @"无内容"

//daily view
#define DAILY_VIEW_DEFAULT_WEBVIEW_SIZE CGSizeMake(DEVICE_SIZE.width, DEVICE_SIZE.height - TITLE_BAR_DEFAULT_SIZE.height - COMMENT_VIEW_DEFAULT_FRAME.size.height)
#define DAILY_VIEW_DEFAULT_CONTENT_SIZE CGSizeMake(DEVICE_SIZE.width, TITLE_BAR_DEFAULT_SIZE.height + COMMENT_VIEW_DEFAULT_FRAME.size.height + DAILY_VIEW_DEFAULT_WEBVIEW_SIZE.height + BOTTOM_BAR_SIZE.height);

//event view
#define EVENT_TIME @"时间"
#define EVENT_LOCATION @"地点"
#define EVENT_INTRODUCE @"介绍"
#define EVENT_PROPERTY_INTERVAL 10.0f
#define EVENT_MAP_ORIGN CGPointMake(10, 225)
#define EVENT_MAP_SIZE CGSizeMake(300, 120)
#define EVENT_VIEW_DEFAULT_PRO_ORIGN CGPointMake(10, 0)
#define EVENT_VIEW_DEFAULT_PRO_SIZE CGSizeMake(DEVICE_SIZE.width - 20, EVENT_VIEW_DEFAULT_FONT_SIZE)
#define EVENT_VIEW_DEFAULT_FONT_SIZE 22
#define EVENT_VIEW_DEFAULT_FONT [UIFont systemFontOfSize:EVENT_VIEW_DEFAULT_FONT_SIZE]

//space view
#define SPACE_CELL_SIZE CGSizeMake(320, 120)
#define SPACE_VIEW_SPACEICON_PLACEHOLDER [UIImage imageNamed:@"zonedefault.jpg"]
#define SPACE_VIEW_TABLE_ROWHIGHT 120

//login view
#define LOGIN_BOTTOMBAR_SIZE CGSizeMake(320, 45)

//register view
#define REGISTER_BOTTOMBAR_SIZE CGSizeMake(320, 45)

//comment view
#define COMMENT_VIEW_SIZE CGSizeMake(320, 300)
#define COMMENT_VIEW_DEFAULT_FRAME CGRectMake(0, DEVICE_SIZE.height - COMMENT_VIEW_SIZE.height, COMMENT_VIEW_SIZE.width, COMMENT_VIEW_SIZE.height)
#define COMMENT_NOTHING @"赶紧来给家人评论一下吧~"
#define COMMENT_LOADING @"正在努力加载评论……"
#define COMMENT_FONT_SIZE 20
#define COMMENT_FONT [UIFont boldSystemFontOfSize:COMMENT_FONT_SIZE]
#define COMMENT_DEFAULT_ORIGIN CGPointMake(10, 50)
#define COMMENT_DEFAULT_SIZE CGSizeMake(300, 22)
#define COMMENT_TEXT_COLOR [UIColor whiteColor]
#define COMMENT_INTERVAL 10
#define COMMENT_VIEW_LOAD_MORE_BUTTON_SIZE CGSizeMake(130, 50)
#define COMMENT_VIEW_TITLE_COMMENT @"评论"
#define COMMENT_VIEW_TITLE_JOIN @"参加"

//repost view
#define REPOST_VIEW_ZONE_BUTTON_ORIGIN CGPointMake(10, 243)
#define REPOST_VIEW_ZONE_BUTTON_SIZE CGSizeMake(300, 56)
#define REPOST_VIEW_PICKER_ROW_HEIGHT 50.0f
#define REPOST_VIEW_PICKER_COM_WIDTH 290.0f

//PickerViewWithToolBar
#define MYPICKER_SIZE CGSizeMake(320, 260)

//keychain
#define KEY_USERNAME @"username"
#define KEY_PASSWORD @"password"
#define KEY_ISCOOKIE @"iscookie"
#define KEY_AUTH @"m_auth"

//urls
#define BASE_URL @"http://www.familyday.com.cn"
#define AC @"ac"
#define DO @"do"
#define ERROR @"error"
#define DATA @"data"
#define PAGE @"page"
#define PERPAGE @"perpage"
#define PERPAGE_COUNT 5
#define ID @"id"
#define UID @"uid"
#define FNAME @"fname"
#define NAME @"name"
#define DATELINE @"dateline"
#define MESSAGE @"message"
#define LOVE_USER @"loveuser"
#define MSG @"msg"
#define API_FAIL_MSG @"网络不好。。"
#define MYLOVE @"mylove"

//登陆接口
#define COMMON_LOGIN_API @"/dapi/do.php?"
#define USERNAME @"username"
#define PASSWORD @"password"
#define ISCOOKIE @"iscookie"
#define LOGIN @"login"
#define M_AUTH @"m_auth"

//m_auth验证接口
#define AUTH_VERIFY_API @"/dapi/do.php?"
#define CKMAUTH @"ckmauth"
#define RETURN @"return"

//pm版本统计接口
#define FEED_COUNT_API @"/dapi/space.php?"
#define ELDER @"elder"
#define ADDVIDEO @"addvideo"
#define ADDEVENT @"addevent"
#define ADDBLOG @"addblog"
#define ADDPHOTO @"addphoto"
#define PMCOUNT @"pmcount"
#define APPLYCOUNT @"applycount"
#define NOTECOUNT @"notecount"

//pm版本动态列表接口
#define PM_FEED_API @"/dapi/space.php?"
#define PMFEED @"pmfeed"
#define IDTYPE @"idtype"
#define EVENTID @"eventid"
#define REEVENTID @"reeventid"
#define EVENTCOMMENT @"eventcomment"
#define BLOGID @"blogid"
#define REBLOGID @"reblogid"
#define BLOGCOMMENT @"blogcomment"
#define PHOTOID @"photoid"
#define PHOTOCOMMENT @"photocomment"
#define REPHOTOID @"rephotoid"
#define VIDEOID @"videoid"
#define REVIDEOID @"revideoid"
#define VIDEOCOMMENT @"videocomment"
#define PROFIELD @"profield"
#define PHOTO_FEED_PERPAGE_COUNT PERPAGE_COUNT
#define VIDEO_FEED_PERPAGE_COUNT PERPAGE_COUNT

//照片详情接口
#define PHOTO @"photo"
#define PHOTO_DETAIL_API @"/dapi/space.php?"
#define PICLIST @"piclist"
#define FILEPATH @"filepath"
#define PIC @"pic"
#define SUBJECT @"subject"

//日志详情接口
#define BLOG @"blog"
#define BLOG_DETAIL_API @"/dapi/space.php?"

//视频详情接口
#define VIDEO @"video"
#define VIDEO_DETAIL_API @"/dapi/space.php?"

//活动详情接口
#define EVENT @"event"
#define EVENT_DETAIL_API @"/dapi/space.php?"
#define TITLE @"title"
#define LOCATION @"location"
#define DETAIL @"detail"
#define STARTTIME @"starttime"
#define EVENT_FEED_PERPAGE_COUNT PERPAGE_COUNT

//评论列表接口
#define COMMENT_LIST_API @"/dapi/space.php?do=comment"
#define AUTHORNAME @"authorname"

//个人空间接口
#define SPACE_LIST_API @"/dapi/space.php?"
#define SPACELIST @"spacelist"
#define SPACE_LIST_PERPAGE_COUNT PERPAGE_COUNT
#define TAGNAME @"tagname"
#define TAGID @"tagid"
#define PIC @"pic"

//帖子收藏接口
#define MY_LIKE_API @"/dapi/space.php?"
#define LOVEFEEDPM @"lovefeedpm"

//空间详情简化接口
#define SPACE_DETAIL_API @"/dapi/space.php?"
#define FAMILYSPACESIMPLE @"familyspacesimple"
#define FEEDLIST @"feedlist"

//评论提交接口
#define COMMENT_POST_API @"/dapi/do.php?ac=comment"

//收藏接口
#define LIKE_API @"/dapi/do.php?ac=feedlove"
#define TYPE @"type"

//个人空间名称列表接口
#define TAG_NAME_LIST_API @"/dapi/do.php?ac=ajax&op=taglist"
#define TAGLIST @"taglist"
#define TAGNAME @"tagname"

//转发接口
#define REPOST_API @"/dapi/cp.php?"
#define AC @"ac"
#define TAGS @"tags"
#define MAKEFEED @"makefeed"
#define FRIEND @"friend"
#define REPHOTO @"rephoto"
#define REBLOG @"reblog"
#define REEVENT @"reevent"
#define REVIDEO @"revideo"
#define PHOTOSUBMIT @"photosubmit"
#define BLOGSUBMIT @"blogsubmit"
#define EVENTSUBMIT @"eventsubmit"
#define VIDEOSUBMIT @"videosubmit"

//天气接口
#define DATE @"date_y"
#define WEATHER_API @"http://m.weather.com.cn/data/"
#define WEATHERINFO @"weatherinfo"
#define IMG_TITLE_A @"img_title1"
#define IMG_TITLE_B @"img_title2"
#define SUGGESTION @"index_d"
#define TEMP @"temp1"
#define DAXUE @"大雪"
#define DAYU @"大雨"
#define DUOYUN @"多云"
#define LEIZHENYU @"雷阵雨"
#define QING @"晴"
#define XIAOXUE @"小雪"
#define XIAOYU @"小雨"
#define YIN @"阴"
#define YUJIAXUE @"雨夹雪"
#define GUANGZHOU_CODE @"101280101"
#define WEATHER @"weather1"

//百度地图逆地址解释接口
#define GEOCODER_API @"http://api.map.baidu.com/geocoder?"
#define STATUS @"status"
#define OK @"OK"
#define RESULT @"result"
#define LOCATION @"location"
#define LNG @"lng"
#define LAT @"lat"
#define ADDRESSCOMPONENT @"addressComponent"
#define CITY @"city"
#define KEY @"key"
#define BAIDU_KEY @"9A85CDC767A4CA2D4B1D2D42BE9A600ADCDAB48A"
#define OUTPUT @"output"
#define OUTPUT_JSON @"json"
#define COORD_TYPE @"coord_type"
#define COORD_TYPE_GPS @"wgs84"
#define CITYCODE @"cityCode"

//通知 NSNotificationCenter
#define NOTIFI_REFRESH_COMMENT @"refreshComment"
#define NOTIFI_REPOST_IAMGE @"repostimage"
#define NOTIFI_POP_TO_MAINVIEW @"poptomainview"
#define NOTIFI_POP_TO_DAILOGLIST @"poptodialoglist"
#define NOTIFI_POP_TO_MYSETTINGVIEW @"poptomysettingview"
#define NOTIFI_POP_FROM_SHOWMAPVIEW @"popfromshowmapview"
#define NOTIFI_DID_SCROLLTOFIRST @"didscrolltofirst"

#define NOTIFI_REQUEST_FAMILYAPPLY_COUNT @"requestfamilyapplycount"
#define NOTIFI_RETURN_FAMILYAPPLY_COUNT @"returnfamilyapplycount"

//注册接口
#define SECCODE @"seccode"

//funciton
#define POST_NOTI(__NOTI__)   [[NSNotificationCenter defaultCenter] postNotificationName:__NOTI__ object:self]

#endif
