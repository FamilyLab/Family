package com.ze.familydayverpm.adapter;

import java.util.List;
import java.util.Map;

import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
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

public class DialogDetailListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	public static final String flag[] = {
		"head","say","time","item_type","vip"
	};
	
	public static final int 		ids[] = {
		R.id.dialog_detail_me_head,
		R.id.dialog_detail_me_say,
		R.id.dialog_detail_me_time,
		R.id.dialog_detail_me_head_vip
	};
	public static final int 		id_othser[] = {
		R.id.dialog_detail_other_head,
		R.id.dialog_detail_other_say,
		R.id.dialog_detail_other_time,
		R.id.dialog_detail_other_head_vip
		
	};
	private int 		layout;
	private int      layout_type2;
	private Context mContext;
	private final int TYPE_ITEM_0 = 0;
	private final int TYPE_ITEM_1 = 1;
	public DialogDetailListViewAdapter(Context context, List<Map<String, Object>>list) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
		this.layout = R.layout.dialog_detail_item_me;
		layout_type2 = R.layout.dialog_detail_item_other;
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
		
		if( convertView == null )
		{
			holder = new Holder();
			if(getItemViewType(position) == 0)
			{
				// other
				convertView = mInflater.inflate(layout_type2, null);
				holder.head = (ImageView)convertView.findViewById(id_othser[0]);
				holder.name = (TextView)convertView.findViewById(id_othser[1]);
				holder.time	= (TextView)convertView.findViewById(id_othser[2]);
				holder.headvip = (ImageView)convertView.findViewById(id_othser[3]);
			}else
			{
				convertView = mInflater.inflate(layout, null);
				holder.head = (ImageView)convertView.findViewById(ids[0]);
				holder.name = (TextView)convertView.findViewById(ids[1]);
				holder.time	= (TextView)convertView.findViewById(ids[2]);
				holder.headvip = (ImageView)convertView.findViewById(ids[3]);
			}
			convertView.setTag(holder);
		}else {
			holder = (Holder) convertView.getTag();
		}
		holder.head.setImageDrawable(LoadImageMgr.getInstance().loadDrawble((String)list.get(position).get(flag[0]), 
				holder.head, LoadImageMgr.getInstance().imageCallBack));
		holder.name.setText( (String)list.get(position).get(flag[1]) );
		if(( (String)list.get(position).get(flag[2]) ).equals("0") )
		{
			holder.time.setText("发送中");
		}else if(( (String)list.get(position).get(flag[2]) ).equals("-1") )
		{
			holder.time.setText("发送失败");
		}else{
			holder.time.setText( NetHelper.transTime(Long.parseLong( (String)list.get(position).get(flag[2]) ) ) );
		}
		if( list.get(position).get(flag[4])  .equals(PublicInfo.VIP_FLAG_F ))
		{
			holder.headvip.setImageResource(R.drawable.v_l_2);
		}else if( list.get(position).get(flag[4])  .equals(PublicInfo.VIP_FLAG_P )){
			holder.headvip.setImageResource(R.drawable.v_l_1);
		}
		
		return convertView;
	}
	

	static class Holder
	{
		ImageView	head;
		TextView 	name;
		TextView 		time;
		ImageView 	headvip;
	}
	
}
