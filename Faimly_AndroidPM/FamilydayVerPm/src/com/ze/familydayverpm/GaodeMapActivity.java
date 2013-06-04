package com.ze.familydayverpm;


import com.amap.api.maps.AMap;
import com.amap.api.maps.CameraUpdate;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.SupportMapFragment;
import com.amap.api.maps.AMap.OnCameraChangeListener;
import com.amap.api.maps.model.BitmapDescriptorFactory;
import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.LatLngBounds;
import com.amap.api.maps.model.Marker;
import com.amap.api.maps.model.MarkerOptions;
import com.amap.api.maps.model.VisibleRegion;
import com.umeng.analytics.MobclickAgent;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
public class GaodeMapActivity extends FragmentActivity {
	// 存放overlayitem 
//	int 	lat ;
//	int lng;
//	
	double 	lat ;
	double 	 lng;
	
	AMap aMap;
	private Marker defaultMarker;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.gaode_fragment);
		if ( aMap == null ) {
			aMap = ((SupportMapFragment)getSupportFragmentManager().findFragmentById(R.id.gaode_map)).getMap();
		}
		
		lat = getIntent().getDoubleExtra("lat", (double) (39.915f*1E6));
		lng = getIntent().getDoubleExtra("lng", (double) (116.404f*1E6));
		setUpMap();
	}
	private void setUpMap() {
		// 对地图添加一个marker
		LatLng pos = new LatLng(lat, lng);
		defaultMarker = aMap.addMarker(new MarkerOptions()
				.position(pos)
				.icon(BitmapDescriptorFactory.defaultMarker()));
		aMap.getUiSettings().setZoomControlsEnabled(true);// 设置系统默认缩放按钮可见
//		aMap.get
		CameraPosition cameraPosition = new CameraPosition.Builder().zoom(18f).target(pos).build();
		aMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
//		aMap.animateCamera(CameraUpdateFactory.zoomTo(0.3f));
		//		aMap.setOnMarkerClickListener(this);// 对marker添加点击监听器
//		aMap.set
	}
	@Override
	protected void onDestroy(){
	        super.onDestroy();
	}
	@Override
	protected void onPause(){
	        super.onPause();
	        MobclickAgent.onPause(this);
	}
	@Override
	protected void onResume(){
	        super.onResume();
	        MobclickAgent.onResume(this);
	}

}
