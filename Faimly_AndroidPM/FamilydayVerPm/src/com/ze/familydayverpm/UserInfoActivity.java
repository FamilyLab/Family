package com.ze.familydayverpm;

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
import com.ze.familydayverpm.adapter.DialogDetailListViewAdapter;
import com.ze.familydayverpm.adapter.FamilyListViewAdapter;
import com.ze.familydayverpm.adapter.PhoneListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnShowListener;
import android.content.Intent;
import android.content.res.Resources.NotFoundException;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.Toast;

public class UserInfoActivity extends Activity {
		
		private 			View 					mBtnBack;
		private 			Button 				mName;
		private 			Button 				mPhone;
		private 			Button 				mBirth;
		private 			ImageView			mHead;
		private 			ImageView 			mHeadVip;
		private 			Button 				mFamilyMemberCount;
		private 			Button 				mSpaceCount;
		private 			Button 				mLastLoginTime;
		private 			String 					uidString;
		private 			ProgressDialog	mProgressDialog;
		private 			View 					mCallView;
		private 			View 					mSendMsg;
		private 			String 					nameString;
		private 			String 					notenameString;
		private 			View					setRelative;
		private 			AlertDialog			editRelativeDialog;
		private 			AlertDialog			editMsgDialog;
		private 			EditText				editRelativeText;
		private 			EditText				editMsgText;
		private 			View 					infoLayout;
		private 			View 					notfamilyLayout;
		private 			View					requestFamilyView;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_userinfo);
			infoLayout = findViewById(R.id.userinfo_body_base);
			notfamilyLayout = findViewById(R.id.userinfo_nofamily_layout);
			requestFamilyView = findViewById(R.id.userinfo_requestfamily_button);
			requestFamilyView.setOnClickListener(buttonClickListener);
			mBtnBack = findViewById(R.id.userinfo_back);
			mName 		= (Button)findViewById(R.id.userinfo_name);
			mPhone 		= (Button)findViewById(R.id.userinfo_phone);
			mBirth 		= (Button)findViewById(R.id.userinfo_birthday);
			mHead		= (ImageView)findViewById(R.id.userinfo_head);
			mHeadVip  = (ImageView)findViewById(R.id.userinfo_head_vip);
			mFamilyMemberCount = (Button)findViewById(R.id.userinfo_family);
			mSpaceCount = (Button)findViewById(R.id.userinfo_space);
			mLastLoginTime = (Button)findViewById(R.id.userinfo_login);
			setRelative = findViewById(R.id.userinfo_relative);
			setRelative.setOnClickListener(buttonClickListener);
			mSpaceCount.setOnClickListener(buttonClickListener);
			mFamilyMemberCount.setOnClickListener(buttonClickListener);
			mCallView = findViewById(R.id.userinfo_call);
			mSendMsg = findViewById(R.id.userinfo_sendMsg);
			mCallView.setOnClickListener(buttonClickListener);
			mSendMsg.setOnClickListener(buttonClickListener);
			mBtnBack.setOnClickListener(buttonClickListener);
			Intent intent = getIntent();
			mProgressDialog = new ProgressDialog(this);
			mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
			if(intent != null )
			{
				mHead.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(
						LoadImageMgr.getInstance().getBigHead( intent.getStringExtra(FamilyListViewAdapter.flag[0]) ),
						mHead, LoadImageMgr.getInstance().imageCallBack));
				nameString = intent.getStringExtra(FamilyListViewAdapter.flag[1]);
				notenameString =  intent.getStringExtra(FamilyListViewAdapter.flag[4]);
				if ( notenameString == null )
				{
					notenameString = "";
				}
				mName.setText( nameString + notenameString );
				mBirth.setText(intent.getStringExtra(FamilyListViewAdapter.flag[2]));
				uidString = intent.getStringExtra(FamilyListViewAdapter.flag[3]);
				loadUserInfoTask();
			}
			
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
		public void showSetRelativeDialog()
		{
			if ( editRelativeDialog == null ) {
				editRelativeText = new EditText(this);
				editRelativeText.setHint(String.format( getResources().getString(R.string.dialog_hint_relative), nameString) );
				editRelativeText.setGravity(Gravity.TOP);
				editRelativeText.setTextSize(24);
				editRelativeText.setText( (! notenameString.equals("") )  == true ? notenameString.substring(1, notenameString.length()-1) : "");
				editRelativeDialog = new Builder(this).setTitle(getResources().getString(R.string.dialog_title_relative)).
						setView(editRelativeText).setNegativeButton(getString(R.string.dialog_button_cancel), null).
						setPositiveButton(getResources().getString(R.string.dialog_button_send), dialogClickListener).create();
			}
			editRelativeDialog.show();
		}
		public void showSendMsgDialog()
		{
			if ( editMsgDialog == null ) {
				editMsgText = new EditText(this);
				editMsgText.setHint(String.format( getResources().getString(R.string.dialog_hint_sendmsg), nameString) );
				editMsgText.setHeight(300);
				editMsgText.setGravity(Gravity.TOP);
				editMsgText.setTextSize(24);
				editMsgDialog = new Builder(this).setTitle(getResources().getString(R.string.dialog_title_sendmsg)).
						setView(editMsgText).setNegativeButton(getString(R.string.dialog_button_cancel), null).
						setPositiveButton(getResources().getString(R.string.dialog_button_send), dialogClickListener).create();
				editMsgDialog.setOnShowListener(new OnShowListener() {
					
					@Override
					public void onShow(DialogInterface dialog) {
						// TODO Auto-generated method stub
						InputMethodManager imm=(InputMethodManager)UserInfoActivity.this.getSystemService(Context.INPUT_METHOD_SERVICE); 
						imm.showSoftInput(editMsgText, 0);
						editMsgText.requestFocus();
					}
				});
			}
			
			editMsgDialog.show();
			
		}
		public void loadUserInfoTask()
		{
			new AsyncTask<String, String, String>(){
				protected void onPreExecute() {
					mProgressDialog.show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_userinfo), 
							UserInfoManager.getInstance(UserInfoActivity.this).getItem("m_auth").getValue(),uidString);
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
							JSONObject dataObject =  jsonObject.getJSONObject("data");
							if( dataObject.getInt("isfamily") == 1 )
							{
							infoLayout.setVisibility(View.VISIBLE);
							notfamilyLayout.setVisibility(View.INVISIBLE);
							
							mName.setText(dataObject.getString("name") + notenameString );
							Drawable drawable = LoadImageMgr.getInstance().loadDrawble(
									LoadImageMgr.getInstance().getBigHead( dataObject.getString("avatar") ),
									mHead, LoadImageMgr.getInstance().imageCallBack);
							if( drawable != null )
							{
								mHead.setImageDrawable(drawable);
							}
							String vipString =  dataObject.getString("vipstatus");
							if (vipString.equals(PublicInfo.VIP_FLAG_F)) {
								mHeadVip.setImageResource(R.drawable.v_l_2);
							}else if( vipString.equals(PublicInfo.VIP_FLAG_P) )
							{
								mHeadVip.setImageResource(R.drawable.v_l_1);
							}
							mBirth.setText(dataObject.getString("birthday"));
							mPhone.setText(dataObject.getString("phone"));
							mFamilyMemberCount.setText(dataObject.getString("fmembers"));
							mSpaceCount.setText(dataObject.getString("tags"));
							mLastLoginTime.setText(NetHelper.transTime(Long.parseLong( dataObject.getString("lastlogin")) ));
//								object.put(FamilyListViewAdapter.flag[0],temp.getString("avatar") );
//								object.put(FamilyListViewAdapter.flag[1],temp.getString("name") );
//								object.put(FamilyListViewAdapter.flag[2],temp.getString("birthday"));
//								object.put(FamilyListViewAdapter.flag[3],temp.getString("phone"));
//								mList.add(object);
//							}
//							mAdapter.notifyDataSetChanged();
							}else
							{
								infoLayout.setVisibility(View.INVISIBLE);
								notfamilyLayout.setVisibility(View.VISIBLE);
							}
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				};
			}.execute("");
		}
		private OnClickListener buttonClickListener = new OnClickListener(){

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if( v == mBtnBack )
				{
					UserInfoActivity.this.finish();
				}else if( v == mSpaceCount )
				{
					String space = mSpaceCount.getText().toString();
					
					if( space != null && !space.equals("")){
						Intent it = new Intent();
						it.setClass(UserInfoActivity.this, SpaceActivity.class);
						it.putExtra("uid", uidString);
						it.putExtra("name", nameString);
						it.putExtra("space",space);
						startActivity(it);
					}
					
				}else if( v == mFamilyMemberCount )
				{
					String family = mFamilyMemberCount.getText().toString();
					
					if( family != null && !family.equals("")){
						Intent it = new Intent();
						it.setClass(UserInfoActivity.this, MyFamilyMemberActivity.class);
						it.putExtra("uid", uidString);
						it.putExtra("name", nameString);
						it.putExtra("family",family);
						startActivity(it);
					}
				}else if( v == mCallView )
				{
					String tel = mPhone.getText().toString();
					if (tel != null && !tel.equals("")) {
						Uri uri = Uri.parse("tel:" + tel);
						Intent it = new Intent(Intent.ACTION_DIAL, uri);
						startActivity(it);
					}else {
						Toast.makeText(UserInfoActivity.this, R.string.tips_msg_nophone, Toast.LENGTH_SHORT).show();
					}
				}else if( v == mSendMsg )
				{
					showSendMsgDialog();
				}else if( v == setRelative )
				{
					showSetRelativeDialog();
				}else if( v == requestFamilyView )
				{
					requestFamilyTask();
				}
					
			}
			
		};
		public void requestFamilyTask()
		{
			new AsyncTask<String, String, String>()
			{
				protected void onPreExecute() {
					mProgressDialog.show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = null;
					try {
						responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_requestadd_family), 
								uidString, "","",UserInfoManager.getInstance(UserInfoActivity.this).getItem("m_auth").getValue()
								);
					} catch (NotFoundException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} 
					return responString;
				}
				protected void onPostExecute(String result) {
					if( mProgressDialog.isShowing() )
					{
						mProgressDialog.hide();
					}
					try {
						JSONObject object = new JSONObject(result);
						if (object.getInt("error") == 0) {
							Toast.makeText(UserInfoActivity.this, R.string.tips_msg_send_requestadd, Toast.LENGTH_SHORT).show();
							UserInfoActivity.this.finish();
						}else
						{
							Toast.makeText(UserInfoActivity.this, R.string.tips_msg_relax, Toast.LENGTH_SHORT).show();
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				};
			}.execute("");
		}
		public void sendMsgTask()
		{
			final String msg = editMsgText.getText().toString().trim();
			if (msg.length() < 1 ) {
				Toast.makeText(this, getResources().getString(R.string.tips_input_less0), Toast.LENGTH_SHORT).show();
				return;
			}
			new AsyncTask<String, String, String>()
			{
				protected void onPreExecute() {
					mProgressDialog.show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = null;
					try {
						responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_send_msg), 
								uidString, "",UserInfoManager.getInstance(UserInfoActivity.this).getItem("m_auth").getValue(),
								URLEncoder.encode(msg, "utf-8"),"androidVerPm");
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
						if (object.getInt("error") == 0) {
							editMsgText.setText("");
							Toast.makeText(UserInfoActivity.this, R.string.tips_msg_finish_publish, Toast.LENGTH_SHORT).show();
						}else
						{
							Toast.makeText(UserInfoActivity.this, R.string.tips_msg_relax, Toast.LENGTH_SHORT).show();
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				};
			}.execute("");
		}
		
		public void setRelativeTask()
		{
			final String msg = editRelativeText.getText().toString().trim();
			if (msg.length() < 1 ) {
				Toast.makeText(this, getResources().getString(R.string.tips_input_less0), Toast.LENGTH_SHORT).show();
				return;
			}
			new AsyncTask<String, String, String>()
			{
				protected void onPreExecute() {
					mProgressDialog.show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = null;
					try {
						responString = NetHelper.uploadPicWithArgs(getResources().getString(R.string.http_setrelative_family), null, "", 
								new String[]{"fuid",
												"note",
												"changenotesubmit",
												"m_auth"}, new String[]{uidString,
												msg,"1",
												UserInfoManager.getInstance(UserInfoActivity.this).getItem("m_auth").getValue()
						});
					} catch (NotFoundException e) {
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
						if (object.getInt("error") == 0) {
							editRelativeText.setText("");
							mName.setText(nameString + "(" + msg + ")" );
							Toast.makeText(UserInfoActivity.this, R.string.tips_msg_finish_publish, Toast.LENGTH_SHORT).show();
						}else
						{
							Toast.makeText(UserInfoActivity.this, R.string.tips_msg_relax, Toast.LENGTH_SHORT).show();
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				};
			}.execute("");
		}
		
		private android.content.DialogInterface.OnClickListener dialogClickListener = 
				new android.content.DialogInterface.OnClickListener(){

					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						if ( dialog == editMsgDialog ) {
							sendMsgTask();
						}else  if( dialog == editRelativeDialog ){
							setRelativeTask();
						}
					}
			
		};
}
