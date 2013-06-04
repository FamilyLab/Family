package com.ze.familydayverpm;

import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.ModelDataMgr;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class RegisterActivity extends Activity {
	private View 		mBtnConfrim;
	private View 		mBtnCode;
	private EditText 		mEtUsername;
	private EditText		mEtPassword;
	private EditText		mEtCode;
	private ProgressDialog	mProgressDialog;
	private AlertDialog	tipsAlertDialog;
	private View		mBtnBack;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_register);
		mBtnConfrim = findViewById(R.id.register_confirm);
		mBtnCode		= findViewById(R.id.register_btngetcode);
		mBtnConfrim.setOnClickListener(buttonClickListener);
		mBtnCode.setOnClickListener(buttonClickListener);
		mBtnBack = findViewById(R.id.register_back);
		mBtnBack.setOnClickListener(buttonClickListener);
		mEtUsername = (EditText) findViewById(R.id.register_etUser);
		mEtPassword = (EditText) findViewById(R.id.register_etPw);
		mEtCode = (EditText) findViewById(R.id.register_etCode);
		
		mProgressDialog = new ProgressDialog(this);
		mProgressDialog.setCanceledOnTouchOutside(false);
		mProgressDialog.setMessage(getResources().getString( R.string.tips_msg_loading) );
		
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
	public void registerTask()
	{
		final String usernameString = mEtUsername.getText().toString();
		if ( usernameString.length() <= 0) {
			Toast.makeText(this, R.string.tips_input_phone_less0, Toast.LENGTH_LONG).show();
			return;
		}
		final String pwString = mEtPassword.getText().toString();
		if ( pwString.length() <= 0) {
			Toast.makeText(this, R.string.tips_input_pw_less0, Toast.LENGTH_LONG).show();
			return;
		}
		final String codeString = mEtCode.getText().toString();
		if ( codeString.length() <= 0) {
			Toast.makeText(this, R.string.tips_input_code_less0, Toast.LENGTH_LONG).show();
			return;
		}
		new AsyncTask<String, String, String>(){
			protected void onPreExecute() {
				mProgressDialog.show();
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String respon = NetHelper.getResponByHttpClient(
						getResources().getString(R.string.http_register),
						usernameString,
						pwString,
						codeString);
				return respon;
			}
			protected void onPostExecute(String result) {
				if (mProgressDialog .isShowing() ) {
					mProgressDialog.hide();
				}
				try {
					JSONObject object = new JSONObject(result);
					if ( object.getInt("error") == 0 ) {
						object = object.getJSONObject("data");
//						String uid = object.getInt("uid") + "";
//						String userString = object.getString("username");
//						String nameString = object.getString("name");
//						String avatar = object.getString("avatar");
//						String vipstatus = object.getString("vipstatus");
						// save m_auth
						Componet m_authComponet = new Componet("m_auth");
						m_authComponet.setValue(object.getString("m_auth"));
						// save name
						Componet nameComponet = new Componet("name");
						nameComponet.setValue(object.getString("name"));
						// save avatar
						Componet avatarComponet = new Componet("avatar");
						avatarComponet.setValue(object.getString("avatar"));
						// save username
						Componet usernameComponet = new Componet("username");
						usernameComponet.setValue(object.getString("username"));
						// save uid
						Componet uidComponet = new Componet("uid");
						uidComponet.setValue(object.getInt("uid") + "");
						// save vip
						Componet vipComponet = new Componet("vip");
						vipComponet.setValue(object.getString("vipstatus"));
						
						Componet preLoginUsername = UserInfoManager.getInstance(RegisterActivity.this).getItem("username");
						if( preLoginUsername != null &&
								! usernameComponet.getValue() .
								equals( preLoginUsername.getValue()))
						{
							// 与上一次登录不同
							ModelDataMgr.getInstance().clear();
						}
						UserInfoManager.getInstance(RegisterActivity.this).add(m_authComponet);
						UserInfoManager.getInstance(RegisterActivity.this).add(nameComponet);
						UserInfoManager.getInstance(RegisterActivity.this).add(avatarComponet);
						UserInfoManager.getInstance(RegisterActivity.this).add(usernameComponet);
						UserInfoManager.getInstance(RegisterActivity.this).add(uidComponet);
						UserInfoManager.getInstance(RegisterActivity.this).add(vipComponet);
						UserInfoManager.getInstance(RegisterActivity.this).saveAll();
						FamilyDayVerPMApplication.bindJpush(RegisterActivity.this, uidComponet.getValue());
						tipsAlertDialog = new AlertDialog.Builder(RegisterActivity.this).setMessage(
								String.format(getResources().getString( R.string.tips_register_success ), pwString)).
								setPositiveButton(R.string.dialog_button_sure, new DialogInterface.OnClickListener() {
									
									@Override
									public void onClick(DialogInterface dialog, int which) {
										// TODO Auto-generated method stub
										Intent intent = new Intent();
										intent.setClass(RegisterActivity.this, HeadNameActivity.class);
										startActivity(intent);
										RegisterActivity.this.finish();
									}
								}).create();
						tipsAlertDialog.show();
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			};
			
		}.execute("");
	}
	private boolean isGetCode = false;
	public void getCodeTask()
	{
		final String usernameString = mEtUsername.getText().toString();
		if ( usernameString.length() <= 0) {
			Toast.makeText(this, R.string.tips_input_phone_less0, Toast.LENGTH_LONG).show();
		}else
		{
//			new 
			new AsyncTask<String, String, String>(){
				protected void onPreExecute() {
					mProgressDialog.show();
				};
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = NetHelper.getResponByHttpClient(
							getResources().getString(R.string.http_register_code)
							,usernameString);
					return responString;
				}
				protected void onPostExecute(String result) {
					if( mProgressDialog.isShowing() )
					{
						mProgressDialog.hide();
					}
					try {
						JSONObject object = new JSONObject(result);
						if( object.getInt("error") == 0 )
						{
							isGetCode = true;
						}else
						{
							isGetCode = false;
						}
						Toast.makeText(RegisterActivity.this, object.getString("msg"), Toast.LENGTH_LONG).show();
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				};
			}.execute("");
		}
	}
	private OnClickListener buttonClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if( v == mBtnConfrim )
			{
//				Intent intent = new Intent();
//				intent.setClass(RegisterActivity.this, HeadNameActivity.class);
//				RegisterActivity.this.startActivity(intent);
				registerTask();
			}else if( v == mBtnCode )
			{
				getCodeTask();
			}else if( v == mBtnBack )
			{
				Intent intent = new Intent();
				intent.setClass(RegisterActivity.this, SignInActivitiy.class);
				RegisterActivity.this.startActivity(intent);
				RegisterActivity.this.finish();
			}
		}
	};
}
