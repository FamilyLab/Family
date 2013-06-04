package com.ze.model;

import java.io.Serializable;
import java.util.ArrayList;

import org.json.JSONArray;

import android.graphics.drawable.Drawable;

public class BlogModel extends DataModel implements Serializable {
//	public String 			id;
	// 发布人
	public String 		name;
	// time
	public String 		time;
	// topic
	public String 		tagname;
	public String 		tagid;
	//	html
	public String 		html;
	// say
	public String 		say;
	
	public BlogModel() {
		// TODO Auto-generated constructor stub
//		photos = new JSONArray();
	}
}
