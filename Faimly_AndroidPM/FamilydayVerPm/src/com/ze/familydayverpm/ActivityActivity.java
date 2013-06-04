package com.ze.familydayverpm;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

//import com.google.android.maps.MapActivity;
import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.adapter.ActivityViewPagerAdapter;
import com.ze.familydayverpm.adapter.ViewPagerAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.ActivityModel;
import com.ze.model.DataModel;
import com.ze.model.ModelDataMgr;
import com.ze.model.PhotoModel;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;

public class ActivityActivity extends FragmentActivity {
	private 	ViewPager 				mViewPager;
	private 	ActivityViewPagerAdapter  mviewAdapter;
	private 	Button 					mBtn_back;
	private 	Button 					mBtn_prev;
	private 	Button 					mBtn_next;
	JSONArray array ;
	
	private 	ProgressDialog		mProgressDialog;
	private 	static final int 				PAGER_SIZE = 10;
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		MobclickAgent.onResume(this);
	}
	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		 MobclickAgent.onPause(this);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.map_activity);
//		
//		mBtn_back 			= (Button)findViewById(R.id.activity_back);
//		mBtn_prev			= (Button)findViewById(R.id.activity_prev);
//		mBtn_next		    =  (Button)findViewById(R.id.activity_next);
//		mBtn_prev.setOnClickListener(ButtonListener);
//		mBtn_next.setOnClickListener(ButtonListener);
//		mBtn_back.setOnClickListener(ButtonListener);
//		mViewPager 		= (ViewPager)findViewById(R.id.activityViewPager);
//		array = new JSONArray();
//		
//		// TODO: test data
////		array.put(PicActivity.getJsonObject(R.drawable.example1));
////		array.put(PicActivity.getJsonObject(R.drawable.example2));
//		// end
//		mProgressDialog = new ProgressDialog(this);
//		mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
//		
//		if (NetHelper.isNetAvailable(this)) {
//			loadFeedTask(true);
//		}else
//		{
//			if( 0 < ModelDataMgr.getInstance().idActivityList.size() )
//			{ 
//				loadActivityDetailTask(ModelDataMgr.getInstance().idActivityList.get(0));
//			}else
//			{
//				loadFeedTask(false);
//			}
//		}
//		mBtn_prev.setVisibility(View.INVISIBLE);
//		mviewAdapter = new ActivityViewPagerAdapter(this, array);
//		mViewPager.setAdapter(mviewAdapter);
//		mViewPager.setOnPageChangeListener(new OnPageChangeListener() {
//			
//			@Override
//			public void onPageSelected(int arg0) {
//				// TODO Auto-generated method stub
//				// TODO: need download from server
//				
//				if( arg0 == 0 )
//				{
//					mBtn_prev.setVisibility(View.INVISIBLE);
//				}else {
//					if (mBtn_prev.getVisibility() == View.INVISIBLE) {
//						mBtn_prev.setVisibility(View.VISIBLE);
//					}
//				}
//				
//				
//				if ( arg0 == ModelDataMgr.getInstance().idActivityList.size() - 1) {
//					// 达到最后一张图片
//					mBtn_next.setVisibility(View.INVISIBLE);
//					loadFeedTask(false);
//				}else {
//					if (mBtn_next.getVisibility() == View.INVISIBLE) {
//						mBtn_next.setVisibility(View.VISIBLE);
//					}
//				}
//				
//			}
//			
//			@Override
//			public void onPageScrolled(int arg0, float arg1, int arg2) {
//				// TODO Auto-generated method stub
////				Log.v("test", "onPageScrolled:" + arg2);
//			}
//			
//			@Override
//			public void onPageScrollStateChanged(int arg0) {
//				// TODO Auto-generated method stub
//				
//			}
//		});
	}
	public void loadFeedTask(final boolean refresh)
	{
		if( ! refresh )
		{
			if( ModelDataMgr.getInstance().idActivityList.size() !=0 && ModelDataMgr.getInstance().idActivityList.size() %10 != 0 )
			{
				Toast.makeText(this, getResources().getString(R.string.dialog_msg_nomoredata), Toast.LENGTH_LONG).show();
				return;
			}
		}
		new AsyncTask<String, String, String>(){
			protected void onPreExecute() {
				mProgressDialog.show();
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String page = "1";
				if( !refresh )
				{
					page = ModelDataMgr.getInstance().idActivityList.size()/PAGER_SIZE + 1 + "";
				}
				String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_feedlist),
						"eventid",page,
						UserInfoManager.getInstance(ActivityActivity.this).getItem("m_auth").getValue());
				return responString;
			}
			protected void onPostExecute(String result) {
//				if (mProgressDialog.isShowing()) {
//					mProgressDialog.hide();
//				}
				try {
					JSONObject jsonObject = new JSONObject(result);
					if ( 0 == jsonObject.getInt("error") )
					{
						JSONArray jsonArray = jsonObject.getJSONArray("data");
						int size = jsonArray.length();
						JSONObject temp;
						if(refresh)
						{
							ModelDataMgr.getInstance().idActivityList.clear();
							array = new JSONArray();
							mviewAdapter = new ActivityViewPagerAdapter(ActivityActivity.this, array);
							mViewPager.setAdapter(mviewAdapter);
						}
						DataModel object ;
						for (int i = 0; i < size; i++) {
							temp = jsonArray.getJSONObject(i);
							//object.put(FamilyListViewAdapter.flag[0],temp.getString("avatar") );
							object = new DataModel();
							object.id = temp.getString("id");
							object.uid = temp.getString("uid");
							object.type = SpaceDetailActivity.DETAIL_EVNET;
							ModelDataMgr.getInstance().idActivityList.add(object);
						}
						if(ModelDataMgr.getInstance().idActivityList.size() > 0 )
						{
							loadActivityDetailTask(ModelDataMgr.getInstance().idActivityList.get(array.length()));
							ModelDataMgr.getInstance().saveIdList(ModelDataMgr.getInstance().idActivityList,ModelDataMgr.ACTIVITY_ID_LIST );
							mBtn_next.setVisibility(View.VISIBLE);
						}else
						{
							Toast.makeText(ActivityActivity.this, getResources().getString(R.string.dialog_msg_nomoredata), Toast.LENGTH_LONG).show();
						}
						
						
					}
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					if (mProgressDialog.isShowing()) {
						mProgressDialog.hide();
					}
					Toast.makeText(ActivityActivity.this, "error", Toast.LENGTH_LONG).show();
				}
				
			};
		}.execute("");
	}
	public void loadActivityDetailTask(final DataModel activityJsonObject)
	{
		new AsyncTask<String, String, ActivityModel>(){
			private boolean error = false;			// 读取操作中是否出错
			protected void onPreExecute() {
//				mProgressDialog.show();
			};
			@Override
			protected ActivityModel doInBackground(String... params) {
				// TODO Auto-generated method stub
				ActivityModel model = null;
				try {
				model = (ActivityModel) ModelDataMgr.getInstance().getModel(activityJsonObject.id,ModelDataMgr.ACTIVITY_DIR);
				if ( model == null ) {
					String respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_activity_detail),
							activityJsonObject.id,
							activityJsonObject.uid,
							UserInfoManager.getInstance(ActivityActivity.this).getItem("m_auth").getValue());
					JSONObject object;
					model = new ActivityModel();
					
						object = new JSONObject(respon);
						if ( 0 == object.getInt("error") ) {
							object = object.getJSONObject("data");
							model.id 			= activityJsonObject.id;
							model.name 	=  object.getString("name");
							model.time 	=  object.getString("dateline");
							
//							"tag": {
//					            "496": "我亲爱的"
//					        },
							model.tagname 	=  object.getJSONObject("tag").getString("tagname");
							model.tagid 	=  object.getJSONObject("tag").getInt("tagid") + "";
//							model.photo 	=  object.getString("pic");
							model.detail	= object.getString("detail");
							ModelDataMgr.getInstance().saveModel(model,ModelDataMgr.ACTIVITY_DIR);
						}else
						{
							// 找不到该id的数据或者获取这个数据时出错了，得到的id得不到详情的内容
							error = true;
//							int size = ModelDataMgr.getInstance().idActivityList.size();
//							for (int i = 0; i < size; i++) {
//								if( ModelDataMgr.getInstance().idActivityList.get(i).equals(id) )
//								{
//									ModelDataMgr.getInstance().idActivityList.remove(i);
//									break;
//								}
//							}
						}
					}
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					//e.printStackTrace();
				}
				return model;
			}
			protected void onPostExecute(ActivityModel result) {
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
//				if ( ! error ) {
					JSONObject object = new JSONObject();
					try {
						object.put("detail", result.detail);
						object.put("time", result.time);
						object.put("name", result.name);
						object.put("tagname", result.tagname);
						object.put("tagid", result.tagid);
						object.put("id", result.id);
						array.put(object);
						mviewAdapter.notifyDataSetChanged();
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
//				}
				
				if ( array.length() < ModelDataMgr.getInstance().idActivityList.size() ) {
						loadActivityDetailTask(ModelDataMgr.getInstance().idActivityList.get(array.length()));
				}
			}
		}.execute("");
	}
	private OnClickListener ButtonListener = new OnClickListener()
	{

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if (v == mBtn_back) {
				ActivityActivity.this.finish();
			}else if( v == mBtn_next )
			{
				if( mViewPager.getCurrentItem() + 1 < array.length() )
				{
					mViewPager.setCurrentItem(mViewPager.getCurrentItem() + 1);
				}else
				{
					Toast.makeText(ActivityActivity.this, "the last one", Toast.LENGTH_SHORT).show();
				}
				
			}else if( v == mBtn_prev )
			{
				if( mViewPager.getCurrentItem() - 1 >= 0 )
				{
					mViewPager.setCurrentItem(mViewPager.getCurrentItem() - 1);
				}else {
					Toast.makeText(ActivityActivity.this, "the first one", Toast.LENGTH_SHORT).show();
				}
			}
			
		}

	};
//	@Override
//	protected boolean isRouteDisplayed() {
//		// TODO Auto-generated method stub
//		return false;
//	}
}
