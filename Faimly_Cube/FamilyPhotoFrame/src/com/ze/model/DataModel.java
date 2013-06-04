package com.ze.model;

import java.io.Serializable;

public class DataModel  implements Serializable {
	// 唯一标识
	public String id;
	// 所属用户
		public String uid;
	// 类型标识 or 错误信息
	public String type;
	// 是否收藏
	public int 		love;
	// 转载自谁
	public String fromName;
	// 转载人的id
	public String fromUid;
}
