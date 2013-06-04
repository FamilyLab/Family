package com.ze.familydayverpm.adapter;

import java.util.List;
import java.util.Map;

import com.ze.familydayverpm.R;


import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class MainListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	private String flag[];
	private Context mContext;
//	private final int TYPE_ITEM_0 = 0;
//	private final int TYPE_ITEM_1 = 1;
	public MainListViewAdapter(Context context, List<Map<String, Object>>list) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
//		this.flag = flags;
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
		return list.size();
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
			convertView = mInflater.inflate(R.layout.main_listview_item, null);
			holder = new Holder();
			holder.tv = (TextView)convertView.findViewById(R.id.main_listview_tv);
			holder.count = (TextView)convertView.findViewById(R.id.main_listview_count);
			convertView.setTag(holder);
		}else {
			holder = (Holder) convertView.getTag();
		}
		if( position % 2 == 0 )
		{
			holder.tv.setBackgroundResource(R.drawable.ver_pm_r23_c1);
		}else
		{
			holder.tv.setBackgroundResource(R.drawable.ver_pm_r27_c2);
		}
		if( position == list.size() - 1 )
		{
			holder.tv.setBackgroundResource(R.drawable.red_block_a);
		}
		
		holder.tv.setCompoundDrawablesWithIntrinsicBounds(getTextLeftIcon( position ), null, getTextRightIcon(position),null );
		holder.tv.setText( (String)list.get(position).get("label") );
		int count = (Integer)list.get(position).get("count");
		holder.count.setText( count > 0 ? count + ""  :  "" );
		
		return convertView;
	}
	
	private Drawable getTextRightIcon( int postion)
	{
		int id = 0;
		if  ( ( (Integer)list.get(postion).get("count") ) > 0 ){
			id = R.drawable.arrow_b;
		}else
		{
			id = R.drawable.arrow_a;
		}
		Drawable drawable = mContext.getResources().getDrawable(id);
//		drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
		return drawable;
	}
	
	private Drawable getTextLeftIcon( int postion)
	{
		int id = 0;
		switch (postion) {
		case 0:
			id = R.drawable.ver_pm_r35_c6;
			break;
		case 1:
			id = R.drawable.ver_pm_r37_c19;
			break;
		case 2:
			id = R.drawable.ver_pm_r36_c24;
			break;
		case 3:
			id = R.drawable.ver_pm_r38_c28;
			break;
		case 4:
			id = R.drawable.ver_pm_r45_c9;
			break;
		case 5:
			id = R.drawable.ver_pm_r47_c26;
			break;
		case 6:
			id = R.drawable.zone_icon;
			break;
		case 7:
			id = R.drawable.ver_pm_r53_c8;
			break;
		case 8:
			id = R.drawable.ver_pm_r78_c19;
			break;
		default:
			return null;
		}
		Drawable drawable = mContext.getResources().getDrawable(id);
//		drawable.setBounds(drawable.getBounds());
		return drawable;
	}
	static class Holder
	{
		TextView 	tv;
		TextView 	count;
	}
}
