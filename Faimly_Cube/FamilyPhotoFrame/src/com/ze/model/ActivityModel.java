package com.ze.model;

import java.io.Serializable;
import java.util.ArrayList;

import org.json.JSONArray;

import android.graphics.drawable.Drawable;

public class ActivityModel extends DataModel implements Serializable {
//	public String 			id;
	// 发布人
	public String 		name;
	// time
	public String 		time;
	// topic
	public String 		tagname;
	public String 		tagid;

	// activity detail
		public String 		detail;
		public String 		eventtime;
		public String 		place;
		public String 		introduce;
		public String 		lat;
		public String 		lng;
		// 海报
		public String 		poster;
	public ActivityModel() {
		// TODO Auto-generated constructor stub
//		photos = new JSONArray();
	}
}
