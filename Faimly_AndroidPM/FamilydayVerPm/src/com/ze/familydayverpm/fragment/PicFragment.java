package com.ze.familydayverpm.fragment;

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
import com.ze.commontool.LoadImageMgr.ImageCallBack;
import com.ze.familydayverpm.BigPicActivity;
import com.ze.familydayverpm.PicActivity;
import com.ze.familydayverpm.R;
import com.ze.familydayverpm.SpaceDetailActivity;
import com.ze.familydayverpm.adapter.PicListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.PhotoModel.PicInfo;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Matrix;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

public class PicFragment extends RelativeLayout  implements RelativeLayoutImp {
	
	private 	Context mContext;
	private	ListView 					mListView;
	private 	BaseAdapter			mAdapter;
	private 	LinearLayout			mPicLayout;
//	private 	ImageView 				mPic_content;
	private 	TextView					mTvSay;
	private    TextView					mTvName;
	private 	TextView					mTvTopic;
	private 	TextView					mTvTime;
//	private 	View						mBack2Line;
	private 	TextView					mTvFromName;
	private 	Button 					mBtnShowDisscuss;
	private 	TextView					mTvEncourage;
	private 	ProgressBar				mProgressBar;
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
	private 	List< ImageView>  imageViews;
	private 	ImageView			mHeadImageViews[];
	private 	View 					mHeadImageViewLayouts[];
	private 	View 					mHeadImageViewPbs[];
	
	public static final String 	IMG_DETAIL_TAIL = "!580";
	public static final int 		ONCE_GET = 5;
	public PicFragment(Context context) {
		// TODO Auto-generated constructor stub
		super(context);
		mContext = context;
		imageViews = new ArrayList<ImageView>();
		setupViews();
	}
	 public PicFragment(Context context, AttributeSet attrs) {  
	        super(context, attrs);  
	        setupViews();  
	    } 
	//初始化View.  
    public void setupViews(){  
        LayoutInflater inflater = LayoutInflater.from( getContext() );  
        View rootView = inflater.inflate(R.layout.fragment_pic, null);  
        mHeadView		= LayoutInflater.from(mContext).inflate(R.layout.pic_listview_head, null);
        mListView 			= (ListView)rootView.findViewById(R.id.pic_listview);
		mList 					= new ArrayList<Map<String,Object>>();
		mTvName 			= (TextView)mHeadView.findViewById(R.id.pic_authorname);
		mTvTime				=(TextView)mHeadView.findViewById(R.id.pic_time);
		mTvTopic			=(TextView)mHeadView.findViewById(R.id.pic_topic);
//		mBack2Line		= rootView.findViewById(R.id.pic_topic_back_2line);
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
		mTvEncourage = (TextView)mFootView.findViewById(R.id.pic_lv_foot_encourage);
		mProgressBar		= (ProgressBar)mFootView.findViewById(R.id.pic_lv_foot_progressbar);
		
		mPicLayout			= (LinearLayout)mHeadView.findViewById(R.id.pic_content_layout);
		mHeadImageViews = new ImageView[3];
		mHeadImageViews[0] = (ImageView)mHeadView.findViewById(R.id.pic_content_1);
		mHeadImageViews[1] = (ImageView)mHeadView.findViewById(R.id.pic_content_2);
		mHeadImageViews[2] = (ImageView)mHeadView.findViewById(R.id.pic_content_3);
		
		mHeadImageViewLayouts = new View[3];
		mHeadImageViewLayouts[0] = mHeadView.findViewById(R.id.pic_content_1_layout);
		mHeadImageViewLayouts[1] = mHeadView.findViewById(R.id.pic_content_2_layout);
		mHeadImageViewLayouts[2] = mHeadView.findViewById(R.id.pic_content_3_layout);
		
		mHeadImageViewPbs = new View[3];
		mHeadImageViewPbs[0] = mHeadView.findViewById(R.id.pic_content_1_pb);
		mHeadImageViewPbs[1] = mHeadView.findViewById(R.id.pic_content_2_pb);
		mHeadImageViewPbs[2] = mHeadView.findViewById(R.id.pic_content_3_pb);
		
		mTvSay				= (TextView)mHeadView.findViewById(R.id.pic_desc);
		
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
            if( !object.isNull("imgarray"))
            {
            	ArrayList<PicInfo> imgArray = (ArrayList<PicInfo>) object.get("imgarray");
            	String imgUrl ;
            	ImageView imageView;
//            	android.widget.LinearLayout.LayoutParams params;
            	for (int i = 0; i < imgArray.size(); i++) {
            		if ( i == 3 ) {
            			// 暂时只发布三张。超过三张忽略不计
						break;
					}
            		imgUrl = imgArray.get(i).url;
            		mHeadImageViewLayouts[i].setVisibility(View.VISIBLE);
            		mHeadImageViews[i].setVisibility(View.VISIBLE);
        			android.widget.RelativeLayout.LayoutParams params = (android.widget.RelativeLayout.LayoutParams) mHeadImageViews[i].getLayoutParams();
        			params.width = PublicInfo.SCREEN_W;
        			params.height =  (int) ( imgArray.get(i).height * ( (float)PublicInfo.SCREEN_W / (float)imgArray.get(i).width ) );
        			 mHeadImageViews[i].setLayoutParams(params);
        			 Drawable imageDrawable = LoadImageMgr.getInstance().loadDrawble(imgUrl, 
            				mHeadImageViews[i], 
                			imageCallBack);
        			 if( imageDrawable != null )
        				 {
        				 mHeadImageViews[i].setImageDrawable(imageDrawable)  ;
        				 }else
        				 {
        					 mHeadImageViewPbs[i].setVisibility(View.VISIBLE);
        				 }
            		mHeadImageViews[i].setOnClickListener(ButtonOnclickListener);
            		imageViews.add(mHeadImageViews[i]);
				}
            }
//            if ( !object.isNull("img")) {
//         	  // mPic_content.setImageResource(object.getInt("img"));
//            	mPic_content.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(object.getString("img"), mPic_content, 
//            			LoadImageMgr.getInstance().imageCallBack)) ;
//            }
            if ( !object.isNull("say")) {
            	mTvSay.setText(object.getString("say"));
            }
            if ( !object.isNull("name")) {
            	mTvName.setText(object.getString("name"));
            }
            if ( !object.isNull("tagname")) {
            	String temp = object.getString("tagname");
            	mTvTopic.setText(temp.equals("") ? getResources().getString(R.string.nulltopic) : temp);
            }
            if ( !object.isNull("time")) {
            	mTvTime.setText(NetHelper.transTime(Long.parseLong( object.getString("time")) ) );
            }
            
			
           if ( !object.isNull("listview")) {
        	   if( object.get("listview") == null )
        	   {
//        		   loadDisscussTask();
        	   }else
        	   {
        		   mList.addAll(0,(List<Map<String,Object>>)object.get("listview"));
        		   mAdapter.notifyDataSetChanged();
                   mListView.setSelection(1);
        	   }
           }else
           {
//        	   loadDisscussTask();
           }
//           if ( !object.isNull("fuid")) {
//        	   if( !object.getString("fuid").equals("0") )
//        	   {
//        		   mTvFromName.setText(String.format(getResources().getString(R.string.itemfrom),object.getString("fname") ));
//        	   }
//        		 
//           }
            //mListView.setAdapter(mAdapter);
            mAdapter.notifyDataSetChanged();
        } catch (JSONException e) {  
            e.printStackTrace();  
        }  
          
    }
    /** 
     * 这里内存回收.外部调用. 
     */  
    
public ImageCallBack imageCallBack = new ImageCallBack() {
		
		@Override
		public void setImage(Drawable d, String url, ImageView view) {
			// TODO Auto-generated method stub
			if( /*mActiveImages.contains(view) &&*/ url.equals((String)view.getTag()))
			{
				view.setImageDrawable(d);
				for (int i = 0; i < mHeadImageViews.length; i++) {
					if (view == mHeadImageViews[i]) {
						mHeadImageViewPbs[i].setVisibility(View.INVISIBLE);
					}
				}
			}
		}
	};
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
//    public void loadDisscussTask(boolean isInited){
//    	if (isInited) {
//			return;
//		}else
//		{
//			loadDisscussTask();
//		}
//    }
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
						if( size == 0 || size % ONCE_GET != 0)
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
			}else 
			{
				for( int i=0; i<imageViews.size(); i++ )
				{
					if (v == imageViews.get(i)  ) {
							Intent intent = new Intent();
							String imgUrl = (String)imageViews.get(i).getTag();
							intent.putExtra("image", imgUrl);
							try {
								intent.putExtra("id", mObject.getString("id") );
							ArrayList<PicInfo> pics = (ArrayList<PicInfo>) mObject.get("imgarray");
							 String picstemp;
							 int find;
							 ArrayList<String> picUrls = new ArrayList<String>();
							 for (int j = 0; j < pics.size(); j++) {
								picstemp = pics.get(j).url	;
								find = picstemp.indexOf("!");
								if( find != -1 )
								{
									picstemp = picstemp.substring(0, find+1);
								}
								picstemp = picstemp + SpaceDetailActivity.REBLOG_PIC_TAIL;
								picUrls.add(picstemp);
							}
							 intent.putStringArrayListExtra("imgarray", picUrls);
							 intent.putExtra("uid",mObject.getString("uid"));
							intent.setClass(mContext, BigPicActivity.class);
							mContext.startActivity(intent);
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}}
				}
		}
	};
	@Override
	public boolean isLoadDisscussed() {
		// TODO Auto-generated method stub
		return loading;
	}
}
