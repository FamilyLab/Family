package com.ze.familydayverpm;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.familydayverpm.adapter.SpaceViewPagerAdapter;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.ActivityModel;
import com.ze.model.BlogModel;
import com.ze.model.DataModel;
import com.ze.model.ModelDataMgr;
import com.ze.model.PhotoModel;
import com.ze.model.VideoModel;
import com.ze.model.PhotoModel.PicInfo;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnDismissListener;
import android.content.DialogInterface.OnShowListener;
import android.content.Intent;
import android.content.res.Resources.NotFoundException;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;

public class SpaceDetailActivity extends FragmentActivity {
		
	private 	Button 					mBtn_back;
	private 	Button 					mBtn_prev;
	private 	Button 					mBtn_next;
	private 	Button 					mBtn_love;
	private 	final static String[]			FLAGS =
																{
																	"name",
																	"say"
																};
	private 	static final int 				PAGER_SIZE = 5;
	private 	ViewPager 						mViewPager;
	private 	SpaceViewPagerAdapter 		mviewAdapter;
	private 	ProgressDialog				mProgressDialog;
	private 	Button 							mReblog;
//	private 	AsyncTask<String, String, String> loveTask;
	JSONArray array ;
	ArrayList<DataModel> arrayList = null;
	private 	String 							tagid;
	private 	String 							mUidString;
	
	private 	AlertDialog 		commentDialog;
	private 	EditText				commentEditText;
	private 	Button 				commentButton;
	
	private 	String 					mID;
	private 	String 					mType;
	private 	String 					detailType;
	
	
	public final static String  	DETAIL_PIC = "photoid";
	public final static String  	DETAIL_REPIC = "rephotoid";
	
	public final static String  	DETAIL_BLOG = "blogid";
	public final static String  	DETAIL_REBLOG = "reblogid";
	
	public final static String  	DETAIL_EVNET = "eventid";
	public final static String  	DETAIL_REEVNET = "reeventid";
	
	public final static String  	DETAIL_VIDEO = "videoid";
	public final static String  	DETAIL_REVIDEO = "revideoid";
	
	
	
	public final static String 	REBLOG_PIC_TAIL = "190X190";
	
	private 	View 		nodataView;
//	private 	View 		addfamilyView;
//	private 	View		publishView;
//	public final static String  	DETAIL_VIDEO = "videoid";
	private   boolean firtstload = false;
	private 	boolean isFromPublish = false;
	private 	boolean isFromLove = false;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_pic);
//			instance = this;
			tagid = getIntent().getStringExtra("tagid");
			mUidString = getIntent().getStringExtra("uid");
			mID				=getIntent().getStringExtra("id");
			mType			=getIntent().getStringExtra("type");
			
			isFromPublish = getIntent().getBooleanExtra("frompublish", false);
			isFromLove = getIntent().getBooleanExtra("lovelist", false);
			if ( ! isFromPublish) {
				if( ! isFromLove )
					loadFileToList();
			}
			
			mBtn_back 			= (Button)findViewById(R.id.pic_back);
			mBtn_prev			= (Button)findViewById(R.id.pic_prev);
			mBtn_next		    =  (Button)findViewById(R.id.pic_next);
			mBtn_love 			= (Button)findViewById(R.id.pic_heart);
			mReblog  			= (Button)findViewById(R.id.pic_reblog);
			nodataView 		= findViewById(R.id.pic_nodataui);
//			addfamilyView	= findViewById(R.id.pic_addfamily);
//			publishView		= findViewById(R.id.pic_publish);
//			
			mBtn_love.setTag("0");					// 判断是否有网络线程已经开始
			mBtn_prev.setOnLongClickListener(longClickListener);
			mBtn_prev.setOnClickListener(ButtonListener);
			mBtn_next.setOnClickListener(ButtonListener);
			mBtn_back.setOnClickListener(ButtonListener);
			mBtn_love.setOnClickListener(ButtonListener);
			mReblog.setOnClickListener(ButtonListener);
			mViewPager 		= (ViewPager)findViewById(R.id.picViewPager);
			array = new JSONArray();
			mProgressDialog = new ProgressDialog(this);
			mProgressDialog.setCanceledOnTouchOutside(false);
			mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
//			arrayList = ModelDataMgr.getInstance().getSpaceIdList(tagid);
			commentEditText = new EditText(this);
			commentEditText.setHint(getResources().getString(R.string.dialog_hint_comment) );
			commentEditText.setHeight(300);
			commentEditText.setGravity(Gravity.TOP);
			commentEditText.setTextSize(24);
			commentDialog = new Builder(this).setTitle(getResources().getString(R.string.dialog_title_comment)).
					setView(commentEditText).setNegativeButton(getString(R.string.dialog_button_cancel), dialogClickListener).
					setPositiveButton(getResources().getString(R.string.dialog_button_send), dialogClickListener).create();
			commentDialog.setOnShowListener(new OnShowListener() {
				
				@Override
				public void onShow(DialogInterface dialog) {
					// TODO Auto-generated method stub
					InputMethodManager imm=(InputMethodManager)SpaceDetailActivity.this.getSystemService(Context.INPUT_METHOD_SERVICE); 
					//imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
					imm.showSoftInput(commentEditText, 0);
//					imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
					commentEditText.requestFocus();
					try {
						if( array.getJSONObject(currentPage).getString("type").equals(DETAIL_EVNET) || 
								array.getJSONObject(currentPage).getString("type").equals(DETAIL_REEVNET) ){
							commentEditText.setText(R.string.takepartin);
						}
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					
				}
			});
			commentButton = (Button)findViewById(R.id.pic_comment);
			commentButton.setOnClickListener(ButtonListener);
			if( arrayList == null )
			{
				arrayList = new ArrayList<DataModel>();
			}
			if( ! isFromPublish )
			{
				if (getIntent().getBooleanExtra("new", true)) {
					loadListTask(true);
				}else
				{
					if( 0 < arrayList.size() )
					{ 
//						loadDetailTask(ModelDataMgr.getInstance().idPicList.get(0));
						mProgressDialog.show();
						loadDetailTask(arrayList.get(0));
					}else
					{
//						loadListTask(false);
						loadListTask(true);
					}
				}
			}else {
				mProgressDialog.show();
				DataModel model = new DataModel();
				model.id = getIntent().getStringExtra("id");
				model.uid = getIntent().getStringExtra("uid");
				model.type = getIntent().getStringExtra("type");
				loadDetailTask(model);
				mBtn_prev.setVisibility(View.INVISIBLE);
				mBtn_next.setVisibility(View.INVISIBLE);
			}
			
			
			mBtn_prev.setVisibility(View.INVISIBLE);
			mviewAdapter = new SpaceViewPagerAdapter(this, array);
			mViewPager.setAdapter(mviewAdapter);
			mViewPager.setOnPageChangeListener(new OnPageChangeListener() {
				
				@Override
				public void onPageSelected(int arg0) {
					// TODO Auto-generated method stub
					currentPage = arg0;
					try {
						mID 	= arrayList.get(arg0).id;
						mType 	= arrayList.get(arg0).type;
						mUidString = arrayList.get(arg0).uid;
						isEventType(mType);
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					if( arg0 == 0 )
					{
						mBtn_prev.setVisibility(View.INVISIBLE);
					}else {
						if (mBtn_prev.getVisibility() == View.INVISIBLE) {
							mBtn_prev.setVisibility(View.VISIBLE);
						}
					}
					if( arrayList.size() > 3 && arg0 == arrayList.size() - 3 )
					{
						// 达到倒数第三张时，加载更多
						loadListTask(false);
					}
					if ( arg0 ==arrayList.size() - 1) {
						// 达到最后一张图片
						mBtn_next.setVisibility(View.INVISIBLE);
						if( loadListTaskFlag )
						{
							// 达到最后一张，且这时加载列表仍未完成时
							mProgressDialog.show();
						}
//						loadListTask(false);
					}else {
						if (mBtn_next.getVisibility() == View.INVISIBLE) {
							mBtn_next.setVisibility(View.VISIBLE);
						}
					}
					//  在此界面停留超过2秒则开始加载评论
					loadComment(currentPage);
					Log.v("test", "onPageSelected:" + arg0);
					try {
							mBtn_love.setSelected( array.getJSONObject(arg0).getInt("love") == 1 );
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
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
		public void isEventType(String type)
		{
			if ( type.equals(DETAIL_EVNET ) ||  type.equals(DETAIL_REEVNET)) {
				commentButton.setBackgroundResource(R.drawable.join_bg);
			}else
			{
				commentButton.setBackgroundResource(R.drawable.comment);
			}
		}
		public Handler handler = new Handler()
		{
//			public void handleMessage(android.os.Message msg) {};
		};
		public void loadComment(final int pageIndex)
		{
			if(mviewAdapter.mHashMap.get(currentPage).isLoadDisscussed())
			{
				return;
			}
			handler.postDelayed(new Runnable() {
				
				@Override
				public void run() {
					// TODO Auto-generated method stub
					if ( pageIndex == currentPage ) {
//						mviewAdapter.mHashMap.get(currentPage).
						mviewAdapter.mHashMap.get(currentPage).loadDisscussTask();
					}else
					{
						Log.v("spacedetail", "not loadDisscussTask");
					}
				}
			}, 2*1000);
		}
		public void loadFileToList()
		{
			if ( tagid == null ) {
				detailType = getIntent().getStringExtra("DETAIL_TYPE");
				if (detailType.equals(DETAIL_PIC)) {
					arrayList = ModelDataMgr.getInstance().idPicList;
				}else if( detailType.equals(DETAIL_BLOG))
				{
					arrayList = ModelDataMgr.getInstance().idBlogList;
				}else if( detailType.equals(DETAIL_EVNET))
				{
					arrayList = ModelDataMgr.getInstance().idActivityList;
				}else if( detailType.equals(DETAIL_VIDEO))
				{
					arrayList = ModelDataMgr.getInstance().idVideoList;
				}
				
	}else
	{
		arrayList = ModelDataMgr.getInstance().getSpaceIdList(tagid);
	}
		}
		private int 	currentPage = 0;
		private boolean loadListTaskFlag = false;
		public void loadListTask(final boolean refresh)
		{
			if( ! refresh )
			{
				int size = arrayList .size() ;
				if( size!=0 && size % PublicInfo.PER_LOAD != 0 )
				{
					Toast.makeText(this, getResources().getString(R.string.dialog_msg_nomoredata), Toast.LENGTH_LONG).show();
					return;
				}
			}
			if( refresh )
			{
				if( loadListTaskFlag )
				{
					return;
				}
					
			}
			new AsyncTask<String, String, String>(){
				protected void onPreExecute() {
//					mProgressDialog.show();
					if ( mUidString == null )
					{
						Componet uidComponet = UserInfoManager.getInstance(SpaceDetailActivity.this).getItem("uid");
						if( uidComponet != null )
						{
							mUidString = uidComponet.getValue();
						}
					}
					if( refresh )
					{
						mProgressDialog.show();
						loadListTaskFlag = true;
					}
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String page = "1";
					if( !refresh )
					{
						page = arrayList.size()/PAGER_SIZE + 1 + "";
					}
					
					String responString ;
					Componet m_authComponet = UserInfoManager.getInstance(SpaceDetailActivity.this).getItem("m_auth");
					if ( null == m_authComponet ) {
						 return "";
					}
					if( detailType != null && detailType.equals(DETAIL_PIC))
					{
						responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_feedlist),
								"photoid",page,
								m_authComponet.getValue());
					}else if( detailType != null && detailType.equals(DETAIL_BLOG))
					{
						responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_feedlist),
								"blogid",page,
								m_authComponet.getValue());
					}else if( detailType != null && detailType.equals(DETAIL_EVNET))
					{
						responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_feedlist),
								"eventid",page,
								m_authComponet.getValue());
					}else if( detailType != null && detailType.equals(DETAIL_VIDEO))
					{
						responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_feedlist),
								"videoid",page,
								m_authComponet.getValue());
					}else if( isFromLove )
					{
						responString= NetHelper.getResponByHttpClient(getResources().getString(R.string.http_lovelist),
								m_authComponet.getValue(),page);
					
					}else
					{
						responString= NetHelper.getResponByHttpClient(getResources().getString(R.string.http_userspace_list),
								m_authComponet.getValue(),
								tagid,
								mUidString!=null?mUidString:"",
								page);
					}
					
					return responString;
				}
				protected void onPostExecute(String result) {
//					if (mProgressDialog.isShowing()) {
//						mProgressDialog.hide();
//					}
					loadListTaskFlag = false;
					if( result != null && !result.equals("") )
					{
					
						if( refresh  )
						{
							arrayList.clear();
							updateString = result;
//							updateAsk();
							update(updateString);
							return;
						}else
						{
							update(result);
						}
					}else {
						Toast.makeText(SpaceDetailActivity.this, getResources().getString(R.string.tips_send_fail), Toast.LENGTH_SHORT).show();
					}
				};
			}.execute("");
		}
		private AlertDialog refreshAlertDialog = null;
		private void updateAsk()
		{
			if( refreshAlertDialog == null )
			{
				refreshAlertDialog = new Builder(this).setMessage(getResources().getString(R.string.dialog_msg_need_refresh)).
				setPositiveButton(getResources().getString(R.string.dialog_button_sure), dialogClickListener).
				setNegativeButton(getResources().getString(R.string.dialog_button_cancel),dialogClickListener).create();
			}
			refreshAlertDialog.show();
		}
		private String updateString;
		private void update(String result)
		{
			try {
				JSONObject jsonObject = new JSONObject(result);
				if ( 0 == jsonObject.getInt("error") )
				{
					if( detailType != null )
					{
						
					
					if(detailType.equals(DETAIL_PIC) || detailType.equals(DETAIL_BLOG) || detailType.equals(DETAIL_EVNET) || detailType.equals(DETAIL_VIDEO))
					{
						JSONArray jsonArray = jsonObject.getJSONArray("data");
						int size = jsonArray.length();
						JSONObject temp;
//						if(refresh)
//						{
////							ModelDataMgr.getInstance().idPicList.clear();
//							
//							arrayList.clear();
//							array = new JSONArray();
//							mviewAdapter = new SpaceViewPagerAdapter(SpaceDetailActivity.this, array);
//							mViewPager.setAdapter(mviewAdapter);
//						}
						
						if ( size == 0 )
						{
							nodataView.setVisibility(View.VISIBLE);
							mViewPager.setVisibility(View.INVISIBLE);
//							addfamilyView.setOnClickListener(ButtonListener);
//							publishView.setOnClickListener(ButtonListener);
						}
						DataModel object ;
						for (int i = 0; i < size; i++) {
							temp = jsonArray.getJSONObject(i);
							//object.put(FamilyListViewAdapter.flag[0],temp.getString("avatar") );
							object = new DataModel();
							object.id = temp.getString("id");
							object.uid = temp.getString("uid");
							object.type = temp.getString("idtype");
							arrayList.add(object);
						}
					}
					}else if( isFromLove )
					{
						JSONArray jsonArray = jsonObject.getJSONArray("data");
						int size = jsonArray.length();
						JSONObject temp;
						DataModel object ;
						for (int i = 0; i < size; i++) {
							temp = jsonArray.getJSONObject(i);
							object = new DataModel();
							object.id = temp.getString("id");
							object.uid = temp.getString("uid");
							object.type = temp.getString("idtype");
							arrayList.add(object);
						}
					}else
					{
						JSONArray jsonArray = jsonObject.getJSONObject("data").getJSONArray("feedlist");
						int size = jsonArray.length();
						JSONObject temp;
//						if(refresh)
//						{
//							arrayList.clear();
//							array = new JSONArray();
//							mviewAdapter = new SpaceViewPagerAdapter(SpaceDetailActivity.this, array);
//							mViewPager.setAdapter(mviewAdapter);
//						}
						DataModel object ;
						for (int i = 0; i < size; i++) {
							temp = jsonArray.getJSONObject(i);
							//object.put(FamilyListViewAdapter.flag[0],temp.getString("avatar") );
							object = new DataModel();
							object.id = temp.getString("id");
							object.uid = temp.getString("uid");
							object.type = temp.getString("idtype");
//							if (object.type.startsWith("re")) {
//								object.type = object.type.substring(2);
//							}
							arrayList.add(object);
						}
					}
					
					if( arrayList.size() > 0 && arrayList.size() > array.length() )
					{
						loadDetailTask(arrayList.get(array.length()));
						if( detailType != null )
						{
							if(detailType.equals(DETAIL_PIC) || detailType.equals(DETAIL_REPIC) )
							{
								ModelDataMgr.getInstance().saveIdList(arrayList,ModelDataMgr.PHOTO_ID_LIST );
							}else if( detailType.equals(DETAIL_BLOG) || detailType.equals(DETAIL_REBLOG) )
							{
								ModelDataMgr.getInstance().saveIdList(arrayList,ModelDataMgr.BLOG_ID_LIST );
							}else if( detailType.equals(DETAIL_EVNET) || detailType.equals(DETAIL_REEVNET)  )
							{
								ModelDataMgr.getInstance().saveIdList(arrayList,ModelDataMgr.ACTIVITY_ID_LIST );
							}else if( detailType.equals(DETAIL_VIDEO) || detailType.equals(DETAIL_REVIDEO)  )
							{
								ModelDataMgr.getInstance().saveIdList(arrayList,ModelDataMgr.VIDEO_ID_LIST );
							}
						}else if( isFromLove)
						{
							// love 暂不缓存
						}else
						{
							ModelDataMgr.getInstance().saveSpaceList(arrayList, tagid);
						}
						mBtn_next.setVisibility(View.VISIBLE);
					}else
					{
						if (mProgressDialog.isShowing()) {
							mProgressDialog.hide();
						}
						Toast.makeText(SpaceDetailActivity.this, getResources().getString(R.string.dialog_msg_nomoredata), Toast.LENGTH_LONG).show();
						if( arrayList.size() == 0 )
						{
							AlertDialog publishAlertDialog = new Builder(SpaceDetailActivity.this).setMessage(R.string.dialog_msg_noanydata).
							setPositiveButton(R.string.dialog_btn_noanydata_publish, new DialogInterface.OnClickListener() {
								
								@Override
								public void onClick(DialogInterface dialog, int which) {
									// TODO Auto-generated method stub
									Intent intent = new Intent();
									intent.setClass(SpaceDetailActivity.this, PublishActivity.class);
									startActivity(intent);
									SpaceDetailActivity.this.finish();
								}
							}).setNegativeButton(R.string.dialog_btn_noanydata_family, new DialogInterface.OnClickListener() {
								
								@Override
								public void onClick(DialogInterface dialog, int which) {
									// TODO Auto-generated method stub
									Intent intent = new Intent();
									intent.putExtra("count", 0);
									intent.setClass(SpaceDetailActivity.this, FamilyActivity.class);
									startActivity(intent);
									SpaceDetailActivity.this.finish();
								}
							}).create();
							publishAlertDialog.show();
							publishAlertDialog.setOnDismissListener(new OnDismissListener() {
								
								@Override
								public void onDismiss(DialogInterface dialog) {
									// TODO Auto-generated method stub
									SpaceDetailActivity.this.finish();
								}
							});
						}
					}
					
					
				}
				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
				Toast.makeText(SpaceDetailActivity.this, "error", Toast.LENGTH_LONG).show();
			}
		}
		@Override
		protected void onDestroy() {
			// TODO Auto-generated method stub
			super.onDestroy();
			if ( detailAsyncTask != null ) {
				detailAsyncTask.cancel(true);
			}
		}
		public String getIdtyePath( String typeidString )
		{
			String dirPath = null;
			if ( typeidString.equals("photoid") || typeidString.equals("rephotoid")) {
				dirPath = ModelDataMgr.PHOTO_DIR;
			}else if( typeidString.equals("blogid") || typeidString.equals("reblogid"))
			{
				dirPath = ModelDataMgr.BLOG_DIR;
			}else if( typeidString.equals("eventid") || typeidString.equals("reeventid") )
			{
				dirPath = ModelDataMgr.ACTIVITY_DIR;
			}else if( typeidString.equals(DETAIL_VIDEO) || typeidString.equals(DETAIL_REVIDEO) )
			{
				dirPath = ModelDataMgr.VIDEO_DIR;
			}
			return dirPath;
		}
		private AsyncTask<String, String, DataModel> detailAsyncTask ;
		public void loadDetailTask(final DataModel picJsonObject)
		{
			detailAsyncTask = new AsyncTask<String, String, DataModel>(){
				boolean notopen = false;
				private boolean error = false;			// 读取操作中是否出错
				String typeidString = null;
				String dirPath = null;
				String urlString = null;
				protected void onPreExecute() {
					typeidString = picJsonObject.type;
					if ( typeidString.equals("photoid") || typeidString.equals("rephotoid")) {
						dirPath = ModelDataMgr.PHOTO_DIR;
						urlString = getResources().getString(R.string.http_photo_detail);
					}else if( typeidString.equals("blogid") || typeidString.equals("reblogid"))
					{
						dirPath = ModelDataMgr.BLOG_DIR;
						urlString = getResources().getString(R.string.http_blog_detail);
					}else if( typeidString.equals("eventid") || typeidString.equals("reeventid") )
					{
						dirPath = ModelDataMgr.ACTIVITY_DIR;
						urlString = getResources().getString(R.string.http_activity_detail);
					}else if( typeidString.equals(DETAIL_VIDEO) || typeidString.equals(DETAIL_REVIDEO) )
					{
						dirPath = ModelDataMgr.VIDEO_DIR;
						urlString = getResources().getString(R.string.http_video_detail);
					}else
					{
//						Toast.makeText(SpaceDetailActivity.this, R.string.notopen, Toast.LENGTH_SHORT).show();
						notopen = true;
					}
				};
				@Override
				protected DataModel doInBackground(String... params) {
					// TODO Auto-generated method stub
					if( notopen )
					{
						return null;
					}
					DataModel model = null;
					try {
					model =  (DataModel) ModelDataMgr.getInstance().getModel(picJsonObject.id,dirPath);
					if ( model == null ) {
						String respon = NetHelper.getResponByHttpClient(urlString,
								picJsonObject.id,
								picJsonObject.uid,
								UserInfoManager.getInstance(SpaceDetailActivity.this).getItem("m_auth").getValue());
						JSONObject object;
						object = new JSONObject(respon);
						if ( 0 == object.getInt("error") ) {
//								model = new DataModel();
								object = object.getJSONObject("data");
								
								if ( typeidString.equals("photoid") || typeidString.equals("rephotoid")) {
									model = new PhotoModel();
									model.id 			= picJsonObject.id;
									model.uid 		= picJsonObject.uid;
									model.type		= picJsonObject.type;
									if( !object.isNull("name") )
									{
										((PhotoModel)model).name 	=  object.getString("name");
									}
									if( !object.isNull("dateline") )
									{
										((PhotoModel)model).time 	=  object.getString("dateline");
									}
									if( !object.isNull("tagname") )
									{
//										((PhotoModel)model).tagname 	=  object.getString("tagname");
										
									}
									if( !object.isNull("message") )
									{
										((PhotoModel)model).say 	=  object.getString("message");
										
									}
									if( !object.isNull("subject") )
									{
//										((PhotoModel)model).say 		=  object.getString("subject");
										((PhotoModel)model).tagname 		=  object.getString("subject");
									}
									if( !object.isNull("mylove") )
									{
//										((PhotoModel)model).say 		=  object.getString("subject");
										((PhotoModel)model).love 		=  object.getInt("mylove");
									}
//									// 数据无用到空间id，服务器返回数据不一致
//									if( !object.isNull("tag") ){
////										((PhotoModel)model).tagid 	=  object.getJSONObject("tag").getInt("tagid") + "";
//										
//									}
									
//									 多图情况处理
									if( ! object.isNull("piclist"))
									{
										JSONArray picArray = object.getJSONArray("piclist");
										PicInfo picInfo;
										for (int i = 0; i < picArray.length(); i++) {
											picInfo = new PicInfo();
											picInfo.url = picArray.getJSONObject(i).getString("pic");
											picInfo.height = Integer.parseInt( picArray.getJSONObject(i).getString("height") );
											picInfo.width 	=  Integer.parseInt( picArray.getJSONObject(i).getString("width") );
											((PhotoModel)model).photos.add(picInfo
													);
										}
									}
									// 界面无转载信息
//									if( !object.isNull("fuid") )
//									{
////										((PhotoModel)model).say 		=  object.getString("subject");
//										((PhotoModel)model).fromUid 		=  object.getString("fuid");
//										if( !((PhotoModel)model).fromUid.equals("0") )
//										{
//											if( !object.isNull("fname") )
//											{
//												((PhotoModel)model).fromName 		=  object.getString("fname");
//											}
//										}
//									}
//									model.photo 	=  object.getString("pic");
								
								}else if(  typeidString.equals("blogid") ||  typeidString.equals("reblogid"))
								{
									model = new BlogModel();
									model.id 			= picJsonObject.id;
									model.type		= picJsonObject.type;
									model.uid 		= picJsonObject.uid;
									if( ! object.isNull("name")) 
									{
										((BlogModel)model).name 	=  object.getString("name");
									}
									if( ! object.isNull("dateline")) 
									{
										((BlogModel)model).time 	=  object.getString("dateline");
									}
									if( ! object.isNull("message")) 
									{
										((BlogModel)model).html		= object.getString("message");
									}
									if( !object.isNull("mylove") )
									{
//										((PhotoModel)model).say 		=  object.getString("subject");
										((BlogModel)model).love 		=  object.getInt("mylove");
									}
									if( !object.isNull("subject") )
									{
//										((PhotoModel)model).say 		=  object.getString("subject");
										((BlogModel)model).tagname 		=  object.getString("subject");
									}
									// 数据没有用到tagid
//									if( ! object.isNull("tag")) 
//									{
//										if( ! object.getJSONObject("tag").isNull("tagname"))
//										{
////											((BlogModel)model).tagname 	=  object.getJSONObject("tag").getString("tagname");
//										
//											((BlogModel)model).tagid 	=  object.getJSONObject("tag").getInt("tagid") + "";
//										}
//									}
									// 界面数据无用到转载信息
//									if( !object.isNull("fuid") )
//									{
////										((PhotoModel)model).say 		=  object.getString("subject");
//										((BlogModel)model).fromUid 		=  object.getString("fuid");
//										if( !((BlogModel)model).fromUid.equals("0") )
//										{
//											if( !object.isNull("fname") )
//											{
//												((BlogModel)model).fromName 		=  object.getString("fname");
//											}
//										}
//									}
									
								}else if( typeidString.equals("eventid") || typeidString.equals("eventid"))
								{
									model = new ActivityModel();
									model.id 			= picJsonObject.id;
									model.type		= picJsonObject.type;
									model.uid 		= picJsonObject.uid;
									if( ! object.isNull("name")) 
									{
										((ActivityModel)model).name 	=  object.getString("name");
									}
									if( ! object.isNull("dateline")) 
									{
										((ActivityModel)model).time 	=  object.getString("dateline");
									}
									if( ! object.isNull("detail")) 
									{
										((ActivityModel)model).introduce	= object.getString("detail");
									}
									if( ! object.isNull("starttime")) 
									{
										((ActivityModel)model).eventtime	= object.getString("starttime");
									}
									if( ! object.isNull("location")) 
									{
										((ActivityModel)model).place	= object.getString("location");
									}
									if( ! object.isNull("poster")) 
									{
										((ActivityModel)model).poster	= object.getString("poster");
										// 替接口擦屁屁的三行代码
										if ( ((ActivityModel)model).poster.length() > 0 && ((ActivityModel)model).poster.charAt(0) == 'h' )
										{
											((ActivityModel)model).poster = ((ActivityModel)model).poster.replace("9ttp", "http");
										}
									}
									if( ! object.isNull("title")) 
									{
//										((ActivityModel)model).introduce	= object.getString("title");
									}
									if( !object.isNull("mylove") )
									{
//										((PhotoModel)model).say 		=  object.getString("subject");
										((ActivityModel)model).love 		=  object.getInt("mylove");
									}
									if( !object.isNull("title") )
									{
//										((PhotoModel)model).say 		=  object.getString("subject");
										((ActivityModel)model).tagname 		=  object.getString("title");
									}
									if( !object.isNull("lat") )
									{
//										((PhotoModel)model).say 		=  object.getString("subject");
										((ActivityModel)model).lat 		=  object.getString("lat");
									}
									if( !object.isNull("lng") )
									{
//										((PhotoModel)model).say 		=  object.getString("subject");
										((ActivityModel)model).lng 		=  object.getString("lng");
									}
									// 界面无用到空间信息
//									if( ! object.isNull("tag")) 
//									{
//										if( ! object.getJSONObject("tag").isNull("tagname"))
//										{
////											((ActivityModel)model).tagname 	=  object.getJSONObject("tag").getString("tagname");
//											((ActivityModel)model).tagid 	=  object.getJSONObject("tag").getInt("tagid") + "";
//										}
//									}
									// 界面无用到转载信息
//									if( !object.isNull("fuid") )
//									{
////										((PhotoModel)model).say 		=  object.getString("subject");
//										((ActivityModel)model).fromUid 		=  object.getString("fuid");
//										if( !((ActivityModel)model).fromUid.equals("0") )
//										{
//											if( !object.isNull("fname") )
//											{
//												((ActivityModel)model).fromName 		=  object.getString("fname");
//											}
//										}
//									}
								}else if( typeidString.equals(DETAIL_VIDEO) || typeidString.equals(DETAIL_REVIDEO))
								{
									model = new VideoModel();
									model.id 			= picJsonObject.id;
									model.type		= picJsonObject.type;
									model.uid 		= picJsonObject.uid;
									if( ! object.isNull("name")) 
									{
										((VideoModel)model).name 	=  object.getString("name");
									}
									if( ! object.isNull("dateline")) 
									{
										((VideoModel)model).time 	=  object.getString("dateline");
									}
									if( ! object.isNull("message")) 
									{
										((VideoModel)model).topic 	=  object.getString("message");
									}
									if( ! object.isNull("subject")) 
									{
										((VideoModel)model).subject 	=  object.getString("subject");
									}
									if( ! object.isNull("pic")) 
									{
										((VideoModel)model).pic 	=  object.getString("pic");
									}
									if( ! object.isNull("videourl")) 
									{
										((VideoModel)model).url 	=  object.getString("videourl");
									}
									// 界面无用到空间信息
//									if( ! object.isNull("tag")) 
//									{
//										if( ! object.getJSONObject("tag").isNull("tagname"))
//										{
//											((VideoModel)model).tagname 	=  object.getJSONObject("tag").getString("tagname");
//											((VideoModel)model).tagid 	=  object.getJSONObject("tag").getInt("tagid") + "";
//										}
//									}
								}
//								if( isFromLove )
//								{
//									model.love = 1;
//								}
								ModelDataMgr.getInstance().saveModel(model,dirPath);
							}else
							{
								// 找不到该id的数据或者获取这个数据时出错了，得到的id得不到详情的内容 
								error = true;
//								model.type = object.getString("msg");
							}
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						//e.printStackTrace();
					}
					if( isFromLove )
					{
						if( model.love != 1 )
						{
							model.love = 1;
							ModelDataMgr.getInstance().saveModel(model,dirPath);
						}
					}
					
					return model;
				}
				protected void onPostExecute(DataModel result) {
					if (mProgressDialog.isShowing()) {
						mProgressDialog.hide();
					}
					if( notopen )
					{
						if( isFromPublish )
						{
							return;
						}
						arrayList.remove(array.length());
						if ( array.length() < arrayList.size() ) {
							loadDetailTask(arrayList.get(array.length()));
						}
						return;
					}
					if ( ! error ) {
						if( result == null )
						{
							arrayList.remove(picJsonObject);
						}else
						{
							JSONObject object = new JSONObject();
							try {
								object.put("id", result.id);
								object.put("type", typeidString);
								object.put("fuid", result.fromUid);
								object.put("fname", result.fromName);
								object.put("love",  result.love);
								object.put("uid", result.uid);
								if( typeidString.equals("photoid") || typeidString.equals("rephotoid"))
								{
									object.put("imgarray", ((PhotoModel)result).photos);
									object.put("say",  ((PhotoModel)result).say);
									object.put("listview", null);
									object.put("time",  ((PhotoModel)result).time);
									object.put("name",  ((PhotoModel)result).name);
									object.put("tagname",  ((PhotoModel)result).tagname);
									object.put("tagid",  ((PhotoModel)result).tagid);
								}else if( typeidString.equals("blogid") || typeidString.equals("reblogid"))
								{
									object.put("html",  ((BlogModel)result).html);
									object.put("say", ((BlogModel)result).say);
									object.put("listview", null);
									object.put("time", ((BlogModel)result).time);
									object.put("name", ((BlogModel)result).name);
									object.put("tagname",  ((BlogModel)result).tagname);
									object.put("tagid",  ((BlogModel)result).tagid);
								}else if( typeidString.equals("eventid") || typeidString.equals("reeventid") )
								{
//									object.put("detail", ((ActivityModel)result).detail);
									object.put("eventintroduce", ((ActivityModel)result).introduce);
									object.put("eventtime", ((ActivityModel)result).eventtime);
									object.put("eventplace", ((ActivityModel)result).place);
									
									object.put("time", ((ActivityModel)result).time);
									object.put("name", ((ActivityModel)result).name);
									object.put("tagname", ((ActivityModel)result).tagname);
									object.put("tagid", ((ActivityModel)result).tagid);
									object.put("poster", ((ActivityModel)result).poster);
									object.put("lat", ((ActivityModel)result).lat);
									object.put("lng", ((ActivityModel)result).lng);
								}else if( typeidString.equals(DETAIL_VIDEO) || typeidString.equals(DETAIL_REVIDEO) )
								{
									object.put("subject", ((VideoModel)result).subject);
									object.put("pic", ((VideoModel)result).pic);
									object.put("topic", ((VideoModel)result).topic);
									object.put("url", ((VideoModel)result).url);
									object.put("time", ((VideoModel)result).time);
									object.put("name", ((VideoModel)result).name);
									object.put("tagname", ((VideoModel)result).tagname);
									object.put("tagid", ((VideoModel)result).tagid);
								}
								array.put(object);
								mviewAdapter.notifyDataSetChanged();
								if( currentPage == 0 && !firtstload)
								{
									mBtn_love.setSelected( array.getJSONObject(0).getInt("love") == 1 );
									loadComment(0);
									isEventType(typeidString);
									firtstload = true;
									mType 	= typeidString;
									mID			= result.id;
									mUidString = result.uid;
								}
							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
						
					}else {
//						Toast.makeText(SpaceDetailActivity.this, result.type, Toast.LENGTH_SHORT).show();
						JSONObject object = new JSONObject();
						try {
							object.put("id", "-1");
							object.put("type", DETAIL_PIC);
							object.put("say",  getResources().getString( R.string.notexist ));
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
						array.put(object);
						mviewAdapter.notifyDataSetChanged();
					}
					
					if ( array.length() < arrayList.size() ) {
							loadDetailTask(arrayList.get(array.length()));
					}
				}
			}.execute("");
		}
		public void sendComment(final String msg)
		{
			// TODO: task to send
			if (msg.length() < 1) {
				Toast.makeText(this, getResources().getString(R.string.tips_input_less0), Toast.LENGTH_SHORT).show();
				return;
			}
			commentEditText.setText("");
			try {
				JSONObject currentJsonObject = array.getJSONObject(currentPage);
				ArrayList<Map<String, Object>> commentList = new ArrayList<Map<String, Object>>();
				Map<String, Object> map = new HashMap<String, Object>();
				map.put(FLAGS[0], UserInfoManager.getInstance(SpaceDetailActivity.this).getItem("name").getValue() +  ": ");
				map.put(FLAGS[1], msg);
//				map.put(FLAGS[2], "");
				commentList.add(map);
				currentJsonObject.put("listview", commentList);
				mviewAdapter.notifyListView(currentPage);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			new AsyncTask<String, String, String>(){
				protected void onPreExecute() {
					Toast.makeText(SpaceDetailActivity.this, getResources().getString(R.string.tips_sending), Toast.LENGTH_SHORT).show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					try {
						String idString = "";
						String typeString = "";
						if (isFromPublish) {
							idString = mID;
							typeString = mType;
						}else
						{
							idString = arrayList.get(currentPage).id;
							typeString = arrayList.get(currentPage).type;
						}
						String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_send_comment),
								 idString, typeString,UserInfoManager.getInstance(SpaceDetailActivity.this).getItem("m_auth").getValue(),
								URLEncoder.encode(msg, "utf-8"));
					} catch (NotFoundException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (UnsupportedEncodingException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					return null;
				}
				protected void onPostExecute(String result) {
//					mviewAdapter.notifyDataSetChanged();
//					Toast.makeText(SpaceDetailActivity.this, getResources().getString(R.string.tips_send_success), Toast.LENGTH_SHORT).show();
				};
			}.execute("");
		}
		
		private android.content.DialogInterface.OnClickListener dialogClickListener = 
				new android.content.DialogInterface.OnClickListener()
				{
				
					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						if( dialog == refreshAlertDialog )
						{
							if ( which == android.content.DialogInterface.BUTTON_NEGATIVE ) {
//								commentDialog.hide();
							}else if( which == android.content.DialogInterface.BUTTON_POSITIVE )
							{
								if( updateString != null && !updateString.equals(""))
								{
									arrayList.clear();
									array = new JSONArray();
									mviewAdapter = new SpaceViewPagerAdapter(SpaceDetailActivity.this, array);
									mViewPager.setAdapter(mviewAdapter);
									if (detailAsyncTask != null  && !detailAsyncTask.isCancelled()) {
										detailAsyncTask.cancel(true);
									}
									update(updateString);
								}
									
							}
						}else if (dialog == commentDialog ) {
							if ( which == android.content.DialogInterface.BUTTON_NEGATIVE ) {
								commentDialog.dismiss();
							}else if( which == android.content.DialogInterface.BUTTON_POSITIVE )
							{
								sendComment(commentEditText.getText().toString());
							}
						}else if ( dialog == backPage1Dialog )
						{
							if ( which == android.content.DialogInterface.BUTTON_POSITIVE ) {
								mViewPager.setCurrentItem(0);
							}
						}
					}
			
				};
				public void requsetSetLove(String mtype, String mid)
				{
					final String type = mtype;
					final String id = mid;
					new AsyncTask<String, String, String>(){
							@Override
							protected void onPreExecute() {
								// TODO Auto-generated method stub
								super.onPreExecute();
								mBtn_love.setSelected( ! mBtn_love.isSelected() );
								mBtn_love.setTag("1");
								Toast.makeText(SpaceDetailActivity.this, R.string.tips_msg_has_run, Toast.LENGTH_SHORT).show();
							}
							@Override
							protected String doInBackground(
									String... params) {
								// TODO Auto-generated method stub
								String respon = null;
								try {
									 respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_set_love), 
											array.getJSONObject(currentPage).getString("id"), 
											array.getJSONObject(currentPage).getString("type"), 
											(mBtn_love.isSelected() ? "1" : "0"),UserInfoManager.getInstance(SpaceDetailActivity.this).getItem("m_auth").getValue());
								} catch (NotFoundException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								return respon;
							}
							@Override
							protected void onPostExecute(String result) {
								// TODO Auto-generated method stub
								super.onPostExecute(result);
								mBtn_love.setTag("0");
								try {
									JSONObject object = new JSONObject(result);
									if( object.getInt("error") == 0)
									{
										String dirname = getIdtyePath(type);
										String idString  = id;
										DataModel currentDataModel = (DataModel) ModelDataMgr.getInstance().getModel(idString, dirname);
										currentDataModel.love = (mBtn_love.isSelected() ? 1 : 0 );
										ModelDataMgr.getInstance().saveModel(currentDataModel, dirname);
										array.getJSONObject(currentPage).put("love", currentDataModel.love );
									}
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
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
							SpaceDetailActivity.this.finish();
						}else if( v == mBtn_next )
						{
							if( mViewPager.getCurrentItem() + 1 < array.length())
							{
								mViewPager.setCurrentItem(mViewPager.getCurrentItem() + 1);
							}else
							{
								if (array.length() == 0) {
									mBtn_next.setVisibility(View.INVISIBLE);
									Toast.makeText(SpaceDetailActivity.this, R.string.tips_msg_nodata, Toast.LENGTH_SHORT).show();
								}else
								{
									Toast.makeText(SpaceDetailActivity.this, R.string.tips_msg_waitforload, Toast.LENGTH_SHORT).show();
									mProgressDialog.show();
								}
							
							}
							
						}else if( v == mBtn_prev )
						{
							if( mViewPager.getCurrentItem() - 1 >= 0 )
							{
								mViewPager.setCurrentItem(mViewPager.getCurrentItem() - 1);
							}else {
								Toast.makeText(SpaceDetailActivity.this, "the first one", Toast.LENGTH_SHORT).show();
							}
						}else if( v == commentButton )
						{
							try{
								if( array.length() > 0 &&  ! array.getJSONObject(currentPage).isNull("id"))
									commentDialog.show();
								else {
									Toast.makeText(SpaceDetailActivity.this, getResources().getString(R.string.tips_msg_nodata), Toast.LENGTH_SHORT).show();
								}
							}catch (Exception e) {
								// TODO: handle exception
								e.printStackTrace();
							}
						}else if( v == mBtn_love )
						{
							try{
								if( array.length() > 0 &&  ! array.getJSONObject(currentPage).isNull("id"))
								{	
									if ( mBtn_love.getTag().equals("1") )
									{
										Toast.makeText(SpaceDetailActivity.this, R.string.tips_msg_has_run, Toast.LENGTH_SHORT).show();
										return;
									}
									if( mBtn_love.isSelected() )
									{
										new Builder(SpaceDetailActivity.this).setMessage(getResources().getString(R.string.dialog_msg_cancel_love))
										.setPositiveButton(R.string.dialog_button_sure, new DialogInterface.OnClickListener() {
											
											@Override
											public void onClick(DialogInterface dialog, int which) {
												// TODO Auto-generated method stub
												requsetSetLove(mType, mID);
											}
										}).setNegativeButton(R.string.dialog_button_cancel, null).create().show();
									}else 
									{
										requsetSetLove(mType, mID);
									}
								}
								else {
									Toast.makeText(SpaceDetailActivity.this, getResources().getString(R.string.tips_msg_nodata), Toast.LENGTH_SHORT).show();
								}
							}catch (Exception e) {
								// TODO: handle exception
								e.printStackTrace();
							}
							
						}else if( v == mReblog )
						{
							
							try {
								if ( mUidString.equals(
										UserInfoManager.getInstance(SpaceDetailActivity.this).getItem("uid").getValue()) )
								{
									Toast.makeText(SpaceDetailActivity.this, R.string.tips_msg_noreblogself, Toast.LENGTH_SHORT).show();
									return;
								}
							} catch (Exception e) {
								// TODO: handle exception
								e.printStackTrace();
							}
							reblog();
						}
//						else if( v == addfamilyView )
//						{
//							Intent intent = new Intent();
//							intent.setClass(SpaceDetailActivity.this, AddMemberActivity.class);
//							SpaceDetailActivity.this.startActivity(intent);
//						}else if( v == publishView )
//						{
//							Intent intent = new Intent();
//							intent.setClass(SpaceDetailActivity.this, PublishActivity.class);
//							SpaceDetailActivity.this.startActivity(intent);
//						}
						
					}
			
				};
				public void reblog()
				{
					try{
						if( array.length() > 0 &&  ! array.getJSONObject(currentPage).isNull("id"))
						{	
							// event is not reblog
							JSONObject currentJsonObject = array.getJSONObject(currentPage);
							String currentIdtype = currentJsonObject.getString("type");
							if ( currentIdtype.equals(DETAIL_EVNET) || currentIdtype.equals(DETAIL_REEVNET) ||
									currentIdtype.equals(DETAIL_VIDEO) || currentIdtype.equals(DETAIL_REVIDEO) )
							{
								Toast.makeText(SpaceDetailActivity.this, getResources().getString(R.string.tips_msg_noreblog), Toast.LENGTH_SHORT).show();
							}else {
								Intent intent = new Intent();
								intent.setClass(SpaceDetailActivity.this, PublishActivity.class);
								intent.putExtra("type", currentIdtype);
								intent.putExtra("id", currentJsonObject.getString("id"));
								if( currentIdtype.equals(DETAIL_BLOG) || currentIdtype.equals(DETAIL_REBLOG) )
								{
									intent.putExtra("blogcontext", currentJsonObject.getString("html"));
								}
								if( currentIdtype.equals(DETAIL_PIC) || currentIdtype.equals(DETAIL_REPIC) )
								{
									 ArrayList<PicInfo> pics = (ArrayList<PicInfo>) currentJsonObject.get("imgarray");
									 ArrayList<String> picUrls = new ArrayList<String>();
									 String picstemp;
									 int find;
									 for (int i = 0; i < pics.size(); i++) {
										picstemp = pics.get(i).url	;
										find = picstemp.indexOf("!");
										if( find != -1 )
										{
											picstemp = picstemp.substring(0, find+1);
										}
										picstemp = picstemp + REBLOG_PIC_TAIL;
										picUrls.add(picstemp);
									}
									 intent.putStringArrayListExtra("imgarray", picUrls);
								}
								SpaceDetailActivity.this.startActivity(intent);
							}
						}else {
							Toast.makeText(SpaceDetailActivity.this, getResources().getString(R.string.tips_msg_nodata), Toast.LENGTH_SHORT).show();
						}
					}catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
				}
				public boolean onCreateOptionsMenu(Menu menu) {
					// Inflate the menu; this adds items to the action bar if it is present.
//					getMenuInflater().inflate(R.menu.activity_login, menu);
					menu.add(menu.NONE, 0, 0, R.string.exit).setIcon(R.drawable.icon_exit);
					return super.onCreateOptionsMenu(menu);
				}
				@Override
				public boolean onOptionsItemSelected(MenuItem item) {
					// TODO Auto-generated method stub
					switch(item.getItemId()) {
						case 0:
							SpaceDetailActivity.this.finish();
							break;
						default:
							break;
					}
					return super.onOptionsItemSelected(item);
				}
				private AlertDialog backPage1Dialog = null;
				public OnLongClickListener longClickListener = new OnLongClickListener() {
					
					@Override
					public boolean onLongClick(View v) {
						// TODO Auto-generated method stub
						if ( backPage1Dialog == null )
						{
							backPage1Dialog = new Builder(SpaceDetailActivity.this).setMessage(R.string.dialog_msg_backpage1).
							setPositiveButton(R.string.dialog_button_sure, dialogClickListener)
							.setNegativeButton(R.string.dialog_button_close, null).create();
						}
						backPage1Dialog.show();
						return false;
					}
				};
}
