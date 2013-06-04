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
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

public class PhoneListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	public static final String flag[] = {
		"head","name","action","item_type"
	};
	
	public static final int 		ids[] = {
		R.id.addmember_listview_item_head,
		R.id.addmember_listview_item_name,
		R.id.addmember_listview_item_action
		
	};
	private int 		layout;
	private int      layout_diver;
	private Context mContext;
	private final int TYPE_ITEM_0 = 0;
	private final int TYPE_ITEM_1 = 1;
	public PhoneListViewAdapter(Context context, List<Map<String, Object>>list) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
		this.layout = R.layout.addmember_listview_item;
		layout_diver = R.layout.addmember_listview_diver;
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
		return (Integer)((Map<String, Object>)getItem(position)).get("item_type");
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
		if(getItemViewType(position) == 0)
		{
			// 分割线
			convertView = mInflater.inflate(layout_diver, null);
			return convertView;
		}
		if( convertView == null )
		{
			convertView = mInflater.inflate(layout, null);
			holder = new Holder();
			holder.head = (ImageView)convertView.findViewById(ids[0]);
			holder.name = (TextView)convertView.findViewById(ids[1]);
			holder.action	= (Button)convertView.findViewById(ids[2]);
			convertView.setTag(holder);
		}else {
			holder = (Holder) convertView.getTag();
		}
		//holder.head.setText( (String)list.get(position).get(flag[0]) );
		holder.name.setText( (String)list.get(position).get(flag[1]) );
		if ( list.get(position).get(flag[2]).equals("0") ) {
			// 不是familyday用户
			holder.action.setBackgroundResource(R.drawable.invite);
		}else if( list.get(position).get(flag[2]).equals("1") )
		{
			// 是familyday用户，不是好友
			holder.action.setBackgroundResource(R.drawable.add);
		}else if( list.get(position).get(flag[2]).equals("2") )
		{
			// 是familyday用户，是家人
			holder.action.setBackgroundResource(R.drawable.cancel);
		}
		
		return convertView;
	}
	

	static class Holder
	{
		ImageView	head;
		TextView 	name;
		Button 		action;
	}
	
}
