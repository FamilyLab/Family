package com.ze.familydayverpm;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
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
import com.ze.familydayverpm.adapter.DialogListViewAdapter;
import com.ze.familydayverpm.adapter.SpaceListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.ModelDataMgr;
import com.ze.model.SpaceModel;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources.NotFoundException;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

public class SpaceActivity extends Activity {
	private List<Map<String, Object>> 	mList;
	private ListView										mListView;
	private View											mBtnBack;
	private SpaceListViewAdapter								mAdapter;
	private ProgressDialog							mProgressDialog;
	private String 										mUserUid;	
	private View											mFootView;
	private boolean 									mIsBottom;
	private View 											mAddView;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_space);
		mAddView = findViewById(R.id.space_add);
		mAddView.setOnClickListener(buttonClickListener);
		mUserUid = getIntent().getStringExtra("uid");
		if (mUserUid == null) {
			mUserUid = "";
		}else
		{
			mAddView.setVisibility(View.INVISIBLE);
		}
		mBtnBack = findViewById(R.id.space_back);
		mBtnBack.setOnClickListener(buttonClickListener);
		mProgressDialog = new ProgressDialog(this);
		mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
		mProgressDialog.setCanceledOnTouchOutside(false);
		mFootView = getLayoutInflater().inflate(R.layout.dialog_listview_head, null);
		mListView = (ListView)findViewById(R.id.space_listview);
		mListView.addFooterView( mFootView );
		mFootView.setVisibility(View.INVISIBLE);
		
		mList = new ArrayList<Map<String,Object>>();
		mAdapter = new SpaceListViewAdapter(this, mList);
		
		mListView.setAdapter(mAdapter);
		mListView.setOnItemClickListener(itemClickListener);
		mListView.setOnScrollListener(new OnScrollListener() {
			
			@Override
			public void onScrollStateChanged(AbsListView view, int scrollState) {
				// TODO Auto-generated method stub
				if (mIsBottom && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE ) {
					if( mListView.getFooterViewsCount() != 0 )
						loadTask();
				}
			}
			
			@Override
			public void onScroll(AbsListView view, int firstVisibleItem,
					int visibleItemCount, int totalItemCount) {
				// TODO Auto-generated method stub
				if ( firstVisibleItem + visibleItemCount == totalItemCount && totalItemCount > 0) {
					mIsBottom = true;
				}else
				{
					mIsBottom = false;
				}
			}
		});
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
	private boolean isLoading =false;
	public void loadTask()
	{
		if( isLoading )
		{
			Toast.makeText(this, R.string.tips_msg_has_run, Toast.LENGTH_SHORT).show();
			return;
		}
		new AsyncTask<String, String, String>(){
			protected void onPreExecute() {
				isLoading = true;
				if ( mList.size() == 0 ) {
					mProgressDialog.show();
				}else
				{
					mFootView.setVisibility(View.VISIBLE);
				}
				
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String responString = null;
				int size = mList.size() / PublicInfo.PER_LOAD + 1;
				if (NetHelper.isNetAvailable(SpaceActivity.this)) {
					responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_zone_list), 
							UserInfoManager.getInstance(SpaceActivity.this).getItem("m_auth").getValue()
							,size+"",mUserUid);
				}else
				{
					responString =  ( (SpaceModel)ModelDataMgr.getInstance().
							getModel(ModelDataMgr.SPACE_FILE_NAME, ModelDataMgr.SPACE_DIR) ).jsonarray;
				}
				 
				return responString;
			}
			protected void onPostExecute(String result) {
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
				isLoading = false;
				if( result == null || result.equals("") ) 
				{
					Toast.makeText(SpaceActivity.this, getResources().getString(R.string.dialog_msg_nomoredata),Toast.LENGTH_SHORT).show();
					return;
				}
				mFootView.setVisibility(View.INVISIBLE);
				try {
					JSONObject jsonObject = new JSONObject(result);
					if ( 0 == jsonObject.getInt("error") )
					{
						JSONArray array = jsonObject.getJSONObject("data").getJSONArray("spacelist");
						int size = array.length();
						JSONObject temp;
						Map<String, Object> object;
						for (int i = 0; i < size; i++) {
							temp = array.getJSONObject(i);
							object = new HashMap<String, Object>();
							object.put(mAdapter.flag[0],LoadImageMgr.getInstance().getSpacePagePic( temp.getString("pic")) );
							object.put(mAdapter.flag[1], temp.getString("tagname"));
							object.put(mAdapter.flag[2], temp.getString("tagid"));
							object.put(mAdapter.flag[3], 1);
//							if( mUserUid.equals("") ){
//								mList.add(mList.size() == 0 ? 0 : mList.size()-1,object);
//							}else
//							{
							mList.add(object);
//							}
						}
						if( size < PublicInfo.PER_LOAD )
						{
							mListView.removeFooterView(mFootView);
						}
//						if( mUserUid.equals("") && mList.size() <= PublicInfo.PER_LOAD ){
//							object = new HashMap<String, Object>();
//							object.put(mAdapter.flag[3], 0);
//							mList.add(object);
//						}
						ModelDataMgr.getInstance().spaceJsonArrayString.jsonarray = result;
						ModelDataMgr.getInstance().saveModel(ModelDataMgr.getInstance().spaceJsonArrayString, 
								ModelDataMgr.SPACE_DIR);
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
				SpaceActivity.this.finish();
			}else if( v == mAddView )
			{
				showCreateDialog();
			}
		}
	};
	private EditText spaceEditText = null;
	private AlertDialog spaceDialog = null;
	public void showCreateDialog()
	{
		if( spaceDialog == null )
		{
			spaceEditText = new EditText(this);
			spaceEditText.setHint(getResources().getString(R.string.dialog_hint_create_space));
			spaceEditText.setHeight(160);
			spaceDialog =  new Builder(this).setTitle(getResources().getString(R.string.space_add)).
				setView(spaceEditText).setNegativeButton(getString(R.string.dialog_button_cancel), dialogClickListener).
				setPositiveButton(getResources().getString(R.string.create), dialogClickListener).create();
		}
		spaceDialog.show();
	}
	private android.content.DialogInterface.OnClickListener dialogClickListener = new 
			android.content.DialogInterface.OnClickListener() {
		
		@Override
		public void onClick(DialogInterface dialog, int which) {
			// TODO Auto-generated method stub
			if (which == DialogInterface.BUTTON_POSITIVE) {
				
				createSpaceTask();
			}
		}
	};
	public void createSpaceTask()
	{
		final String tagName = spaceEditText.getText().toString().trim();
		if ( tagName.length() < 1 ) {
			Toast.makeText(this, getResources().getString(R.string.tips_input_less0), Toast.LENGTH_SHORT).show();
			return;
		}
		new AsyncTask<String, String, String>(){
			protected void onPreExecute() {
				InputMethodManager imm=(InputMethodManager)SpaceActivity.this.getSystemService(Context.INPUT_METHOD_SERVICE); 
				imm.hideSoftInputFromWindow(spaceEditText.getWindowToken(), 0);
				mProgressDialog.show();
				Toast.makeText(SpaceActivity.this, getResources().getString(R.string.tips_sending), Toast.LENGTH_SHORT).show();
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String responString = null ;
				try {
					responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_create_space),
							URLEncoder.encode(tagName, "utf-8"),
							UserInfoManager.getInstance(SpaceActivity.this).getItem("m_auth").getValue());
				} catch (NotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return responString;
			}
			protected void onPostExecute(String result) {
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
				try {
					JSONObject object = new JSONObject(result);
					if ( object.getInt("error") == 0 ) {
						JSONObject temp = object.getJSONObject("data");
						Map<String, Object> newTagMap = new HashMap<String, Object>();
						newTagMap.put(mAdapter.flag[0],temp.getString("default_image"));
						newTagMap.put(mAdapter.flag[1], temp.getString("tagname"));
						newTagMap.put(mAdapter.flag[2], temp.getString("tagid"));
						newTagMap.put(mAdapter.flag[3], 1);
//						mList.add(mList.size()-1, newTagMap);
						mList.add(0,newTagMap);
						spaceEditText.setText("");
						mAdapter.notifyDataSetChanged();
						Toast.makeText(SpaceActivity.this, getResources().getString(R.string.tips_create_success), Toast.LENGTH_SHORT).show();
						return;
					}
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
				Toast.makeText(SpaceActivity.this, getResources().getString(R.string.error_net), Toast.LENGTH_SHORT).show();
			};
		}.execute("");
			
		
	}
	private OnItemClickListener itemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
				long arg3) {
			// TODO Auto-generated method stub
//			if( arg2 == mList.size()-1 && mUserUid.equals(""))
//			{
//				// TODO create new space
//				showCreateDialog();
//				return;
//			}
			Intent intent = new Intent();
			intent.putExtra("tagid", (String)mList.get(arg2).get(mAdapter.flag[2]) );
			intent.putExtra("uid", mUserUid);
			intent.setClass(SpaceActivity.this, SpaceDetailActivity.class);
			SpaceActivity.this.startActivity(intent);
		}
	};
}
