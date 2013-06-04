package com.ze.familydayverpm.userinfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;


import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

/**
 * 
 * @author ze
 */
public class UserInfoManager {
	private static Activity mActivity;
	private UserInfoManager()
	{
//		infoList = new ArrayList<Componet>();
	}
	public static void setContext(Activity context)
	{
		mActivity = context;
	}
	private static UserInfoManager instance;
	public static UserInfoManager getInstance(Activity activity)
	{
		if ( instance == null ) {
			instance = new UserInfoManager();
			mActivity = activity;
			// init data
			infoList = new ArrayList<Componet>();
			SharedPreferences sharedPreferences = activity.getSharedPreferences("user.config", Activity.MODE_WORLD_READABLE);
			HashMap<String, Object> data = (HashMap<String, Object>) sharedPreferences.getAll();
			Set<String> keySet = data.keySet();
			Componet item = null;
			String key = null ;
			for (Iterator<String> iterator = keySet.iterator();  iterator.hasNext(); ) {
				key = iterator.next();
				item = new Componet(key);
				item.setValue((String)data.get(key));
				infoList.add(item);
			}
		}
		return instance;
	}
	protected static List<Componet> infoList;
	public Componet getItem(String name)
	{
		Componet item = null;
		for (int i = 0; i < infoList.size(); i++) {
			item = infoList.get(i);
			if (item.getName().equals( name ) ) {
				return item;
			}
		}
		return null;
	}
	public void add(Componet item) {
		// TODO Auto-generated method stub
		Componet existComponet = getItem(item.getName());
		if( existComponet != null )
		{
			infoList.remove(existComponet);
		}else
		{
			existComponet = new Componet(item.getName());
		}
		existComponet.setValue(item.getValue());
		infoList.add(existComponet);
//		save(item);
	}
	
	public void delete(Componet item) {
		// TODO Auto-generated method stub
		infoList.remove(item);
	}
	public void delete(String name)
	{
		delete(getItem(name));
	}
	public void deleteAll()
	{
		if ( mActivity != null ) {
			SharedPreferences sharedPreferences = mActivity.getSharedPreferences("user.config", Activity.MODE_WORLD_WRITEABLE);
			Editor editor = sharedPreferences.edit();
			editor.clear();
			editor.commit();
			infoList.clear();
		}
	}
	public void save(Componet item)
	{
		// save one
		if ( mActivity != null ) {
			SharedPreferences sharedPreferences = mActivity.getSharedPreferences("user.config", Activity.MODE_WORLD_WRITEABLE);
			Editor editor = sharedPreferences.edit();
			editor.putString(item.getName(), item.getValue());
			editor.commit();
		}
		
	}
	public void saveAll()
	{
		if ( mActivity != null ) {
			SharedPreferences sharedPreferences = mActivity.getSharedPreferences("user.config", Activity.MODE_WORLD_WRITEABLE);
			Componet item;
			Editor editor = sharedPreferences.edit();
			for (int i = 0; i < infoList.size(); i++) {
				item = infoList.get(i);
				editor.putString(item.getName(), item.getValue());
			}
			editor.commit();
		}
	}
	
}
