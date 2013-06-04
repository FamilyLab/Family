package com.ze.familydayverpm;

import org.json.JSONObject;

import com.ze.commontool.NetHelper;

import cn.jpush.android.api.JPushInterface;
import android.app.Application;
import android.content.Context;
import android.util.Log;

public class FamilyDayVerPMApplication extends Application {
	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		super.onCreate();
		JPushInterface.setDebugMode(false);
		JPushInterface.init(this);
		JPushInterface.setLatestNotifactionNumber(this, 3);			// 最多3个推送同时出现在通知栏
	}
	public static void bindJpush(final Context context, final String uidString)
	{
		new Thread( new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				JPushInterface.setAliasAndTags(context, uidString, null);
				String respon = NetHelper.getResponByHttpClient(String.format( context.getResources().getString( 
						R.string.http_bindjpush),uidString ));
				try {
					JSONObject object = new JSONObject(respon);
					if ( object.getInt("code") == 0 ) {
						Log.v("jpush","bind success");
					}else
					{
						Log.v("jpush","bind error");
					}
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
			}
		}).start();
	}
	
	public static void unBindJpush(final Context context, final String uidString)
	{
		new Thread( new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				JPushInterface.setAliasAndTags(context, "", null);
				String respon = NetHelper.getResponByHttpClient(String.format( context.getResources().getString( 
						R.string.http_unbindjpush),uidString ));
				try {
					JSONObject object = new JSONObject(respon);
				} catch (Exception e) {
					// TODO: handle exception
				}
			}
		}).start();
	}
	
}
