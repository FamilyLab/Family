package com.ze.familyday.familyphotoframe;


import org.json.JSONObject;


import cn.jpush.android.api.JPushInterface;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
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
	        
//	           openNotification(context,bundle);
	 
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
        String pushType = "";
        try {
        	  JSONObject extrasJson = new JSONObject(extras);
              pushType = extrasJson.optString("idtype");
              if (pushType.equals(TYPE_PIC)) {
				PhotoFrameActivity.instance.isPush = true;
//				PhotoFrameActivity.instance.pushString = extras;
				PhotoFrameActivity.instance.notifyPush(extras);
			}else
			{
				nm.cancelAll();
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
      
    } 
 
   private void openNotification(Context context, Bundle bundle){
   }
}
