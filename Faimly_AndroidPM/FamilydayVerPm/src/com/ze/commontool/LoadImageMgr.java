package com.ze.commontool;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.ref.SoftReference;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;

public class LoadImageMgr {
//	private Context 	mContext;
	public final static String 		PIC_CACHE_PATH = Environment.getExternalStorageDirectory() + "/familydayVerPm/pic_cache/";
	private static LoadImageMgr instance = null;
	private ExecutorService executorService = Executors.newFixedThreadPool(5);
	public Map<String, SoftReference<Drawable>> imageCache = new HashMap<String, SoftReference<Drawable>>();
	private LoadImageMgr(/*Context context*/)
	{
		//mContext = context;
		File dir = new File(PIC_CACHE_PATH);
		if ( !dir.exists()) {
			dir.mkdirs();
		}
	}
	public static LoadImageMgr getInstance()
	{
		if (instance == null) {
			instance = new LoadImageMgr();
		}
		return instance;
	}
	final Handler imageHandler = new Handler()
	{
		public void handleMessage(android.os.Message msg) {
			Map<String, Object> dataMap = (Map<String, Object>)msg.obj;
			ImageView view = (ImageView)dataMap.get("view");
			//int type = (Integer)dataMap.get("type");
			Drawable drawable ;
		
			drawable = (Drawable)dataMap.get("drawable");
			view.setImageDrawable(drawable);
			
			
			//view.setTag(drawable);
			
		};
	};
	public void removeImageCache(String urlString)
	{
		if (imageCache.containsKey(urlString)) {
			imageCache.remove(urlString);
		}
			File cacheFile = new File( PIC_CACHE_PATH + formatString( urlString ) );
			if ( cacheFile.exists() ) {
				cacheFile.delete();
			}
	}
	public Drawable loadDrawble(final String imageUrl, final ImageView view ,final ImageCallBack callBack)
	{
		final Handler  handler =  new Handler()
		 {
			public void handleMessage(Message msg) {
				if( msg.what == 0 )
				{
					callBack.setImage((Drawable) msg.obj, imageUrl, view);
				}else if( msg.what == 1 )
				{
					if ( msg.obj == null ) {
						netLoadImage(imageUrl, this);
					}else
					{
						callBack.setImage((Drawable) msg.obj, imageUrl, view);
					}
				}
				
			}; 
		 };
		 
		view.setTag(imageUrl);
		//System.out.println("loadDrawble---->" + imageUrl);
		Drawable drawable = null;
		//Message msg = null;
		//Map<String, Object> dataMap = null;
		 if (imageCache.containsKey(imageUrl)) {
	            SoftReference<Drawable> softReference = imageCache.get(imageUrl);
	            drawable = softReference != null ? softReference.get() : null;
	            if ( null == drawable ) {
	            	imageCache.remove(imageUrl);
	            	loadDrawble(imageUrl,view,callBack);
				}
	            return drawable;
		 }else
		 {
//			 netLoadImage(imageUrl,handler);
			findLocalImage(imageUrl, handler); 
		 }
		return null;
	}
	public void findLocalImage(final String imageUrl,final Handler handler)
	{
		executorService.submit(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				Drawable drawable = null;
				FileInputStream inputStream = null;
				ObjectInputStream objectInputStream = null;
				try {
					File cacheFile = new File( PIC_CACHE_PATH + formatString( imageUrl ) );
					if ( cacheFile.exists() ) {
						inputStream = new FileInputStream(cacheFile);
						objectInputStream = new ObjectInputStream(inputStream);
						byte[] buffer = (byte[]) objectInputStream.readObject();
						//objectInputStream.read(buffer);
						drawable = ByteArray2Drawable( buffer);
					}
//					drawable = Drawable.createFromStream(new URL(imageUrl).openStream(), "png");
					if(drawable != null)
					{
						imageCache.put(imageUrl, new SoftReference<Drawable>(drawable));
						//System.out.println("loadDrawble---->" + imageUrl + "<load>");
						
					}
					handler.sendMessage(handler.obtainMessage(1, drawable));
					
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				} finally
				{
					try {
						if (inputStream != null ) {
							inputStream.close();
							inputStream = null;
						}
						if (objectInputStream != null ) {
							objectInputStream.close();
							objectInputStream = null;
						}
					} catch (Exception e2) {
						// TODO: handle exception
					}
				}
			
			}
		});
	}
	public void netLoadImage(final String imageUrl,final Handler handler)
	{
		executorService.submit(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				Drawable drawable = null;
				FileOutputStream outputStream = null;
				ObjectOutputStream	objectOutputStream = null ;
				try {
					drawable = Drawable.createFromStream(new URL(imageUrl).openStream(), "png");
					if(drawable != null)
					{
						imageCache.put(imageUrl, new SoftReference<Drawable>(drawable));
						
						//System.out.println("loadDrawble---->" + imageUrl + "<load>");
						handler.sendMessage(handler.obtainMessage(0, drawable));
						File drawableFile = new File(PIC_CACHE_PATH + formatString( imageUrl ) );
						if (drawableFile.exists()) {
							drawableFile.delete();
						}
						drawableFile.createNewFile();
						outputStream = new FileOutputStream(drawableFile);
						objectOutputStream = new ObjectOutputStream(outputStream);
						objectOutputStream.writeObject( drawable2ByteArray(drawable) );
//						BitmapDrawable bitmapDrawable = (BitmapDrawable)drawable;
//						Bitmap bitmap = bitmapDrawable.getBitmap();
//						bitmap.compress(CompressFormat.JPEG, 75, outputStream);
					}
					
					
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}finally {
					try {
						if (objectOutputStream != null ) {
							objectOutputStream.close();
							objectOutputStream = null;
						}
						if (outputStream != null ) {
							outputStream.flush();
							outputStream.close();
							outputStream = null;
						}
						
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
				}
			
			}
		});
	}
	public byte[] drawable2ByteArray(final Drawable drawable)
	{
		BitmapDrawable bitmapDrawable = (BitmapDrawable)drawable;
		Bitmap bitmap = bitmapDrawable.getBitmap();
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		bitmap.compress(CompressFormat.JPEG, 75, baos);
		byte[] drawableArray = baos.toByteArray();
		try {
			baos.close();
			baos = null;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if ( baos != null ) {
					baos.close();
					baos = null;
				}
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		
		return drawableArray;
	}
	public Drawable ByteArray2Drawable(byte[] drawableArray)
	{
		Bitmap bitmap = BitmapFactory.decodeByteArray(drawableArray, 0, drawableArray.length);
		return new BitmapDrawable(bitmap);
	}
	public ImageCallBack imageCallBack = new ImageCallBack() {
		
		@Override
		public void setImage(Drawable d, String url, ImageView view) {
			// TODO Auto-generated method stub
			if( /*mActiveImages.contains(view) &&*/ url.equals((String)view.getTag()))
			{
				view.setImageDrawable(d);
			}
		}
	};
	public String clearTail(final String from )
	{
		String s_notTail = null;
		int find = from.indexOf("!");
		if( find != -1 )
		{
			s_notTail = from.substring(0, find+1);
		}
		return s_notTail;
	}
	public String formatString( final String from )
	{
		String formatString = new String(from);
		String[] strs = formatString.split("/");
		formatString = "";
		for( int i=0; i<strs.length; i++ )
		{
			formatString = formatString + strs[i];
		}
		formatString = formatString.substring(formatString.lastIndexOf("com"));
		return formatString;
	}
	public interface ImageCallBack
	{
		public void setImage(Drawable d,String url, ImageView view);
	}
	public String getMiddleHead( String avatar )
	{
		return avatar.replace("small", "middle");
	}
	
	public String getBigHead( String avatar )
	{
		return avatar.replace("small", "big");
	}
	public String getSpacePagePic( String pic )
	{
		int pos = pic.indexOf("!");
		if ( pos != -1 ) {
			return pic.substring(0, pos+1) + PublicInfo.SPACE_PAGE_PIC;
		}else
		{
			return pic;
		}
	}
}
