package com.ze.commontool;

import java.util.ArrayList;
import java.util.Map;

import com.ze.familydayverpm.R;

import android.app.Activity;
import android.graphics.drawable.BitmapDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.AbsListView.LayoutParams;
import android.widget.AdapterView.OnItemClickListener;

public class PullDownView {
	private PopupWindow 	popupWindow 		= null;
	private View 			parentView			= null;
	private Activity 		activity			= null;
	private ListView		listView			= null;
	private BaseAdapter		listaAdapter		= null;
	private ArrayList<Map<String, Object>> data = null;
	
	private int[] 			location			= new int[2];
	private int height;
	private int width;
	private DataHandler 	dataHandler 		= null;
	public PullDownView(Activity _Activity, View _parentView, 
			View _showLocationView,ArrayList<Map<String, Object>> _data, DataHandler _DataHandler){
		activity 		= _Activity;
		parentView 		= _parentView;
		_showLocationView.getLocationOnScreen(location);
		width 			= _showLocationView.getWidth();
		height 			= _showLocationView.getHeight();
		data			= _data;
		setDataHandler(_DataHandler);
		initPopuWindow();
	}
	public void initPopuWindow()
	{
		View 	window 		= (View)activity.getLayoutInflater().inflate(R.layout.pulldown_layout, null);
		listView			= (ListView)window.findViewById(R.id.pulldown_listview);
		listaAdapter		= new PullDownListAdapter(activity, data);
		listView.setAdapter(listaAdapter);
		popupWindow 		= new PopupWindow(window, width, android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,true);
		height = popupWindow.getHeight();
		popupWindow.setOutsideTouchable(true);
		popupWindow.setBackgroundDrawable(new BitmapDrawable());
		popupWindow.setOnDismissListener(new OnDismissListener() {
			
			@Override
			public void onDismiss() {
				// TODO Auto-generated method stub
				dataHandler.onPullDownViewDissmiss();
			}
		});
		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				// TODO Auto-generated method stub
				dataHandler.selected(arg2);		// 接口实现选中后的处理
				popupWindow.dismiss();
			}
			
		});
	}
	public void setDataHandler(DataHandler dataHandler) {
		this.dataHandler = dataHandler;
	}
	public interface DataHandler
	{
		public Object selected(int index);
		public void 	onPullDownViewDissmiss();
	}
	public void show(View view)
	{
		if(view == null)
		{
			popupWindow.showAtLocation(parentView, Gravity.NO_GRAVITY, location[0], location[1] + height);
		}else
		{
			popupWindow.showAsDropDown(view);
		}
		//popupWindow.showAsDropDown(parentView, location[0], location[1] + height);
		
	}
	static class PullDownListAdapter extends BaseAdapter{
		ArrayList<Map<String, Object>> data = new ArrayList<Map<String,Object>>();
		Activity activity = null;
		public PullDownListAdapter(Activity _Activity,ArrayList<Map<String, Object>> _data)
		{
			activity  = _Activity;
			data		= _data;
		}
		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return data.size();
		}

		@Override
		public Object getItem(int position) {
			// TODO Auto-generated method stub
			return data.get(position);
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			Holder holder = null;
			if (convertView == null) {
				convertView = activity.getLayoutInflater().inflate(R.layout.pull_listview_item, null);
				holder = new Holder();
				holder.tv = (TextView)convertView.findViewById(R.id.pullview_item_name);
				holder.pullview_item_arrow = (Button)convertView.findViewById(R.id.pullview_item_arrow);
				convertView.setTag(holder);
			}else {
				holder = (Holder)convertView.getTag();
			}
			if(data.get(position).get("arrow").equals("1"))
			{
				holder.pullview_item_arrow.setVisibility(View.VISIBLE);
				holder.tv.setVisibility(View.GONE);
			}else
			{
				holder.pullview_item_arrow.setVisibility(View.GONE);
				holder.tv.setVisibility(View.VISIBLE);
				holder.tv.setText((String)data.get(position).get("item"));
			}
			return convertView;
		}
		
		static class Holder
		{
			TextView tv;
			Button 	pullview_item_arrow;
		}
	}
}
