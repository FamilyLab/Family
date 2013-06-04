package com.ze.familydayverpm.adapter;

import java.util.ArrayList;
import java.util.List;

import com.ze.commontool.LoadImageMgr;
import com.ze.familydayverpm.R;



import android.R.integer;
import android.content.Context;
import android.graphics.drawable.Drawable;

import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Gallery;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;

public class ImageAdapter extends BaseAdapter {
	private ArrayList<Drawable> pic_array_id ; 
	private Context mContext; 
	private ArrayList<String> pic_string_id = null;
	public ImageAdapter(Context context, List<Drawable> pic_ids) {
		// TODO Auto-generated constructor stub
		mContext = context;
		pic_array_id = (ArrayList<Drawable>) pic_ids;
		
//		if(pic_ids != null && pic_ids.size() != 0) {
//			pic_array_id.addAll(pic_ids);
//		}
//		pic_array_id.add(R.drawable.add);
	}
	public ImageAdapter(Context context, ArrayList<String> pic_ids) {
		// TODO Auto-generated constructor stub
		mContext = context;
		pic_string_id = pic_ids;
	}
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		if(pic_string_id != null )
		{
			return pic_string_id.size();
		}
		return pic_array_id.size();
	}

	@Override
	public Object getItem(int arg0) {
		// TODO Auto-generated method stub
		if(pic_string_id != null )
		{
			return pic_string_id.get(arg0);
		}
		return pic_array_id.get(arg0);
	}

	@Override
	public long getItemId(int arg0) {
		// TODO Auto-generated method stub
		return arg0;
	}

	@Override
	public View getView(int arg0, View arg1, ViewGroup arg2) {
		// TODO Auto-generated method stub
		ImageView img = (ImageView)arg1;
		if(img == null) {
			img = new ImageView(mContext);
		}
		if( pic_string_id != null )
		{
			img.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(pic_string_id.get(arg0), img, LoadImageMgr.getInstance().imageCallBack));
		}else
		{
			img.setImageDrawable(pic_array_id.get(arg0));
		}
		img.setLayoutParams(new Gallery.LayoutParams((int)mContext.getResources().getDimension(R.dimen.galley_high),
										(int)mContext.getResources().getDimension(R.dimen.galley_high)));
		return img;
	}
	
}
