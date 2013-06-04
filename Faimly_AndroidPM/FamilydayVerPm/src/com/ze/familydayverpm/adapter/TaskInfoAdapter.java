package com.ze.familydayverpm.adapter;

import java.util.List;
import java.util.Map;

import com.ze.commontool.LoadImageMgr;



import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class TaskInfoAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	private int layoutID;
	private String flag[];
	private int itemIDs[];
	private Context mContext;
	public TaskInfoAdapter(Context context, List<Map<String, Object>>list, int layoutID, String flags[], int itemIDs[]) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
		this.layoutID = layoutID;
		this.flag = flags;
		this.itemIDs = itemIDs;
		mContext = context;
	}
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return list.size();
	}

	@Override
	public Object getItem(int arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		ViewHolder holder;
		if(convertView == null) {
			convertView = mInflater.inflate(layoutID, null);
			holder = new ViewHolder();
			holder.btn_head = (ImageView)convertView.findViewById(itemIDs[0]);
			holder.tv_title = (TextView)convertView.findViewById(itemIDs[1]);
			holder.tv_context = (TextView)convertView.findViewById(itemIDs[2]);
			holder.tv_finish = (TextView)convertView.findViewById(itemIDs[3]);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder)convertView.getTag();
		}
		
		//holder.btn_head.setBackgroundDrawable((Drawable)list.get(position).get(flag[0]));
		holder.btn_head.setImageDrawable(
				LoadImageMgr.getInstance().loadDrawble((String)list.get(position).get(flag[0]), holder.btn_head,
				LoadImageMgr.getInstance().imageCallBack));
		holder.tv_title.setText((String)list.get(position).get(flag[1]) );
		holder.tv_context.setText((String)list.get(position).get(flag[2]));
		if ( 0 == (Integer)list.get(position).get(flag[3]) ) {
			holder.tv_finish.setText("未完成");
		}else {
			holder.tv_finish.setText("完成");
		}
		
		return convertView;
	}
	
	static class ViewHolder {
		ImageView btn_head;
		TextView tv_title;
		TextView tv_context;
		TextView tv_finish;
		
		
		
		
	}

}
