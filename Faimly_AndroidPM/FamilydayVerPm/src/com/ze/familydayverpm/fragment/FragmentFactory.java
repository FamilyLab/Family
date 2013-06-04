package com.ze.familydayverpm.fragment;

import android.content.Context;

public class FragmentFactory {
	private static FragmentFactory instance;
	public static FragmentFactory getInstance()
	{
		if ( instance == null ) {
			instance = new FragmentFactory();
		}
		return instance;
	}
	private FragmentFactory()
	{
		
	}
	public RelativeLayoutImp producePicLayout(Context context)
	{
		return new PicFragment(context);
	}
	public RelativeLayoutImp produceActivityLayout(Context context)
	{
		return new ActivityFragment(context);
	}
}
