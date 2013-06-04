package com.ze.familydayverpm.adapter;

import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.commontool.PublicInfo;
import com.ze.familydayverpm.NeedConfirmActivity;
import com.ze.familydayverpm.R;
import com.ze.familydayverpm.R.id;
import com.ze.familydayverpm.userinfo.UserInfoManager;


import android.R.raw;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class NeedConfirmListViewAdapter extends BaseAdapter {
	private LayoutInflater mInflater;
	private List<Map<String, Object>> list;
	public static final String flag[] = {
		"head","name","id","vip"
	};
	
	public static final int 		ids[] = {
		R.id.needconfirm_listview_item_head,
		R.id.needconfirm_listview_item_name,
		R.id.needconfirm_listview_item_confirm,
		R.id.needconfirm_listview_item_cancel,
		R.id.needconfirm_listview_item_head_vip
	};
	private int 		layout;
//	private int      layout_diver;
	private Context mContext;
//	private final int TYPE_ITEM_0 = 0;
//	private final int TYPE_ITEM_1 = 1;
	public NeedConfirmListViewAdapter(Context context, List<Map<String, Object>>list) {
		this.mInflater = LayoutInflater.from(context);
		this.list = list;
		this.layout = R.layout.needconfirm_listview_item;
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
		final int f_pos = position;
		if( convertView == null )
		{
			convertView = mInflater.inflate(layout, null);
			holder = new Holder();
			holder.head = (ImageView)convertView.findViewById(ids[0]);
			holder.name = (TextView)convertView.findViewById(ids[1]);
			holder.agree = (Button)convertView.findViewById(ids[2]);
			holder.cancel	= (Button)convertView.findViewById(ids[3]);
			holder.vip     = (ImageView)convertView.findViewById(ids[4]);
			holder.agree.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					agreeRequest(f_pos);
				}
			});
			holder.cancel.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					cancelRequest(f_pos);
				}
			});
			convertView.setTag(holder);
		}else {
			holder = (Holder) convertView.getTag();
		}
		holder.head.setImageDrawable(LoadImageMgr.getInstance().loadDrawble(
				(String)list.get(position).get(flag[0]), holder.head, LoadImageMgr.getInstance().imageCallBack));
		holder.name.setText( (String)list.get(position).get(flag[1]) );
		if( list.get(position).get(flag[3]).equals(PublicInfo.VIP_FLAG_P)){
			holder.vip.setImageResource(R.drawable.v_l_1);
		}else if( list.get(position).get(flag[3]).equals(PublicInfo.VIP_FLAG_F) )
		{
			holder.vip.setImageResource(R.drawable.v_l_2);
		}
		return convertView;
	}
	
	public OnClickListener onClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			
		}
	};
	static class Holder
	{
		ImageView	head;
		TextView 	name;
		Button 		cancel;
		Button 		agree;
		ImageView vip;
	}
	private ProgressDialog mProgressDialog;
	
	public void agreeRequest(final int pos)
	{
		new AsyncTask<String, String, String> (){
			protected void onPreExecute() {
				if( mProgressDialog == null )
				{
					mProgressDialog = new ProgressDialog(mContext);
					mProgressDialog.setMessage(mContext.getResources().getString( R.string.dialog_msg_load) );
				}
				mProgressDialog.show();
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String respon = NetHelper.getResponByHttpClient(mContext.getResources().getString(R.string.http_agree_family),
						(String)list.get(pos).get(flag[2]),
						"",		//分组信息？
						UserInfoManager.getInstance((Activity)mContext).getItem("m_auth").getValue() );
				return respon;
			}
			protected void onPostExecute(String result) {
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
				try {
					JSONObject object = new JSONObject(result);
					if ( object.getInt("error") == 0 ) {
						Toast.makeText(mContext, 
								String.format(mContext.getResources().getString(R.string.tips_msg_agreefamily), (String)list.get(pos).get(flag[1])),
								Toast.LENGTH_SHORT).show();
						list.remove(pos);
						((NeedConfirmActivity)mContext).onConfirmed();
						notifyDataSetChanged();
					}
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
			};
		}.execute("");
	}

	public void cancelRequest(final int pos)
	{
		new AsyncTask<String, String, String> (){
			protected void onPreExecute() {
				if( mProgressDialog == null )
				{
					mProgressDialog = new ProgressDialog(mContext);
					mProgressDialog.setMessage(mContext.getResources().getString( R.string.dialog_msg_load) );
				}
				mProgressDialog.show();
			};
			@Override
			protected String doInBackground(String... params) {
				// TODO Auto-generated method stub
				String respon = NetHelper.getResponByHttpClient(mContext.getResources().getString(R.string.http_cancle_family),
						(String)list.get(pos).get(flag[2]),
						UserInfoManager.getInstance((Activity)mContext).getItem("m_auth").getValue() );
				return respon;
			}
			protected void onPostExecute(String result) {
				if (mProgressDialog.isShowing()) {
					mProgressDialog.hide();
				}
				try {
					JSONObject object = new JSONObject(result);
					if ( object.getInt("error") == 0 ) {
						Toast.makeText(mContext, 
								String.format(mContext.getResources().getString(R.string.tips_msg_cancelfamily), (String)list.get(pos).get(flag[1])),
								Toast.LENGTH_SHORT).show();
						list.remove(pos);
						((NeedConfirmActivity)mContext).onConfirmed();
						notifyDataSetChanged();
					}
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
			};
		}.execute("");
	}
}
