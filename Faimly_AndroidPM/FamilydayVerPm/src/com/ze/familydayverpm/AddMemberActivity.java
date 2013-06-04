package com.ze.familydayverpm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.NetHelper;
import com.ze.familydayverpm.adapter.PhoneListViewAdapter;
import com.ze.familydayverpm.userinfo.UserInfoManager;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.Contacts.People.Phones;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;
import android.widget.Toast;

public class AddMemberActivity extends Activity {
		private 			EditText						mEtPhone;
		private 			EditText						mEtName;
		private 			EditText						mEtMsg;
		
		private 			ImageButton 					mBtnBack;
		private 			View 					mBtnAdd;
		private 			View 					mBtnInvite;
		private 			boolean 				isFromRegister;
		private 			View 					mBtnIgnore;
		@Override
		protected void onResume() {
			// TODO Auto-generated method stub
			super.onResume();
			MobclickAgent.onResume(this);
		}
		@Override
		protected void onPause() {
			// TODO Auto-generated method stub
			super.onPause();
			 MobclickAgent.onPause(this);
		}
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_invite);
			isFromRegister = getIntent().getBooleanExtra("register", false);
			mEtPhone 			= (EditText)findViewById(R.id.invite_etTel);
			mEtName 			= (EditText)findViewById(R.id.invite_etName);
			mEtName.setOnFocusChangeListener(new OnFocusChangeListener() {
				
				@Override
				public void onFocusChange(View v, boolean hasFocus) {
					// TODO Auto-generated method stub
					if (hasFocus == false) {
//						  mEtMsg.setText(String.format(getResources().getString(R.string.tips_msg_invite), mEtName.getText().toString(),
//				            		UserInfoManager.getInstance(AddMemberActivity.this).getItem("name").getValue() ));
					}
				}
			});
			mEtMsg 				= (EditText)findViewById(R.id.invite_etmsg);
			mEtMsg.setEnabled(false);
			mBtnBack		    = (ImageButton) findViewById(R.id.invite_back);
			mBtnAdd		    = findViewById(R.id.invite_btnTelAdd);
			mBtnInvite		    = findViewById(R.id.invite_btnconfirm);
			mBtnIgnore		= findViewById(R.id.invite_ignore);
			mBtnBack.setOnClickListener(buttonClickListener);
			mBtnInvite.setOnClickListener(buttonClickListener);
			mBtnAdd.setOnClickListener(buttonClickListener);
			mBtnIgnore.setOnClickListener(buttonClickListener);
			if (isFromRegister) {
				mBtnBack.setVisibility(View.INVISIBLE);
				mBtnIgnore.setVisibility(View.VISIBLE);
			}else
			{
				mBtnBack.setVisibility(View.VISIBLE);
				mBtnIgnore.setVisibility(View.INVISIBLE);
			}
		}
		@Override
		protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
		switch (requestCode) {
        case 0:
            if (data == null) {
                return;
            }
            Uri uri = data.getData();
            Cursor cursor = getContentResolver().query(uri, null, null, null, null);
            cursor.moveToFirst();
            
            String number = cursor.getString(cursor.getColumnIndexOrThrow(Phones.NUMBER));
            String name = cursor.getString(cursor.getColumnIndexOrThrow(Phones.NAME));
            
            mEtName.setText(name);
            mEtPhone.setText(number);
            
            mEtMsg.setText(String.format(getResources().getString(R.string.tips_msg_invite), mEtName.getText().toString(),
            		UserInfoManager.getInstance(AddMemberActivity.this).getItem("name").getValue() ));
            
//            mEtMsg.setText(String.format(getResources().getString(R.string.tips_msg_invite), name,
//            		UserInfoManager.getInstance(AddMemberActivity.this).getItem("name").getValue() ,""));
            
//            mEtMsg.setEnabled(false);
            break;
        
        default:
            break;
    }
		}
		private OnClickListener buttonClickListener = new OnClickListener(){

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if ( v == mBtnAdd ) {
					//TODO: to contract book
					Intent i = new Intent(Intent.ACTION_PICK);
                    i.setType("vnd.android.cursor.dir/phone");
                    startActivityForResult(i, 0);
				}else if( v == mBtnBack )
				{
//					if( isFromRegister )
//					{
//						Intent intent = new Intent();
//						intent.setClass(AddMemberActivity.this, MainActivity.class);
//						startActivity(intent);
//					}
					AddMemberActivity.this.finish();
					
				}else if( v == mBtnInvite )
				{
					// TODO: to send msg
					requestRegister();
				}else if( v == mBtnIgnore )
				{
					Intent intent = new Intent();
					intent.setClass(AddMemberActivity.this, MainActivity.class);
					startActivity(intent);
				}
			}
			
		};
		private ProgressDialog mProgressDialog;
		public void requestRegister()
		{
			final String username;
			final String name;
			username 	= mEtPhone.getText().toString().trim();
			name			= mEtName.getText().toString().trim();
			if( username.length() > 0 && name.length() > 0 )
			{
				new AsyncTask<String, String, String> (){
					
					protected void onPreExecute() {
						if (mProgressDialog == null) {
							mProgressDialog = new ProgressDialog(AddMemberActivity.this);
							mProgressDialog.setMessage(getResources().getString( R.string.dialog_msg_load) );
						}
						mProgressDialog.show();
					};
				
					protected void onPostExecute(String result) {
						if( mProgressDialog.isShowing() )
						{
							mProgressDialog.hide();
						}
						try {
							JSONObject object = new JSONObject(result);
							if( object.getInt("error") == 0 )
							{
//								object = object.getJSONObject("data");
//								String pw = object.getString("password");
//								mEtMsg.setText(String.format(getResources().getString(R.string.tips_msg_invite), name,
//					            		UserInfoManager.getInstance(AddMemberActivity.this).getItem("name").getValue(),
//					            		pw));
								Toast.makeText(AddMemberActivity.this, R.string.tips_msg_invite_sucess, Toast.LENGTH_SHORT).show();
//								Uri smsToUri = Uri.parse("smsto:" + username );
//								Intent intent = new Intent(Intent.ACTION_SENDTO, smsToUri);
//								intent.putExtra("sms_body", mEtMsg.getText().toString());
//								startActivity(intent);
							}else
							{
								String msg = object.getString("msg");
								Toast.makeText(AddMemberActivity.this, msg, Toast.LENGTH_LONG).show();
							}
							return;
						} catch (Exception e) {
							// TODO: handle exception
							e.printStackTrace();
						}
						Toast.makeText(AddMemberActivity.this, R.string.error_net, Toast.LENGTH_LONG).show();
					}
	
					@Override
					protected String doInBackground(String... params) {
						// TODO Auto-generated method stub
						String respon = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_invite_family),username,name,
								UserInfoManager.getInstance(AddMemberActivity.this).getItem("m_auth").getValue());
						return respon;
					};
				}.execute("");
			}else
			{
				Toast.makeText(AddMemberActivity.this, R.string.tips_msg_needwrite, Toast.LENGTH_SHORT).show();
			}
		}
}
