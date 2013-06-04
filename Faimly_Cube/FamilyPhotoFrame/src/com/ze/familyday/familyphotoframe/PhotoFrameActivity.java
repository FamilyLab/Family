package com.ze.familyday.familyphotoframe;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.commontool.LoadImageMgr.ImageCallBack;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.DataModel;
import com.ze.model.ModelDataMgr;
import com.ze.model.PhotoModel;
import com.ze.model.PhotoModel.PicInfo;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources.NotFoundException;
import android.graphics.Color;
import android.graphics.Paint.Style;
import android.graphics.drawable.Drawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextPaint;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationSet;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import android.widget.Toast;

public class PhotoFrameActivity extends Activity {
	
	private ImageView img_1;
	private ImageView img_2;
	private TextView say;
	ProgressDialog mProgressDialog;
	JSONArray array ;
	JSONArray array_love ;		// 播放本地喜爱的照片
	int currentPage = 0;
	public boolean isPush =false;
	public String 	  pushString = "";
	public static PhotoFrameActivity instance;
//	private Button stopView;
	private View logoutView;
	private Button love;
	private View menuView;
	private View photoFrameView;
	private Animation menuInAnimation;
	private Animation menuOutAnimation;
	
	private View playAll;
	private View deleteView;
	private View playLove;
	private View wifiView;
	private AnimationSet deleteOutAnimation;
	private View 			layout_info;
	private View 			layout_info_1;
	
	private TextView 	layout_info_name;
	private TextView 	layout_info_name_back;
	private TextView 	layout_info_time;
	private TextView 	layout_info_time_back;
	
	private TextView	layout_info_say_back;
	private View 			layout_info_img;
	private int 				model;
	private boolean 	uselocal;
	private 		BroadcastReceiver receiver ;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_frame);
		uselocal = getIntent().getBooleanExtra("uselocal",false);
		img_1 	= (ImageView) findViewById(R.id.pic_content_1);
		img_2 	= (ImageView) findViewById(R.id.pic_content_2);
		say = (TextView)findViewById(R.id.pic_desc);
		model = getIntent().getIntExtra("model", PLAYING_ALL);
//		stopView = (Button) findViewById(R.id.photoframe_stop);
		logoutView = findViewById(R.id.photoframe_logout);
		love = (Button) findViewById(R.id.photoframe_love);
//		stopView.setOnClickListener(buttonClickListener);
		img_1.setOnClickListener(buttonClickListener);
		img_2.setOnClickListener(buttonClickListener);
		playAll = findViewById(R.id.photoframe_play_all);
		playLove = findViewById(R.id.photoframe_play_love);
		deleteView = findViewById(R.id.photoframe_del);
		wifiView		= findViewById(R.id.photoframe_wifi);
		wifiView.setOnClickListener(buttonClickListener);
		playAll.setOnClickListener(buttonClickListener);
		playLove.setOnClickListener(buttonClickListener);
		deleteView.setOnClickListener(buttonClickListener);
		
		logoutView.setOnClickListener(buttonClickListener);
		love.setOnClickListener(buttonClickListener);
		menuView = findViewById(R.id.photoframe_menu_layout);
		photoFrameView = findViewById(R.id.pic_content_layout);
		photoFrameView.setOnClickListener(buttonClickListener);
		PublicInfo.SCREEN_W = getWindowManager().getDefaultDisplay().getWidth();
		PublicInfo.SCREEN_H = getWindowManager().getDefaultDisplay().getHeight();
		img_1.setVisibility(View.VISIBLE);
		img_2.setVisibility(View.INVISIBLE);
		arrayList = new ArrayList<DataModel>();
		array = new JSONArray();
		array_love = new JSONArray();
		mProgressDialog = new ProgressDialog(this);
		mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
//		mProgressDialog.setCanceledOnTouchOutside(false);
		indexAnimation = new AlphaAnimation(0.0f, 1.0f);
		indexAnimation.setAnimationListener(animationListener);
		indexAnimation.setDuration(500);
		dismissAnimation = new AlphaAnimation(1.0f, 0.0f);
		dismissAnimation.setAnimationListener(animationListener);
		dismissAnimation.setDuration(500);
		instance = this;
		menuInAnimation = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0.0f, Animation.RELATIVE_TO_SELF,0.0f, Animation.RELATIVE_TO_SELF, -1.0f, 
		Animation.RELATIVE_TO_SELF,0.0f);
		menuInAnimation.setAnimationListener(animationListener);
		menuInAnimation.setDuration(200);
		menuInAnimation.setFillEnabled(true);
		menuInAnimation.setFillAfter(true);
//		menuOutAnimation =  new TranslateAnimation(1.0f, 1.0f, 0.0f, -1.0f);
		menuOutAnimation = new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0.0f, Animation.RELATIVE_TO_SELF,0.0f, Animation.RELATIVE_TO_SELF, 0.0f, 
				Animation.RELATIVE_TO_SELF,-1.0f);
		menuOutAnimation.setAnimationListener(animationListener);
		menuOutAnimation.setDuration(200);
		menuOutAnimation.setFillEnabled(true);
		menuOutAnimation.setFillAfter(true);
//		menuShowing();
		deleteOutAnimation = new AnimationSet(true);
		deleteOutAnimation.addAnimation(new ScaleAnimation(1.0f, 0.1f, 1.0f, 0.1f, 
				Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f) );
		deleteOutAnimation.addAnimation(new TranslateAnimation(Animation.RELATIVE_TO_SELF, 0.0f, Animation.RELATIVE_TO_PARENT,0.5f, Animation.RELATIVE_TO_SELF, 0.0f, 
				Animation.RELATIVE_TO_PARENT,-1.0f) );
		deleteOutAnimation.setDuration(500);
//		deleteOutAnimation.setFillEnabled(true);
//		deleteOutAnimation.setFillAfter(true);
		deleteOutAnimation.setAnimationListener(deleteAnimationListener);
		layout_info = findViewById(R.id.photoframe_info_layout);
		layout_info_1 = findViewById(R.id.photoframe_info_layout_1);
		
		layout_info_name_back = (TextView)findViewById(R.id.pic_desc_name_back);
		layout_info_time_back = (TextView)findViewById(R.id.pic_desc_time_back);
		layout_info_say_back 	= (TextView)findViewById(R.id.pic_desc_back);
		layout_info_name = (TextView)findViewById(R.id.pic_desc_name);
		layout_info_time = (TextView)findViewById(R.id.pic_desc_time);
		textPaint_name = layout_info_name_back.getPaint();
		textPaint_name.setStrokeWidth(1.0f);
		textPaint_name.setStyle(Style.STROKE);
		textPaint_time = layout_info_time_back.getPaint();
		textPaint_time.setStrokeWidth(1.0f);
		textPaint_time.setStyle(Style.STROKE);
		textPaint_say = layout_info_say_back.getPaint();
		textPaint_say.setStrokeWidth(1.0f);
		textPaint_say.setStyle(Style.STROKE);
		textPaintSayBody = say.getPaint();
		textPaint_say.setStrokeWidth(1.0f);
		textPaint_say.setStyle(Style.FILL_AND_STROKE);
		
		layout_info_img = findViewById(R.id.pic_desc_img);
//		textPaint.setColor(Color.BLACK);
		
		if( model == PLAYING_ALL )
		{
//			playAll.setVisibility(View.VISIBLE);
//			playLove.setVisibility(View.INVISIBLE);
			loadListTask(true);
		}else
		{
//			playLove.setVisibility(View.VISIBLE);
//			playAll.setVisibility(View.INVISIBLE);
			loadLoveListTask(true);
		}
		judgeNext(500);
		receiver = new WifiReceiver();
		IntentFilter filter = new IntentFilter();
		filter.addAction(WifiManager.NETWORK_STATE_CHANGED_ACTION);
		registerReceiver(receiver, filter);
	};
	TextPaint textPaint_name;
	TextPaint textPaint_time;
	TextPaint textPaint_say;
	TextPaint textPaintSayBody;
	ArrayList<DataModel> arrayList = null;
	boolean loadListTaskFlag = false;
	String mUidString = null;
	public void loadListTask(final boolean refresh){
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
			array = new JSONArray();
			if( loadListTaskFlag )
			{
				return;
			}
				
		}
		new AsyncTask<String, String, String>(){
			protected void onPreExecute() {
//				mProgressDialog.show();
				if ( mUidString == null )
				{
					Componet uidComponet = UserInfoManager.getInstance(PhotoFrameActivity.this).getItem("uid");
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
					page = arrayList.size()/PublicInfo.PER_LOAD + 1 + "";
				}
				if( refresh )
				{
					if (!isNetAble()) {
						return ModelDataMgr.getInstance().loadPhotoListResponse(1);
					}
				}
				String responString ;
				Componet m_authComponet = UserInfoManager.getInstance(PhotoFrameActivity.this).getItem("m_auth");
				if ( null == m_authComponet ) {
					 return "";
				}
					responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_feedlist),
							"photoid",page,
							m_authComponet.getValue());
				if( refresh && responString != null && !responString.equals("") )
				{
					ModelDataMgr.getInstance().savePhotoListResponse(responString,1);
				}
				return responString;
			}
			protected void onPostExecute(String result) {
				loadListTaskFlag = false;
				if( result != null && !result.equals("") )
				{
				
					if( refresh  )
					{
						switchPlayModel = PLAYING_ALL;
						currentPage = 0;
						arrayList.clear();
						update(result);
						return;
					}else
					{
						update(result);
					}
				}else {
					Toast.makeText(PhotoFrameActivity.this, "出错了，请检查你的网络！", Toast.LENGTH_SHORT).show();
					PhotoFrameActivity.this.finish();
				}
			};
		}.execute("");
}
	public void setTimerRefresh()
	{
		new Thread(new Runnable() {
				
				@Override
				public void run() {
					// TODO Auto-generated method stub
					int count = 0;
					while(count < PublicInfo.REFRESH_TIME)
					{
						if (isDestryod) {
							return;
						}else
						{
							try {
								Thread.sleep(1000);
								count++;
							} catch (Exception e) {
								// TODO: handle exception
							}
						}
					}
					//时间到
					if( array != null ){
						try {
							// 当前是否处于推送暂停状态
							while( play_stop && !array.getJSONObject(currentPage).isNull("pushnoread"))
							{
								Thread.sleep(1000);
							}
						} catch (Exception e) {
							// TODO: handle exception
						}
					}
					// 开始调用刷新任务
					handler.sendEmptyMessage(0);
				}
			}).start();
	}
	public void loadLoveListTask(final boolean refresh){
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
				array = new JSONArray();
				if( loadListTaskFlag )
				{
					return;
				}
					
			}
			new AsyncTask<String, String, String>(){
				protected void onPreExecute() {
					mProgressDialog.show();
					array = new JSONArray();
					if ( mUidString == null )
					{
						Componet uidComponet = UserInfoManager.getInstance(PhotoFrameActivity.this).getItem("uid");
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
						page = arrayList.size()/PublicInfo.PER_LOAD + 1 + "";
					}
					if( refresh )
					{
						if (!isNetAble()) {
							return ModelDataMgr.getInstance().loadPhotoListResponse(2);
						}
					}
					String responString ;
					Componet m_authComponet = UserInfoManager.getInstance(PhotoFrameActivity.this).getItem("m_auth");
					if ( null == m_authComponet ) {
						 return "";
					}
					responString= NetHelper.getResponByHttpClient(getResources().getString(R.string.http_lovelist),
							m_authComponet.getValue(),page);
//					arrayList = ModelDataMgr.getInstance().getIdList(ModelDataMgr.PHOTO_LOVE_IDLIST);
					if( refresh && responString != null && !responString.equals("") )
					{
						ModelDataMgr.getInstance().savePhotoListResponse(responString,2);
					}
					return responString;
				}
				protected void onPostExecute(String result) {
					currentPage = 0;
					loadListTaskFlag = false;
					if( result != null && !result.equals("") )
					{
						if( refresh  )
						{
							switchPlayModel = PLAYING_LOVE;
							currentPage = 0;
							arrayList.clear();
							update(result);
							return;
						}else
						{
							update(result);
						}
					}else {
						Toast.makeText(PhotoFrameActivity.this, "出错了，请检查你的网络！", Toast.LENGTH_SHORT).show();
						PhotoFrameActivity.this.finish();
					}
				};
			}.execute("");
	}
	public void switchModel(int pModel)
	{
		Intent intent = new Intent();
		intent.setClass(PhotoFrameActivity.this, PhotoFrameActivity.class);
		intent.putExtra("model", pModel);
		PhotoFrameActivity.this.startActivity(intent);
		PhotoFrameActivity.this.finish();
	}
	private void update(String result)
	{
		try {
			JSONObject jsonObject = new JSONObject(result);
			if ( 0 == jsonObject.getInt("error") )
			{
					JSONArray jsonArray = jsonObject.getJSONArray("data");
					int size = jsonArray.length();
					JSONObject temp;
					if ( size == 0 )
					{
//						mViewPager.setVisibility(View.INVISIBLE);
					}
					DataModel object ;
					for (int i = 0; i < size; i++) {
						temp = jsonArray.getJSONObject(i);
						object = new DataModel();
						object.id = temp.getString("id");
						object.uid = temp.getString("uid");
						object.type = temp.getString("idtype");
						arrayList.add(object);
					}
				}
				if( arrayList.size() > 0 && arrayList.size() > array.length() )
				{
					loadDetailTask(arrayList.get(array.length()));
							ModelDataMgr.getInstance().saveIdList(arrayList,ModelDataMgr.PHOTO_ID_LIST );
				}else
				{
					if (mProgressDialog.isShowing()) {
						mProgressDialog.hide();
					}
//					Toast.makeText(PhotoFrameActivity.this, getResources().getString(R.string.dialog_msg_nomoredata), Toast.LENGTH_LONG).show();
				}
			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			if (mProgressDialog.isShowing()) {
				mProgressDialog.hide();
			}
//			Toast.makeText(PhotoFrameActivity.this, "error", Toast.LENGTH_LONG).show();
		}
	}
	public void loadDetailTask(final DataModel picJsonObject)
	{
		new AsyncTask<String, String, DataModel>(){
			boolean notopen = false;
			private boolean error = false;			// 读取操作中是否出错
			String typeidString = "photoid";
			String dirPath = null;
			String urlString = null;
			protected void onPreExecute() {
				typeidString = picJsonObject.type;
				if ( typeidString.equals("photoid") || typeidString.equals("rephotoid")) {
					dirPath = ModelDataMgr.PHOTO_DIR;
					urlString = getResources().getString(R.string.http_photo_detail);
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
							UserInfoManager.getInstance(PhotoFrameActivity.this).getItem("m_auth").getValue());
					JSONObject object;
					object = new JSONObject(respon);
					if ( 0 == object.getInt("error") ) {
//							model = new DataModel();
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
//									((PhotoModel)model).tagname 	=  object.getString("tagname");
									
								}
								if( !object.isNull("message") )
								{
									((PhotoModel)model).say 	=  object.getString("message");
									
								}
								if( !object.isNull("subject") )
								{
//									((PhotoModel)model).say 		=  object.getString("subject");
									((PhotoModel)model).tagname 		=  object.getString("subject");
								}
								if( !object.isNull("mylove") )
								{
//									((PhotoModel)model).say 		=  object.getString("subject");
									((PhotoModel)model).love 		=  object.getInt("mylove");
								}
//								 多图情况处理
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
							}
							ModelDataMgr.getInstance().saveModel(model,dirPath);
						}else
						{
							// 找不到该id的数据或者获取这个数据时出错了，得到的id得不到详情的内容 
							error = true;
//							model.type = object.getString("msg");
						}
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					//e.printStackTrace();
				}
				return model;
			}
			protected void onPostExecute(DataModel result) {
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
				if( notopen )
				{
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
							}
							array.put(object);
//							mviewAdapter.notifyDataSetChanged();
							if( currentPage == 0 && !initFlag )
							{
								Log.v("test", "**********load " + array.length() + "***********");
								if( array.length() > PublicInfo.FIRST_LOAD || arrayList.size() <= PublicInfo.FIRST_LOAD )
								{
									initFlag = true;
									showNext(currentPage);
									if( model == PLAYING_ALL )
										setTimerRefresh();
									Log.v("test", "********** start to show! ***********");
								}
							}
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					
				}else {
//					Toast.makeText(SpaceDetailActivity.this, result.type, Toast.LENGTH_SHORT).show();
					JSONObject object = new JSONObject();
					try {
						object.put("id", "-1");
						object.put("type", "(((");
						object.put("say",  getResources().getString( R.string.notexist ));
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					array.put(object);
//					mviewAdapter.notifyDataSetChanged();
				}
				if ( array.length() < arrayList.size() ) {
						loadDetailTask(arrayList.get(array.length()));
				}
			}
		}.execute("");
	}
	public static final String SIZEMODEL_1 = "320";
	public static final String SIZEMODEL_2 = "512X768";
	
	public void showNext(int index)
	{
			try {
				JSONObject object = null;
				if( index < array.length() )
				{
					object = array.getJSONObject(index);
				}else
				{
					currentPage = 0;
					object = array.getJSONObject(0);
				}
				boolean judeOneRound = false;
				while( object.optBoolean("delete", false))
				{
					if( currentPage < array.length() )
					{
						currentPage ++;
						index = currentPage;
						object = array.getJSONObject(index);
					}else
					{
						if(judeOneRound)
						{
							// 一张图片都不符合显示条件
							new AlertDialog.Builder(this).setMessage("目前没有可显示的照片，你可以通过手机客户端拍照分享，邀请你的家人一起来吧！").setNeutralButton("关闭", null).show();
						}else {
							judeOneRound = true;
							currentPage = 0;
						}
					}
				}
				img_1.setVisibility(View.INVISIBLE);
//				img_2.setVisibility(View.VISIBLE);
				  if( !object.isNull("imgarray"))
				  {
					  ArrayList<PicInfo> imgArray = (ArrayList<PicInfo>) object.get("imgarray");
					  String imgUrl ;
		          	for (int i = 0; i < imgArray.size(); i++) {
		          		if ( i == 1 ) {
		          			// 电子相框版本。只有一张，其他的不加入
								break;
							}
	          		imgUrl = imgArray.get(i).url;
	          		int endFlag = -1;
	          		int img_w = imgArray.get(i).width;
	          		int img_h  = imgArray.get(i).height;
//	          		android.widget.RelativeLayout.LayoutParams params = (android.widget.RelativeLayout.LayoutParams) img_1.getLayoutParams();
	          		android.widget.RelativeLayout.LayoutParams params = new android.widget.RelativeLayout.LayoutParams(1024, 768);
	          		endFlag = imgUrl.indexOf("!");
	          		android.widget.RelativeLayout.LayoutParams layout_infoParams = null;
	          		android.widget.RelativeLayout.LayoutParams layout_infoParams_1 = null;
	          		
//	          		layout_infoParams.setMargins(20, 20, 20, 20);
	          		if ( endFlag != -1 ) {
						imgUrl = imgUrl.substring(0, endFlag);
						if ( img_w >= img_h ) {
							imgUrl = imgUrl + PublicInfo.PHOTO_SIZE_LARGE;
							Log.v("test1", "next is heng");
							params.height = PublicInfo.SCREEN_H;
							params.width = PublicInfo.SCREEN_W;
							layout_infoParams
			          		= new android.widget.RelativeLayout.LayoutParams(PublicInfo.SCREEN_W, PublicInfo.SCREEN_H / 3);
							layout_infoParams_1
			          		= new android.widget.RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
							layout_infoParams_1.addRule(RelativeLayout.CENTER_VERTICAL);
							layout_infoParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
							layout_infoParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
							say.setTextColor(Color.WHITE);
							layout_info_name.setTextColor(Color.WHITE);
							layout_info_time.setTextColor(Color.WHITE);
							textPaint_name.setStrokeWidth(1.0f);
							textPaint_name.setStyle(Style.STROKE);
							textPaint_say.setStrokeWidth(1.0f);
							textPaint_say.setStyle(Style.STROKE);
							textPaint_time.setStrokeWidth(1.0f);
							textPaint_time.setStyle(Style.STROKE);
//							layout_info_img.setVisibility(View.INVISIBLE);
							layout_info_img.setBackgroundDrawable(getResources().getDrawable(R.drawable.photo_img_2));
							
							layout_infoParams.setMargins(20, 20, 100, 100);
							
							layout_info_say_back.setMaxLines(1);
							say.setMaxLines(1);
							
//							layout_info_time.setVisibility(View.INVISIBLE);
//							layout_info_time_back.setVisibility(View.INVISIBLE);
						}else
						{
							Log.v("test1", "next is shu");
							imgUrl = imgUrl + PublicInfo.PHOTO_SIZE_HALF;
							params.height = PublicInfo.SCREEN_H;
							params.width = PublicInfo.SCREEN_W / 2;
							layout_infoParams
			          		= new android.widget.RelativeLayout.LayoutParams(PublicInfo.SCREEN_W/2, PublicInfo.SCREEN_H);
							layout_infoParams_1
			          		= new android.widget.RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
							int random = (int) (Math.random()*10);
							layout_infoParams.addRule(RelativeLayout.CENTER_VERTICAL);
							if(random % 2== 0) 
							{
								params.addRule(RelativeLayout.ALIGN_PARENT_RIGHT) ;
								layout_infoParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
//								layout_infoParams.setMargins(20, 20, 20, 20);
								layout_infoParams_1.addRule(RelativeLayout.CENTER_VERTICAL);
							}else{
								params.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
								layout_infoParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
//								layout_infoParams.setMargins(50,0,10,0);
								layout_infoParams_1.addRule(RelativeLayout.CENTER_IN_PARENT);
							}
							say.setTextColor(Color.BLACK);
							layout_info_name.setTextColor(getResources().getColor(R.color.picinfo_name));
							layout_info_time.setTextColor(getResources().getColor(R.color.picinfo_time));
							textPaint_name.setStrokeWidth(0.0f);
							textPaint_name.setStyle(Style.STROKE);
							textPaint_say.setStrokeWidth(0.0f);
							textPaint_say.setStyle(Style.STROKE);
							textPaint_time.setStrokeWidth(0.0f);
							textPaint_time.setStyle(Style.STROKE);
//							layout_info_img.setVisibility(View.VISIBLE);
							layout_info_img.setBackgroundDrawable(getResources().getDrawable(R.drawable.photo_img_1));
							layout_info_say_back.setMaxLines(3);
							say.setMaxLines(3);
							
//							layout_info_time.setVisibility(View.VISIBLE);
//							layout_info_time_back.setVisibility(View.VISIBLE);
						}
					}
	          		if( layout_infoParams != null )
	          		{
	          			layout_info.setLayoutParams(layout_infoParams);
	          		}
	          		if( layout_infoParams_1 != null )
	          		{
	          			layout_info_1.setLayoutParams(layout_infoParams_1);
	          		}
	      			img_1.setLayoutParams(params);
	      			img_1.setVisibility(View.VISIBLE);
	      			 Drawable imageDrawable = LoadImageMgr.getInstance().loadDrawble(imgUrl, 
	      					img_1, 
	              			imageCallBack);
	      			img_1.setImageDrawable(imageDrawable)  ;
		          	}
				  }else
				  {
					Log.v("test", "*************** NO IMG ***************");
					  currentPage ++ ;
					  showNext(index);
				  }
				if ( img_1.getDrawable() == null ) {
					isLoadingPic = true;
				}else
				{
					
				}
				img_1.startAnimation(indexAnimation);
				  ///...
				 
				  
			}catch (Exception e) {
				// TODO: handle exception
			}
	}
	int loadImgCount = 0;
	public boolean isLoadingPic = false;
	public void judgeNext(int time)
	{
		  handler.postDelayed(new Runnable() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
					try {
						if ( array.getJSONObject(currentPage).optBoolean("pushnoread",false) )
						{
							 array.getJSONObject(currentPage).put("pushnoread", false);
							stopOrContinue(true);
						}
					} catch (Exception e) {
						// TODO: handle exception
					}
					if( play_stop || isLoadingPic || animation_playing || !initFlag )
					{
						if( img_1.getDrawable() == null )
						{
							Log.v("test", "^^^^^^^^^^^^ loading img ^^^^^^^^^^^^^^^^");
							loadImgCount ++ ;
							img_2.setVisibility(View.VISIBLE);
						}
						if( loadImgCount >= PublicInfo.LOAD_IMG_TIME )
						{
							Log.v("test", "^^^^^^^^^^^^ loading fail ^^^^^^^^^^^^^^^^");
							isLoadingPic = false;
							img_2.setVisibility(View.INVISIBLE);
							loadImgCount =0;
							currentPage ++;
							showNext(currentPage);
							judgeNext(PHOTO_SHOW_TIME);
							return;
						}
						judgeNext(1000);
						return;
					}
					if( isDestryod )
					{
						return;
					}
					if (currentPage < array.length()) {
						currentPage ++;
						if( currentPage == array.length() - 10 )
						{
							if ( isNetAble()) {
								//倒数第10张时,再次加载新数据
								if( switchPlayModel == PLAYING_ALL )
								{
									loadListTask(false);
								}else {
									loadLoveListTask(false);
								}
							}
						}
						img_1.startAnimation(dismissAnimation);
					}else
					{
//						Toast.makeText(PhotoFrameActivity.this, "已经达到最后一张,即将重新刷新！", Toast.LENGTH_SHORT).show();
//						loadListTask(true);
						currentPage = 0;
						img_1.startAnimation(dismissAnimation);
					}
					judgeNext(PHOTO_SHOW_TIME);
//					img_1.startAnimation(dismissAnimation);
				}
			}, time);
	}
	public boolean isDestryod = false;
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		isDestryod = true;
		unregisterReceiver(receiver);
	}
	public void setPicInfo(JSONObject object)
	{
		if( object == null )
		{
			say.setText("");
			layout_info_say_back.setText("");
			layout_info_name.setText("");
			layout_info_time.setText("");
			layout_info_name_back.setText("");
			layout_info_time_back.setText("");
			layout_info.setVisibility(View.INVISIBLE);
		}else
		{
			layout_info.setVisibility(View.VISIBLE);
			try {
				String str_say = object.optString("say","无标题");
				if (str_say.equals("")) {
					str_say = "无标题";
				}
				say.setText( str_say);
				layout_info_say_back.setText( str_say );
				layout_info_name_back.setText(object.getString("name"));
				layout_info_name.setText(object.getString("name"));
				layout_info_time.setText(NetHelper.transTime(Long.parseLong(object.getString("time"))) );
				layout_info_time_back.setText( NetHelper.transTime(Long.parseLong(object.getString("time"))) );
				
				
			} catch (Exception e) {
				// TODO: handle exception
			}
			
		}
		
	}
	private boolean muneShowFlag = false;
	public AnimationListener animationListener = new AnimationListener() {
		
		@Override
		public void onAnimationStart(Animation animation) {
			// TODO Auto-generated method stub
			if ( animation == dismissAnimation ) {
				setPicInfo(null);
			}else if( animation == indexAnimation )
			{
				try {
					JSONObject object = array.getJSONObject(currentPage);
					setPicInfo(object);
				} catch (Exception e) {
					// TODO: handle exception
				}
			}
			animation_playing = true;
		}
		
		@Override
		public void onAnimationRepeat(Animation animation) {
			// TODO Auto-generated method stub
			
		}
		
		@Override
		public void onAnimationEnd(Animation animation) {
			// TODO Auto-generated method stub
			animation_playing = false;
			if( animation == menuOutAnimation )
			{
				menuView.setVisibility(View.INVISIBLE);
				love.setSelected(false);
				return;
			}else if( animation == menuInAnimation )
			{
				try {
					if ( array != null && array.length() > currentPage ) {
						int set = array.getJSONObject(currentPage).optInt("love", 0);
						if( set == 1 ){
							love.setSelected(true);
						}else
						{
							love.setSelected(false);
						}
					}
			} catch (Exception e) {
				// TODO: handle exception
			}
				menuView.setVisibility(View.VISIBLE);
				return;
			}
			 if (animation == dismissAnimation) {
				 showNext(currentPage);
			 }
		}
	};
	private boolean play_stop = false;
	private boolean animation_playing = false;
	private boolean initFlag = false;
	public void stopOrContinue(boolean needStop)
	{
		if(  needStop )
		{
			play_stop = true;
			if (!muneShowFlag) {
				muneShowFlag = true;
				menuView.setVisibility(View.VISIBLE);
				menuView.startAnimation(menuInAnimation);
			}
		}else
		{
			play_stop = false;
			if (muneShowFlag) {
				muneShowFlag = false;
				menuView.setVisibility(View.INVISIBLE);
				menuView.startAnimation(menuOutAnimation);
			}
		}
	}
	private static int PHOTO_SHOW_TIME = 5000;
	public boolean isNetAble()
	{
		// 网络是否可用
		 ConnectivityManager connectivityManager=(ConnectivityManager) this.getSystemService(Context.CONNECTIVITY_SERVICE);
		 NetworkInfo net=connectivityManager.getActiveNetworkInfo();
		return net == null ? false : net.isConnected();
	}
	private Handler handler = new Handler()
	{
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 0:
				// 定时刷新
				if( model == PLAYING_ALL )
					switchModel(PLAYING_ALL);
				break;

			default:
				break;
			}
		};
	};
	private Animation indexAnimation;
	private Animation dismissAnimation;
	public void notifyPush(String extra)
	{
		try {
			JSONObject object = new JSONObject(extra);
		    final String pushType 	= object.optString("idtype");
		    final String uid				= object.optString("uid");
		    final String id					= object.optString("id");
//            DataModel dataModel = new DataModel();
//            dataModel.id = id;
//            dataModel.uid = uid;
//            dataModel.type = pushType;
            new AsyncTask<String , String, DataModel>(){
            	DataModel model = null;
				@Override
				protected DataModel doInBackground(String... params) {
					// TODO Auto-generated method stub
					String respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_photo_detail),
							id,
							uid,
							UserInfoManager.getInstance(PhotoFrameActivity.this).getItem("m_auth").getValue());
					JSONObject object;
					try {
						object = new JSONObject(respon);
					if ( 0 == object.getInt("error") ) {
//							model = new DataModel();
							object = object.getJSONObject("data");
								model = new PhotoModel();
								model.id 			= id;
								model.uid 		= uid;
								model.type		= pushType;
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
//									((PhotoModel)model).tagname 	=  object.getString("tagname");
									
								}
								if( !object.isNull("message") )
								{
									((PhotoModel)model).say 	=  object.getString("message");
									
								}
								if( !object.isNull("subject") )
								{
//									((PhotoModel)model).say 		=  object.getString("subject");
									((PhotoModel)model).tagname 		=  object.getString("subject");
								}
								if( !object.isNull("mylove") )
								{
//									((PhotoModel)model).say 		=  object.getString("subject");
									((PhotoModel)model).love 		=  object.getInt("mylove");
								}
//								 多图情况处理
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
							}
							ModelDataMgr.getInstance().saveModel(model,ModelDataMgr.PHOTO_DIR);
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					return model;
				}
				protected void onPostExecute(DataModel result) {
					try {
						JSONObject object = new JSONObject();
							object.put("id", result.id);
							object.put("type", result.type);
							object.put("fuid", result.fromUid);
							object.put("fname", result.fromName);
							object.put("love",  result.love);
							object.put("uid", result.uid);
							if( pushType.equals("photoid") || pushType.equals("rephotoid"))
							{
								object.put("imgarray", ((PhotoModel)result).photos);
								object.put("say",  ((PhotoModel)result).say);
								object.put("listview", null);
								object.put("time",  ((PhotoModel)result).time);
								object.put("name",  ((PhotoModel)result).name);
								object.put("tagname",  ((PhotoModel)result).tagname);
								object.put("tagid",  ((PhotoModel)result).tagid);
							}
							int pos = 0;
							if (currentPage == array.length()-1) {
								pos = 0;
							}else
							{
								pos = currentPage + 2;
							}
							object.put("pushnoread", true);
							array.put(pos,object);
							
						} catch (Exception e) {
							// TODO: handle exception
						}
					
				};
            }.execute("");
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
	public int switchPlayModel = 0;
	public static final int CHANGE_TO_ALL = 1;
	public static final int CHANGE_TO_LOVE = 2;
	public static final int PLAYING_ALL = 22;
	public static final int PLAYING_LOVE = 11;
	
	/**
	 * 
	 */
	public OnClickListener buttonClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if( v == img_1 || v == img_2 || v == photoFrameView )
			{
				stopOrContinue(!play_stop);
			}
			else if( v == love )
			{
				try {
					if (array != null && array.length() > currentPage) {
						requsetSetLove(array.getJSONObject(currentPage).getString("id"));
					}
				} catch (Exception e) {
					// TODO: handle exception
				}
				
			}else if( v == playAll )
			{
				switchModel(PLAYING_ALL);
			}else if( v == playLove )
			{
				switchModel(PLAYING_LOVE);
			}else if( v == deleteView ) 
			{
				if ( animation_playing ) {
					return;
				}else
				{
//					array.
					try {
						array.getJSONObject(currentPage).put("delete", true);
						img_1.startAnimation(deleteOutAnimation);
					} catch (Exception e) {
						// TODO: handle exception
					}
				}
			}else if( v == logoutView )
			{
				new AlertDialog.Builder(PhotoFrameActivity.this).setMessage("确定要退出登录吗?").setPositiveButton("确定", 
						new DialogInterface.OnClickListener() {
							
							@Override
							public void onClick(DialogInterface dialog, int which) {
								// TODO Auto-generated method stub
								Componet uidComponet = UserInfoManager.getInstance(PhotoFrameActivity.this).getItem("uid");
								if (uidComponet != null) {
									FamilyDayVerPMApplication.unBindJpush(PhotoFrameActivity.this, uidComponet.getValue());
									UserInfoManager.getInstance(PhotoFrameActivity.this).deleteAll();
									PhotoFrameActivity.this.finish();
								}
							}
						}).
				setNegativeButton("取消", null).create().show();
			}else if( v == wifiView )
			{
				openWifiLogin();
			}
				
		}
	};
	public void requsetSetLove(final String mid)
	{
		new AsyncTask<String, String, String>(){
				@Override
				protected void onPreExecute() {
					// TODO Auto-generated method stub
					super.onPreExecute();
					love.setSelected( ! love.isSelected() );
					love.setTag("1");
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
								(love.isSelected() ? "1" : "0"),UserInfoManager.getInstance(PhotoFrameActivity.this).getItem("m_auth").getValue());
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
					love.setTag("0");
					try {
						JSONObject object = new JSONObject(result);
						if( object.getInt("error") == 0)
						{
							String dirname  = ModelDataMgr.PHOTO_DIR;
							String idString  = mid;
							DataModel currentDataModel = (DataModel) ModelDataMgr.getInstance().getModel(idString, dirname);
							currentDataModel.love = (love.isSelected() ? 1 : 0 );
							ModelDataMgr.getInstance().saveModel(currentDataModel, dirname);
							array.getJSONObject(currentPage).put("love", currentDataModel.love );
							if (love.isSelected()) {
								Toast.makeText(PhotoFrameActivity.this, "收藏成功！", Toast.LENGTH_SHORT).show();
							}else
							{
								Toast.makeText(PhotoFrameActivity.this, "取消收藏成功！", Toast.LENGTH_SHORT).show();
							}
							
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				}
			}.execute("");
	}
	AnimationListener deleteAnimationListener = new AnimationListener() {
		
		@Override
		public void onAnimationStart(Animation animation) {
			// TODO Auto-generated method stub
			
		}
		
		@Override
		public void onAnimationRepeat(Animation animation) {
			// TODO Auto-generated method stub
			
		}
		
		@Override
		public void onAnimationEnd(Animation animation) {
			// TODO Auto-generated method stub
			if (animation == deleteOutAnimation) {
				Toast.makeText(PhotoFrameActivity.this, "删除成功", Toast.LENGTH_LONG).show();
				showNext(currentPage);
			}
		}
	};
public ImageCallBack imageCallBack = new ImageCallBack() {
		
		@Override
		public void setImage(Drawable d, String url, ImageView view) {
			// TODO Auto-generated method stub
			if( /*mActiveImages.contains(view) &&*/ url.equals((String)view.getTag()))
			{
				view.setImageDrawable(d);
				if( isLoadingPic )
				{
					img_2.setVisibility(View.INVISIBLE);
					img_1.startAnimation(indexAnimation);
					handler.postDelayed(new Runnable() {
						
						@Override
						public void run() {
							// TODO Auto-generated method stub
							if( img_1.getDrawable() != null)
								isLoadingPic = false;
						}
					}, PHOTO_SHOW_TIME);
				}
			}
		}
	};
	public AlertDialog netErrorDialog = null;
	public void notifyWifiChange()
	{
		if( uselocal )
		{
			return;
		}
		// 网络断开
		if( isNetAble() )
		{
			if( netErrorDialog != null && netErrorDialog.isShowing() )
			{
				netErrorDialog.hide();
			}
			return;
		}else
		{
			if( netErrorDialog == null )
			{
				netErrorDialog = new AlertDialog.Builder(this).setMessage("请设置wifi，以链接网络！").setPositiveButton("确定", new DialogInterface.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						openWifiLogin();
					}
				}).
				setNegativeButton("离线使用", new DialogInterface.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
					}
				}).create();
			}
			if( netErrorDialog.isShowing() )
			{
				return;
			}else
			{
				netErrorDialog.show();
			}
			
		}
	}
	public void openWifiLogin()
	{
		Intent intent = new Intent();
		intent.setClass(PhotoFrameActivity.this, WifiLoginActivity.class);
		startActivity(intent);
	}
}
