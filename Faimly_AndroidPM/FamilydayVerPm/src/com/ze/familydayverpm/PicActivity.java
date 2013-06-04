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
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.adapter.FamilyListViewAdapter;
import com.ze.familydayverpm.adapter.ViewPagerAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.DataModel;
import com.ze.model.ModelDataMgr;
import com.ze.model.PhotoModel;

import android.app.Activity;
import android.app.ProgressDialog;
import android.graphics.AvoidXfermode.Mode;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class PicActivity extends Activity {
		
//	private	ListView 					mListView;
	private 	Button 					mBtn_back;
	private 	Button 					mBtn_prev;
	private 	Button 					mBtn_next;
//	private 	BaseAdapter			mAdapter;
	private 	final static String[]			FLAGS =
																{
																	"name",
																	"say"
																};
	private 	static final 	int[]				IDS = {R.id.pic_item_name,R.id.pic_item_say};
	private 	static final int 				PAGER_SIZE = 10;
//	private 	static View 						mHeadView;

	private 	List<Map<String, Object>> mList;
	
	private 	ViewPager 				mViewPager;
	private 	ViewPagerAdapter mviewAdapter;
	private 	ProgressDialog		mProgressDialog;
	
	JSONArray array ;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_pic);
			
			mBtn_back 			= (Button)findViewById(R.id.pic_back);
			mBtn_prev			= (Button)findViewById(R.id.pic_prev);
			mBtn_next		    =  (Button)findViewById(R.id.pic_next);
			mBtn_prev.setOnClickListener(ButtonListener);
			mBtn_next.setOnClickListener(ButtonListener);
			mBtn_back.setOnClickListener(ButtonListener);
			
			mViewPager 		= (ViewPager)findViewById(R.id.picViewPager);
			array = new JSONArray();
//			array.put(getJsonObject(R.drawable.example1));
//			array.put(getJsonObject(R.drawable.example2));
			mProgressDialog = new ProgressDialog(this);
			mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
//			mProgressDialog.setCancelable(false);
//			loadFeedTask();
			// 是否网络通畅？
			if (NetHelper.isNetAvailable(this)) {
				loadFeedTask(true);
			}else
			{
				if( 0 < ModelDataMgr.getInstance().idPicList.size() )
				{ 
					loadPicDetailTask(ModelDataMgr.getInstance().idPicList.get(0));
				}else
				{
					loadFeedTask(false);
				}
			}
			mBtn_prev.setVisibility(View.INVISIBLE);
			mviewAdapter = new ViewPagerAdapter(this, array);
			mViewPager.setAdapter(mviewAdapter);
			mViewPager.setOnPageChangeListener(new OnPageChangeListener() {
				
				@Override
				public void onPageSelected(int arg0) {
					// TODO Auto-generated method stub
					if( arg0 == 0 )
					{
						mBtn_prev.setVisibility(View.INVISIBLE);
					}else {
						if (mBtn_prev.getVisibility() == View.INVISIBLE) {
							mBtn_prev.setVisibility(View.VISIBLE);
						}
					}
					
					if ( arg0 == ModelDataMgr.getInstance().idPicList.size() - 1) {
						// 达到最后一张图片
						mBtn_next.setVisibility(View.INVISIBLE);
						loadFeedTask(false);
					}else {
						if (mBtn_next.getVisibility() == View.INVISIBLE) {
							mBtn_next.setVisibility(View.VISIBLE);
						}
					}
//						array.put(getJsonObject(R.drawable.example1));
//						array.put(getJsonObject(R.drawable.example2));
//						try {
//							if( array.getJSONObject(arg0).isNull("topic") )
//							{
//								if( arg0 < ModelDataMgr.getInstance().idPicList.size() )
//								{ 
//									loadPicDetailTask(ModelDataMgr.getInstance().idPicList.get(arg0));
//								}else
//								{
//									loadFeedTask();
//								}
//							}
//						} catch (JSONException e) {
//							// TODO Auto-generated catch block
//							e.printStackTrace();
//						}
						
//						Toast.makeText(PicActivity.this, "load more...", Toast.LENGTH_SHORT).show();
//					}
					Log.v("test", "onPageSelected:" + arg0);
				}
				
				@Override
				public void onPageScrolled(int arg0, float arg1, int arg2) {
					// TODO Auto-generated method stub
				Log.v("test", "onPageScrolled arg0:" + arg0);
				Log.v("test", "onPageScrolled arg2:" + arg2);
				}
				
				@Override
				public void onPageScrollStateChanged(int arg0) {
					// TODO Auto-generated method stub
					
				}
			});
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
		public void loadFeedTask(final boolean refresh)
		{
			if( ! refresh )
			{
				if( ModelDataMgr.getInstance().idPicList.size() !=0 && ModelDataMgr.getInstance().idPicList.size() %10 != 0 )
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
						page = ModelDataMgr.getInstance().idPicList.size()/PAGER_SIZE + 1 + "";
					}
					String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_feedlist),
							"photoid",page,
							UserInfoManager.getInstance(PicActivity.this).getItem("m_auth").getValue());
					return responString;
				}
				protected void onPostExecute(String result) {
//					if (mProgressDialog.isShowing()) {
//						mProgressDialog.hide();
//					}
					try {
						JSONObject jsonObject = new JSONObject(result);
						if ( 0 == jsonObject.getInt("error") )
						{
							JSONArray jsonArray = jsonObject.getJSONArray("data");
							int size = jsonArray.length();
							JSONObject temp;
							if(refresh)
							{
								ModelDataMgr.getInstance().idPicList.clear();
								array = new JSONArray();
								mviewAdapter = new ViewPagerAdapter(PicActivity.this, array);
								mViewPager.setAdapter(mviewAdapter);
							}
							DataModel object ;
							for (int i = 0; i < size; i++) {
								temp = jsonArray.getJSONObject(i);
								//object.put(FamilyListViewAdapter.flag[0],temp.getString("avatar") );
								object = new DataModel();
								object.id = temp.getString("id");
								object.uid = temp.getString("uid");
								object.type = SpaceDetailActivity.DETAIL_PIC;
								ModelDataMgr.getInstance().idPicList.add(object);
							}
							if(ModelDataMgr.getInstance().idPicList.size() > 0 )
							{
								loadPicDetailTask(ModelDataMgr.getInstance().idPicList.get(array.length()));
								ModelDataMgr.getInstance().saveIdList(ModelDataMgr.getInstance().idPicList,ModelDataMgr.PHOTO_ID_LIST );
								mBtn_next.setVisibility(View.VISIBLE);
							}else
							{
								Toast.makeText(PicActivity.this, getResources().getString(R.string.dialog_msg_nomoredata), Toast.LENGTH_LONG).show();
							}
							
							
						}
						
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						if (mProgressDialog.isShowing()) {
							mProgressDialog.hide();
						}
						Toast.makeText(PicActivity.this, "error", Toast.LENGTH_LONG).show();
					}
					
				};
			}.execute("");
		}
		public void loadPicDetailTask(final DataModel picJsonObject)
		{
			new AsyncTask<String, String, PhotoModel>(){
				private boolean error = false;			// 读取操作中是否出错
				protected void onPreExecute() {
//					mProgressDialog.show();
				};
				@Override
				protected PhotoModel doInBackground(String... params) {
					// TODO Auto-generated method stub
					PhotoModel model = null;
					try {
					model = (PhotoModel) ModelDataMgr.getInstance().getModel(picJsonObject.id,ModelDataMgr.PHOTO_DIR);
					if ( model == null ) {
						String respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_photo_detail),
								picJsonObject.id,
								picJsonObject.uid,
								UserInfoManager.getInstance(PicActivity.this).getItem("m_auth").getValue());
						JSONObject object;
						model = new PhotoModel();
						
							object = new JSONObject(respon);
							if ( 0 == object.getInt("error") ) {
								object = object.getJSONObject("data");
								model.id 			= object.getString("photoid");
								model.name 	=  object.getString("name");
								model.time 	=  object.getString("dateline");
								
//								"tag": {
//						            "496": "我亲爱的"
//						        },
								model.tagname 	=  object.getJSONObject("tag").getString("tagname");
								model.tagid 	=  object.getJSONObject("tag").getInt("tagid") + "";
//								 多图情况处理
								JSONArray picArray = object.getJSONArray("piclist");
								for (int i = 0; i < picArray.length(); i++) {
//									model.photos.add( picArray.getJSONObject(i).getString("pic")
//											);
								}
//								model.photo 	=  object.getString("pic");
								model.say 		=  object.getString("subject");
								
								ModelDataMgr.getInstance().saveModel(model,ModelDataMgr.PHOTO_DIR);
							}else
							{
								// 找不到该id的数据或者获取这个数据时出错了，得到的id得不到详情的内容
								error = true;
//								int size = ModelDataMgr.getInstance().idPicList.size();
//								for (int i = 0; i < size; i++) {
//									if( ModelDataMgr.getInstance().idPicList.get(i).equals(id) )
//									{
//										ModelDataMgr.getInstance().idPicList.remove(i);
//										break;
//									}
//								}
							}
						}
						
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						//e.printStackTrace();
					}
					return model;
				}
				protected void onPostExecute(PhotoModel result) {
					if (mProgressDialog.isShowing()) {
						mProgressDialog.hide();
					}
//					if ( ! error ) {
						JSONObject object = new JSONObject();
						try {
							object.put("imgarray", result.photos);
							object.put("say", result.say);
							object.put("listview", null);
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
//					}
					
					if ( array.length() < ModelDataMgr.getInstance().idPicList.size() ) {
							loadPicDetailTask(ModelDataMgr.getInstance().idPicList.get(array.length()));
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
							PicActivity.this.finish();
						}else if( v == mBtn_next )
						{
							if( mViewPager.getCurrentItem() + 1 < array.length())
							{
								mViewPager.setCurrentItem(mViewPager.getCurrentItem() + 1);
							}else
							{
								Toast.makeText(PicActivity.this, "the last one", Toast.LENGTH_SHORT).show();
							}
							
						}else if( v == mBtn_prev )
						{
							if( mViewPager.getCurrentItem() - 1 >= 0 )
							{
								mViewPager.setCurrentItem(mViewPager.getCurrentItem() - 1);
							}else {
								Toast.makeText(PicActivity.this, "the first one", Toast.LENGTH_SHORT).show();
							}
						}
						
					}
			
				};
				
}
