package com.ze.commontool;

import java.util.HashMap;

public class PublicInfo {
	public static final int 					PER_LOAD = 25;
	public static final int 					FIRST_LOAD = 10;
	public static final int 					REFRESH_TIME = 30 * 60 ;  // 30分钟刷新一次
	public static final int 					LOAD_IMG_TIME = 20 ;  // 20秒钟加载时间
	public static final int 					PHOTO_CACHE_MAXCOUNT = 1000 ;  // 缓存1000张图片
	public static final int 					PHOTO_DETAIL_MAXCOUNT = 2000 ;  // 缓存2000个详情
	
	public static final String 				SPACE_PAGE_PIC = "220X220";
	public static final String 				PHOTO_SIZE_LARGE = "!320X480";
	public static final String 				PHOTO_SIZE_HALF = "!512";
	public static int 		SCREEN_W  = 480;
	public static int 		SCREEN_H	= 800;
	public static final String 				VIP_FLAG_P = "personal";
	public static final String 				VIP_FLAG_F = "family";
	public static final int 					INFOPIC_ABOUT = 0;
	public static final int 					INFOPIC_VIP = 1;
	public static final int 					INFOPIC_COIN = 2;
	
	
//	public static HashMap<String, String> cityCodeHashMap;
//	static {
//		cityCodeHashMap = new HashMap<String, String>();
//		cityCodeHashMap.put("北京", "101010100");
//		cityCodeHashMap.put("上海", "101010100");
//		cityCodeHashMap.put("广州", "101010100");
//		cityCodeHashMap.put("朝阳", "101010100");
//		cityCodeHashMap.put("海淀", "101010100");
//		cityCodeHashMap.put("杭州", "101010100");
//		cityCodeHashMap.put("重庆", "101010100");
//	}
}
