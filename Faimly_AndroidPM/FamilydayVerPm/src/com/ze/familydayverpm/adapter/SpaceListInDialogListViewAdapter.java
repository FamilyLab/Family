package com.ze.familydayverpm.adapter;

import java.util.List;
import java.util.Map;

import com.ze.familydayverpm.PublishActivity.TagInfo;
import com.ze.familydayverpm.R;
import com.ze.familydayverpm.R.id;


import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class SpaceListInDialogListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<TagInfo> list;
	private Context mContext;
//	private final int TYPE_ITEM_0 = 0;
//	private final int TYPE_ITEM_1 = 1;
	public SpaceListInDialogListViewAdapter(Context context, List<TagInfo> list) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
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
			convertView = mInflater.inflate(R.layout.tag_listview_item, null);
			holder = new Holder();
			holder.name = (TextView)convertView.findViewById(R.id.tag_lv_item);
			convertView.setTag(holder);
		}else {
			holder = (Holder) convertView.getTag();
		}
		holder.name.setText(list.get(position).nameString);
		return convertView;
	}
	

	static class Holder
	{
		TextView 	name;
	}
}
