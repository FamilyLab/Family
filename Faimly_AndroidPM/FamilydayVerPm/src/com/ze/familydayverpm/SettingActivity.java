package com.ze.familydayverpm;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.familydayverpm.adapter.FamilyListViewAdapter;
import com.ze.familydayverpm.adapter.PhoneListViewAdapter;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.DataModel;
import com.ze.model.ModelDataMgr;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.DatePickerDialog.OnDateSetListener;
import android.app.ProgressDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources.NotFoundException;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.os.Message;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.DatePicker.OnDateChangedListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TimePicker;
import android.widget.Toast;

public class SettingActivity extends Activity {
		private 			View 					mBtnBack;
		private 			Button					mName;
		private 			Button					mPhone;
		private 			Button 				mBirth;
		private 			Button 				mCoin;
		private 			View 					mTask;
		private 			ImageView			mHead;
		private 			ImageView			mHeadVip;
		private 			ProgressDialog	mProgressDialog;
		private 			View 					mIconUploadView;
		private 			String 					headImageUrl;
		private 			View					mMyLove;
		private 			View					mAbout;
		private 			View 					mVIPServer;
		private 			View 					mExit;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_setting);
			mBtnBack = findViewById(R.id.setting_back);
			mName = (Button)findViewById(R.id.setting_name);
			mPhone = (Button)findViewById(R.id.setting_phone);
			mCoin = (Button)findViewById(R.id.setting_coin);
			mBirth = (Button)findViewById(R.id.setting_birthday);
			mIconUploadView = findViewById(R.id.setting_head_grey);
			mHead  = (ImageView)findViewById(R.id.setting_head);
			mHeadVip = (ImageView)findViewById(R.id.setting_head_vip);
			mMyLove = findViewById(R.id.setting_mylove);
			mAbout	= findViewById(R.id.setting_about);
			mMyLove.setOnClickListener(buttonClickListener);
			mAbout.setOnClickListener(buttonClickListener);
			mHead.setOnClickListener(buttonClickListener);
			mTask = findViewById(R.id.setting_task);
			mTask.setOnClickListener(buttonClickListener);
			mBtnBack.setOnClickListener(buttonClickListener);
			mName.setOnClickListener(buttonClickListener);
			mPhone.setOnClickListener(buttonClickListener);
			mBirth.setOnClickListener(buttonClickListener);
			mCoin.setOnClickListener(buttonClickListener);
			mVIPServer = findViewById(R.id.setting_vip);
			mVIPServer.setOnClickListener(buttonClickListener);
			mExit = findViewById(R.id.setting_exit);
			mExit.setOnClickListener(buttonClickListener);
			mProgressDialog = new ProgressDialog(this);
			mProgressDialog.setCanceledOnTouchOutside(false);
			mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
			String vipFlag = UserInfoManager.getInstance(SettingActivity.this).getItem("vip").getValue();
			if (vipFlag.equals(PublicInfo.VIP_FLAG_P)) {
				mHeadVip.setImageDrawable(getResources().getDrawable(R.drawable.v_l_1));
			}else if( vipFlag.equals(PublicInfo.VIP_FLAG_F ))
			{
				mHeadVip.setImageDrawable(getResources().getDrawable(R.drawable.v_l_2));
			}
			Componet avatarComponet = UserInfoManager.getInstance(SettingActivity.this).getItem("avatar");
			if ( avatarComponet != null ) {
				mHead.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(
						LoadImageMgr.getInstance().getBigHead(avatarComponet.getValue())
						,mHead,LoadImageMgr.getInstance().imageCallBack) );
			}
			loadTask();
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
		public void loadTask()
		{
			new AsyncTask<String, String, String>(){
				protected void onPreExecute() {
					mProgressDialog.show();
					Toast.makeText(SettingActivity.this, getResources().getString(R.string.dialog_msg_load), Toast.LENGTH_SHORT).show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_setinfo), 
							UserInfoManager.getInstance(SettingActivity.this).getItem("m_auth").getValue());
					return responString;
				}
				protected void onPostExecute(String result) {
					if (mProgressDialog.isShowing()) {
						mProgressDialog.hide();
					}
					try {
						JSONObject jsonObject = new JSONObject(result);
						if ( 0 == jsonObject.getInt("error") )
						{
							jsonObject = jsonObject.getJSONObject("data");
							mName.setText(jsonObject.getString("name"));
							mPhone.setText(jsonObject.getString("phone"));
							mBirth.setText(jsonObject.getString("birthday"));
							mCoin.setText(jsonObject.getString("credit"));
							headImageUrl = jsonObject.getString("avatar");
							Componet componet = UserInfoManager.getInstance(SettingActivity.this).getItem("avatar");
							if ( componet != null ) {
								componet.setValue(headImageUrl);
								UserInfoManager.getInstance(SettingActivity.this).save(componet);
							}
							mHead.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(
									LoadImageMgr.getInstance().getBigHead( headImageUrl ), 
									mHead, LoadImageMgr.getInstance().imageCallBack));
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				};
			}.execute("");
		}
		private AlertDialog 	setNameAlertDialog = null;
		private AlertDialog 	setPhoneAlertDialog = null;
		private DatePickerDialog 	setBirthAlertDialog = null;
		
		private EditText			setNameEditText;
		private EditText			setPhoneEditText;
//		private EditText			setBirEditText;
		private OnClickListener buttonClickListener = new OnClickListener(){

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if ( v == mName ) {
					if (setNameAlertDialog == null ) {
						setNameEditText = new EditText(SettingActivity.this);
						setNameEditText.setText(mName.getText());
						setNameEditText.setHint(getResources().getString(R.string.dialog_hint_setname));
						setNameAlertDialog =  new Builder(SettingActivity.this).setTitle(getResources().getString(R.string.dialog_title_setname)).
							setView(setNameEditText).setNegativeButton(getString(R.string.dialog_button_cancel), dialogClickListener).
							setPositiveButton(getResources().getString(R.string.dialog_button_send), dialogClickListener).create();
						}
					setNameAlertDialog.show();
				}else if( v == mPhone )
				{
					Toast.makeText(SettingActivity.this, R.string.tips_msg_changephone, Toast.LENGTH_SHORT).show();
				}else if( v == mBirth )
				{
					final int _year;
					final int month;
					final int day;
					
					if( mBirth.getText().toString().equals("") )
					{
						_year = 2013;
						month = 2;
						day = 14;
						
					}else
					{
						String birthInfoString[] = mBirth.getText().toString().split("-");
						 _year = Integer.parseInt( birthInfoString[0] );
						month =Integer.parseInt( birthInfoString[1] ) - 1;
						day =  Integer.parseInt( birthInfoString[2] );
					}
					
					if ( setBirthAlertDialog == null ) {
						OnDateSetListener onDateSetListener = new OnDateSetListener() {
							
							@Override
							public void onDateSet(DatePicker view, int year, int monthOfYear,
									int dayOfMonth) {
								// TODO Auto-generated method stub
								 setBirthTask(year, monthOfYear + 1, dayOfMonth);
							}
						};
						setBirthAlertDialog = new DatePickerDialog(SettingActivity.this,  onDateSetListener, _year, month, day);
					}
					setBirthAlertDialog.show();
				}else if( v == mBtnBack )
				{
					SettingActivity.this.finish();
//					LoadImageMgr.getInstance().removeImageCache(
//							LoadImageMgr.getInstance().getBigHead( headImageUrl )
//							);
//					LoadImageMgr.getInstance().removeImageCache(
//							LoadImageMgr.getInstance().getMiddleHead( headImageUrl )
//							);
//					LoadImageMgr.getInstance().removeImageCache(
//							 headImageUrl 
//							);
				}else if( v == mHead )
				{
					showPickDialog();
				}else if( v == mTask )
				{
					Intent intent = new Intent();
					intent.setClass(SettingActivity.this, TaskActivity.class);
					startActivity(intent);
				}else if( v == mMyLove )
				{
//					Toast.makeText(SettingActivity.this, R.string.notopen, Toast.LENGTH_SHORT).show();
					Intent intent = new Intent();
					intent.putExtra("lovelist", true);
					intent.setClass(SettingActivity.this, SpaceDetailActivity.class)	;
					startActivity(intent);
				}else if( v == mAbout )
				{
//					Toast.makeText(SettingActivity.this, R.string.notopen, Toast.LENGTH_SHORT).show();
					Intent intent = new Intent();
					intent.putExtra("infopic", PublicInfo.INFOPIC_ABOUT);
					intent.setClass(SettingActivity.this, AboutActivity.class)	;
					startActivity(intent);
				}else if( v ==  mVIPServer )
				{
					Intent intent = new Intent();
					intent.putExtra("infopic", PublicInfo.INFOPIC_VIP);
					intent.setClass(SettingActivity.this, AboutActivity.class)	;
					startActivity(intent);
				}else if( v == mCoin )
				{
					Intent intent = new Intent();
					intent.putExtra("infopic", PublicInfo.INFOPIC_COIN);
					intent.setClass(SettingActivity.this, AboutActivity.class)	;
					startActivity(intent);
				}else if( v == mExit )
				{
					SettingActivity.this.finish();
					MainActivity.MAIN_ACTIVITY.unLogin();
				}
			}
			
		};
		
		public void setBirthTask(int year, int month, int day )
		{
			final String tagName = year + "-" + month + "-" + day;
			new AsyncTask<String, String, String>(){
				protected void onPreExecute() {
					mProgressDialog.show();
					Toast.makeText(SettingActivity.this, getResources().getString(R.string.tips_sending), Toast.LENGTH_SHORT).show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = null ;
					try {
						responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_set_birth),
								URLEncoder.encode(tagName, "utf-8"),
								UserInfoManager.getInstance(SettingActivity.this).getItem("m_auth").getValue());
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
					if (mProgressDialog.isShowing()) {
						mProgressDialog.hide();
					}
					try {
						JSONObject object = new JSONObject(result);
						if ( object.getInt("error") == 0 ) {
							mBirth.setText(tagName);
							Toast.makeText(SettingActivity.this, getResources().getString(R.string.tips_send_success), Toast.LENGTH_SHORT).show();
							return;
						}
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					Toast.makeText(SettingActivity.this, getResources().getString(R.string.tips_send_fail), Toast.LENGTH_SHORT).show();
				};
			}.execute("");
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
		 private void setPicToView(Intent picdata) {  
		        Bundle extras = picdata.getExtras();  
		        if (extras != null) {  
		            Bitmap photo = extras.getParcelable("data");  
		            final Drawable drawable = new BitmapDrawable(photo); 
//		            if ( iconImageView != null ) {
//		            	  iconImageView.setImageDrawable(drawable);
//					}
//					if ( mProgressDialog == null ) {
//						mProgressDialog = new ProgressDialog(this);
//					}
//					progressDialog.setMessage("上传中...");
		            mProgressDialog.show();
		            // upload
		          new AsyncTask<String, String, String>()
		          {
		        	  private Drawable preDrawable;
		        	  protected void onPreExecute() {
		        		  mIconUploadView.setVisibility(View.VISIBLE);
		        		  preDrawable = mHead.getDrawable();
		        		  mHead.setImageDrawable(drawable);
		        		  Toast.makeText(SettingActivity.this, getResources().getString(R.string.tips_icon_sending), Toast.LENGTH_SHORT).show();
		        	  };
					@Override
					protected String doInBackground(String... params) {
						// TODO Auto-generated method stub
						String urlString = getResources().getString(R.string.http_set_icon);
						urlString = String.format(urlString, UserInfoManager.getInstance(SettingActivity.this).getItem("m_auth").getValue());
						String respon = NetHelper.uploadPic(urlString, drawable,"Filedata");
						return respon;
					}
		        	  protected void onPostExecute(String result) {
		        		  JSONObject object;
		        		  if(mProgressDialog.isShowing()){
		        			  mProgressDialog.hide();
		        		  }
		        		  mIconUploadView.setVisibility(View.INVISIBLE);
							try {
								object = new JSONObject(result);
								if ( object.getInt("error") == 0 ) {
									// success
									Toast.makeText(SettingActivity.this, getResources().getString(R.string.tips_icon_sendsuccess), Toast.LENGTH_SHORT).show();
									LoadImageMgr.getInstance().removeImageCache(
											LoadImageMgr.getInstance().getBigHead( headImageUrl )
											);
									LoadImageMgr.getInstance().removeImageCache(
											LoadImageMgr.getInstance().getMiddleHead( headImageUrl )
											);
									LoadImageMgr.getInstance().removeImageCache(
											 headImageUrl 
											);
									return;
								}
							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							mHead.setImageDrawable(preDrawable);
							Toast.makeText(SettingActivity.this, getResources().getString(R.string.tips_icon_sendfail), Toast.LENGTH_SHORT).show();
		        	  };
		          }.execute("");
		        }  
		    }  
		@Override
		protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
			if ( data == null )
			 {
				 if( requestCode != 2 )
				 {
//					 Toast.makeText(this, text, duration)
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
//						handler.sendEmptyMessage(0);
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
//			iconImageView = (ImageView) view;
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
		public void setNameTask()
		{
			final String tagName = setNameEditText.getText().toString().trim();
			if ( tagName.length() < 1 ) {
				Toast.makeText(this, getResources().getString(R.string.tips_input_less0), Toast.LENGTH_SHORT).show();
				return;
			}
			new AsyncTask<String, String, String>(){
				protected void onPreExecute() {
					mProgressDialog.show();
					Toast.makeText(SettingActivity.this, getResources().getString(R.string.tips_sending), Toast.LENGTH_SHORT).show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = null ;
					try {
						responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_set_name),
								URLEncoder.encode(tagName, "utf-8"),
								UserInfoManager.getInstance(SettingActivity.this).getItem("m_auth").getValue());
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
					if (mProgressDialog.isShowing()) {
						mProgressDialog.hide();
					}
					try {
						JSONObject object = new JSONObject(result);
						if ( object.getInt("error") == 0 ) {
							mName.setText(setNameEditText.getText().toString());
							setNameEditText.setText("");
							Toast.makeText(SettingActivity.this, getResources().getString(R.string.tips_send_success), Toast.LENGTH_SHORT).show();
							return;
						}
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					Toast.makeText(SettingActivity.this, getResources().getString(R.string.tips_send_fail), Toast.LENGTH_SHORT).show();
				};
			}.execute("");
		}
		
		private android.content.DialogInterface.OnClickListener dialogClickListener = new 
				android.content.DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				if( dialog == setNameAlertDialog )
				{
					if (which == DialogInterface.BUTTON_POSITIVE) {
						setNameTask();
					}
				}else if( dialog == setPhoneAlertDialog )
				{
					
				}
				
			}
		};
		
}
