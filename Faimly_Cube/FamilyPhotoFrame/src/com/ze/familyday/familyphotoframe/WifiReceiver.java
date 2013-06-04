package com.ze.familyday.familyphotoframe;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class WifiReceiver extends BroadcastReceiver {
	@Override
	public void onReceive(Context context, Intent intent) {
		// TODO Auto-generated method stub
		PhotoFrameActivity.instance.notifyWifiChange();
	}
}
