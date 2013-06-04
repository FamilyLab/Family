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

public class DialogListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	public static final String flag[] = {
		"head","name","call","unread","touid","vip"
	};
	
	public static final int 		ids[] = {
		R.id.dialog_listview_item_head,
		R.id.dialog_listview_item_name,
		R.id.dialog_listview_item_call,
		R.id.dialog_listview_item_unread,
		R.id.dialog_listview_item_v
	};
	private int 		layout;
	private int      layout_diver;
	private Context mContext;
//	private final int TYPE_ITEM_0 = 0;
//	private final int TYPE_ITEM_1 = 1;
	public DialogListViewAdapter(Context context, List<Map<String, Object>>list) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
		this.layout = R.layout.dialog_listview_item;
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
			holder.call	= (TextView)convertView.findViewById(ids[2]);
			holder.unread	= (TextView)convertView.findViewById(ids[3]);
			holder.headvip = (ImageView)convertView.findViewById(ids[4]);
			convertView.setTag(holder);
		}else {
			holder = (Holder) convertView.getTag();
		}
		holder.head.setImageDrawable(
				LoadImageMgr.getInstance().loadDrawble((String)list.get(position).get(flag[0]) , holder.head, 
						LoadImageMgr.getInstance().imageCallBack));
		holder.name.setText( (String)list.get(position).get(flag[1]) );
		holder.call.setText( (String)list.get(position).get(flag[2]) );
		int count = Integer.parseInt( (String)list.get(position).get(flag[3]) );
		
		if(count > 0 )
		{
			holder.unread.setVisibility(View.VISIBLE);
			holder.unread.setText( count + "");
		}else
		{
			holder.unread.setVisibility(View.INVISIBLE);
		}
		
		if( list.get(position).get(flag[5]).equals(PublicInfo.VIP_FLAG_P) )
		{
			holder.headvip.setImageResource(R.drawable.v_l_1);
		}else if(  list.get(position).get(flag[5]).equals(PublicInfo.VIP_FLAG_F))
		{
			holder.headvip.setImageResource(R.drawable.v_l_2);
		}
		
		return convertView;
	}
	

	static class Holder
	{
		ImageView	head;
		TextView 	name;
		TextView		call;
		TextView	 	unread;
		ImageView	headvip;
	}
	
}
