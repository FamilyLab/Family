package com.ze.familydayverpm.adapter;

import java.util.List;
import java.util.Map;

import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.PublicInfo;
import com.ze.familyday.familyphotoframe.R;


import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

public class WifiListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	public static final String flag[] = {
		"wifi","status","strong","pw","netid","ispw"
	};
	
	public static final int 		ids[] = {
		R.id.wifi_item_name,
		R.id.wifi_item_status,
		R.id.wifi_item_icon,
	};
	private int 		layout;
	private Context mContext;
	public WifiListViewAdapter(Context context, List<Map<String, Object>>list) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
		this.layout = R.layout.wifi_listview_item;
//		layout_diver = R.layout.addmember_listview_diver;
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
			holder.status	= (TextView)convertView.findViewById(ids[1]);
			holder.icon = (ImageView)convertView.findViewById(ids[2]);
			convertView.setTag(holder);
		}else {
			holder = (Holder) convertView.getTag();
		}
		holder.name.setText( (String)list.get(position).get(flag[0]) );
		Integer strong = (Integer) list.get(position).get(flag[2]);
		switch (strong.intValue()) {
		case 1:
			holder.icon.setBackgroundResource(R.drawable.wifi_unlink1);
			break;
		case 2:
			holder.icon.setBackgroundResource(R.drawable.wifi_unlink2);
			break;
		case 3:
			holder.icon.setBackgroundResource(R.drawable.wifi_unlink3);
			break;
		case 4:
			holder.icon.setBackgroundResource(R.drawable.wifi_unlink3);
			break;
		default:
			break;
		}
		if( list.get(position).get(flag[1]).equals("1") )
		{
			holder.icon.setBackgroundResource(R.drawable.wifi_link);
		}
		return convertView;
	}
	

	static class Holder
	{
		TextView	    name;
		TextView 	status;
		ImageView 		icon;
	}
	
}
