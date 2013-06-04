package com.ze.familydayverpm;

import java.util.ArrayList;
import java.util.List;

import com.umeng.analytics.MobclickAgent;


import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

public class GuidActivity extends Activity implements OnPageChangeListener {
	private ViewPager guidViewPager;
	private static final int[] pics = { R.drawable.guiding1,
		   R.drawable.guiding2, R.drawable.guiding3,
		   };
//	private static final int[] buttonIds = { R.id.guid_select_1,
//								R.id.guid_select_2,
//								R.id.guid_select_3,
//								R.id.guid_select_4};
//	
//	private static Button[] selectors;
	private List<View>list  ;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.guid_layout);
		guidViewPager = (ViewPager) findViewById(R.id.guid_viewPager_layout);
		RelativeLayout.LayoutParams mParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT,
				RelativeLayout.LayoutParams.WRAP_CONTENT);
		list  = new ArrayList<View>();
		 for(int i=0; i<pics.length; i++) {
	         ImageView iv = new ImageView(this);
	         iv.setLayoutParams(mParams);
	         iv.setImageResource(pics[i]);
	         iv.setOnClickListener(picOnClickListener);
	         list.add(iv);
	        }
		guidViewPager.setAdapter(new ViewAdapter(list));
		guidViewPager.setOnPageChangeListener(this);
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
	private class ViewAdapter extends PagerAdapter
	{
		private List<View> mPagerViews;
		
		public ViewAdapter(List<View> list)
		{
			this.mPagerViews = list;
		}
		
		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			// TODO Auto-generated method stub
			( (ViewPager)container) .removeView(mPagerViews.get(position));
//			super.destroyItem(container, position, object);
		}
		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			if(mPagerViews != null )
			{
				return mPagerViews.size();
			}
			return 0;
		}
		@Override
		public Object instantiateItem(ViewGroup container, int position) {
			// TODO Auto-generated method stub
			((ViewPager)container).addView(mPagerViews.get(position),0);
			return mPagerViews.get(position);
		}
		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			// TODO Auto-generated method stub
			return (arg0 == arg1);
		}
		
	}
	@Override
	public void onPageScrollStateChanged(int arg0) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void onPageScrolled(int arg0, float arg1, int arg2) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void onPageSelected(int arg0) {
		// TODO Auto-generated method stub
	}
	public OnClickListener picOnClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if( v == list.get(list.size()-1))
			{
				Animation animation = new AlphaAnimation(1.0f, 0.1f);
				animation.setDuration(300);
				animation.setFillAfter(true);
				animation.setAnimationListener(new AnimationListener() {
				
					@Override
					public void onAnimationStart(Animation animation) {
						// TODO Auto-generated method stub
					
					}
				
					@Override
					public void onAnimationRepeat(Animation animation) {
						// TODO Auto-generated method stub
						
					}
				
					@Override
					public void onAnimationEnd(Animation animation) {
						// TODO Auto-generated method stub
						SharedPreferences sharedPreferences = GuidActivity.this.getSharedPreferences("guid.cfg",
								GuidActivity.this.MODE_WORLD_WRITEABLE);
						sharedPreferences.edit().putBoolean("needguid", false).commit();
						
	//					Bundle bundle = new Bundle();
	//					bundle.putInt("single", 1);
						Intent intent = new Intent();
						intent.setClass(GuidActivity.this, LoginActivity.class);
						startActivity(intent);
						GuidActivity.this.finish();
					}
				});
				v.startAnimation(animation);
			}else
			{
				guidViewPager.setCurrentItem(guidViewPager.getCurrentItem() + 1);
			}
		}
	};
}
