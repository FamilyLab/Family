package com.ze.familydayverpm.fragment;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.familydayverpm.R;
import com.ze.familydayverpm.VideoActivity;
import com.ze.familydayverpm.adapter.PicListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

public class VideoFragment extends RelativeLayout  implements RelativeLayoutImp {
	
	private 	Context mContext;
	private	ListView 					mListView;
	private 	BaseAdapter			mAdapter;
	private 	TextView					mTvSubject;
//	private 	ImageView 				mblog_content;
	private 	ImageView					mImgPic;
	private    TextView					mTvName;
	private 	TextView					mTvToblog;
	private 	TextView					mTvTime;
	private 	Button 					mBtnShowDisscuss;
	private 	ProgressBar				mProgressBar;
	private 	TextView					mTvEncourage;
	private 	TextView					mTvFromName;
	private 	View						mPlay;
	private 	final String[]			FLAGS =
																{
									
																	"name",
																	"say",
																	"uid"
																};
	private 	static final 	int[]				IDS = {R.id.pic_item_name,R.id.pic_item_say};
	private 	 View 						mHeadView;
	private 	 View 						mFootView;
	private 	List<Map<String, Object>> mList;
	private 	JSONObject mObject;
	public 	boolean loading = false;
	public VideoFragment(Context context) {
		// TODO Auto-generated constructor stub
		super(context);
		mContext = context;
		setupViews();
	}
	public VideoFragment(Context context, AttributeSet attrs) {  
	        super(context, attrs);  
	        setupViews();  
	    } 
	 
	//初始化View.  
    public void setupViews(){  
        LayoutInflater inflater = LayoutInflater.from( getContext() );  
        View rootView = inflater.inflate(R.layout.fragment_video, null);  
        mHeadView		= LayoutInflater.from(mContext).inflate(R.layout.video_listview_head, null);
        mListView 			= (ListView)rootView.findViewById(R.id.video_listview);
		mList 					= new ArrayList<Map<String,Object>>();
		mTvName 			= (TextView)mHeadView.findViewById(R.id.video_authorname);
		mTvTime				=(TextView)mHeadView.findViewById(R.id.video_time);
		mTvToblog			=(TextView)mHeadView.findViewById(R.id.video_topic);
		
		mAdapter			= new PicListViewAdapter(mContext, mList, R.layout.pic_listview_item, FLAGS, IDS);
		mFootView			= LayoutInflater.from(mContext).inflate(R.layout.pic_listview_foot, null);
		mBtnShowDisscuss = (Button)mFootView.findViewById(R.id.pic_lv_foot_show_disscuss);
		mBtnShowDisscuss.setOnClickListener(ButtonOnclickListener);
		mProgressBar		= (ProgressBar)mFootView.findViewById(R.id.pic_lv_foot_progressbar);
		mTvEncourage = (TextView)mFootView.findViewById(R.id.pic_lv_foot_encourage);
		mTvSubject			= (TextView)mHeadView.findViewById(R.id.video_subject);
		mImgPic				= (ImageView)mHeadView.findViewById(R.id.video_cutpic);
		mPlay     				= mHeadView.findViewById(R.id.video_play);
		mPlay.setOnClickListener(ButtonOnclickListener);
		mImgPic.setOnClickListener(ButtonOnclickListener);
		mListView.addHeaderView(mHeadView);
		mListView.addFooterView(mFootView);
		mListView.setAdapter(mAdapter);
        addView(rootView);  
    }  
    /** 
     * 填充数据，共外部调用. 
     * @param object 
     */  
    public void setData(JSONObject object){  
        this.mObject = object;  
        try {  
//            if ( !object.isNull("img")) {
//         	  // mblog_content.setImageResource(object.getInt("img"));
//            	mblog_content.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(object.getString("img"), mblog_content, 
//            			LoadImageMgr.getInstance().imageCallBack)) ;
//            }
        	 if ( !object.isNull("subject")) {
        			mTvSubject.setText(object.getString("subject"));
             }
            if ( !object.isNull("pic")) {
            	mImgPic.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(object.getString("pic"), mImgPic, LoadImageMgr.getInstance().imageCallBack));
            }
            if ( !object.isNull("name")) {
            	mTvName.setText(object.getString("name"));
            }
            if ( !object.isNull("topic")) {
            	mTvToblog.setText(object.getString("topic"));
            }
            if ( !object.isNull("time")) {
            	mTvTime.setText(NetHelper.transTime(Long.parseLong( object.getString("time")) ) );
            }
            
			
            if ( !object.isNull("listview")) {
         	   if( object.get("listview") == null )
         	   {
//         		   loadDisscussTask();
         	   }else
         	   {
         		   mList.addAll(0,(List<Map<String,Object>>)object.get("listview"));
         	   }
            }else
            {
//         	   loadDisscussTask();
            }
           if ( !object.isNull("fuid")) {
        	   if( !object.getString("fuid").equals("0") )
        	   {
        		   mTvFromName.setText(String.format(getResources().getString(R.string.itemfrom),object.getString("fname") ));
        	   }
        		 
           }
            //mListView.setAdapter(mAdapter);
            mAdapter.notifyDataSetChanged();
        } catch (JSONException e) {  
            e.printStackTrace();  
        }  
          
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
//        try {  
//            int resId = mObject.getInt("resid");  
            //实战中如果图片耗时应该令其一个线程去拉图片异步,不然把UI线程卡死.  
//            mAlbumImageView.setImageResource(resId);  
            setData(mObject);
//        }catch (JSONException e) {  
//            e.printStackTrace();  
//        }  
    }
    public void loadDisscussTask()
    {
    	new AsyncTask<String, String, String> ()
    	{
    		boolean isLoad = true;
    		protected void onPreExecute() {
    			loading = true;
    			mBtnShowDisscuss.setVisibility(View.VISIBLE);
    			mTvEncourage.setVisibility(View.INVISIBLE);
    			mBtnShowDisscuss.setOnClickListener(null);
    			mProgressBar.setVisibility(View.VISIBLE);
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
						respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_video_disscuss),
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
    private OnClickListener ButtonOnclickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if ( v == mBtnShowDisscuss ) {
//				mProgressBar.setVisibility(View.VISIBLE);
				loadDisscussTask();
			}else if( v == mImgPic || v == mPlay )
			{
				try {
					String videoUrl = mObject.getString("url") ;
					if  ( videoUrl != null  && ! videoUrl.equals("") ) {
//						Intent intent = new Intent();
//						intent.setClass(mContext, VideoActivity.class);
//						intent.putExtra("url", videoUrl);
//						mContext.startActivity(intent);
						new WebView(mContext).loadUrl(videoUrl);
					}else
					{
						Toast.makeText(mContext, R.string.tips_msg_nodata, Toast.LENGTH_SHORT).show();
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
				
		}
	};
	@Override
	public boolean isLoadDisscussed() {
		// TODO Auto-generated method stub
		return loading;
	}
}
