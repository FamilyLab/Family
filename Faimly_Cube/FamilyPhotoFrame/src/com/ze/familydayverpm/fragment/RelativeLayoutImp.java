package com.ze.familydayverpm.fragment;

import org.json.JSONObject;

public interface RelativeLayoutImp {
	 public void setupViews();
	 public void setData(JSONObject object);
	 public void recycle();
	 public void reload();
	 public void loadDisscussTask();
	public boolean isLoadDisscussed();
}
