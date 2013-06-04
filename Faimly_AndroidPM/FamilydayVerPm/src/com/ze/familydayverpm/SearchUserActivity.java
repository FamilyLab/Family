package com.ze.familydayverpm;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.adapter.FamilyListViewAdapter;
import com.ze.familydayverpm.adapter.PhoneListViewAdapter;
import com.ze.familydayverpm.adapter.SearchListViewAdapter;
import com.ze.familydayverpm.adapter.SpaceListInDialogListViewAdapter;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.Contacts.People.Phones;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

public class SearchUserActivity extends Activity {
		private 			EditText						mEtSearch;
		private 			View 					mBtnBack;
		private 			View 					mBtnSearch;
		private 			ListView 					mListView;
		private 			BaseAdapter			mAdapter;
		private 			List<Map<String, Object> > mList;
//		private 			boolean 				mIsFromRegister;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_search);
			mEtSearch 			= (EditText)findViewById(R.id.search_etSearch);
			mBtnBack		    = findViewById(R.id.search_back);
			mBtnSearch		    = findViewById(R.id.search_btnSearch);
			mListView			=(ListView)findViewById(R.id.search_listview);
			mBtnBack.setOnClickListener(buttonClickListener);
			mBtnSearch.setOnClickListener(buttonClickListener);
			mList = new ArrayList<Map<String,Object>>();
			mAdapter 			= new SearchListViewAdapter(this, mList);
			mListView.setAdapter(mAdapter);
			mListView.setOnItemClickListener(itemClickListener);
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
		private OnItemClickListener itemClickListener = new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				// TODO Auto-generated method stub
				Intent intent = new Intent();
				intent.setClass(SearchUserActivity.this, UserInfoActivity.class);
				Map<String, Object> object = mList.get(arg2);
				intent.putExtra("head",(String)object.get(SearchListViewAdapter.flag[0]));
				intent.putExtra("name",(String)object.get(SearchListViewAdapter.flag[1]));
				intent.putExtra("id",(String)object.get("id"));
				intent.putExtra("vip",(String)object.get("vip"));
				startActivity(intent);
			}
		};
		private OnClickListener buttonClickListener = new OnClickListener(){

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if ( v == mBtnSearch ) {
					// 
					searchTask();
				}else if( v == mBtnBack )
				{
						SearchUserActivity.this.finish();
				}
			}
			
		};
		private ProgressDialog mProgressDialog;
		public void searchTask()
		{
			final String search = mEtSearch.getText().toString();
			if ( search.length() < 0 ) {
				Toast.makeText(SearchUserActivity.this, R.string.tips_input_less0, Toast.LENGTH_SHORT).show();
				return;
			}
				new AsyncTask<String, String, String> (){
					
					protected void onPreExecute() {
						if (mProgressDialog == null) {
							mProgressDialog = new ProgressDialog(SearchUserActivity.this);
							mProgressDialog.setMessage(getResources().getString( R.string.dialog_msg_load) );
						}
						mProgressDialog.show();
						InputMethodManager immInputMethodManager = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
						immInputMethodManager.hideSoftInputFromWindow(SearchUserActivity.this.getCurrentFocus().getWindowToken(), 0);
					};
				
					protected void onPostExecute(String result) {
						if( mProgressDialog.isShowing() )
						{
							mProgressDialog.hide();
						}
						try {
							JSONObject object = new JSONObject(result);
							object = object.getJSONObject("data");
							JSONArray array = object.getJSONArray("fmemberlist");
							int size = array.length();
							if ( size > 0) {
								JSONObject temp;
								Map<String, Object> map;
								mList.clear();
								for (int i = 0; i < size; i++) {
									temp = array.getJSONObject(i);
									map = new HashMap<String, Object>();
									map.put(SearchListViewAdapter.flag[0], LoadImageMgr.getInstance().getMiddleHead( temp.getString("avatar")) );
									map.put(SearchListViewAdapter.flag[1], temp.getString("name"));
									map.put(SearchListViewAdapter.flag[2], temp.getString("uid"));
									map.put(SearchListViewAdapter.flag[3], temp.getString("vipstatus"));
									map.put(SearchListViewAdapter.flag[4], temp.getInt("isfamily"));
									mList.add(map);
								}
							}else
							{
								Toast.makeText(SearchUserActivity.this, R.string.tips_msg_nodata, Toast.LENGTH_LONG).show();
							}
							mAdapter.notifyDataSetChanged();
						} catch (Exception e) {
							// TODO: handle exception
							e.printStackTrace();
						}
					}
	
					@Override
					protected String doInBackground(String... params) {
						// TODO Auto-generated method stub
						Componet componet = UserInfoManager.getInstance(SearchUserActivity.this).getItem("m_auth");
						if ( componet == null ) {
							return "";
						}
						String respon = "";
						try {
							respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_search),
									componet.getValue(),
									URLEncoder.encode(search, "utf-8"));
						} catch (Exception e) {
							// TODO: handle exception
							e.printStackTrace();
						}
						return respon;
					};
				}.execute("");
			}
}
