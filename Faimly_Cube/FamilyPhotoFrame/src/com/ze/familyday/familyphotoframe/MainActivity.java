package com.ze.familyday.familyphotoframe;


import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.familydayverpm.adapter.SpaceViewPagerAdapter;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.DataModel;
import com.ze.model.ModelDataMgr;
import com.ze.model.PhotoModel;
import com.ze.model.PhotoModel.PicInfo;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

public class MainActivity extends FragmentActivity {

	/**
	 * The {@link android.support.v4.view.PagerAdapter} that will provide
	 * fragments for each of the sections. We use a
	 * {@link android.support.v4.app.FragmentPagerAdapter} derivative, which
	 * will keep every loaded fragment in memory. If this becomes too memory
	 * intensive, it may be best to switch to a
	 * {@link android.support.v4.app.FragmentStatePagerAdapter}.
	 */

	/**
	 * The {@link ViewPager} that will host the section contents.
	 */
	View 			mBtnLoginDialog;
	ProgressDialog	mProgressDialog;
	private 	SpaceViewPagerAdapter 		mviewAdapter;
	ArrayList<DataModel> arrayList = null;
	String  mUidString;
	int currentPage = 0;
	View wifiView;
	ListView wifiListView;
	View loginView;
	private 		BroadcastReceiver receiver ;
	public static MainActivity instance;
	WifiManager wifiManager;
	ConnectivityManager conMan;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_pic);
		mBtnLoginDialog = findViewById(R.id.pic_back);
		wifiView  = findViewById(R.id.signin_btnSignWifi);
		loginView = findViewById(R.id.signin_loginview);
		wifiView.setOnClickListener(onClickListener);
		mBtnLoginDialog.setOnClickListener(onClickListener);
		mProgressDialog = new ProgressDialog(this);
		mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
		dialog_login					= findViewById(R.id.signin_btnSignIn);
		dialog_etUser 					= (EditText)findViewById(R.id.signin_etUser);
		dialog_etPw					= (EditText)findViewById(R.id.signin_etPw);
		dialog_login.setOnClickListener(onClickListener);
		loginView.setVisibility(View.INVISIBLE);
		instance = this;
		if( netErrorDialog == null )
		{
			netErrorDialog = new AlertDialog.Builder(this).setMessage("请设置wifi，以链接网络！").setPositiveButton("确定", new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int which) {
					// TODO Auto-generated method stub
					openWifiLogin();
					uselocal =false;
				}
			}).
			setNegativeButton("离线使用", new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int which) {
					// TODO Auto-generated method stub
					uselocal = true;
				}
			}).create();
			netErrorDialog.setCanceledOnTouchOutside(false);
		}
		wifiManager = (WifiManager) getSystemService(Context.WIFI_SERVICE);
		conMan = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		receiver = new WifiReceiverInMain();
		IntentFilter filter = new IntentFilter();
		filter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
		registerReceiver(receiver, filter);
	}
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		onEnterFrame();
	}
	public void onEnterFrame()
	{
		 ConnectivityManager connectivityManager=(ConnectivityManager) this.getSystemService(Context.CONNECTIVITY_SERVICE);
		 NetworkInfo net=connectivityManager.getActiveNetworkInfo();
		if( uselocal  || (net != null && net.isConnected()) )
		{
			if ( UserInfoManager.getInstance(MainActivity.this).getItem("m_auth") != null ) {
				downloadPicTask();
			}else
			{
//				new AlertDialog.Builder(this).setMessage("请登录你的family账号！").setNeutralButton("确定", new DialogInterface.OnClickListener() {
//					
//					@Override
//					public void onClick(DialogInterface dialog, int which) {
//						// TODO Auto-generated method stub
//						showLoginDialog();
//					}
//				}).create().show();
				showLoginDialog();
			}
		}else
		{
			netErrorDialog.show();
		}
	}
	public boolean uselocal = false;
	private boolean loadListTaskFlag = false;
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	private AlertDialog loginAlertDialog 		= null;
	private View dialog_login 						= null;
	private EditText dialog_etUser 					= null;
	private EditText dialog_etPw 					= null;
	
//	public void createLoginDialog()
//	{
//		View loginView 				= getLayoutInflater().inflate(R.layout.activity_signin, null);
//		dialog_login					= loginView.findViewById(R.id.signin_btnSignIn);
//		dialog_etUser 					= (EditText)loginView.findViewById(R.id.signin_etUser);
//		dialog_etPw					= (EditText)loginView.findViewById(R.id.signin_etPw);
//		loginAlertDialog 			= new AlertDialog.Builder(this).setView(loginView).create();
//		dialog_login.setOnClickListener(onClickListener);
//	}
	Animation loginViewAnimation = null;
	public void showLoginDialog()
	{
		loginView.setVisibility(View.VISIBLE);
		if ( loginViewAnimation == null ) {
			loginViewAnimation = new AlphaAnimation(0.0f, 1.0f);
			loginViewAnimation.setDuration(2000);
		}
		loginView.startAnimation(loginViewAnimation);
	}
	DialogInterface.OnClickListener dialogOnClickListener = new DialogInterface.OnClickListener() {
		
		@Override
		public void onClick(DialogInterface dialog, int which) {
			// TODO Auto-generated method stub
			
		}
	};
	String username;
	String password;
	public boolean isLegalInput()
	{
		username = dialog_etUser.getText().toString().trim();
		if ( username.length() == 0 ) {
			Toast.makeText(this, getResources().getString(R.string.tips_login_nameinput), Toast.LENGTH_SHORT).show();
			return true;
		}
		password = dialog_etPw.getText().toString().trim();
		if ( password.length() == 0 ) {
			Toast.makeText(this, getResources().getString(R.string.tips_login_pwinput), Toast.LENGTH_SHORT).show();
			return true;
		}
		if ( password.length() < 6 ) {
			Toast.makeText(this, getResources().getString(R.string.tips_login_pwinput2), Toast.LENGTH_SHORT).show();
			return true;
		}
		return false;
	}
	public void loginTask()
	{
		if (  !isLegalInput() ) {
			mProgressDialog.show();
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					// TODO Auto-generated method stub
					String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_login), username, password);
					Message msg = handler.obtainMessage(1);
					msg.obj = responString;
					handler.sendMessage(msg);
				}
			}).start();
		}
	}
	OnClickListener onClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if ( v == mBtnLoginDialog) {
//				showLoginDialog();
			}else if( v == dialog_login )
			{
//				loginAlertDialog.hide();
				loginTask();
			}else if( v == wifiView )
			{
				openWifiLogin();
			}
		}
	};
	public void openWifiLogin()
	{
		Intent intent = new Intent();
		intent.setClass(MainActivity.this, WifiLoginActivity.class);
		startActivity(intent);
	}
	Handler handler = new Handler()
	{
		public void handleMessage(android.os.Message msg) {
			int what = msg.what;
			try {
				switch (what) {
				case 1:
					// 登录
					mProgressDialog.hide();
					JSONObject object = new JSONObject((String)msg.obj);
					if ( 0 == object.optInt("error", -1)) {
						if ( 1 == object.getJSONObject("data").getInt("return") )
						{
							// save m_auth
							Componet m_authComponet = new Componet("m_auth");
							m_authComponet.setValue(object.getJSONObject("data").getString("m_auth"));
							// save name
							Componet nameComponet = new Componet("name");
							nameComponet.setValue(object.getJSONObject("data").getString("name"));
							// save avatar
							Componet avatarComponet = new Componet("avatar");
							avatarComponet.setValue(object.getJSONObject("data").getString("avatar"));
							// save username
							Componet usernameComponet = new Componet("username");
							usernameComponet.setValue(object.getJSONObject("data").getString("username"));
							// save uid
							Componet uidComponet = new Componet("uid");
							uidComponet.setValue(object.getJSONObject("data").getString("uid"));
							// save vip
							Componet vipComponet = new Componet("vip");
							vipComponet.setValue(object.getJSONObject("data").getString("vipstatus"));
							
							Componet preLoginUsername = UserInfoManager.getInstance(MainActivity.this).getItem("username");
							if( preLoginUsername != null &&
									! usernameComponet.getValue() .
									equals( preLoginUsername.getValue()))
							{
								// 与上一次登录不同
								ModelDataMgr.getInstance().clear();
							}
							UserInfoManager.getInstance(MainActivity.this).add(m_authComponet);
							UserInfoManager.getInstance(MainActivity.this).add(nameComponet);
							UserInfoManager.getInstance(MainActivity.this).add(avatarComponet);
							UserInfoManager.getInstance(MainActivity.this).add(usernameComponet);
							UserInfoManager.getInstance(MainActivity.this).add(uidComponet);
							UserInfoManager.getInstance(MainActivity.this).add(vipComponet);
//							Componet tempComponet = UserInfoManager.getInstance(SignInActivitiy.this).getItem("m_auth");
//							if ( tempComponet  != null ) {
////								UserInfoManager.getInstance(SignInActivitiy.this).delete(tempComponet);
//								tempComponet.setValue(m_authComponet.getValue());
//								Log.v("test", "xiugai:"+m_authComponet.getValue());
//							}else
//							{
//								UserInfoManager.getInstance(SignInActivitiy.this).add(m_authComponet);
//								Log.v("test", "new mauth:"+m_authComponet.getValue());
//							}
							UserInfoManager.getInstance(MainActivity.this).saveAll();
							FamilyDayVerPMApplication.bindJpush(MainActivity.this, uidComponet.getValue());
//							loginAlertDialog.hide();
							downloadPicTask();
						}
					}
					break;

				default:
					break;
				}
			} catch (Exception e) {
				// TODO: handle exception
			}
		
		};
	};
	public AlertDialog netErrorDialog = null;
//	boolean uselocal = false;
	public  void notifyWifiChange()
	{
		if( uselocal )
		{
			return;
		}
		if( NetHelper.isNetAble(this) )
		{
			if( netErrorDialog != null && netErrorDialog.isShowing() )
			{
				netErrorDialog.hide();
				onEnterFrame();
			}
			return;
		}else
		{
			if( netErrorDialog.isShowing() )
			{
				netErrorDialog.setTitle( conMan.getNetworkInfo(ConnectivityManager.TYPE_WIFI).getState().toString() );
				return;
			}else
			{
				netErrorDialog.show();
			}
			
		}
	}
	public void downloadPicTask()
	{
//		loadListTask(true);
		Intent intent = new Intent();
		intent.setClass(this, PhotoFrameActivity.class);
		intent.putExtra("uselocal", uselocal);
		startActivity(intent);
	}
}
