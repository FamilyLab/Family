package com.ze.familydayverpm;

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
import com.ze.familydayverpm.adapter.NeedConfirmListViewAdapter;
import com.ze.familydayverpm.adapter.PhoneListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.R.integer;
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
import android.widget.Toast;

public class NeedConfirmActivity extends Activity {
		private			ListView 					mListView;
		private 			NeedConfirmListViewAdapter			mAdapter;
		private 			List<Map<String, Object>> mList;
		private 			View 					mBtnBack;
		private			TextView				mNameTextView;
		private			TextView				mTotalTextView;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_needconfirm);
			mListView 					= (ListView)findViewById(R.id.needconfirm_listview);
			mNameTextView 		= (TextView)findViewById(R.id.needconfirm_name);
			mNameTextView.setText(UserInfoManager.getInstance(NeedConfirmActivity.this).getItem("name").getValue());
			mTotalTextView			= (TextView)findViewById(R.id.needconfirm_total);
			mTotalTextView.setText(String.format(getResources().getString(R.string.total_number), "0"));
			mBtnBack					= findViewById(R.id.needconfirm_back);
			mBtnBack.setOnClickListener(buttonClickListener);
			mList							= new ArrayList<Map<String,Object>>();
//			Map<String ,Object> map;
//			map = new HashMap<String, Object>();
//			map.put(NeedConfirmListViewAdapter.flag[0],null );
//			map.put(NeedConfirmListViewAdapter.flag[1],"成语接龙" );
//			mList.add(map);
//			map = new HashMap<String, Object>();
//			map.put(NeedConfirmListViewAdapter.flag[0],null );
//			map.put(NeedConfirmListViewAdapter.flag[1],"唐诗三百首" );
//			mList.add(map);
//			map = new HashMap<String, Object>();
//			map.put(NeedConfirmListViewAdapter.flag[0],null );
//			map.put(NeedConfirmListViewAdapter.flag[1],"大名人小故事" );
//			mList.add(map);
//			map = new HashMap<String, Object>();
//			map.put(FamilyListViewAdapter.flag[0],null );
//			map.put(FamilyListViewAdapter.flag[1],"成语接龙" );
//			map.put(FamilyListViewAdapter.flag[2],"10月1日");
//			mList.add(map);
//			map = new HashMap<String, Object>();
//			map.put(NeedConfirmListViewAdapter.flag[0],null );
//			map.put(NeedConfirmListViewAdapter.flag[1],"明朝那些事儿" );
//			mList.add(map);
//			map = new HashMap<String, Object>();
//			map.put(NeedConfirmListViewAdapter.flag[0],null );
//			map.put(NeedConfirmListViewAdapter.flag[1],"扬帆起航" );
//			mList.add(map);
//			map = new HashMap<String, Object>();
//			map.put(NeedConfirmListViewAdapter.flag[0],null );
//			map.put(NeedConfirmListViewAdapter.flag[1],"电脑报" );
//			mList.add(map);
			mAdapter = new NeedConfirmListViewAdapter(this, mList);
			mListView.setAdapter(mAdapter);
			mListView.setOnItemClickListener(itemClickListener);
			
			mProgressDialog = new ProgressDialog(this);
			mProgressDialog.setMessage(getResources().getString( R.string.dialog_msg_load) );
			loadRequstTask();
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
		private ProgressDialog mProgressDialog;
		
		public void onConfirmed()
		{
			mTotalTextView.setText(String.format( getResources().getString(R.string.total_number),mList.size() + "") );
		}
		public void loadRequstTask()
		{
			new AsyncTask<String, String, String> (){
				protected void onPreExecute() {
					mProgressDialog.show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_request_family),
							UserInfoManager.getInstance(NeedConfirmActivity.this).getItem("m_auth").getValue() );
					return respon;
				}
				protected void onPostExecute(String result) {
					if (mProgressDialog.isShowing()) {
						mProgressDialog.hide();
					}
					try {
						JSONObject object = new JSONObject(result);
						if ( object.getInt("error") == 0 ) {
							object = object.getJSONObject("data");
							JSONArray array = object.getJSONArray("requestlist");
							int size = array == null ? 0 : array.length();
							mTotalTextView.setText(String.format(getResources().getString(R.string.total_number), size + ""));
							JSONObject temp;
							Map<String, Object> map;
							for (int i = 0; i < size; i++) {
								temp = array.getJSONObject(i);
								map = new HashMap<String, Object>();
								map.put(NeedConfirmListViewAdapter.flag[0], LoadImageMgr.getInstance().getMiddleHead( temp.getString("avatar")) );
								map.put(NeedConfirmListViewAdapter.flag[1], temp.getString("name"));
//								map.put(FamilyListViewAdapter.flag[2], temp.getString("phone"));
								map.put(NeedConfirmListViewAdapter.flag[2], temp.getString("uid"));
								map.put(NeedConfirmListViewAdapter.flag[3], temp.getString("vipstatus"));
								
//								temp.getString("name");
//								temp.getString("avatar");
//								temp.getString("dateline");
//								temp.getString("phone");
								mList.add(map);
							}
							if( size == 0 )
							{
								Toast.makeText(NeedConfirmActivity.this, R.string.tips_msg_nodata, Toast.LENGTH_SHORT).show();
							}
							mAdapter.notifyDataSetChanged();
						}
					} catch (Exception e) {
						// TODO: handle exception
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
				intent.setClass(NeedConfirmActivity.this, UserInfoActivity.class);
				NeedConfirmActivity.this.startActivity(intent);
			}
			
		};
		private OnClickListener buttonClickListener = new OnClickListener(){

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if( v == mBtnBack )
				{
						NeedConfirmActivity.this.finish();
				}
			}
			
		};
}
