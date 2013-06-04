package com.ze.familydayverpm;

import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.R.string;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.ModelDataMgr;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.Toast;

public class SignInActivitiy extends Activity {
	private ImageButton 			mBtnRegiser;
	private ImageButton 						mBtnSign;
	private CheckBox 						mBtnSavePw;
	private EditText						mEtUserName;
	private EditText						mEtPassword;
	private View							mFindPw;
	private View 							mHelp;
	private ProgressDialog			mProgressDialog;
//	private LoginTask					 loginAsyncTask;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_signin);
		Componet componet = UserInfoManager.getInstance(this).getItem("m_auth");
		Componet componet_check = UserInfoManager.getInstance(this).getItem("signin");
		boolean isCheck = componet_check == null ? false : (componet_check.getValue().equals("1") );
		if( componet != null && isCheck)
		{
//			checkMAuth(componet.getValue());
			Intent intent = new Intent();
			intent.setClass(SignInActivitiy.this, MainActivity.class)	;
			SignInActivitiy.this.startActivity(intent);
			SignInActivitiy.this.finish();
		}
		mBtnRegiser 			= (ImageButton)findViewById(R.id.sign_in_register);
		mBtnSign				= (ImageButton)findViewById(R.id.signin_btnSignIn);
		mBtnSavePw			= (CheckBox)findViewById(R.id.signin_btnSavePw);
		mEtUserName			= (EditText)findViewById(R.id.signin_etUser);
		mEtPassword			= (EditText)findViewById(R.id.signin_etPw);
		mBtnRegiser.setOnClickListener(buttonClickListener);
		mBtnSign.setOnClickListener(buttonClickListener);
		mFindPw 				= findViewById(R.id.signin_btnfindpw);
		mFindPw.setOnClickListener(buttonClickListener);
		mHelp						= findViewById(R.id.sign_in_help);
		mHelp.setOnClickListener(buttonClickListener);
		mProgressDialog = new ProgressDialog(this);
		mProgressDialog.setCanceledOnTouchOutside(false);
		mProgressDialog.setMessage(getResources().getString( R.string.dialog_msg_load) );
//		mBtnSavePw.setOnClickListener(buttonClickListener);
		
//		loginAsyncTask = new LoginTask();
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
	private OnClickListener buttonClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if ( v == mBtnRegiser ) {
				Intent intent = new Intent();
				intent.setClass(SignInActivitiy.this, RegisterActivity.class);
				SignInActivitiy.this.startActivity(intent);
				SignInActivitiy.this.finish();
//				Toast.makeText(SignInActivitiy.this, R.string.notopen, Toast.LENGTH_SHORT).show();
			}else if( v == mBtnSavePw )
			{
//				 mBtnSavePw.setChecked( ! mBtnSavePw.isChecked() ) ;
//				 mBtnSavePw.setSelected( ! mBtnSavePw.isSelected());
			}else if( v == mBtnSign )
			{
				InputMethodManager immInputMethodManager = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
				immInputMethodManager.hideSoftInputFromWindow(SignInActivitiy.this.getCurrentFocus().getWindowToken(), 0);
				 Componet  componet = new Componet("signin");
				 if( mBtnSavePw.isChecked() )
				 {
					 componet.setValue("1");
				 }else
				 {
					 componet.setValue("0");
				 }
				 UserInfoManager.getInstance(SignInActivitiy.this).add(componet);
				 UserInfoManager.getInstance(SignInActivitiy.this).save(componet);
				new LoginTask().execute("");
			}else if( v == mHelp )
			{
				Toast.makeText(SignInActivitiy.this, R.string.notopen, Toast.LENGTH_SHORT).show();
			}else if( v == mFindPw )
			{
//				Toast.makeText(SignInActivitiy.this, R.string.notopen, Toast.LENGTH_SHORT).show();
				if( mEtUserName.getText().toString().length() <= 0 )
				{
					Toast.makeText(SignInActivitiy.this, R.string.tips_input_less0, Toast.LENGTH_SHORT).show();
				}else
				{
					changePwTask( mEtUserName.getText().toString());
				}
			}
		}
	};
	private String username;
	private String password;
	public void changePwTask(final String username)
	{
		new AsyncTask<String, String, String>(){
			protected void onPreExecute() {
				mProgressDialog.show();
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_change_pw_1),username);
				return respon;
			}
			protected void onPostExecute(String result) {
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
				try {
					JSONObject object = new JSONObject(result);
					if ( object.getInt("error") == 0 ) {
						String uidString = object.getJSONObject("data").getString("uid");
						Toast.makeText(SignInActivitiy.this,object.getString("msg"), Toast.LENGTH_LONG).show();
						Intent intent = new Intent();
						intent.putExtra("uid", uidString);
						intent.setClass(SignInActivitiy.this, FindPwActivity.class);
						SignInActivitiy.this.startActivity(intent);
					}else
					{
						Toast.makeText(SignInActivitiy.this,object.getString("msg"), Toast.LENGTH_SHORT).show();
					}
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
					Toast.makeText(SignInActivitiy.this,R.string.error_net, Toast.LENGTH_SHORT).show();
				}
			};
		}.execute("");
	}
	public boolean isLegalInput()
	{
		username = mEtUserName.getText().toString().trim();
		if ( username.length() == 0 ) {
			Toast.makeText(this, getResources().getString(R.string.tips_login_nameinput), Toast.LENGTH_SHORT).show();
			return true;
		}
		password = mEtPassword.getText().toString().trim();
		if ( password.length() == 0 ) {
			Toast.makeText(this, getResources().getString(R.string.tips_login_pwinput), Toast.LENGTH_SHORT).show();
			return true;
		}
		if ( password.length() < 6 ) {
			Toast.makeText(this, getResources().getString(R.string.tips_login_pwinput2), Toast.LENGTH_SHORT).show();
			return true;
		}
		return false;
	}
	class LoginTask extends AsyncTask<Object, Object, Object>
	{
		boolean  cancel;
		ProgressDialog	tipsDialog;
		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			super.onPreExecute();
			cancel = isLegalInput();
			if ( !cancel ) {
				if(tipsDialog == null )
				{
					tipsDialog = new ProgressDialog(SignInActivitiy.this);
					tipsDialog.setCanceledOnTouchOutside(false);
					tipsDialog.setMessage(getResources().getString(R.string.dialog_msg_login));
				}
				tipsDialog.show();
			}
		}
		@Override
		protected Object doInBackground(Object... params) {
			// TODO Auto-generated method stub
			
			if (cancel) {
				return null;
			}else
			{
//				NetHelper.get
				String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_login), username, password);
				return responString;
			}
			
		}
		@Override
		protected void onPostExecute(Object result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			
			if (cancel) {
				return;
			}
			tipsDialog.hide();
			try {
				JSONObject object = new JSONObject((String)result);
				if(!object.isNull("error"))
				{
					if ( 0 == object.getInt("error") )
					{
						if ( 1 == object.getJSONObject("data").getInt("return") )
						{
							// save m_auth
							Componet m_authComponet = new Componet("m_auth");
							m_authComponet.setValue(object.getJSONObject("data").getString("m_auth"));
							// save name
							Componet nameComponet = new Componet("name");
							nameComponet.setValue(object.getJSONObject("data").getString("name"));
							// save avatar
							Componet avatarComponet = new Componet("avatar");
							avatarComponet.setValue(object.getJSONObject("data").getString("avatar"));
							// save username
							Componet usernameComponet = new Componet("username");
							usernameComponet.setValue(object.getJSONObject("data").getString("username"));
							// save uid
							Componet uidComponet = new Componet("uid");
							uidComponet.setValue(object.getJSONObject("data").getString("uid"));
							// save vip
							Componet vipComponet = new Componet("vip");
							vipComponet.setValue(object.getJSONObject("data").getString("vipstatus"));
							
							Componet preLoginUsername = UserInfoManager.getInstance(SignInActivitiy.this).getItem("username");
							if( preLoginUsername != null &&
									! usernameComponet.getValue() .
									equals( preLoginUsername.getValue()))
							{
								// 与上一次登录不同
								ModelDataMgr.getInstance().clear();
							}
							UserInfoManager.getInstance(SignInActivitiy.this).add(m_authComponet);
							UserInfoManager.getInstance(SignInActivitiy.this).add(nameComponet);
							UserInfoManager.getInstance(SignInActivitiy.this).add(avatarComponet);
							UserInfoManager.getInstance(SignInActivitiy.this).add(usernameComponet);
							UserInfoManager.getInstance(SignInActivitiy.this).add(uidComponet);
							UserInfoManager.getInstance(SignInActivitiy.this).add(vipComponet);
//							Componet tempComponet = UserInfoManager.getInstance(SignInActivitiy.this).getItem("m_auth");
//							if ( tempComponet  != null ) {
////								UserInfoManager.getInstance(SignInActivitiy.this).delete(tempComponet);
//								tempComponet.setValue(m_authComponet.getValue());
//								Log.v("test", "xiugai:"+m_authComponet.getValue());
//							}else
//							{
//								UserInfoManager.getInstance(SignInActivitiy.this).add(m_authComponet);
//								Log.v("test", "new mauth:"+m_authComponet.getValue());
//							}
							UserInfoManager.getInstance(SignInActivitiy.this).saveAll();
							Intent intent = new Intent();
							intent.setClass(SignInActivitiy.this, MainActivity.class)	;
							FamilyDayVerPMApplication.bindJpush(SignInActivitiy.this, uidComponet.getValue());
							SignInActivitiy.this.startActivity(intent);
							SignInActivitiy.this.finish();
						}
					}else {
						String msg = object.getString("msg");
						Toast.makeText(SignInActivitiy.this, msg, Toast.LENGTH_SHORT).show();
					}
				}
				return;
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Toast.makeText(SignInActivitiy.this, R.string.error_net, Toast.LENGTH_SHORT).show();
		}
	}
	
	public void checkMAuth( final String m_auth )
	{
		new AsyncTask<String, String, String>()
		{
			ProgressDialog progressDialog;
			protected void onPreExecute() {
				if  ( m_auth != null ) {
					progressDialog = new ProgressDialog(SignInActivitiy.this);
					progressDialog.setMessage(getResources().getString(R.string.dialog_msg_check_mauth));
					progressDialog.show();
				}
				
				};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				if( m_auth != null )
				{
					String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_validation),m_auth);
					return responString;
				}else
				{
					return null;
				}
			}
			protected void onPostExecute(String result) {
				if(result == null )
				{
					return;
				}
				if (progressDialog.isShowing()) {
					progressDialog.hide();
				}
				JSONObject object;
				try {
					object = new JSONObject(result);
					if ( object.getJSONObject("data").getInt("return") == 1) {
//						Intent intent = new Intent();
//						intent.setClass(SignInActivitiy.this, MainActivity.class)	;
//						SignInActivitiy.this.startActivity(intent);
//						SignInActivitiy.this.finish();
					}else {
						Toast.makeText(SignInActivitiy.this, getResources().getString(R.string.login_fail), Toast.LENGTH_SHORT).show();
					}
					return ;
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}finally
				{
					
				}
				
			
			};
		}.execute("");
	}
	
}
