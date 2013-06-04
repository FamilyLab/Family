package com.ze.familydayverpm;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.adapter.PhoneListViewAdapter;
import com.ze.familydayverpm.adapter.SearchListViewAdapter;
import com.ze.familydayverpm.adapter.SpaceListInDialogListViewAdapter;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.Contacts.People.Phones;
import android.text.InputType;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

public class FindPwActivity extends Activity {
		private 			EditText						mEtPw1;
		private 			EditText						mEtPw2;
		private 			EditText						mEtAuthCode;
		private 			CheckBox						mCbShow;
		private 			View 					mBtnBack;
		private 			View 					mBtnConfirm;
		private 			String 					uidString;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_findpw);
			uidString = getIntent().getStringExtra("uid");
			mBtnBack		    = findViewById(R.id.findpw_back);
			mEtPw1				= (EditText)findViewById(R.id.findpw_etNew);
			mEtPw2				= (EditText)findViewById(R.id.findpw_etpw_2);
			mEtAuthCode				= (EditText)findViewById(R.id.findpw_auth_code);
			mCbShow			= (CheckBox)findViewById(R.id.findpw_showpw);
			mCbShow.setOnCheckedChangeListener(new OnCheckedChangeListener() {
				
				@Override
				public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
					// TODO Auto-generated method stub
					if ( isChecked) {
						mEtPw1.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
						mEtPw2.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
					}else
					{
						mEtPw1.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
						mEtPw2.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
					}
				}
			});
			mBtnConfirm 		= findViewById(R.id.findpw_btnchangepw);
			mBtnBack.setOnClickListener(buttonClickListener);
			mBtnConfirm.setOnClickListener(buttonClickListener);
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
		private OnClickListener buttonClickListener = new OnClickListener(){

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if ( v == mBtnConfirm ) {
					// 
					changePwTask();
				}else if( v == mBtnBack )
				{
						FindPwActivity.this.finish();
				}
			}
			
		};
		private ProgressDialog mProgressDialog;
		public void changePwTask()
		{
			final String pw1 = mEtPw1.getText().toString();
			final String pw2 = mEtPw2.getText().toString();
			if ( ! pw1.equals(pw2) ) {
				Toast.makeText(this, R.string.tips_msg_pw_nosame, Toast.LENGTH_LONG).show();
				return;
			}
			final String auth_code = mEtAuthCode.getText().toString().trim();
			if ( auth_code.length() <= 0 ) {
				Toast.makeText(this, R.string.tips_msg_pw_needauth, Toast.LENGTH_LONG).show();
				return;
			}
				new AsyncTask<String, String, String> (){
					
					protected void onPreExecute() {
						if (mProgressDialog == null) {
							mProgressDialog = new ProgressDialog(FindPwActivity.this);
							mProgressDialog.setMessage(getResources().getString( R.string.dialog_msg_load) );
						}
						mProgressDialog.show();
						InputMethodManager immInputMethodManager = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
						immInputMethodManager.hideSoftInputFromWindow(FindPwActivity.this.getCurrentFocus().getWindowToken(), 0);
					};
					@Override
					protected String doInBackground(String... params) {
						// TODO Auto-generated method stub
						String respon = NetHelper.getResponByHttpClient(
								getResources().getString(R.string.http_change_pw_2),
								uidString,
								pw1,
								pw2,
								auth_code);
						return respon;
					};
					protected void onPostExecute(String result) {
						if( mProgressDialog.isShowing() )
						{
							mProgressDialog.hide();
						}
						try {
							JSONObject object = new JSONObject(result);
							if ( object.getInt("error") == 0 ) {
								FindPwActivity.this.finish();
							}
							Toast.makeText(FindPwActivity.this, object.getString("msg"), Toast.LENGTH_LONG).show();
						} catch (Exception e) {
							// TODO: handle exception
							e.printStackTrace();
						}
					}
	
					
				}.execute("");
			}
}
