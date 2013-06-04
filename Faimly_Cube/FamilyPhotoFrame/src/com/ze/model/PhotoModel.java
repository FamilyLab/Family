package com.ze.model;

import java.io.Serializable;
import java.sql.Struct;
import java.util.ArrayList;

import org.json.JSONArray;

import android.graphics.drawable.Drawable;

public class PhotoModel extends DataModel implements Serializable {
	// photo动态的唯一标识
//	public String 			id;
	// 发布人
	public String 		name;
	// time
	public String 		time;
	// topic
	public String 		tagname;
	public String 		tagid;
	//	image
	public ArrayList<PicInfo> 		photos;
	// say
	public String 		say;
	public int 			height;
	public int 			width;
	
	public PhotoModel() {
		// TODO Auto-generated constructor stub
		photos = new ArrayList<PicInfo>();
	}
	public static  class  PicInfo implements Serializable
	{
		public 	int 			height;
		public 	int 			width;
		public String 		url;
	}
}
