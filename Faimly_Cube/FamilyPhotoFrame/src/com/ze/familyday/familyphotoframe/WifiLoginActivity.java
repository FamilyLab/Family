package com.ze.familyday.familyphotoframe;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ze.familydayverpm.adapter.WifiListViewAdapter;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnDismissListener;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

public class WifiLoginActivity extends Activity{
	ListView mWifiListView;
	BaseAdapter	wifiAdapter;
	List<Map<String, Object>> mList;	
	View			mBtnRefresh;
	View			mPbLoading;
	boolean 		mIsRefreshing = false;
	WifiManager wifiManager;
	List<ScanResult> mScanResults;
	List<WifiConfiguration> mWifiConfigurations;
	View dialog_wifiView ;
	EditText dialog_etPw;
	ConnectivityManager conMan;
	ProgressDialog progressDialog;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_wifilogin);
		mBtnRefresh = findViewById(R.id.wifi_refresh);
		mPbLoading	= findViewById(R.id.wifi_refresh_loading);
		mList = new ArrayList<Map<String,Object>>();
		wifiAdapter = new WifiListViewAdapter(this, mList);
		mWifiListView = (ListView) findViewById(R.id.wifi_list);
		mWifiListView.setAdapter(wifiAdapter);
		wifiManager = (WifiManager) getSystemService(WIFI_SERVICE);
		openWifi();
		mBtnRefresh.setOnClickListener(buttonOnClickListener);
		mWifiListView.setOnItemClickListener(itemClickListener);
		dialog_wifiView = this.getLayoutInflater().inflate(R.layout.dialog_wifilogin, null);
		dialog_etPw = (EditText) (dialog_wifiView.findViewById(R.id.wifilogin_pw));
		conMan = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		progressDialog = new ProgressDialog(this);
		progressDialog.setMessage("正在连接wifi");
		refreshWifiList();
	}
	public void openWifi()
	{
		if ( ! wifiManager.isWifiEnabled()) {
			wifiManager.setWifiEnabled(true);
		}
	}
	public void closeWifi()
	{
		if ( wifiManager.isWifiEnabled()) {
			wifiManager.setWifiEnabled(false);
		}
	}
	public void refreshWifiList()
	{
		if (mIsRefreshing) {
			Toast.makeText(this, "正在扫描", Toast.LENGTH_SHORT).show();
			return;
		}else
		{
			new AsyncTask<String, String, String>()
			{
				protected void onPreExecute() {
					mIsRefreshing = true;
					mPbLoading.setVisibility(View.VISIBLE);
					mBtnRefresh.setVisibility(View.INVISIBLE);
				}

				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					mScanResults = wifiManager.getScanResults();
					mWifiConfigurations = wifiManager.getConfiguredNetworks();
//					mScanResults.get(0);
					if( mScanResults == null )
					{
						return "";
					}
					int size = mScanResults.size();
					HashMap<String, Object> map;
					ScanResult scanResult;
					mList.clear();
					for (int i = 0; i < size; i++) {
						map = new HashMap<String, Object>();
						scanResult = mScanResults.get(i);
						map.put(WifiListViewAdapter.flag[0], scanResult.SSID);
						if( wifiManager.getConnectionInfo() != null )
						{
							if (wifiManager.getConnectionInfo().getSSID().equals(scanResult.SSID)) {
								map.put(WifiListViewAdapter.flag[1], "1");
							}else
							{
								map.put(WifiListViewAdapter.flag[1], "0");
							}
						}else
						{
							map.put(WifiListViewAdapter.flag[1], "0");
						}
						map.put(WifiListViewAdapter.flag[2], wifiManager.calculateSignalLevel(scanResult.level, 4));
						if ( scanResult.capabilities.contains("PSK") || scanResult.capabilities.contains("EPA") )
						{
							map.put(WifiListViewAdapter.flag[5], 1);
						}else
						{
							map.put(WifiListViewAdapter.flag[5], 0);
						}
//						map.put(WifiListViewAdapter.flag[3], mWifiConfigurations.get(i).networkId);
						mList.add(map);
						//[WPS][ESS] [WPA-PSK-TKIP][WPS][ESS]
					}
					return null;
				};
				protected void onPostExecute(String result) {
					mIsRefreshing = false;
					mPbLoading.setVisibility(View.INVISIBLE);
					mBtnRefresh.setVisibility(View.VISIBLE);
					wifiAdapter.notifyDataSetChanged();
				};
			}.execute("");
		}
	}
//	public static int calculateSignalLevel(int rssi, int numLevels) {
//        if (rssi <= MIN_RSSI) {
//            return 0;
//        } else if (rssi >= MAX_RSSI) {
//            return numLevels - 1;
//        } else {
//            int partitionSize = (MAX_RSSI - MIN_RSSI) / (numLevels - 1);
//            return (rssi - MIN_RSSI) / partitionSize;
//        }
//    }
	
	 // 指定配置好的网络进行连接  
    public void connectConfiguration(int index) { 
        // 索引大于配置好的网络索引返回  
        if (index > mWifiConfigurations.size()) { 
            return; 
        } 
        // 连接配置好的指定ID的网络  
        wifiManager.enableNetwork(mWifiConfigurations.get(index).networkId, 
                true); 
    } 
    
    WifiConfiguration CreateWifiInfo(String SSID, String Password, String mSecurity) 
    { 
    	//创建一个新的WifiConfiguration
    	WifiConfiguration wcg = new WifiConfiguration();
//    	wcg.b.BSSID = mBSSID;
    	//SSID和preSharedKey必须添加双引号，否则将会导致连接失败
    	wcg.SSID = "\"" + SSID + "\""; 
    	wcg.hiddenSSID = false;
    	wcg.status = WifiConfiguration.Status.ENABLED;
    	wcg.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.OPEN);
    	wcg.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.SHARED);
    	wcg.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.TKIP);
    	wcg.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.CCMP);
    	wcg.allowedProtocols.set(WifiConfiguration.Protocol.RSN);
    	wcg.allowedProtocols.set(WifiConfiguration.Protocol.WPA);
    	//如果加密模式为WEP
    	if(mSecurity.equals("WEP"))
    	{ 
    	wcg.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE);
    	wcg.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.WEP40);
    	wcg.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.WEP104);
    	wcg.wepKeys[0] ="\"" + Password + "\""; //This is the WEP Password
    	wcg.wepTxKeyIndex = 0;
    	}
    	//如果加密模式为WPA EPA
    	else if(mSecurity.equals("WPA EAP"))
    	{
    	wcg.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_EAP);
    	wcg.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
    	wcg.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
    	wcg.preSharedKey = "\"" + Password+ "\"";
    	}
    	//如果加密模式为WPA PSK
    	else if(mSecurity.equals("WPA PSK"))
    	{
    	wcg.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
    	wcg.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
    	wcg.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
    	wcg.preSharedKey = "\"" + Password + "\"";
    	}
    	//无加密
    	else
    	{
    	wcg.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE);
    	}
    	return wcg;
    } 
    AlertDialog wifiAlertDialog;
	OnItemClickListener itemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
				long arg3) {
			// TODO Auto-generated method stub
//			wifiManager.enableNetwork((Integer)mList.get(arg2).get("netid"), true);
			final String ssid = (String)mList.get(arg2).get("wifi");
			final int index = arg2;
			final int ispw = (Integer)mList.get(arg2).get("ispw");
			WifiConfiguration find = IsExsits( ssid );
			if( find == null )
			{
				if( wifiAlertDialog == null )
				{
					wifiAlertDialog = new AlertDialog.Builder(WifiLoginActivity.this).setView(dialog_wifiView)
							.setNegativeButton("取消", null)
							.create();
				}
				if( ispw == 1 )
				{
					wifiAlertDialog.setMessage("配置" + ssid + " 的密码");
				}else
				{
					wifiAlertDialog.setMessage("该类型为无密码，按确定继续连接");
				}
					
					wifiAlertDialog.setButton(DialogInterface.BUTTON_POSITIVE, "确定", new DialogInterface.OnClickListener() {
						
						@Override
						public void onClick(DialogInterface dialog, int which) {
							// TODO Auto-generated method stub
							String pw = dialog_etPw.getText().toString().trim();
							WifiConfiguration newWifiConfiguration ;
							if( ispw ==1 ){
								newWifiConfiguration = CreateWifiInfo(ssid, pw,  "WPA PSK");
							}else
							{
								newWifiConfiguration = CreateWifiInfo(ssid, pw,  "none");
							}
							int networkid = wifiManager.addNetwork(newWifiConfiguration);
							mList.get(index).put(WifiListViewAdapter.flag[4], networkid);
							boolean issave = wifiManager.saveConfiguration();
							boolean success = wifiManager.enableNetwork(networkid, true);
							if(success)
							{
								checkWifiStatus(index);
							}else{
								wifiManager.removeNetwork(networkid);
							}
						}
					});
					wifiAlertDialog.show();
			}else
			{
//				wifiManager.removeNetwork(find.networkId);
//				onItemClick(arg0, arg1, arg2, arg3);
				if( "1".equals( mList.get(index).get(WifiListViewAdapter.flag[1])) )
				{
					Toast.makeText(WifiLoginActivity.this, "已连接，如需更换wifi，则选择其他wifi信号连接！", Toast.LENGTH_LONG).show();
				}else{
					Toast.makeText(WifiLoginActivity.this, "正在发起连接", Toast.LENGTH_LONG).show();
					boolean success = wifiManager.enableNetwork(find.networkId, true);
					if(success)
					{
						checkWifiStatus(index);
					}else{
						wifiManager.removeNetwork(find.networkId);
					}
				}
			}
		}
	};
	public Handler handler = new Handler(){
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 0:
				progressDialog.hide();
				if( conMan.getNetworkInfo(conMan.TYPE_WIFI).getState() == NetworkInfo.State.CONNECTED )
				{
					mList.get(msg.arg1).put(WifiListViewAdapter.flag[1], "1");
					wifiAdapter.notifyDataSetChanged();
					handler.postDelayed(new Runnable() {
						
						@Override
						public void run() {
							// TODO Auto-generated method stub
							WifiLoginActivity.this.finish();
						}
					},500);
				}else
				{
					Toast.makeText(WifiLoginActivity.this, "连接失败可能信号不好或者密码错误造成的，请重试", Toast.LENGTH_LONG).show();
					WifiConfiguration configuration = IsExsits((String)mList.get(msg.arg1).get(WifiListViewAdapter.flag[0]));
					if( configuration != null )
					{
						wifiManager.removeNetwork(configuration.networkId);
					}
					dialog_etPw.setText("");
//					onItemClick(arg0, arg1, arg2, arg3);
				}
			
				
				break;
			case 1:
				progressDialog.setMessage((String)msg.obj);
				break;
			default:
				break;
			}
		};
	};
	public void checkWifiStatus(final int index)
	{
		progressDialog.show();
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				NetworkInfo.State state = conMan.getNetworkInfo(conMan.TYPE_WIFI).getState();
				int checkCount = 0;
				while( state != NetworkInfo.State.CONNECTED && checkCount<50)
				{
					Message msg = handler.obtainMessage(1);
					msg.obj =  conMan.getNetworkInfo(conMan.TYPE_WIFI).getDetailedState().toString();
					handler.sendMessage(msg);
					try {
						Thread.sleep(500);
						state = conMan.getNetworkInfo(conMan.TYPE_WIFI).getState();
						checkCount++;
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				Message msg = handler.obtainMessage(0);
				msg.arg1 = index;
				handler.sendMessage(msg);
			}
		}).start();
	}
//	public int findFromConfigue(String ssid)
//	{
//		int size = mWifiConfigurations.size();
//		for (int i = 0; i < size; i++) {
//			if( mWifiConfigurations.get(i).SSID.equals(ssid) )
//			{
//				return i;
//			}
//		}
//		return -1;
//	}
	public static final int TYPE_NO_PASSWD = 0x11;  
    public static final int TYPE_WEP = 0x12;  
    public static final int TYPE_WPA = 0x13;  
	OnClickListener buttonOnClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if ( v == mBtnRefresh ) {
				refreshWifiList();
			}
		}
	};
	//定义几种加密方式，一种是WEP，一种是WPA，还有没有密码的情况  
    public enum WifiCipherType  
    {  
      WIFICIPHER_WEP,WIFICIPHER_WPA, WIFICIPHER_NOPASS, WIFICIPHER_INVALID  
    }  
	 //查看以前是否也配置过这个网络  
    private WifiConfiguration IsExsits(String SSID)  
    {  
        List<WifiConfiguration> existingConfigs = wifiManager.getConfiguredNetworks();  
           for (WifiConfiguration existingConfig : existingConfigs)   
           {  
             if (existingConfig.SSID.equals("\""+SSID+"\""))  
             {  
                 return existingConfig;  
             }  
           }  
        return null;   
    }  
}
