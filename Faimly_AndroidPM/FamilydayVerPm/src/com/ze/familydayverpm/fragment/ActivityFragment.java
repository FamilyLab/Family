package com.ze.familydayverpm.fragment;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
//
//import com.google.android.maps.MapController;
//import com.google.android.maps.MapView;
import com.amap.api.location.core.GeoPoint;
import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.familydayverpm.GaodeMapActivity;
import com.ze.familydayverpm.R;
import com.ze.familydayverpm.SpaceDetailActivity;
import com.ze.familydayverpm.adapter.PicListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.text.Html;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.webkit.WebView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

public class ActivityFragment extends RelativeLayout  implements RelativeLayoutImp {
	
	private Context mContext;
	
	private	ListView 					mListView;
	private 	BaseAdapter			mAdapter;
	private 	final String[]			FLAGS =
																{
																	"name",
																	"say",
																	"uid",
																};
	private 	static final 	int[]				IDS = {R.id.pic_item_name,R.id.pic_item_say};
	private 	 View 						mHeadView;
	private 	 View 						mFootView;
	private 	List<Map<String, Object>> mList;
	private 	JSONObject mObject;
	private    TextView					mTvName;
	private 	TextView					mTvTopic;
	private 	TextView					mTvTime;
	private 	TextView					mTvDetail;
	
	private 	TextView					mTvEventTime;
	private 	TextView					mTvEventPlace;
	private 	WebView					mTvEventIntroduce;
	
	private 	Button 					mBtnShowDisscuss;
	private 	ProgressBar				mProgressBar;
	public 	LinearLayout					mMapViewLayout;
	public 		Button 					mBtnSeeMap;
	private 	TextView					mTvEncourage;
	private 	ImageView				mPosterImageView;
	public ActivityFragment(Context context) {
		// TODO Auto-generated constructor stub
		super(context);
		mContext = context;
		setupViews();
	}
	 public ActivityFragment(Context context, AttributeSet attrs) {  
	        super(context, attrs);  
	        setupViews();  
	    } 
	//初始化View.  
    public void setupViews(){  
        LayoutInflater inflater = LayoutInflater.from( getContext() );  
        View rootView = inflater.inflate(R.layout.fragment_activity, null);  
        mHeadView		= LayoutInflater.from((SpaceDetailActivity)mContext).inflate(R.layout.activity_listview_head, null);
        mListView 			= (ListView)rootView.findViewById(R.id.activity_listview);
        mTvTopic			= (TextView)mHeadView.findViewById(R.id.activity_topic);
        mTvName			= (TextView)mHeadView.findViewById(R.id.activity_authorname);
        mTvTime				= (TextView)mHeadView.findViewById(R.id.activity_time);
		mList 					= new ArrayList<Map<String,Object>>();
		mAdapter			= new PicListViewAdapter(mContext, mList, R.layout.pic_listview_item, FLAGS, IDS);
		mFootView			= LayoutInflater.from(mContext).inflate(R.layout.pic_listview_foot, null);
		mBtnShowDisscuss = (Button)mFootView.findViewById(R.id.pic_lv_foot_show_disscuss);
		mBtnShowDisscuss.setOnClickListener(ButtonOnclickListener);
		mProgressBar		= (ProgressBar)mFootView.findViewById(R.id.pic_lv_foot_progressbar);
		mTvEncourage = (TextView)mFootView.findViewById(R.id.pic_lv_foot_encourage);
		
//		mTvDetail			= (TextView)mHeadView.findViewById(R.id.activity_detail);
		mTvEventTime    = (TextView)mHeadView.findViewById(R.id.activity_time_value);
		mTvEventPlace    = (TextView)mHeadView.findViewById(R.id.activity_place_value);
		mTvEventIntroduce    = (WebView)mHeadView.findViewById(R.id.activity_introduce_value);
		mBtnSeeMap			= (Button)mHeadView.findViewById(R.id.activity_see_map);
		mPosterImageView = (ImageView)mHeadView.findViewById(R.id.activity_place_logo);
		mBtnSeeMap.setOnClickListener(ButtonOnclickListener);
		mTvEventIntroduce.getSettings().setDefaultTextEncodingName("utf-8") ;
		mListView.addHeaderView(mHeadView);
		mListView.addFooterView(mFootView);
		mListView.setAdapter(mAdapter);
        addView(rootView);  
//        Toast.makeText(getContext(), "rootView.getMeasuredHeight:"+rootView.getMeasuredHeight() + "rootView.getHeight() " + rootView.getHeight() , Toast.LENGTH_SHORT).show();
    }  
    /** 
     * 填充数据，共外部调用. 
     * @param object 
     */  
    public void setData(JSONObject object){  
        this.mObject = object;  
        try {  
            
        	
//              if ( !object.isNull("detail")) {
//                	mTvDetail.setText( Html.fromHtml(object.getString("detail") ) ) ;
//                }
              if ( !object.isNull("eventtime")) {
              	mTvEventTime.setText( NetHelper.transTime(Long.parseLong( object.getString("eventtime")  ) ) );
              }
              if ( !object.isNull("eventplace")) {
            		mTvEventPlace.setText( object.getString("eventplace")  ) ;
              }
              if ( !object.isNull("poster")) {
            	  if( object.getString("poster") .equals("") )
            	  {
            		  mPosterImageView.setVisibility(View.GONE);
            	  }else
            	  {
            		  Drawable drawable = LoadImageMgr.getInstance().loadDrawble(object.getString("poster"), mPosterImageView, 
                			  LoadImageMgr.getInstance().imageCallBack);
                	  if( drawable != null )
                		  mPosterImageView.setImageDrawable(drawable);
            	  }
            }else
            {
            	mPosterImageView.setVisibility(View.GONE);
            }
              if ( !object.isNull("eventintroduce")) {
            	  mTvEventIntroduce.loadDataWithBaseURL(null,object.getString("eventintroduce"), "text/html", "utf-8",null);
//            	  mTvEventIntroduce.setText( Html.fromHtml(object.getString("eventintroduce") ) ) ;
              }
              if ( !object.isNull("tagname")) {
              	mTvTopic.setText(object.getString("tagname"));
              }
              if ( !object.isNull("time")) {
              	mTvTime.setText(NetHelper.transTime(Long.parseLong( object.getString("time")) ) );
              }
              if ( !object.isNull("name")) {
                	mTvName.setText(object.getString("name"));
                }
//              if( ! object.isNull("lat")) {
//            	  // 
//            	  float lat = Float.parseFloat( object.getString("lat") );
//            	  if( ! object.isNull("lng")) {
//                	  float lng = Float.parseFloat( object.getString("lng") );
//                	  GeoPoint  point = new GeoPoint((int)(lat* 1E6),(int)(lng* 1E6));
//                	  mBtnSeeMap.setTag(point);
//                  }
//            	 
//              }
              
              
              if ( !object.isNull("listview")) {
	           	   if( object.get("listview") == null )
	           	   {
//	           		   loadDisscussTask();
	           	   }else
	           	   {
	           		   mList.addAll(0,(List<Map<String,Object>>)object.get("listview"));
	           	   }
              }else
              {
//           	   loadDisscussTask();
              }
             
            //mListView.setAdapter(mAdapter);
            mAdapter.notifyDataSetChanged();
        } catch (JSONException e) {  
            e.printStackTrace();  
        }  
          
    }
   private boolean loading = false;
    public void loadDisscussTask()
    {
    	new AsyncTask<String, String, String> ()
    	{
    		boolean isLoad = true;
    		protected void onPreExecute() {
    			loading = true;
    			mBtnShowDisscuss.setVisibility(View.VISIBLE);
    			mTvEncourage.setVisibility(View.INVISIBLE);
    			mProgressBar.setVisibility(View.VISIBLE);
    			mBtnShowDisscuss.setOnClickListener(null);
    		};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String respon = null;
				int page = 1;
				if ( mList.size() != 0 && mList.size()%PublicInfo.PER_LOAD != 0 )
				{
					isLoad = false;
					return "";
				}else {
					page = mList.size()/PublicInfo.PER_LOAD + 1;
				}
				try{
						respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_event_disscuss),
							mObject.getString("id"),
							UserInfoManager.getInstance(null).getItem("m_auth").getValue(),page + "");
				}catch (Exception e) {
					// TODO: handle exception
				}
				return respon;
			}
    		protected void onPostExecute(String result) {
    			mProgressBar.setVisibility(View.INVISIBLE);
    			mBtnShowDisscuss.setOnClickListener(ButtonOnclickListener);
    			if( !isLoad)
    			{
    				Toast.makeText(mContext, getResources().getString(R.string.dialog_msg_nomoredata), Toast.LENGTH_SHORT).show();
    				return;
    			}
    			try {
					JSONObject object = new JSONObject(result);
					if ( object.getInt("error") == 0 ) {
						JSONArray array = object.getJSONArray("data");
						int size = array.length();
						JSONObject temp;
						Map<String, Object> map;
						for (int i = 0; i < size; i++) {
							map = new HashMap<String, Object>();
							temp = array.getJSONObject(i);
							map.put(FLAGS[0], temp.getString("authorname") + ": ");
							map.put(FLAGS[1], temp.getString("message"));
//							map.put(FLAGS[2], temp.getString("uid"));
							mList.add(map);
						}
						if( size == 0 || size % PublicInfo.PER_LOAD != 0)
						{
							mTvEncourage.setVisibility(View.VISIBLE);
							mBtnShowDisscuss.setVisibility(View.INVISIBLE);
						}else
						{
							mTvEncourage.setVisibility(View.INVISIBLE);
							mBtnShowDisscuss.setVisibility(View.VISIBLE);
						}
					}
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
//    			Toast.makeText(mContext, getResources().getString(R.string.tips_load_finished), Toast.LENGTH_SHORT).show();
    			mAdapter.notifyDataSetChanged();
    			
    		};
    	}.execute("");
    }
    /** 
     * 这里内存回收.外部调用. 
     */  
    public void recycle(){  
//        mAlbumImageView.setImageBitmap(null);  
//        if ((this.mBitmap == null) || (this.mBitmap.isRecycled()))  
//            return;  
//        this.mBitmap.recycle();  
//        this.mBitmap = null;  
    }  
    /** 
     * 重新加载.外部调用. 
     */  
    public void reload(){  
        try {  
            int resId = mObject.getInt("resid");  
            //实战中如果图片耗时应该令其一个线程去拉图片异步,不然把UI线程卡死.  
//            mAlbumImageView.setImageResource(resId);  
            setData(mObject);
        }catch (JSONException e) {  
            e.printStackTrace();  
        }  
    }
    public void loadTogether()
    {
    	new AsyncTask<String, String, String> ()
    	{
    		boolean isLoad = true;
    		protected void onPreExecute() {
    			mBtnShowDisscuss.setOnClickListener(null);
    		};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String respon = null;
				int page = 1;
				if ( mList.size() != 0 && mList.size()%10 != 0 )
				{
					isLoad = false;
					return "";
				}else {
					page = mList.size()/10 + 1;
				}
				try{
						respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_photo_disscuss),
							mObject.getString("id"),
							UserInfoManager.getInstance(null).getItem("m_auth").getValue(),page + "");
				}catch (Exception e) {
					// TODO: handle exception
				}
				return respon;
			}
    		protected void onPostExecute(String result) {
    			mProgressBar.setVisibility(View.INVISIBLE);
    			mBtnShowDisscuss.setOnClickListener(ButtonOnclickListener);
    			if( !isLoad)
    			{
    				Toast.makeText(mContext, getResources().getString(R.string.dialog_msg_nomoredata), Toast.LENGTH_SHORT).show();
    				return;
    			}
    			try {
					JSONObject object = new JSONObject(result);
					if ( object.getInt("error") == 0 ) {
						JSONArray array = object.getJSONArray("data");
						int size = array.length();
						JSONObject temp;
						Map<String, Object> map;
						for (int i = 0; i < size; i++) {
							map = new HashMap<String, Object>();
							temp = array.getJSONObject(i);
							map.put(FLAGS[0], temp.getString("authorname") + ": ");
							map.put(FLAGS[1], temp.getString("message"));
							map.put(FLAGS[2], temp.getString("uid"));
							mList.add(map);
						}
					}
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
    			Toast.makeText(mContext, getResources().getString(R.string.tips_load_finished), Toast.LENGTH_SHORT).show();
    			mAdapter.notifyDataSetChanged();
    			
    		};
    	}.execute("");
    }
private OnClickListener ButtonOnclickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if ( v == mBtnShowDisscuss ) {
				mProgressBar.setVisibility(View.VISIBLE);
				loadTogether();
			}else if( v == mBtnSeeMap )
			{
				// 
				 GeoPoint  point = null;
				try {
					if( ! mObject.isNull("lat")) {
		            	  Double lat = Double.parseDouble( mObject.getString("lat") );
		            	  if( ! mObject.isNull("lng")) {
		            		  Double lng = Double.parseDouble( mObject.getString("lng") );
//		                	  point = new GeoPoint((int)(lat* 1E6),(int)(lng* 1E6));
		            		  Intent intent = new Intent();
								intent.setClass(mContext, GaodeMapActivity.class);
								intent.putExtra("lat",lat);
								intent.putExtra("lng",lng);
								mContext.startActivity(intent);
								return;
		                  }
		            	 
		              }
				} catch (Exception e) {
					// TODO: handle exception
				}
				  
//				if ( point != null ) {
//						Intent intent = new Intent();
//						intent.setClass(mContext, GaodeMapActivity.class);
//						intent.putExtra("lat",point.getLatitudeE6());
//						intent.putExtra("lng",point.getLongitudeE6());
//						mContext.startActivity(intent);
//					}else
//					{
						Toast.makeText(mContext, R.string.no_map_info, Toast.LENGTH_SHORT).show();
//					}
				
			}
		}
	};
@Override
public boolean isLoadDisscussed() {
	// TODO Auto-generated method stub
	return loading;
}
}
