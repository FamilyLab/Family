package com.ze.familydayverpm.adapter;

import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ze.familydayverpm.SpaceDetailActivity;
import com.ze.familydayverpm.fragment.ActivityFragment;
import com.ze.familydayverpm.fragment.BlogFragment;
import com.ze.familydayverpm.fragment.FragmentFactory;
import com.ze.familydayverpm.fragment.PicFragment;
import com.ze.familydayverpm.fragment.RelativeLayoutImp;
import com.ze.familydayverpm.fragment.VideoFragment;

import android.content.Context;
import android.os.Parcelable;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.Toast;

/**
 * @author frankiewei
 * 相册的适配器.
 */
public class SpaceViewPagerAdapter extends PagerAdapter {
	/**
	 * 上下文
	 */
	private Context mContext;
	
	/**
	 * 数据源,这里是JSONARRAY
	 */
	private JSONArray mJsonArray;
	
	/**
	 * Hashmap保存相片的位置以及ItemView.
	 */
	public HashMap<Integer, RelativeLayoutImp> mHashMap;
	
//	private List<PicFragment>
	public SpaceViewPagerAdapter(Context context,JSONArray arrays) {
		this.mContext = context;
		this.mJsonArray = arrays;
		mHashMap = new HashMap<Integer, RelativeLayoutImp>();
	}
	public LinearLayout getMapViewLinearLayout(int position)
	{
		return ((ActivityFragment)mHashMap.get(position)).mMapViewLayout;
	}
	//这里进行回收，当我们左右滑动的时候，会把早期的图片回收掉.
	@Override
	public void destroyItem(View container, int position, Object object) {
//		PicFragment itemView = (PicFragment)object;
//		itemView.recycle();
		((ViewPager)container).removeView((View)mHashMap.get(position));
		mHashMap.remove(position);
		Log.v("test", "destroyItem:" + position);
	}
	
	@Override
	public void finishUpdate(View view) {

	}

	//这里返回相册有多少条,和BaseAdapter一样.
	@Override
	public int getCount() {
		return mJsonArray== null ? 0 : mJsonArray.length();
	}
	
	//这里就是初始化ViewPagerItemView.如果ViewPagerItemView已经存在,
	//重新reload，不存在new一个并且填充数据.
	@Override
	public Object instantiateItem(View container, int position) {	
		RelativeLayoutImp itemView = null ;
		if(mHashMap.containsKey(position)){
			itemView = mHashMap.get(position);
			Log.v("test", "containsKey:" + position);
			itemView.reload();
		}else{
			try {
				JSONObject dataObj = (JSONObject) mJsonArray.get(position);
				String type = null;
				if(!dataObj.isNull("type"))
				{
					type = dataObj.getString("type");
				}
				if (type.equals("photoid") || type.equals("rephotoid") ) {
					itemView = new PicFragment(mContext);
				}else if (type.equals("blogid") || type.equals("reblogid") ) {
					itemView = new BlogFragment(mContext);
				}else if (type.equals("eventid") || type.equals("reeventid")) {
					itemView = new ActivityFragment(mContext);
				}else if (type.equals(SpaceDetailActivity.DETAIL_VIDEO) || type.equals(SpaceDetailActivity.DETAIL_REVIDEO)) {
					itemView = new VideoFragment(mContext);
				}
				itemView.setData(dataObj);
				
			} catch (JSONException e) {
				e.printStackTrace();
			}
			mHashMap.put(position, itemView);
			((ViewPager) container).addView((View)itemView);
		}
		
		return itemView;
	}
	@Override
	public boolean isViewFromObject(View view, Object object) {
		return view == object;
	}

	@Override
	public void restoreState(Parcelable arg0, ClassLoader arg1) {
		
	}

	@Override
	public Parcelable saveState() {
		return null;
	}

	@Override
	public void startUpdate(View view) {

	}
	public void notifyListView( int index )
	{
		mHashMap.get(index).reload();
	}
}
