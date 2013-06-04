package com.ze.model;

import java.io.Serializable;
import java.util.ArrayList;

import org.json.JSONArray;

import android.graphics.drawable.Drawable;

public class VideoModel extends DataModel implements Serializable {
//	public String 			id;
	// 发布人
	public String 		name;
	// time
	public String 		time;
	// topic
	public String 		tagname;
	public String 		tagid;

	// activity detail
		public String 		subject;
		public String 		topic;
		public String 		pic;
		public String 		url;
	public VideoModel() {
		// TODO Auto-generated constructor stub
//		photos = new JSONArray();
	}
}
