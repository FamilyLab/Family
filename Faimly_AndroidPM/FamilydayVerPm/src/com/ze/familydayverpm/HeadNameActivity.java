package com.ze.familydayverpm;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.ModelDataMgr;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources.NotFoundException;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

public class HeadNameActivity extends Activity {
	private 		View				mBtnConfirm; 	
	private 		ImageView 				mBtnHead;
	private 		EditText 				mEtName;
	private 		ProgressDialog 	mProgressDialog;
	private 		View 				mBtnIgnore;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_head_name);
		mBtnConfirm = findViewById(R.id.head_name_confirm);
		mBtnIgnore = findViewById(R.id.head_name_ignore);
		mBtnIgnore.setOnClickListener(buttonClickListener);
		mBtnConfirm.setOnClickListener(buttonClickListener);
		mBtnHead = (ImageView) findViewById(R.id.head_name_icon);
		mBtnHead.setOnClickListener(buttonClickListener);
		mProgressDialog = new ProgressDialog(this);
		mProgressDialog.setCanceledOnTouchOutside(false);
		mEtName = (EditText)findViewById(R.id.head_name_etName);
	}
	public void startPhotoZoom(Uri uri) {  
        Intent intent = new Intent("com.android.camera.action.CROP");  
        intent.setDataAndType(uri, "image/*");  
        //下面这个crop=true是设置在开启的Intent中设置显示的VIEW可裁剪  
        intent.putExtra("crop", "true");  
        // aspectX aspectY 是宽高的比例  
        intent.putExtra("aspectX", 1);  
        intent.putExtra("aspectY", 1);  
        // outputX outputY 是裁剪图片宽高  
        intent.putExtra("outputX", 220);  
        intent.putExtra("outputY", 220);  
        intent.putExtra("return-data", true);  
        startActivityForResult(intent, 3);  
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
	 private void setPicToView(Intent picdata) {  
	        Bundle extras = picdata.getExtras();  
	        if (extras != null) {  
	            Bitmap photo = extras.getParcelable("data");  
	            final Drawable drawable = new BitmapDrawable(photo); 
	            mBtnHead.setImageDrawable(drawable);
	            isUploadHead = false;
	        }  
	    }  
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
	// TODO Auto-generated method stub
		if ( data == null )
		 {
			 if( requestCode != 2 )
			 {
//				 Toast.makeText(this, text, duration)
				 return;
			 }
		 }
	        switch (requestCode) {  
	        // 如果是直接从相册获取  
	        case 1:  
	            startPhotoZoom(data.getData());  
	            break;  
	        // 如果是调用相机拍照时  
	        case 2:  
	            File temp = new File(ModelDataMgr.ROOT_PATH
	                    + ModelDataMgr.ICON_TEMP);  
	            //if()
	            if ( temp == null ) {
//					handler.sendEmptyMessage(0);
					return;
				}
	            startPhotoZoom(Uri.fromFile(temp));  
	            
	            break;  
	        // 取得裁剪后的图片  
	        case 3:  
	            /**  
	             * 非空判断大家一定要验证，如果不验证的话，  
	             * 在剪裁之后如果发现不满意，要重新裁剪，丢弃  
	             * 当前功能时，会报NullException，小马只  
	             * 在这个地方加下，大家可以根据不同情况在合适的  
	             * 地方做判断处理类似情况  
	             *   
	             */ 
	            if(data != null){  
	                setPicToView(data);  
	            }  
	            File file = new File(ModelDataMgr.ROOT_PATH
	                    + ModelDataMgr.ICON_TEMP);  
	            if( file != null )
	            	file.delete();
	            break;  
	        default:  
	            break;  
	 
	        }  
	        super.onActivityResult(requestCode, resultCode, data);  
	}
	public void showPickDialog() {  
//		iconImageView = (ImageView) view;
	        new AlertDialog.Builder(this)  
	                .setTitle("上传图片")  
	                .setNegativeButton("相册", new DialogInterface.OnClickListener() {  
	                    public void onClick(DialogInterface dialog, int which) {  
	                        dialog.dismiss();  
	                        Intent intent = new Intent(Intent.ACTION_PICK, null); 
	                        intent.setDataAndType(  
	                                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,  
	                                "image/*");  
	                        startActivityForResult(intent, 1);  
	                    }  
	                })  
	                .setPositiveButton("拍照", new DialogInterface.OnClickListener()	 {  
	                    public void onClick(DialogInterface dialog, int whichButton) {  
	                        dialog.dismiss();  
	                        Intent intent = new Intent(  
	                                MediaStore.ACTION_IMAGE_CAPTURE);  
	                        //下面这句指定调用相机拍照后的照片存储的路径  
	                        intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri  
	                                .fromFile(new File(ModelDataMgr.ROOT_PATH,  
	                                		ModelDataMgr.ICON_TEMP)));  
	                        startActivityForResult(intent, 2);  
	                    }  
	                }).show();  
	    } 
	private boolean isUploadHead = false;
	public void setNameTask()
	{
		final String username = mEtName.getText().toString();
		if (username.length() <= 0 ) {
			Toast.makeText(this, R.string.tips_input_name_less0, Toast.LENGTH_LONG).show();
			return;
		}
		 new AsyncTask<String, String, String>()
	        {
	      	  protected void onPreExecute() {
	      		 mProgressDialog.setMessage(getResources().getString(R.string.tips_name_sending));
		            mProgressDialog.show();
	      	  };
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = null ;
					try {
						responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_set_name),
								URLEncoder.encode(username, "utf-8"),
								UserInfoManager.getInstance(HeadNameActivity.this).getItem("m_auth").getValue());
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
	      		  JSONObject object;
	      		  if(mProgressDialog.isShowing()){
	      			  mProgressDialog.hide();
	      		  }
						try {
							object = new JSONObject(result);
							if ( object.getInt("error") == 0 ) {
								Intent intent =new Intent();
								intent.setClass(HeadNameActivity.this, AddMemberActivity.class);
								intent.putExtra("register", true);
								HeadNameActivity.this.startActivity(intent);
								HeadNameActivity.this.finish();
							}else
							{
								Toast.makeText(HeadNameActivity.this, object.getString("msg"), Toast.LENGTH_SHORT).show();
							}
							return;
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						Toast.makeText(HeadNameActivity.this, getResources().getString(R.string.error_net), Toast.LENGTH_SHORT).show();
	      	  };
	        }.execute("");
	}
	public void setHeadTask()
	{
	     // upload
        new AsyncTask<String, String, String>()
        {
      	  private Drawable preDrawable;
      	  protected void onPreExecute() {
      		 mProgressDialog.setMessage(getResources().getString(R.string.tips_icon_sending));
	            mProgressDialog.show();
      		  preDrawable = mBtnHead.getDrawable();
//      		  Toast.makeText(HeadNameActivity.this, getResources().getString(R.string.tips_icon_sending), Toast.LENGTH_SHORT).show();
      	  };
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String urlString = getResources().getString(R.string.http_set_icon);
				urlString = String.format(urlString, UserInfoManager.getInstance(HeadNameActivity.this).getItem("m_auth").getValue());
				String respon = NetHelper.uploadPic(urlString, preDrawable,"Filedata");
				return respon;
			}
      	  protected void onPostExecute(String result) {
      		  JSONObject object;
      		  if(mProgressDialog.isShowing()){
      			  mProgressDialog.hide();
      		  }
					try {
						object = new JSONObject(result);
						if ( object.getInt("error") == 0 ) {
							// success
							isUploadHead = true;
							Componet headComponet = UserInfoManager.getInstance(HeadNameActivity.this).getItem("avatar");
							if (headComponet == null) {
								return;
							}
							String headImageUrl  = headComponet.getValue();
							LoadImageMgr.getInstance().removeImageCache(
									LoadImageMgr.getInstance().getBigHead( headImageUrl )
									);
							LoadImageMgr.getInstance().removeImageCache(
									LoadImageMgr.getInstance().getMiddleHead( headImageUrl )
									);
							LoadImageMgr.getInstance().removeImageCache(
									 headImageUrl 
									);
							Toast.makeText(HeadNameActivity.this, getResources().getString(R.string.tips_icon_sendsuccess), Toast.LENGTH_SHORT).show();
							setNameTask();
							return;
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					mBtnHead.setImageDrawable(preDrawable);
					Toast.makeText(HeadNameActivity.this, getResources().getString(R.string.tips_icon_sendfail), Toast.LENGTH_SHORT).show();
      	  };
        }.execute("");
	}
	private OnClickListener buttonClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if ( v == mBtnConfirm ) {
				if( isUploadHead )
				{
					setNameTask();
				}else
				{
					setHeadTask();
				}
//				Intent intent =new Intent();
//				intent.setClass(HeadNameActivity.this, AddMemberActivity.class);
//				HeadNameActivity.this.startActivity(intent);
			}else if( v == mBtnHead )
			{
				showPickDialog();
			}else if( v == mBtnIgnore )
			{
				Intent intent =new Intent();
				intent.setClass(HeadNameActivity.this, AddMemberActivity.class);
				intent.putExtra("register", true);
				HeadNameActivity.this.startActivity(intent);
				HeadNameActivity.this.finish();
			}
		}
	};
}
