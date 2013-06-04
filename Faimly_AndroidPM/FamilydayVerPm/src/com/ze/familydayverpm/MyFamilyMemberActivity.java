package com.ze.familydayverpm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.familydayverpm.adapter.FamilyListViewAdapter;
import com.ze.familydayverpm.adapter.PhoneListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

public class MyFamilyMemberActivity extends Activity {
		private			ListView 					mListView;
		private 			FamilyListViewAdapter			mAdapter;
		private 			List<Map<String, Object>> mList;
		private 			View 					mBtnBack;
		
		
		private 			ProgressDialog			mProgressDialog;
		private 			TextView						mName;
		private			TextView						mCount;
		private 			String 										mUserUid;	
		private 			String 							mUserName;
		private 			String 							mUserFamilyCount;
		private 			View							mFamilyAdd;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_myfamilymember);
			mUserUid = getIntent().getStringExtra("uid");
			if (mUserUid == null) {
				mUserUid = "";
			}
			mUserName = getIntent().getStringExtra("name");
			if (mUserName == null) {
				mUserName = UserInfoManager.getInstance(MyFamilyMemberActivity.this).getItem("name").getValue();
			}
			mUserFamilyCount = getIntent().getStringExtra("family");
			if (mUserFamilyCount == null) {
				mUserFamilyCount = "";
			}
			mListView 					= (ListView)findViewById(R.id.myfamilymember_listview);
			mBtnBack					= findViewById(R.id.myfamilymember_back);
			mBtnBack.setOnClickListener(buttonClickListener);
//			mFamilyAdd				= findViewById(R.id.myfamilymember_add);
//			mFamilyAdd.setOnClickListener(buttonClickListener);
//			if( !mUserUid.equals("") )
//			{
//				mFamilyAdd.setVisibility(View.INVISIBLE);
//			}
			mProgressDialog = new ProgressDialog(this);
			mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
			mProgressDialog.setCancelable(false);
			mList							= new ArrayList<Map<String,Object>>();
			mName 	= (TextView)findViewById(R.id.myfamilymember_selfname);
			mName.setText(mUserName);
			mCount  =(TextView)findViewById(R.id.myfamilymember_count);
			mCount.setText("共" + mUserFamilyCount  + "人");
			mAdapter = new FamilyListViewAdapter(this, mList);
			mListView.setAdapter(mAdapter);
			mListView.setOnItemClickListener(itemClickListener);
			loadTask();
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
		boolean isLoading = false;
		public void loadTask()
		{
			if( isLoading ){
				return;
			}
			new AsyncTask<String, String, String>(){
				protected void onPreExecute() {
					mProgressDialog.show();
					isLoading = true;
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
//					int page = mList.size() / PublicInfo.PER_LOAD + 1;
					String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_family_list), 
							UserInfoManager.getInstance(MyFamilyMemberActivity.this).getItem("m_auth").getValue()
							,mUserUid);
					return responString;
				}
				protected void onPostExecute(String result) {
					if (mProgressDialog.isShowing()) {
						mProgressDialog.hide();
					}
					try {
						JSONObject jsonObject = new JSONObject(result);
						if ( 0 == jsonObject.getInt("error") )
						{
							JSONObject dataObject =  jsonObject.getJSONObject("data");
							mName.setText(dataObject.getString("name"));
							mCount.setText("共" + dataObject.getString("fmembers")  + "人");
							JSONArray array = dataObject.getJSONArray("fmemberlist");
							int size = array.length();
							JSONObject temp;
							Map<String, Object> object;
							mList.clear();
							String noteName;
							
							for (int i = 0; i < size; i++) {
								temp = array.getJSONObject(i);
								object = new HashMap<String, Object>();
								object.put(FamilyListViewAdapter.flag[0],LoadImageMgr.getInstance().getMiddleHead( temp.getString("avatar") ) );
								object.put(FamilyListViewAdapter.flag[5], temp.getString("vipstatus") );
								noteName = temp.isNull("note")?"": temp.getString("note").equals("") ?  "" : "(" + temp.getString("note") + ")";
								object.put(FamilyListViewAdapter.flag[1],temp.getString("name")  );
								object.put(FamilyListViewAdapter.flag[2],temp.getString("birthday"));
								object.put(FamilyListViewAdapter.flag[3],temp.getString("uid"));
								object.put(FamilyListViewAdapter.flag[4],noteName);
								
								mList.add(object);
							}
							mAdapter.notifyDataSetChanged();
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				};
			}.execute("");
		}
		private OnItemClickListener itemClickListener = new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				// TODO Auto-generated method stub
				Intent intent = new Intent();
				Map<String, Object> object = mList.get(arg2);
				intent.putExtra(FamilyListViewAdapter.flag[0],(String)object.get(FamilyListViewAdapter.flag[0]));
				intent.putExtra(FamilyListViewAdapter.flag[1],(String)object.get(FamilyListViewAdapter.flag[1]));
				intent.putExtra(FamilyListViewAdapter.flag[2],(String)object.get(FamilyListViewAdapter.flag[2]));
				intent.putExtra(FamilyListViewAdapter.flag[3],(String)object.get(FamilyListViewAdapter.flag[3]));
				intent.putExtra(FamilyListViewAdapter.flag[4],(String)object.get(FamilyListViewAdapter.flag[4]));
				intent.setClass(MyFamilyMemberActivity.this, UserInfoActivity.class);
				MyFamilyMemberActivity.this.startActivity(intent);
			}
			
		};
		private OnClickListener buttonClickListener = new OnClickListener(){

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if( v == mBtnBack )
				{
						MyFamilyMemberActivity.this.finish();
				}else if( v == mFamilyAdd )
				{
					// TODO: add
				}
			}
			
		};
}
