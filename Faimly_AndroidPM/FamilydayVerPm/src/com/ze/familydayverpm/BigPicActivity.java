package com.ze.familydayverpm;

import java.io.File;
import java.io.FileOutputStream;
import java.lang.ref.SoftReference;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.Inflater;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.commontool.LoadImageMgr.ImageCallBack;
import com.ze.familydayverpm.adapter.BlogViewPagerAdapter;
import com.ze.familydayverpm.adapter.FamilyListViewAdapter;
import com.ze.familydayverpm.adapter.ViewPagerAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.BlogModel;
import com.ze.model.ModelDataMgr;
import com.ze.model.PhotoModel;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.Matrix;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.FloatMath;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import android.widget.Toast;

public class BigPicActivity extends Activity {
	private 	Button 					mBtn_back;
	private 	ProgressDialog		mProgressDialog;
	private 	String						mPicString;
	private 	ImageView			mPicLayout;
	private 	int 							mWidth;
	private 	View						mLayoutView;
	private 	View 						mReblog;
	private 	View 						mDownLoad;
	private	String 						mPicIdString;
	private 	ArrayList<String>	pics;
	private boolean 					isSelf = false;
	
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
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_bigpic);
			mPicString = getIntent().getStringExtra("image");
			mPicIdString = getIntent().getStringExtra("id");
			pics = getIntent().getStringArrayListExtra("imgarray");
			mBtn_back 			= (Button)findViewById(R.id.bigpic_back);
			mBtn_back.setOnClickListener(ButtonListener);
			mPicLayout			= (ImageView)findViewById(R.id.bigpic_pic);
			mReblog = findViewById(R.id.bigpic_reblog);
			mDownLoad = findViewById(R.id.bigpic_download);
			mReblog.setOnClickListener(ButtonListener);
			mDownLoad.setOnClickListener(ButtonListener);
			mProgressDialog = new ProgressDialog(this);
			mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
			mLayoutView = findViewById(R.id.bigpic_liearlayout);
			isSelf = getIntent().getStringExtra("uid").equals(UserInfoManager.getInstance(BigPicActivity.this).getItem("uid").getValue());
			initImage();
		}
//		public ImageCallBack imageCallBack = new ImageCallBack() {
//			
//			@Override
//			public void setImage(Drawable d, String url, ImageView view) {
//				// TODO Auto-generated method stub
//				if( /*mActiveImages.contains(view) &&*/ url.equals((String)view.getTag()))
//				{
//					matrix.postTranslate((PublicInfo.SCREEN_W/2- d.getIntrinsicWidth()/2), ( PublicInfo.SCREEN_H/2 - d.getIntrinsicHeight()/2) );
//					view.setImageDrawable(d);
//					Toast.makeText(BigPicActivity.this, R.string.tips_msg_has_run, Toast.LENGTH_SHORT).show();
//				}
//			}
//		};
		private void initImage()
		{
//			if( LoadImageMgr.getInstance().imageCache.containsKey(mPicIdString)){
			Drawable pre_drawable  = LoadImageMgr.getInstance().loadDrawble(mPicString, mPicLayout, 
		        			LoadImageMgr.getInstance().imageCallBack);
			if( pre_drawable != null )
			{
//				matrix.postTranslate((PublicInfo.SCREEN_W/2- pre_drawable.getIntrinsicWidth()/2), ( PublicInfo.SCREEN_H/2 - pre_drawable.getIntrinsicHeight()/2) );
				float height =  (  (float)pre_drawable.getIntrinsicHeight() * ( (float)PublicInfo.SCREEN_W /  (float)pre_drawable.getIntrinsicWidth() ));
				float y =  (PublicInfo.SCREEN_H-100)/2 - height/2;
				y = y<0?0:y;
				float scale = ((float)PublicInfo.SCREEN_W / (float)pre_drawable.getIntrinsicWidth());
				matrix.setScale(scale, scale);
				matrix.preTranslate(0,0);
				matrix.postTranslate(0,y);
				mPicLayout.setImageDrawable(pre_drawable);
				mPicLayout.setImageMatrix(matrix);
			}
//			}
//			mPicString = LoadImageMgr.getInstance().cl(mPicIdString);
//			Drawable drawable = LoadImageMgr.getInstance().loadDrawble(
//					LoadImageMgr.getInstance().clearTail(mPicString), mPicLayout, 
//        			imageCallBack);
//			LayoutParams params = (LayoutParams) mLayoutView.getLayoutParams();
//			WindowManager wm = (WindowManager) this.getSystemService(Context.WINDOW_SERVICE);
//
//			int width = wm.getDefaultDisplay().getWidth();//屏幕宽度
//			int height = wm.getDefaultDisplay().getHeight();//屏幕高度
//			if ( drawable != null ) {
//				mPicLayout.setImageDrawable(drawable);
//			}
//			mPicLayout.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(mPicString, mPicLayout, 
//            			LoadImageMgr.getInstance().imageCallBack)) ;
			mPicLayout.setOnTouchListener(new OnTouchListener() {
				
				@Override
				public boolean onTouch(View v, MotionEvent event) {
					// TODO Auto-generated method stub
					
					switch (event.getAction() & MotionEvent.ACTION_MASK) {
					case MotionEvent.ACTION_DOWN:
							savedMatrix.set(matrix); //把原始  Matrix对象保存起来
							start.set(event.getX(), event.getY());  //设置x,y坐标
							mode = DRAG;
							break;
				case MotionEvent.ACTION_UP:
				case MotionEvent.ACTION_POINTER_UP:
							mode = NONE;
							break;
				case MotionEvent.ACTION_POINTER_DOWN:
							oldDist = spacing(event);
							if (oldDist > 10f) {
								savedMatrix.set(matrix);
								midPoint(mid, event);  //求出手指两点的中点
								mode = ZOOM;
							}
							break;
				case MotionEvent.ACTION_MOVE:
						if (mode == DRAG) {
							matrix.set(savedMatrix);
							matrix.postTranslate(event.getX() - start.x, event.getY()
									- start.y);
						} else if (mode == ZOOM) {
								float newDist = spacing(event);
								if (newDist > 10f) {
									matrix.set(savedMatrix);
									float scale = newDist / oldDist;
									matrix.postScale(scale, scale, mid.x, mid.y);
								}
							}
						break;
				}


				mPicLayout.setImageMatrix(matrix);
				return true;
				}
			});
		}
		private Matrix savedMatrix = new Matrix();
		private Matrix matrix = new Matrix();
		private static final int NONE = 0;
		private static final int DRAG = 1;
		private static final int ZOOM = 2;
		
		private int mode = NONE;
		private float oldDist;
		
		private PointF start = new PointF();
		private PointF mid = new PointF();
		
		//求两点距离
		private float spacing(MotionEvent event) {
			float x = event.getX(0) - event.getX(1);
			float y = event.getY(0) - event.getY(1);
			return FloatMath.sqrt(x * x + y * y);
		}
		//求两点间中点
		private void midPoint(PointF point, MotionEvent event) {
			float x = event.getX(0) + event.getX(1);
			float y = event.getY(0) + event.getY(1);
			point.set(x / 2, y / 2);
		};
		private OnClickListener ButtonListener = new OnClickListener()
				{

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						if (v == mBtn_back) {
							BigPicActivity.this.finish();
						}else if( v == mDownLoad )
						{
							 Drawable drawable = null ;
							 drawable = mPicLayout.getDrawable();
							if( drawable != null )
							{
					            	FileOutputStream outputStream = null ;
					            	Date date = new Date();
					            	String fileName = Environment.getExternalStorageDirectory() +
					            			"/familydayVerPm/" + "Family_" + ( date.getYear() + 1900 )+ "" +
					            			date.getMonth() + 1 + "" + 
					            			date.getDate() + "" + 
					            			date.getHours() + "" + 
					            			date.getMinutes() + "" +
					            			date.getSeconds() + "" + ".jpg";
					            	try {
					            		File picFile = new File(fileName);
						            	picFile.createNewFile();
						            	outputStream = new FileOutputStream(picFile);
						            	BitmapDrawable bitmapDrawable = (BitmapDrawable)drawable;
										Bitmap bitmap = bitmapDrawable.getBitmap();
										bitmap.compress(CompressFormat.JPEG, 100, outputStream);
										Toast.makeText(BigPicActivity.this, R.string.tips_msg_download, Toast.LENGTH_SHORT).show();
									} catch (Exception e) {
										// TODO: handle exception
										e.printStackTrace();
									}finally{
										try {
											if ( outputStream != null ) {
												outputStream.close();
												outputStream = null;
											}
										} catch (Exception e) {
											// TODO: handle exception
											e.printStackTrace();
										}
					            	
									return;
					            }
					            
							}
							Toast.makeText(BigPicActivity.this, R.string.tips_msg_download_error, Toast.LENGTH_SHORT).show();
						}else if( v == mReblog )
						{
							if(isSelf)
							{
								Toast.makeText(BigPicActivity.this, R.string.tips_msg_noreblogself, Toast.LENGTH_SHORT).show();
								return;
							}
							Intent intent = new Intent();
							intent.setClass(BigPicActivity.this, PublishActivity.class);
							intent.putExtra("type", SpaceDetailActivity.DETAIL_PIC);
							intent.putExtra("id",mPicIdString );
							 intent.putStringArrayListExtra("imgarray", pics);
							 startActivity(intent);
						}
					}
			
				};
				
}
