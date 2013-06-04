package com.ze.familydayverpm.adapter;

import java.util.List;
import java.util.Map;

import com.ze.familydayverpm.R;
import com.ze.familydayverpm.R.id;


import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class PicListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	private String flag[];
	private int 		ids[];
	private int 		layout;
	private Context mContext;
//	private final int TYPE_ITEM_0 = 0;
//	private final int TYPE_ITEM_1 = 1;
	public PicListViewAdapter(Context context, List<Map<String, Object>>list, int layout, String[]flag, int[] ids ) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
		this.flag = flag;
		this.layout = layout;
		this.ids = ids;
		mContext = context;
	}
//	@Override
//	public int getViewTypeCount() {
//		// TODO Auto-generated method stub
//		return 2;
//	}
//	@Override
//	public int getItemViewType(int position) {
//		// TODO Auto-generated method stub
//		return (Integer)((Map<String, Object>)getItem(position)).get("item_type");
//	}
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
		if( convertView == null )
		{
			convertView = mInflater.inflate(layout, null);
			holder = new Holder();
			holder.name = (TextView)convertView.findViewById(ids[0]);
			holder.say = (TextView)convertView.findViewById(ids[1]);
			convertView.setTag(holder);
		}else {
			holder = (Holder) convertView.getTag();
		}
		holder.name.setText( (String)list.get(position).get(flag[0]) );
		holder.say.setText( (String)list.get(position).get(flag[1]) );
		
		
		return convertView;
	}
	

	static class Holder
	{
		TextView 	name;
		TextView 	say;
	}
}
