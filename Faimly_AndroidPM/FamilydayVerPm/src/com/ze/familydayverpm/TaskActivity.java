package com.ze.familydayverpm;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.adapter.TaskInfoAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class TaskActivity extends Activity {
	
	private ListView 					mListView;
	private List<Map<String, Object>>	mList;
	private BaseAdapter					mAdapter;
	private ProgressDialog 				mDialog;
	private AlertDialog 				mAlertDialog;
	private View							mBack;
	private int[] 						mItemIds = {
			R.id.task_item_icon,
			R.id.task_item_title,
			R.id.task_item_context,
			R.id.task_item_finish
	};
	public static String[] 			taskEngineFlags = 
		{"head","title","context","finish","taskid"};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.task_layout);
		mBack = findViewById(R.id.task_back);
		mBack.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				TaskActivity.this.finish();
			}
		});
		mListView = (ListView)findViewById(R.id.task_listview);
		mList = new ArrayList<Map<String,Object>>();
		mAdapter = new TaskInfoAdapter(this, mList, R.layout.task_list_item, taskEngineFlags, mItemIds);
		mListView.setOnItemClickListener(onItemClickListener);
		mListView.setAdapter(mAdapter);
		mDialog = new ProgressDialog(this);
		mDialog.setMessage("正在载入数据");
		mDialog.setCanceledOnTouchOutside(false);
		mDialog.show();
		
		mAlertDialog = new Builder(this).setTitle("你还没有完成任务").setNegativeButton("以后再说", null).create();
		
		task_refresh();
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
	void task_refresh()
	{
		new AsyncTask<String	, String, String>() {

			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_task), 
						UserInfoManager.getInstance(TaskActivity.this).getItem("m_auth").getValue());
				return responString;
			}
			protected void onPostExecute(String result) {
				if (mDialog.isShowing()) {
					mDialog.hide();
				}
				try {
					JSONObject object = new JSONObject(result);
					if( object.getInt("error") == 0 )
					{
//						object = object.getJSONObject("data").getJSONObject("tasklist");
//						Iterator<?> it = object.keys();
//						String name;
//						JSONObject temp ;
//						Map<String, Object> dataMap;
//						while( it.hasNext() ){
//							//遍历JSONObject  
//							name = (String) it.next().toString();  
//							temp = object.getJSONObject(name);  
//			                dataMap = new HashMap<String, Object>();
//			                dataMap.put(taskEngineFlags[4], temp.getString("taskid"));
//			                dataMap.put(taskEngineFlags[1], temp.getString("name"));
//			                dataMap.put(taskEngineFlags[2], temp.getString("note"));
//			                dataMap.put(taskEngineFlags[0], temp.getString("image"));
//			                dataMap.put(taskEngineFlags[3], temp.getInt("done") );
//			                mList.add(dataMap);
//			            }  
						JSONArray array = object.getJSONObject("data").getJSONArray("tasklist");
						int length = array.length();
						Map<String, Object> dataMap;
						JSONObject temp;
						for (int i = 0; i < length; i++) {
							temp = array.getJSONObject(i);
							 dataMap = new HashMap<String, Object>();
			                dataMap.put(taskEngineFlags[4], temp.getString("taskid"));
			                dataMap.put(taskEngineFlags[1], temp.getString("name"));
			                dataMap.put(taskEngineFlags[2], temp.getString("note"));
			                dataMap.put(taskEngineFlags[0], temp.getString("image"));
			                dataMap.put(taskEngineFlags[3], temp.getInt("done") );
			                mList.add(dataMap);
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
	
	private ProgressDialog progressDialog ;
	void task_getReward(final String id,final int position)
	{
		
	}
	
	void task_isFinish(final String id,final int index)
	{
		
	}
	private OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
				long arg3) {
			// TODO Auto-generated method stub
			task_isFinish((String)mList.get(arg2).get("taskid"),arg2);
		}
	};
}
