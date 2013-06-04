package com.ze.familydayverpm;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.PublicInfo;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;

public class AboutActivity extends Activity {
	private int 			flag;
	private ImageView	  picImageView;
	private View 			back;
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
		setContentView(R.layout.activity_about);
		picImageView = (ImageView)findViewById(R.id.about_infopic);
		back = findViewById(R.id.about_back);
		back.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				AboutActivity.this.finish();
			}
		});
		flag = getIntent().getIntExtra("infopic", 0);
		switch (flag) {
		case PublicInfo.INFOPIC_ABOUT:
			picImageView.setImageResource(R.drawable.about_family);
			break;
		case PublicInfo.INFOPIC_VIP:
			picImageView.setImageResource(R.drawable.vip_info);
			break;
		case PublicInfo.INFOPIC_COIN:
			picImageView.setImageResource(R.drawable.coin_use);
			break;
		default:
			break;
		}
	}
}
