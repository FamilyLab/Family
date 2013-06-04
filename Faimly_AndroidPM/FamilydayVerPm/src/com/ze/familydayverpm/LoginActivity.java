package com.ze.familydayverpm;					// 打包至com.ze.familydayverpm

// 代码中引用的库文件
import com.umeng.analytics.MobclickAgent;

import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;

public class LoginActivity extends Activity {
	private  	boolean 				isLogined;		// 判断是否已经登录过的标志
	private 	View					rollView;			// 界面上旋转的按钮控件
	
	// Activity 的第一个周期，布局，控件的初始化在这里完成
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);		// 载入布局文件
		// to init login info
		isLogined = false;
		SharedPreferences sharedPreferences = this.getSharedPreferences("guid.cfg",
				Context.MODE_WORLD_READABLE);				// Android的存储机制，判断是否需要第一次打开程序
		if ( sharedPreferences.getBoolean("needguid", true) )
		{
			// 如果为第一次打开程序，则进入引导页面
			Intent intent = new Intent();
			intent.setClass(this, GuidActivity.class);  // 引导界面的Activity
			startActivity(intent);
			this.finish();
			return;											
		}
		// 如果不是第一次打开程序，跳过引导流程
		initWidget();			// 初始化空间的函数
	}
	
	// Activity的周期
	@Override
	public void onResume() {
	    super.onResume();
	    MobclickAgent.onResume(this);		// 第三方统计平台（友盟）的函数调用
	}
	// Activity的周期
	@Override
	public void onPause() {
	    super.onPause();
	    MobclickAgent.onPause(this);  // 第三方统计平台（友盟）的函数调用
	}
	private Animation rollViewaAnimation ;			// 界面旋转动画
	private void initWidget()
	{
		rollView							= findViewById(R.id.login_logo_view_roll);			// 在布局里通过ID查找控件
		// 定义一个旋转动画
		rollViewaAnimation = new RotateAnimation(0.0f ,720.0f ,Animation.RELATIVE_TO_SELF,0.5f ,Animation.RELATIVE_TO_SELF,0.5f );
		rollViewaAnimation.setDuration(1500);
		rollViewaAnimation.setInterpolator(new LinearInterpolator());
		rollView.setVisibility(View.INVISIBLE);
		// 2000 ms后执行run方法
		new Handler().postDelayed(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				rollView.setVisibility(View.VISIBLE);
				rollView.startAnimation(rollViewaAnimation);
			}
		}, 2000);
		// 定义旋转动画的监听函数
		rollViewaAnimation.setAnimationListener(new AnimationListener() {
			// 动画监听函数：开始以后的时机
			@Override
			public void onAnimationStart(Animation animation) {
				// TODO Auto-generated method stub
				
			}
			// 动画监听函数：重复的时机
			@Override
			public void onAnimationRepeat(Animation animation) {
				// TODO Auto-generated method stub
				
			}
			// 动画监听函数：结束的时机
			@Override
			public void onAnimationEnd(Animation animation) {
				// TODO Auto-generated method stub
				if( isLogined )
				{
					// 如果记录过登陆信息，则直接进入主菜单界面MainActivity
					Intent intent = new Intent();
					intent.setClass(LoginActivity.this, MainActivity.class);
					LoginActivity.this.startActivity(intent);
					LoginActivity.this.finish();
				}else{
					// 如果没有记录过登陆信息，则直接进入登陆账号界面SignInActivitiy
					Intent intent = new Intent();
					intent.setClass(LoginActivity.this, SignInActivitiy.class);
					LoginActivity.this.startActivity(intent);
					LoginActivity.this.finish();
				}
			}
		});
	}
}
