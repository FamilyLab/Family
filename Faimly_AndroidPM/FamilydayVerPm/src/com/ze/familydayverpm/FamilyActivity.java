package com.ze.familydayverpm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.umeng.analytics.MobclickAgent;
import com.ze.familydayverpm.adapter.PhoneListViewAdapter;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

public class FamilyActivity extends Activity {
		private 			View						mBtnMine;
		private 			View						mBtnInvite;
		private 			View						mBtnNeedConfirm;
		private 			View 						mBtnSearch;
		private 			View 					mBtnBack;
		private   			TextView				mTvCount;
		private 			int 						mCount;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_family);
			mCount = getIntent().getIntExtra("count",0);
			mBtnMine = findViewById(R.id.family_mine);
			mBtnInvite = findViewById(R.id.family_invite);
			mBtnNeedConfirm = findViewById(R.id.family_needconfirm);
			mBtnBack = findViewById(R.id.family_back);
			mBtnSearch = findViewById(R.id.family_search);
			mBtnMine.setOnClickListener(buttonClickListener);
			mBtnInvite.setOnClickListener(buttonClickListener);
			mBtnNeedConfirm.setOnClickListener(buttonClickListener);
			mBtnBack.setOnClickListener(buttonClickListener);
			mBtnSearch.setOnClickListener(buttonClickListener);
			
			mTvCount = (TextView)findViewById(R.id.family_needconfirm_count);
			if( mCount != 0 )
			{
				mTvCount.setText(mCount + "");
				mTvCount.setVisibility(View.VISIBLE);
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
		private OnClickListener buttonClickListener = new OnClickListener(){

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if ( v == mBtnMine ) {
					Intent intent = new Intent();
					intent.setClass(FamilyActivity.this, MyFamilyMemberActivity.class);
					FamilyActivity.this.startActivity(intent);
				}else if( v == mBtnInvite )
				{
					Intent intent = new Intent();
					intent.setClass(FamilyActivity.this, AddMemberActivity.class);
					intent.putExtras(new Bundle());
					FamilyActivity.this.startActivity(intent);
				}else if( v == mBtnNeedConfirm )
				{
					Intent intent = new Intent();
					intent.setClass(FamilyActivity.this, NeedConfirmActivity.class);
					intent.putExtras(new Bundle());
					FamilyActivity.this.startActivity(intent);
				}else if( v == mBtnBack )
				{
					FamilyActivity.this.finish();
				}else if( v == mBtnSearch )
				{
					Intent intent = new Intent();
					intent.setClass(FamilyActivity.this, SearchUserActivity.class);
					intent.putExtras(new Bundle());
					FamilyActivity.this.startActivity(intent);
				}
			}
			
		};
}
