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
import com.ze.familydayverpm.adapter.PicListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Context;
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

public class BlogFragment extends RelativeLayout  implements RelativeLayoutImp {
	
	private 	Context mContext;
	private	ListView 					mListView;
	private 	BaseAdapter			mAdapter;
	private 	WebView					mTvHtml;
//	private 	ImageView 				mblog_content;
	private 	TextView					mTvSay;
	private    TextView					mTvName;
	private 	TextView					mTvToblog;
	private 	TextView					mTvTime;
	private 	Button 					mBtnShowDisscuss;
	private 	ProgressBar				mProgressBar;
	private 	TextView					mTvEncourage;
	private 	TextView					mTvFromName;
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
	public BlogFragment(Context context) {
		// TODO Auto-generated constructor stub
		super(context);
		mContext = context;
		setupViews();
	}
	public BlogFragment(Context context, AttributeSet attrs) {  
	        super(context, attrs);  
	        setupViews();  
	    } 
	 
	//初始化View.  
    public void setupViews(){  
        LayoutInflater inflater = LayoutInflater.from( getContext() );  
        View rootView = inflater.inflate(R.layout.fragment_blog, null);  
        mHeadView		= LayoutInflater.from(mContext).inflate(R.layout.blog_listview_head, null);
        mListView 			= (ListView)rootView.findViewById(R.id.blog_listview);
		mList 					= new ArrayList<Map<String,Object>>();
		mTvName 			= (TextView)mHeadView.findViewById(R.id.blog_authorname);
		mTvTime				=(TextView)mHeadView.findViewById(R.id.blog_time);
		mTvToblog			=(TextView)mHeadView.findViewById(R.id.blog_topic);
//		mTvFromName	= (TextView)mHeadView.findViewById(R.id.pic_fname);
//		Map<String, Object> map;
//		map = new HashMap<String, Object>();
//		map.put(FLAGS[0], "黄显超 :");
//		map.put(FLAGS[1], "以后也生个胖娃娃");
//		mList.add(map);
//		map = new HashMap<String, Object>();
//		map.put(FLAGS[0], "刘梦超 :");
//		map.put(FLAGS[1], "睡觉了，别想太多");
//		mList.add(map);
//		map = new HashMap<String, Object>();
//		map.put(FLAGS[0], "温思鹏 :");
//		map.put(FLAGS[1], "春节去逛花市！");
//		mList.add(map);
		
		mAdapter			= new PicListViewAdapter(mContext, mList, R.layout.pic_listview_item, FLAGS, IDS);
		mFootView			= LayoutInflater.from(mContext).inflate(R.layout.pic_listview_foot, null);
		mBtnShowDisscuss = (Button)mFootView.findViewById(R.id.pic_lv_foot_show_disscuss);
		mBtnShowDisscuss.setOnClickListener(ButtonOnclickListener);
		mProgressBar		= (ProgressBar)mFootView.findViewById(R.id.pic_lv_foot_progressbar);
		mTvEncourage = (TextView)mFootView.findViewById(R.id.pic_lv_foot_encourage);
		
//		mTvHtml			= (TextView)mHeadView.findViewById(R.id.blog_content_layout);
		mTvHtml			= (WebView)mHeadView.findViewById(R.id.blog_content_layout);
		mTvHtml.getSettings().setDefaultTextEncodingName("utf-8") ;
		
//		mblog_content		= (ImageView)mHeadView.findViewById(R.id.blog_content);
//		mTvSay				= (TextView)mHeadView.findViewById(R.id.blog_desc);
		
		mListView.addHeaderView(mHeadView);
		mListView.addFooterView(mFootView);
		mListView.setAdapter(mAdapter);
//        android.widget.RelativeLayout.LayoutParams params = (android.widget.RelativeLayout.LayoutParams) rootView.getLayoutParams();
//        params.height = 480;
//        rootView.setLayoutParams(params);
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
//            if ( !object.isNull("img")) {
//         	  // mblog_content.setImageResource(object.getInt("img"));
//            	mblog_content.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(object.getString("img"), mblog_content, 
//            			LoadImageMgr.getInstance().imageCallBack)) ;
//            }
        	 if ( !object.isNull("html")) {
//        		 URLImageParser p = new URLImageParser(mTvHtml, mContext);
//        			Spanned htmlSpan = Html.fromHtml(object.getString("html"), p, null);
        			mTvHtml.loadDataWithBaseURL(null,object.getString("html"), "text/html", "utf-8",null);
             }
            if ( !object.isNull("say")) {
            	mTvSay.setText(object.getString("say"));
            }
            if ( !object.isNull("name")) {
            	mTvName.setText(object.getString("name"));
            }
            if ( !object.isNull("tagname")) {
            	mTvToblog.setText(object.getString("tagname"));
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
						respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_blog_disscuss),
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
    @Override
    public boolean isLoadDisscussed() {
    	// TODO Auto-generated method stub
    
    	return loading;
    }
    private OnClickListener ButtonOnclickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if ( v == mBtnShowDisscuss ) {
//				mProgressBar.setVisibility(View.VISIBLE);
				loadDisscussTask();
			}
		}
	};
}
