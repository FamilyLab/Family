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
import com.ze.familydayverpm.adapter.DialogDetailListViewAdapter;
import com.ze.familydayverpm.adapter.DialogListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.res.Resources.NotFoundException;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class DialogDetailActivity extends Activity {
	private List<Map<String, Object>> 	mList;
	private ListView										mListView;
	private View											mBtnBack;
	private BaseAdapter								mAdapter;
	private TextView									mTopName;
	
	private String 										mMsgToName;
	private String 										mMsgToPic;
	private String 										mMsgToPicVip;
	private String 										mSelfPic;
	private String 										mSelfPicVip;
	public String 											mMsgToUid;
	private EditText										mEtSay;
	private ProgressDialog							mProgressDialog;
	private Button 										mBtnSend;
	private int 												listViewLastItem;
	private View											mHeadView;
	public static boolean 							inDetailView = false;
	public static DialogDetailActivity			DialogDetailInstance = null;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_dialog_detail);
		DialogDetailInstance = this;
		mMsgToName 		= getIntent().getStringExtra(DialogListViewAdapter.flag[1]);
		mMsgToUid  			= getIntent().getStringExtra(DialogListViewAdapter.flag[4]);
		mProgressDialog 	= new ProgressDialog(this);
		mProgressDialog.setCanceledOnTouchOutside(false);
		mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
		mBtnBack = findViewById(R.id.dialog_detail_back);
		mBtnBack.setOnClickListener(buttonClickListener);
		mTopName = (TextView)findViewById(R.id.dialog_detail_object);
		mTopName.setText(mMsgToName);
		mHeadView = getLayoutInflater().inflate(R.layout.dialog_listview_head, null);
		mListView = (ListView)findViewById(R.id.dialog_detail_listview);
		mList = new ArrayList<Map<String,Object>>();
		
		mAdapter = new DialogDetailListViewAdapter(this, mList);
		mListView.addHeaderView(mHeadView);
		mListView.setAdapter(mAdapter);
		mEtSay = (EditText)findViewById(R.id.dialog_detail_etSay);
		loadTask();
		
		mBtnSend = (Button)findViewById(R.id.dialog_detail_send);
		mBtnSend.setOnClickListener(buttonClickListener);
		mSelfPicVip = UserInfoManager.getInstance(DialogDetailActivity.this).getItem("vip").getValue();
		mListView.setOnScrollListener(new OnScrollListener() {
			
			@Override
			public void onScrollStateChanged(AbsListView view, int scrollState) {
				// TODO Auto-generated method stub
				if ( firstVisible == 0 && scrollState == OnScrollListener.SCROLL_STATE_IDLE)
				{
					// 进行翻页操作+
				if(	 mListView.getHeaderViewsCount() == 0 )
				{
//					Toast.makeText(DialogDetailActivity.this, R.string.tips_msg_nodata, Toast.LENGTH_SHORT).show();
				}else
				{
					loadTask();
				}
							
				
//					Toast.makeText(DialogDetailActivity.this, "h", Toast.LENGTH_SHORT).show();
				}
			}
			
			@Override
			public void onScroll(AbsListView view, int firstVisibleItem,
					int visibleItemCount, int totalItemCount) {
				// TODO Auto-generated method stub
				// 当listView中没有数据，或者数据超过100条，或者不是10的整数倍（即数据不足）时隐藏“更多”并取消onScroll事件的绑定
//				if (ma.getCount() % 10 > 0 || arrayAdapter.getCount() == 0)
//				{
//					listView.removeFooterView(listViewLoadingView);
//					listView.setOnScrollListener(null);
//				}
				firstVisible = firstVisibleItem;
				if( firstVisibleItem == 0 )
				{
//					Toast.makeText(DialogDetailActivity.this, "h", Toast.LENGTH_SHORT).show();
				}
			}
		});
	}

	@Override
	protected void onStop() {
		// TODO Auto-generated method stub
		super.onStop();
		inDetailView = false;
	}
	public boolean isEqualCurrentUid( String uid_a )
	{
		return mMsgToUid.equals(uid_a);
	}
	public void updateFromPushData(Bundle bundle)
	{
		String uidString = bundle.getString("uid");
		if (uidString.equals(mMsgToUid)) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put(DialogDetailListViewAdapter.flag[0], mMsgToPic);
			map.put(DialogDetailListViewAdapter.flag[1], bundle.getString("msg"));
			map.put(DialogDetailListViewAdapter.flag[2], System.currentTimeMillis()/1000 + "");
			map.put(DialogDetailListViewAdapter.flag[3], 0);
			map.put(DialogDetailListViewAdapter.flag[4], mMsgToPicVip);
			mList.add(map);
			mAdapter.notifyDataSetChanged();
			mListView.setSelection(mList.size()-1);
		}
	}
		
	@Override
	public void onResume() {
	    super.onResume();
	    inDetailView = true;
	    MobclickAgent.onResume(this);
	}
	@Override
	public void onPause() {
	    super.onPause();
	    MobclickAgent.onPause(this);
	}
	public int firstVisible = -1;
	public void sendMsgTask()
	{
		final String msg = mEtSay.getText().toString().trim();
		if (msg.length() < 1 ) {
			Toast.makeText(this, getResources().getString(R.string.tips_input_less0), Toast.LENGTH_SHORT).show();
			return;
		}
		new AsyncTask<String, String, String>()
		{
			Map<String, Object> map;
			protected void onPreExecute() {
//				mProgressDialog.show();
				InputMethodManager immInputMethodManager = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
				immInputMethodManager.hideSoftInputFromWindow(DialogDetailActivity.this.getCurrentFocus().getWindowToken(), 0);
				
				 map = new HashMap<String, Object>();
				map.put(DialogDetailListViewAdapter.flag[0], mSelfPic);
				map.put(DialogDetailListViewAdapter.flag[1], msg);
				map.put(DialogDetailListViewAdapter.flag[2],  "0");
				map.put(DialogDetailListViewAdapter.flag[3], 1);
				map.put(DialogDetailListViewAdapter.flag[4], mSelfPicVip);
				mList.add(map);
				mAdapter.notifyDataSetChanged();
				mEtSay.setText("");
				mListView.setSelection(mList.size()-1);
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String responString = null;
				try {
					responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_send_msg), 
							mMsgToUid, "",UserInfoManager.getInstance(DialogDetailActivity.this).getItem("m_auth").getValue(),
							URLEncoder.encode(msg, "utf-8"),"android");
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
//				if (mProgressDialog.isShowing()) {
//					mProgressDialog.hide();
//				}
				try {
					JSONObject object = new JSONObject(result);
					if (object.getInt("error") == 0) {
//						Map<String, Object> map = new HashMap<String, Object>();
//						map.put(DialogDetailListViewAdapter.flag[0], mSelfPic);
//						map.put(DialogDetailListViewAdapter.flag[1], msg);
//						map.put(DialogDetailListViewAdapter.flag[2], System.currentTimeMillis()/1000 + "");
//						map.put(DialogDetailListViewAdapter.flag[3], 1);
//						map.put(DialogDetailListViewAdapter.flag[4], mSelfPicVip);
//						
//						mList.add(map);
						if( map != null )
						{
							map.put(DialogDetailListViewAdapter.flag[2], System.currentTimeMillis()/1000 + "");
						}
						mAdapter.notifyDataSetChanged();
//						mEtSay.setText("");
//						mListView.setSelection(mList.size()-1);
					}else
					{
						if( map != null )
						{
							map.put(DialogDetailListViewAdapter.flag[2],  "-1");
						}
						mAdapter.notifyDataSetChanged();
						
						String errorMsg = object.getString("msg");
						if (errorMsg != null || !errorMsg.equals("")) {
							Toast.makeText(DialogDetailActivity.this,errorMsg, Toast.LENGTH_SHORT).show();
						}else
						{
							Toast.makeText(DialogDetailActivity.this, R.string.tips_msg_relax, Toast.LENGTH_SHORT).show();
						}
						
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			};
		}.execute("");
	}
	boolean isLoading = false;
	
	public void loadTask()
	{
		if( isLoading)
		{
			Toast.makeText(DialogDetailActivity.this, R.string.tips_msg_has_run, Toast.LENGTH_SHORT).show();
			return;
		}
		new AsyncTask<String, String, String>(){
			
			protected void onPreExecute() {
				if( mList.size() == 0 )
				{
					
//					mProgressDialog.show();
				}else
				{
//					mListView.addHeaderView(mHeadView);
				}
				
				isLoading = true;
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String endtime = mList.size() != 0 ? (String)mList.get( 0 ).get(DialogDetailListViewAdapter.flag[2]) : "";
				String respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_dialog_detail), 
						UserInfoManager.getInstance(DialogDetailActivity.this).getItem("m_auth").getValue(),
						mMsgToUid,endtime);
				return respon;
			}
			protected void onPostExecute(String result) {
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
				isLoading = false;
				
				try {
					JSONObject jsonObject = new JSONObject(result);
					if ( 0 == jsonObject.getInt("error") )
					{
						mMsgToPic 		= LoadImageMgr.getInstance().getMiddleHead( 
								jsonObject.getJSONObject("data").getJSONObject("touser").getString("avatar") );
						mMsgToPicVip 	= jsonObject.getJSONObject("data").getJSONObject("touser").getString("vipstatus") ;
						mSelfPic 				=  LoadImageMgr.getInstance().getMiddleHead( 
								jsonObject.getJSONObject("data").getJSONObject("fromuser").getString("avatar") );
						if(  ! jsonObject.getJSONObject("data").isNull("dialog") )
						{
							JSONArray array = jsonObject.getJSONObject("data").getJSONArray("dialog");
							int size = array.length();
							JSONObject temp;
							Map<String, Object> object;
							List<Map<String, Object>> dataList = new ArrayList<Map<String,Object>>();
							if( size < 5 )
							{
								mListView.removeHeaderView(mHeadView);
								Toast.makeText(DialogDetailActivity.this, R.string.tips_msg_finish_load, Toast.LENGTH_SHORT).show();
							}
							for (int i = 0; i < size; i++) {
								temp = array.getJSONObject(i);
								object = new HashMap<String, Object>();
								
								object.put(DialogDetailListViewAdapter.flag[1], temp.getString("message"));
								object.put(DialogDetailListViewAdapter.flag[2], temp.getString("dateline"));
								if (temp.getString("msgfromid").equals(mMsgToUid)) {
									object.put(DialogDetailListViewAdapter.flag[3], 0);
									object.put(DialogDetailListViewAdapter.flag[0], mMsgToPic);
									object.put(DialogDetailListViewAdapter.flag[4], mMsgToPicVip);
								}else
								{
									object.put(DialogDetailListViewAdapter.flag[3], 1);
									object.put(DialogDetailListViewAdapter.flag[0], mSelfPic);
									object.put(DialogDetailListViewAdapter.flag[4], mSelfPicVip);
								}
								dataList.add(object);
							}
							boolean isMore = mList.size() != 0 ;
							mList.addAll(0, dataList);
							mAdapter.notifyDataSetChanged();
							if ( !  isMore ) {
								mListView.setSelection(mList.size()-1);
							}else {
								mListView.setSelection(dataList.size()-1);
							}
						}else {
							mListView.removeHeaderView(mHeadView);
							Toast.makeText(DialogDetailActivity.this, R.string.tips_msg_finish_load, Toast.LENGTH_SHORT).show();
						}
					}else {
						mListView.removeHeaderView(mHeadView);
						Toast.makeText(DialogDetailActivity.this, R.string.error_net, Toast.LENGTH_SHORT).show();
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
				DialogDetailActivity.this.finish();
			}else if( v== mBtnSend)
			{
				sendMsgTask();
			}
		}
	};
}
