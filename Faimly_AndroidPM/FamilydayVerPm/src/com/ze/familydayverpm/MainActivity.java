package com.ze.familydayverpm;



import cn.jpush.android.api.JPushInterface;

import com.umeng.analytics.MobclickAgent;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.json.JSONException;
import org.json.JSONObject;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.familydayverpm.adapter.MainListViewAdapter;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {
	
	public 		static 	MainActivity		MAIN_ACTIVITY;
	private 	ListView 							mListView;
	private 	MainListViewAdapter		mAdapter;
	private 	List<Map<String, Object>> mList;	
	private 	TextView							mTempTextView;
	private 	Button 							mWeatherIcon;
	private 	View 								mWeatherDetailView;
	private 	TextView							mTopLabel;
	private 	TextView							mTempLabel;
	private 	TextView							mConditionLabel;
	private 	TextView							mTipsLabel;
//	private   	View 								mLabelClose;
	private 	AlertDialog						mWeatherDetailViewAlertDialog;
	private 	final int BUTTON_COUNT = 9;
	public static boolean isExist = false;
	private 	final int STRING_ID[] = {	
			R.string.main_pic,
			R.string.main_diary,
			R.string.main_activity,
			R.string.main_video,
			R.string.main_dialog,
			R.string.main_zone,
			R.string.main_family,
			R.string.main_set,
			R.string.main_send};
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
//		JPushInterface.setDebugMode(true);
//		JPushInterface.init(this);
		if( ! isConnectingToInternet() )
		{
			new AlertDialog.Builder(this).setMessage(R.string.dialog_msg_nonettips).setPositiveButton(R.string.dialog_button_sure, dialogClickListener)
			.setNegativeButton(R.string.dialog_button_cancel, null).create().show();
		}
		initWidget();
//		UserInfoManager.getInstance(this);
		// read news num
//		Log.v("test", "into:"+"MainAcitivity");
		wifiManager = (WifiManager) getSystemService(WIFI_SERVICE);
		WindowManager wm = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
		PublicInfo.SCREEN_W = wm.getDefaultDisplay().getWidth();//屏幕宽度
		PublicInfo.SCREEN_H = wm.getDefaultDisplay().getHeight();//屏幕高度
		String locationString = getLoaction();
		if( locationString != null )
		{
			getWeatherInfo(locationString);
		}
//		getWeatherInfo();
		loadTagInfo();
		isExist = true;
		MAIN_ACTIVITY = this;
	}
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		isExist = false;
	}
	public void loadTagInfo()
	{
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				Componet componet = UserInfoManager.getInstance(MainActivity.this).getItem("m_auth");
				if (componet != null) {
					String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_zone_list), 
							componet.getValue()
							, 1 +  "",""
							);
					Componet tagComponet = new Componet("tag");
					tagComponet.setValue(responString);
					 UserInfoManager.getInstance(MainActivity.this).add(tagComponet);
					 UserInfoManager.getInstance(MainActivity.this).save(tagComponet);
				}
				
			}
		}).start();
	}
	public boolean isConnectingToInternet(){
        ConnectivityManager connectivity = (ConnectivityManager) this.getSystemService(Context.CONNECTIVITY_SERVICE);
          if (connectivity != null)
          {
              NetworkInfo[] info = connectivity.getAllNetworkInfo();
              if (info != null)
                  for (int i = 0; i < info.length; i++)
                      if (info[i].getState() == NetworkInfo.State.CONNECTED)
                      {
                          return true;
                      }
 
          }
          return false;
    }
	private WifiManager wifiManager ;
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		MobclickAgent.onResume(this);
		checkNewsNum();
//		if (wifiManager.WIFI_STATE_ENABLED == wifiManager.getWifiState()) {
//			// 
//			Log.v("test", "wifi onStart");
//			Intent intent = new Intent();
//			intent.setClass(this, NetHelper.class);
//			startService(intent);
//		}
	}
	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		MobclickAgent.onPause(this);
	}
	public XmlSaxParserCallback callback = new XmlSaxParserCallback() {
		
		@Override
		public void onFind(String uri, String localName, String qName,
				Attributes attributes) {
			// TODO Auto-generated method stub
			String cityCode = attributes.getValue("code");
			Componet location = new Componet("location");   //  citycode
			location.setValue(cityCode);
			UserInfoManager.getInstance(MainActivity.this).add(location);
			UserInfoManager.getInstance(MainActivity.this).save(location);
			getWeatherInfo(cityCode);
		}
	};
	
	public String getLoaction()
	{
		Componet loactionComponet = UserInfoManager.getInstance(this).getItem("location") ;
		if ( loactionComponet != null ) {
			return loactionComponet.getValue();
		}else
		{
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					// TODO Auto-generated method stub
					Componet username = UserInfoManager.getInstance(MainActivity.this).getItem("username");
					if( username != null )
					{
						String respon = NetHelper.getLocation(getResources().getString(R.string.http_phonenumber_from),
								username.getValue() );
						int find_s = respon.indexOf("<location>") + 10;
						int find_e = respon.indexOf("</location>");
						if(find_e == -1 | find_s == -1 )
						{
							return;
						}else
						{
							respon = respon.substring(find_s, find_e);
							int find_name = respon.indexOf(" ")+1;
							respon = respon.substring(find_name);
							SAXParserFactory parserFactory = SAXParserFactory.newInstance();
							 // 2.构建并实例化SAXPraser对象
						        try {
									SAXParser saxParser = parserFactory.newSAXParser();
									// 3.构建XMLReader解析器
							        XMLReader xmlReader = saxParser.getXMLReader();
							        xmlReader.setContentHandler(new CityCodeParserHandler(respon, callback));
							        InputStream stream = getResources().openRawResource(R.raw.citycodes);
							        InputSource is = new InputSource(stream);
							     // 6.解析文件
							        xmlReader.parse(is);
								} catch (ParserConfigurationException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								} catch (SAXException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								} catch (IOException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
						}
					}
				}
			}).start();
			return null;
		}
	}
	Handler handler = new Handler(){
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 0:
				// weather
				try {
					String result = (String) msg.obj;
					JSONObject object = new JSONObject(result);
					object = object.getJSONObject("weatherinfo");
					String temp = object.getString("temp1");
					mTempLabel.setText(String.format(getResources().getString(R.string.weather_temp), temp));
					mTempTextView.setText(temp);
					
					String date = object.getString("date_y");
					String city = object.getString("city");
					mTopLabel.setText(String.format(getResources().getString(R.string.weather_label), date,city));
					
					String weather = object.getString("weather1");
					mConditionLabel.setText(String.format(getResources().getString(R.string.weather_condition), weather));
					
					String cur_weather = object.getString("img_title1");
					if( cur_weather.equals("晴") )
					{
						mWeatherIcon.setBackgroundResource(R.drawable.w_qing);
					}else if( cur_weather.contains("雨") ){
						if( cur_weather.contains("小"))
						{
							mWeatherIcon.setBackgroundResource(R.drawable.w_xiaoyu);
						}else if(cur_weather.contains("雷"))
						{
							mWeatherIcon.setBackgroundResource(R.drawable.w_leizhenyu);
						}else if(cur_weather.contains("雪"))
						{
							mWeatherIcon.setBackgroundResource(R.drawable.w_yujiaxue);
						}else {
							mWeatherIcon.setBackgroundResource(R.drawable.w_dayu);
						}
					}else if( cur_weather.contains("雪") ){
						if( cur_weather.contains("小"))
						{
							mWeatherIcon.setBackgroundResource(R.drawable.w_xiaoxue);
						}else {
							mWeatherIcon.setBackgroundResource(R.drawable.w_daxue);
						}
					}else if( cur_weather.contains("阴") ){
							mWeatherIcon.setBackgroundResource(R.drawable.w_yin);
					}
					String tips = object.getString("index_d");
					mTipsLabel.setText(String.format(getResources().getString(R.string.weather_tips), tips));
					isReadWeather = true;
					// update date
					Componet updatewComponet = new Componet("updatew");
					updatewComponet.setValue(new Date().getDate() + "");
					UserInfoManager.getInstance(MainActivity.this).add( updatewComponet );
					UserInfoManager.getInstance(MainActivity.this).save(updatewComponet);
					// weather info
					Componet weatherComponet = new Componet("weather");
					weatherComponet.setValue(result);
					UserInfoManager.getInstance(MainActivity.this).add( weatherComponet );
					UserInfoManager.getInstance(MainActivity.this).save(weatherComponet);
					} catch (Exception e) {
						// TODO: handle exception
					}
				break;

			default:
				break;
			}
		};
	};
	public void getWeatherInfo(final String citycode)
	{
		if( citycode != null && citycode.length() > 0 )
		{
			
		new Thread( new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				String result = "";
				Componet weatherComponet = UserInfoManager.getInstance(MainActivity.this).getItem("weather");
				if( weatherComponet != null )
				{
					// 天气信息不为空
					Componet updatewComponet = UserInfoManager.getInstance(MainActivity.this).getItem("updatew");
					if ( updatewComponet.getValue().equals(new Date().getDate() + "")) {
						// 更新时间没变化
						result = weatherComponet.getValue();
					}else
					{
						// 更新时间变化,请求新数据
						result = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_weatherapi),
								citycode);
					}
				}else
				{
					result = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_weatherapi),
							citycode);
				}
				Message msg = handler.obtainMessage(0);
				msg.obj = result;
				handler.sendMessage(msg);
			}
		}).start();
		}
	}
	private boolean isReadWeather = false;
	public void checkNewsNum()
	{
		new AsyncTask<String, String, String>(){

			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				Componet m_auth = UserInfoManager.getInstance(MainActivity.this).getItem("m_auth");
				String string = null;
				if ( m_auth != null ) {
					string = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_news_num), 
							m_auth.getValue());
//					Log.v("test", "read news:"+UserInfoManager.getInstance(MainActivity.this).getItem("m_auth").getValue());
				}
				return string;
			}
			protected void onPostExecute(String result) {
				if( result == null )
				{
					return;
				}
				try {
					JSONObject object = new JSONObject(result);
					if ( ! object.isNull("data") )
					{
						object = object.getJSONObject("data");
						int photo = object.getInt("addphoto");
						int addvideo = object.getInt("addvideo");
						int addevent = object.getInt("addevent");
						int addblog = object.getInt("addblog");
						int requestcount = object.getInt("applycount");
						// TODO: 
						int pmcount = Integer.parseInt( object.getString("pmcount") );
						Map<String, Object> map ;
						mList.clear();
						for(int i=0; i<BUTTON_COUNT;i++)
						{
							map = new HashMap<String, Object>();
							if( i == 0 )
							map.put("count", photo);
							else if( i== 1 )
							{
								map.put("count", addblog);
							}else if( i== 2 )
							{
								map.put("count", addevent);
							}else if( i== 3 )
							{
								map.put("count", addvideo);
							}else if( i== 4 )
							{
								map.put("count", pmcount);
							}else if (i== 6){
								map.put("count", requestcount);
							}else
							{
								map.put("count", 0);
							}
							map.put("label", getResources().getString(STRING_ID[i]));
							mList.add(map);
						}
						mAdapter.notifyDataSetChanged();
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					Log.v("test", e.toString());
				}
				
			};
			}.execute("");
	}
	private void initWidget()
	{
		mTempTextView = (TextView)findViewById(R.id.main_weather_temp);
		mWeatherIcon	= (Button)findViewById(R.id.main_weather_type);
		mWeatherIcon.setOnClickListener(ButtonOnclickListener);
		
		if( mWeatherDetailViewAlertDialog == null ){
			mWeatherDetailView = MainActivity.this.getLayoutInflater().inflate(R.layout.weatherpulldown_layout, null);
//			mLabelClose	= mWeatherDetailView.findViewById(R.id.main_weather_label_close);
//			mLabelClose.setOnClickListener(ButtonOnclickListener);
			mTopLabel		= (TextView)mWeatherDetailView.findViewById(R.id.main_weather_label_top);
			mTempLabel	= (TextView)mWeatherDetailView.findViewById(R.id.main_weather_label_temp);
			mConditionLabel	= (TextView)mWeatherDetailView.findViewById(R.id.main_weather_label_condition);
			mTipsLabel		=(TextView)mWeatherDetailView.findViewById(R.id.main_weather_label_tips);
			mWeatherDetailViewAlertDialog = new AlertDialog.Builder(MainActivity.this).setView(mWeatherDetailView).
					setNeutralButton(R.string.dialog_button_close, null).setTitle(R.string.dialog_title_weather_detail).create();
		}
		
		mListView 			= (ListView)findViewById(R.id.main_listview);
		mList 					= new ArrayList<Map<String,Object>>();
		Map<String, Object> map ;
		
		for(int i=0; i<BUTTON_COUNT;i++)
		{
			map = new HashMap<String, Object>();
		
				map.put("count", 0);
			map.put("label", getResources().getString(STRING_ID[i]));
			mList.add(map);
		}
		
		mAdapter 			= new MainListViewAdapter(this, mList);
		
		mListView.setAdapter(mAdapter);
		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				// TODO Auto-generated method stub
				if ( arg2 == 0) {
					// to pic 
					Intent intent = new Intent();
					intent.putExtra("DETAIL_TYPE", SpaceDetailActivity.DETAIL_PIC);
					if ( (Integer)mList.get(0).get("count") > 0 ) {
						intent.putExtra("new", true);
					}
					intent.setClass(MainActivity.this, SpaceDetailActivity.class);
					MainActivity.this.startActivity(intent);
				}else if( arg2 == 1  )
				{
					// to note
					Intent intent = new Intent();
					intent.putExtra("DETAIL_TYPE", SpaceDetailActivity.DETAIL_BLOG);
					intent.setClass(MainActivity.this, SpaceDetailActivity.class);
					MainActivity.this.startActivity(intent);
				}else if( arg2 == 2 )
				{
					// to activity
					Intent intent = new Intent();
					intent.putExtra("DETAIL_TYPE", SpaceDetailActivity.DETAIL_EVNET);
					intent.setClass(MainActivity.this, SpaceDetailActivity.class);
					MainActivity.this.startActivity(intent);
				}else if( arg2 == 3 )
				{
					// to video
					Intent intent = new Intent();
					intent.putExtra("DETAIL_TYPE", SpaceDetailActivity.DETAIL_VIDEO);
					intent.setClass(MainActivity.this, SpaceDetailActivity.class);
					MainActivity.this.startActivity(intent);
//					Toast.makeText(MainActivity.this, R.string.notopen, Toast.LENGTH_SHORT).show();
				}else if( arg2 == 4 )
				{
					// to dialog
					Intent intent = new Intent();
					intent.putExtra("frommain", true);
					intent.setClass(MainActivity.this, DialogActivity.class);
					MainActivity.this.startActivity(intent);
				}else if( arg2 == 5 )
				{
					// to space
					Intent intent = new Intent();
					intent.setClass(MainActivity.this, SpaceActivity.class);
					MainActivity.this.startActivity(intent);
				}else if( arg2 == 6 )
				{
					// to family
					Intent intent = new Intent();
					intent.putExtra("count", (Integer)mList.get(arg2).get("count"));
					intent.setClass(MainActivity.this, FamilyActivity.class);
					MainActivity.this.startActivity(intent);
				}else if( arg2 == 7 )
				{
					// to setting
					Intent intent = new Intent();
					intent.setClass(MainActivity.this, SettingActivity.class);
					MainActivity.this.startActivity(intent);
				}else if( arg2 == 8 )
				{
					// to publish
					Intent intent = new Intent();
					intent.setClass(MainActivity.this, PublishActivity.class);
					MainActivity.this.startActivity(intent);
				}
					
			}
		});
	}
	public void unLogin()
	{
		FamilyDayVerPMApplication.unBindJpush(MainActivity.this, UserInfoManager.getInstance(MainActivity.this).getItem("uid").getValue());
		UserInfoManager.getInstance(MainActivity.this).deleteAll();
		Intent intent = new Intent();
		intent.setClass(MainActivity.this, LoginActivity.class);
		MainActivity.this.startActivity(intent);
		MainActivity.this.finish();
	}
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
//		getMenuInflater().inflate(R.menu.activity_login, menu);
		menu.add(menu.NONE, 0, 0, R.string.exit).setIcon(R.drawable.icon_exit);
		menu.add(menu.NONE, 1, 1, R.string.unsign).setIcon(R.drawable.icon_exit);
		return super.onCreateOptionsMenu(menu);
	}
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// TODO Auto-generated method stub
		switch(item.getItemId()) {
			case 0:
				MainActivity.this.finish();
				break;
			case 1:
				unLogin();
			default:
				break;
		}
		return super.onOptionsItemSelected(item);
	}
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if( keyCode == KeyEvent.KEYCODE_BACK )
		{
			Intent intent= new Intent(Intent.ACTION_MAIN); 
			intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			intent.addCategory(Intent.CATEGORY_HOME);
			startActivity(intent);
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}
	class CityCodeParserHandler extends DefaultHandler {
		private String find_key;
		private XmlSaxParserCallback callback;
		public CityCodeParserHandler(String key,XmlSaxParserCallback callback)
		{
			find_key = key;
			this.callback = callback;
		}
		@Override
		public void startElement(String uri, String localName, String qName,
				Attributes attributes) throws SAXException {
			// TODO Auto-generated method stub
			String node = localName.length() != 0 ? localName : qName;
			if( node.equals("string"))
			{
				if( attributes.getValue("name").equals(find_key) ){
					callback.onFind(uri, localName, qName, attributes);
				}
			}
			super.startElement(uri, localName, qName, attributes);
		}
	}
	
	interface XmlSaxParserCallback {
		public void onFind(String uri, String localName, String qName,
				Attributes attributes);
	}
	private Animation weatherdetailOpenAnimation = null;
	private Animation	weatherdetailCloseAnimation = null;
	private OnClickListener ButtonOnclickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if ( v == mWeatherIcon ) {
				// open detail
				if( isReadWeather )
				{
//					if( weatherdetailOpenAnimation == null ){
//						weatherdetailOpenAnimation = new AlphaAnimation(0.0f, 1.0f);
//						weatherdetailOpenAnimation.setDuration(500);
//					}
//					mWeatherDetailView.startAnimation(weatherdetailOpenAnimation);
					mWeatherDetailViewAlertDialog.show();
				}else
				{
					Toast.makeText(MainActivity.this, R.string.tips_msg_waitforload, Toast.LENGTH_LONG).show();
				}
//			}else if( v == mLabelClose )
//			{
//				// close detail
////				if( weatherdetailCloseAnimation == null ){
////					weatherdetailCloseAnimation = new AlphaAnimation(1.0f, 0.0f);
////					weatherdetailCloseAnimation.setDuration(500);
////					weatherdetailCloseAnimation.setAnimationListener(new AnimationListener() {
////						
////						@Override
////						public void onAnimationStart(Animation animation) {
////							// TODO Auto-generated method stub
////							
////						}
////						
////						@Override
////						public void onAnimationRepeat(Animation animation) {
////							// TODO Auto-generated method stub
////							
////						}
////						
////						@Override
////						public void onAnimationEnd(Animation animation) {
////							// TODO Auto-generated method stub
////							mWeatherDetailView.setVisibility(View.INVISIBLE);
////						}
////					});
////				}
////				mWeatherDetailView.startAnimation(weatherdetailCloseAnimation);
//				mWeatherDetailViewAlertDialog.dismiss();
			}
		}
	};
	private DialogInterface.OnClickListener dialogClickListener = new DialogInterface.OnClickListener() {
		
		@Override
		public void onClick(DialogInterface dialog, int which) {
			// TODO Auto-generated method stub
			if ( which == dialog.BUTTON_POSITIVE ) {
				startActivity(new Intent(Settings.ACTION_WIRELESS_SETTINGS));
			}
		}
	};
}
