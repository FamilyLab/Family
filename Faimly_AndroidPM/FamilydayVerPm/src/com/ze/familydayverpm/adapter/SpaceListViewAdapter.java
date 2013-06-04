package com.ze.familydayverpm.adapter;

import java.util.List;
import java.util.Map;

import com.ze.commontool.LoadImageMgr;
import com.ze.familydayverpm.R;
import com.ze.familydayverpm.R.id;


import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

public class SpaceListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	public static final String flag[] = {
		"img","name","id","item_type",
	};
	
	public static final int 		ids[] = {
		R.id.space_item_img,
		R.id.space_item_name,
		
	};
	private int 		layout;
	private int      layout_2;
	private Context mContext;
	private final int TYPE_ITEM_0 = 0;
	private final int TYPE_ITEM_1 = 1;
	public SpaceListViewAdapter(Context context, List<Map<String, Object>>list) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
		this.layout = R.layout.space_listview_item;
		layout_2 = R.layout.space_listview_item_2;
		mContext = context;
	}
	@Override
	public int getViewTypeCount() {
		// TODO Auto-generated method stub
		return 2;
	}
	@Override
	public int getItemViewType(int position) {
		// TODO Auto-generated method stub
		//if((Map<String, Object>)getItem(position) ).get
		Object object = ((Map<String, Object>)getItem(position)).get("item_type");
		if ( object == null ) {
			return 1;
		}else
		{
			return (Integer)object;
		}
	}
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return list == null ? 0 :list.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return list.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		Holder holder ;
		if( getItemViewType(position) == 0 )
		{
			convertView = mInflater.inflate(layout_2, null);
			return convertView;
		}
		if( convertView == null )
		{
			convertView = mInflater.inflate(layout, null);
			holder = new Holder();
			holder.img = (ImageView)convertView.findViewById(ids[0]);
			holder.name = (TextView)convertView.findViewById(ids[1]);
			
			convertView.setTag(holder);
		}else {
			
			holder = (Holder) convertView.getTag();
		}
		Drawable drawable = LoadImageMgr.getInstance().loadDrawble((String)list.get(position).get(flag[0]) ,
				holder.img, LoadImageMgr.getInstance().imageCallBack);
		if( drawable != null )
		{
			holder.img.setImageDrawable(drawable);
		}
		
		holder.name.setText( (String)list.get(position).get(flag[1]) );
		
		return convertView;
	}
	

	static class Holder
	{
		ImageView	img;
		TextView 	name;
	}
	
}
