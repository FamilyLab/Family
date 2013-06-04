package com.ze.familyday.familyphotoframe;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class WifiReceiverInMain extends BroadcastReceiver {
	@Override
	public void onReceive(Context context, Intent intent) {
		// TODO Auto-generated method stub
		MainActivity.instance.notifyWifiChange();
	}
}
