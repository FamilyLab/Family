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
import com.ze.familydayverpm.adapter.DialogListViewAdapter;
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
import android.widget.ListView;
import android.widget.Toast;

public class DialogActivity extends Activity {
	private List<Map<String, Object>> 	mList;
	private ListView										mListView;
	private View											mBtnBack;
	private BaseAdapter								mAdapter;
	private ProgressDialog							mProgressDialog;
//	public static  boolean 									mIsFromMain = true; //  检测activities栈有没有Main
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_dialog);
//		mIsFromMain = getIntent().getBooleanExtra("frommain", false);
		mBtnBack = findViewById(R.id.dialog_back);
		mBtnBack.setOnClickListener(buttonClickListener);
		mListView = (ListView)findViewById(R.id.dialog_listview);
		mProgressDialog = new ProgressDialog(this);
		mProgressDialog.setCanceledOnTouchOutside(false);
		mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
		mList = new ArrayList<Map<String,Object>>();
		mAdapter = new DialogListViewAdapter(this, mList);
		
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
	public void loadTask()
	{
		new AsyncTask<String, String, String>(){
			
			protected void onPreExecute() {
				if ( mList.size() == 0 ) {
					mProgressDialog.show();
				}else
				{
					Toast.makeText (DialogActivity.this, getResources().getString(R.string.dialog_msg_load),Toast.LENGTH_LONG).show();
				}
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_dialog_list), 
						UserInfoManager.getInstance(DialogActivity.this).getItem("m_auth").getValue());
				
				return respon;
			}
			
			protected void onPostExecute(String result) {
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
				try {
					JSONObject jsonObject = new JSONObject(result);
					if ( 0 == jsonObject.getInt("error") )
					{
						JSONArray array = jsonObject.getJSONArray("data");
						int size = array.length();
						JSONObject temp;
						Map<String, Object> object;
						mList.clear();
						String noteName ;
						for (int i = 0; i < size; i++) {
							temp = array.getJSONObject(i);
							object = new HashMap<String, Object>();
							object.put(DialogListViewAdapter.flag[0],LoadImageMgr.getInstance().getMiddleHead( temp.getString("msgtoavatar")) );
							noteName = temp.isNull("note")?"":
								( temp.getString("note").equals("")?"":"(" + temp.getString("note") + ")");
							object.put(DialogListViewAdapter.flag[1],temp.getString("msgtoname") + noteName);
							object.put(DialogListViewAdapter.flag[3], temp.getString("new"));
							object.put(DialogListViewAdapter.flag[4], temp.getString("touid"));
							object.put(DialogListViewAdapter.flag[5], temp.getString("vipstatus"));
							
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
	private OnClickListener buttonClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if ( v == mBtnBack ) {
				if( MainActivity.isExist )
					DialogActivity.this.finish();
				else {
					Intent intent = new Intent();
					intent.setClass(DialogActivity.this, MainActivity.class);
					startActivity(intent);
					DialogActivity.this.finish();
				}
			}
		}
	};
	private OnItemClickListener itemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
				long arg3) {
			// TODO Auto-generated method stub
			Intent intent = new Intent();
			intent.setClass(DialogActivity.this, DialogDetailActivity.class);
			intent.putExtra(DialogListViewAdapter.flag[1],(String)mList.get(arg2).get(DialogListViewAdapter.flag[1]) );
			intent.putExtra(DialogListViewAdapter.flag[4],(String)mList.get(arg2).get(DialogListViewAdapter.flag[4]) );
			DialogActivity.this.startActivity(intent);
			mList.get(arg2).put(DialogListViewAdapter.flag[3], "0");
			mAdapter.notifyDataSetChanged();
		}
	};
}
