package com.ze.familydayverpm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.Inflater;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.adapter.BlogViewPagerAdapter;
import com.ze.familydayverpm.adapter.FamilyListViewAdapter;
import com.ze.familydayverpm.adapter.ViewPagerAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.BlogModel;
import com.ze.model.ModelDataMgr;
import com.ze.model.PhotoModel;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Matrix;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.FloatMath;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.WindowManager;
import android.webkit.WebView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import android.widget.Toast;

public class VideoActivity extends Activity {
	private 	Button 					mBtn_back;
	private 	WebView					mWebView;
	private 	String 						url;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_videowebview);
			url = getIntent().getStringExtra("url");
			mBtn_back 			= (Button)findViewById(R.id.videowebview_back);
			mBtn_back.setOnClickListener(ButtonListener);
			mWebView = (WebView)findViewById(R.id.videowebview_webview);
			mWebView.loadUrl(url);
		}
		
		@Override
		public void onResume() {
		    super.onResume();
		    MobclickAgent.onResume(this);
		}
		@Override
		public void onPause() {
		    super.onPause();
		    MobclickAgent.onPause(this);
		}
		private OnClickListener ButtonListener = new OnClickListener()
				{

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						if (v == mBtn_back) {
							VideoActivity.this.finish();
						}
					}
			
				};
				
}
