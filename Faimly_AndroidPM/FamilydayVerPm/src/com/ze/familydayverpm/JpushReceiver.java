package com.ze.familydayverpm;


import org.json.JSONObject;

import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import cn.jpush.android.api.JPushInterface;
import android.app.Activity;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ComponentInfo;
import android.os.Bundle;
import android.util.Log;

public class JpushReceiver extends BroadcastReceiver  {
	private static final String TAG = "MyReceiver";
    
    private NotificationManager nm;
    private static final String TYPE_MSG = "pmid";
    private static final String TYPE_PIC = "photoid";
    private static final String TYPE_BLOG = "blogid";
    private static final String TYPE_ACTIVITY = "eventid";
    private static final String TYPE_VIDEO = "videoid";
    
	@Override
	public void onReceive(Context context, Intent intent) {
		// TODO Auto-generated method stub
		 if (null == nm) {
	            nm = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
	        }
	         
	        Bundle bundle = intent.getExtras();
//	        Logger.d(TAG, "onReceive - " + intent.getAction() + ", extras: " + AndroidUtil.printBundle(bundle));
	         
	        if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
	            Log.d(TAG, "JPush用户注册成功");
	             
	        } else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
	            Log.d(TAG, "接受到推送下来的自定义消息");
	                     
	        } else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {
	            Log.d(TAG, "接受到推送下来的通知");
	     
	            receivingNotification(context,bundle);
	 
	        } else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
	            Log.d(TAG, "用户点击打开了通知");
	        
	           openNotification(context,bundle);
	 
	        } else {
	            Log.d(TAG, "Unhandled intent - " + intent.getAction());
	        }
	}
	private void receivingNotification(Context context, Bundle bundle){
        String title = bundle.getString(JPushInterface.EXTRA_NOTIFICATION_TITLE);
        Log.d(TAG, " title : " + title);
        String message = bundle.getString(JPushInterface.EXTRA_ALERT);  //EXTRA_MESSAGE
        Log.d(TAG, "message : " + message);
        String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
        Log.d(TAG, "extras : " + extras);
        if( DialogDetailActivity.inDetailView )
        {
//        	if (nm != null) {
//        		nm.cancel(0);
//			}
	        String pushType = ""; 
	        String uid = "";
	        try {
	            JSONObject extrasJson = new JSONObject(extras);
	            pushType = extrasJson.optString("idtype");
	            uid = extrasJson.optString("uid");
	        } catch (Exception e) {
	            Log.w(TAG, "Unexpected: extras is not a valid json", e);
	            return;
	        }
	        if (TYPE_MSG.equals(pushType)){
	       	 int find = message.indexOf(":");
	       	 if ( -1 != find ) {
					message = message.substring(find + 1 );
				}
	       	 bundle.putString("msg", message);
	       	 bundle.putString("uid", uid);
			DialogDetailActivity.DialogDetailInstance.updateFromPushData(bundle);
	        }
        }
    } 
 
   private void openNotification(Context context, Bundle bundle){
	   Componet auth = UserInfoManager.getInstance(MainActivity.MAIN_ACTIVITY).getItem("m_auth");
	   if (auth == null) {
		return;
	   }
        String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
        String pushType = ""; 
        String uid = "";
        String id		= "";
        try {
            JSONObject extrasJson = new JSONObject(extras);
            pushType = extrasJson.optString("idtype");
            uid				= extrasJson.optString("uid");
            id					= extrasJson.optString("id");
        } catch (Exception e) {
            Log.w(TAG, "Unexpected: extras is not a valid json", e);
            return;
        }
       if (TYPE_MSG.equals(pushType)){
        	 String message = bundle.getString(JPushInterface.EXTRA_ALERT);  //EXTRA_MESSAGE
//        	 message.substring(message)
        	 int find = message.indexOf(":");
        	 if ( -1 != find ) {
				message = message.substring(find + 1 );
			}
        	 bundle.putString("msg", message);
        	 if ( ! DialogDetailActivity.inDetailView  || ! DialogDetailActivity.DialogDetailInstance.isEqualCurrentUid(uid)) {
	            Intent mIntent = new Intent(context, DialogActivity.class);
	            mIntent.putExtras(bundle);
	            mIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	            context.startActivity(mIntent);
//	            ((Activity)context).finish();
		       	 if(  DialogDetailActivity.inDetailView && ! DialogDetailActivity.DialogDetailInstance.isEqualCurrentUid(uid) )
	    		 {
	    			 DialogDetailActivity.DialogDetailInstance.finish();
	    		 }
        	 }
        	
        }else if( pushType.contains("friend") )
        {
        	Intent intent = new Intent();
			intent.putExtra("count", 1);
			intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			intent.setClass(context, FamilyActivity.class);
			context.startActivity(intent);
        }else
        {
        	   Intent mIntent = new Intent(context, SpaceDetailActivity.class);
        	   mIntent.putExtra("frompublish", true);
        	   mIntent.putExtra("id", id);
        	   mIntent.putExtra("uid", uid);
        	   mIntent.putExtra("type", pushType);
//               mIntent.putExtras(bundle);
               mIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
               context.startActivity(mIntent);
//               ((Activity)context).finish();
        }
    }
}
