package com.ze.familydayverpm.adapter;

import java.util.List;
import java.util.Map;

import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.PublicInfo;
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

public class FamilyListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	public static final String flag[] = {
		"head","name","birth","id","note","vip"
	};
	
	public static final int 		ids[] = {
		R.id.familymember_listview_item_head,
		R.id.familymember_listview_item_name,
		R.id.familymember_listview_item_birthday,
		R.id.familymember_listview_item_head_vip
		
	};
	private int 		layout;
//	private int      layout_diver;
	private Context mContext;
//	private final int TYPE_ITEM_0 = 0;
//	private final int TYPE_ITEM_1 = 1;
	public FamilyListViewAdapter(Context context, List<Map<String, Object>>list) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
		this.layout = R.layout.familymember_listview_item;
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
			holder.head = (ImageView)convertView.findViewById(ids[0]);
			holder.name = (TextView)convertView.findViewById(ids[1]);
			holder.birth	= (TextView)convertView.findViewById(ids[2]);
			holder.headvip = (ImageView)convertView.findViewById(ids[3]);
			convertView.setTag(holder);
		}else {
			holder = (Holder) convertView.getTag();
		}
		holder.head.setImageDrawable(LoadImageMgr.getInstance().loadDrawble((String)list.get(position).get(flag[0]), 
				holder.head, LoadImageMgr.getInstance().imageCallBack));
		holder.name.setText( (String)list.get(position).get(flag[1]) +(String)list.get(position).get(flag[4]));
		holder.birth.setText(
				(String)list.get(position).get(flag[2])  );
		if ( list.get(position).get(flag[5]).equals(PublicInfo.VIP_FLAG_F) )
		{
			holder.headvip.setImageResource(R.drawable.v_l_2);
		}else if ( list.get(position).get(flag[5]).equals(PublicInfo.VIP_FLAG_P) )
		{
			holder.headvip.setImageResource(R.drawable.v_l_1);
		}
		return convertView;
	}
	

	static class Holder
	{
		ImageView	head;
		TextView 	name;
		TextView 		birth;
		ImageView 	headvip;
	}
	
}
