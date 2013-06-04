package com.ze.model;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.StreamCorruptedException;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONObject;

import android.os.Environment;
import android.util.Log;

public class ModelDataMgr {
//	public static final int 			MAX_LIST = 10;
	public static final int 			MAX_SD_LIST = 100;
	public static final String 		PHOTO_DIR = "photodata/";
	public static final String 		SPACE_DIR = "spacedata/";
	public static final String 		SPACE_FILE_NAME	=  "spaceidname";
	public static final String 		BLOG_DIR = "blogdata/";
	public static final String 		ACTIVITY_DIR = "activitydata/";
	public static final String 		VIDEO_DIR = "videodata/";
	
	public static final String 		PHOTO_LOVE_DIR = "photo_love/";
	
	public static final String 		PHOTO_ID_LIST = "photodata/pic_id_list";
	public static final String 		BLOG_ID_LIST = "blogdata/blog_id_list";
	public static final String 		ACTIVITY_ID_LIST = "activitydata/activity_id_list";
	public static final String 		VIDEO_ID_LIST = "activitydata/activity_id_list";
	
	public static final String 		PHOTO_LOVE_IDLIST = "photo_love/lovelist";
	public static final String 		 PHOTO_RESPON= "photodata/response";
	public static final String 		 PHOTO_LOVE_RESPON= "photodata/loveresponse";
	
	public final static String 		ROOT_PATH = Environment.getExternalStorageDirectory() + "/familydayVerPm/";
	public final static String 		ICON_TEMP = "familyicon_temp.jpg";
	// 添加用户专属文件夹，用户唯一标识的id在登录时没有得到
//	public ArrayList<JSONObject> 					idPicList;
//	public ArrayList<JSONObject> 					idBlogList;
//	public ArrayList<JSONObject> 					idActivityList;
//	public ArrayList<JSONObject>   				idSpaceList;
	public ArrayList<DataModel> 					idPicList;
	public ArrayList<DataModel> 					idBlogList;
	public ArrayList<DataModel> 					idActivityList;
	public ArrayList<DataModel> 					idVideoList;
	
	public ArrayList<DataModel> 					idPhotoLoveList;
	
	
	public ArrayList<DataModel>   				idSpaceList;
	public static final int MAX_COUNT = 100;
	public SpaceModel									spaceJsonArrayString;
	
	public String 												PhotoResponse;
	private ModelDataMgr()
	{
//		idPicList = new ArrayList<String>();
		File file = new File(ROOT_PATH);
		if ( !file.exists() ) {
			file.mkdirs();
		}
		file = new File(ROOT_PATH + PHOTO_DIR );
		if ( !file.exists() ) {
			file.mkdirs();
		}
		file = new File(ROOT_PATH + BLOG_DIR );
		if ( !file.exists() ) {
			file.mkdirs();
		}
		file = new File(ROOT_PATH + ACTIVITY_DIR );
		if ( !file.exists() ) {
			file.mkdirs();
		}
		file = new File(ROOT_PATH + VIDEO_DIR );
		if ( !file.exists() ) {
			file.mkdirs();
		}
		file = new File(ROOT_PATH + SPACE_DIR );
		if ( !file.exists() ) {
			file.mkdirs();
		}
		
		file = new File(ROOT_PATH + PHOTO_LOVE_DIR );
		if ( !file.exists() ) {
			file.mkdirs();
		}
		
//		if( idPicList == null )
//		{
		
			idPhotoLoveList = new ArrayList<DataModel>();
		 
			idPicList = new ArrayList<DataModel>();
			idBlogList = new ArrayList<DataModel>();
			idActivityList = new ArrayList<DataModel>();
			idVideoList = new ArrayList<DataModel>();
			spaceJsonArrayString = new SpaceModel();
			spaceJsonArrayString.id = "spaceidname";
//		}
		ArrayList<DataModel> arrayList;
		
		 arrayList = getIdList(PHOTO_ID_LIST);
		if( arrayList != null )
		{
			idPicList.addAll(arrayList);
		}
		arrayList = getIdList(BLOG_ID_LIST);
		if( arrayList != null )
		{
			idBlogList.addAll(arrayList);
		}
		arrayList = getIdList(ACTIVITY_ID_LIST);
		if( arrayList != null )
		{
			idActivityList.addAll(arrayList);
		}
		arrayList = getIdList(VIDEO_ID_LIST);
		if( arrayList != null )
		{
			idVideoList.addAll(arrayList);
		}
		arrayList = getIdList(PHOTO_LOVE_IDLIST);
		if( arrayList != null )
		{
			idPhotoLoveList.addAll(arrayList);
		}
	}
	public void savePhotoListResponse( String respon, int whichDir )
	{
		if( respon == null && respon.equals("") )
		{
			return;
		}
		FileOutputStream outputStream = null;
		ObjectOutputStream	objectOutputStream = null ;
		try {
//			File dirFile = new File(ROOT_PATH);
			String str_file = null;
			if (whichDir == 1) {
				str_file = ROOT_PATH  + PHOTO_RESPON;
			}else
			{
				str_file = ROOT_PATH  + PHOTO_LOVE_RESPON;
			}
			File listFile = new File(str_file );
			if (!listFile.exists()) {
				listFile.createNewFile();
			}else {
				listFile.delete();
				listFile.createNewFile();
			}
			outputStream = new FileOutputStream(listFile);
			objectOutputStream = new ObjectOutputStream(outputStream);
			objectOutputStream.writeObject(respon);
		}catch (Exception e) {
			// TODO: handle exception
		}
	}
	public String loadPhotoListResponse(int whichDir )
	{
		FileInputStream inputStream = null;
		ObjectInputStream objectInputStream = null;
		try {
			String str_file = null;
			if (whichDir == 1) {
				str_file = ROOT_PATH  + PHOTO_RESPON;
			}else
			{
				str_file = ROOT_PATH  + PHOTO_LOVE_RESPON;
			}
			File idListFile = new File(str_file );
			if( ! idListFile.exists() )
			{
				return null;
			}else
			{
				inputStream = new FileInputStream(idListFile);
				objectInputStream = new ObjectInputStream(inputStream);
				return (String) objectInputStream.readObject();
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (StreamCorruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally
		{
			try {
				if ( inputStream != null ) {
					inputStream.close();
				}
				inputStream = null;
				if (objectInputStream != null ) {
					objectInputStream.close();
				}
				objectInputStream = null;
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		return null;
	}
	public ArrayList<DataModel> getIdList(String filename)
	{
		FileInputStream inputStream = null;
		ObjectInputStream objectInputStream = null;
		try {
			File idListFile = new File(ROOT_PATH  + filename );
			if( ! idListFile.exists() )
			{
				return null;
			}else
			{
				inputStream = new FileInputStream(idListFile);
				objectInputStream = new ObjectInputStream(inputStream);
				ArrayList<DataModel> idList;
				idList = (ArrayList<DataModel>) objectInputStream.readObject();
				return idList;
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (StreamCorruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally
		{
			try {
				if ( inputStream != null ) {
					inputStream.close();
				}
				inputStream = null;
				if (objectInputStream != null ) {
					objectInputStream.close();
				}
				objectInputStream = null;
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		return null;
	}
	// save space 
	public void saveSpaceList(ArrayList<DataModel> list,String tagid)
	{
		FileOutputStream outputStream = null;
		ObjectOutputStream	objectOutputStream = null ;
		try {
//			File dirFile = new File(ROOT_PATH);
			File listFile = new File(ROOT_PATH  + SPACE_DIR + tagid );
			if (!listFile.exists()) {
				listFile.createNewFile();
			}else {
				listFile.delete();
				listFile.createNewFile();
			}
			outputStream = new FileOutputStream(listFile);
			objectOutputStream = new ObjectOutputStream(outputStream);
			objectOutputStream.writeObject(list);
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			try {
			if ( outputStream != null ) {
					outputStream.close();
				} 
				outputStream = null ;
			
			if ( objectOutputStream != null ) {
				objectOutputStream.close();
			}
			objectOutputStream = null;
			}catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}
	// space id list
	public ArrayList<DataModel> getSpaceIdList(String tagid)
	{
		FileInputStream inputStream = null;
		ObjectInputStream objectInputStream = null;
		try {
			File idListFile = new File(ROOT_PATH  + SPACE_DIR + tagid );
			if( ! idListFile.exists() )
			{
				return null;
			}else
			{
				inputStream = new FileInputStream(idListFile);
				objectInputStream = new ObjectInputStream(inputStream);
				ArrayList<DataModel> idList;
				idList = (ArrayList<DataModel>) objectInputStream.readObject();
				return idList;
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (StreamCorruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally
		{
			try {
				if ( inputStream != null ) {
					inputStream.close();
				}
				inputStream = null;
				if (objectInputStream != null ) {
					objectInputStream.close();
				}
				objectInputStream = null;
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		return null;
	}
	/*
	public ArrayList<JSONObject> getIdPicList()
	{
		FileInputStream inputStream = null;
		ObjectInputStream objectInputStream = null;
		try {
			File idListFile = new File(ROOT_PATH +PHOTO_DIR + PHOTO_ID_LIST );
			if( ! idListFile.exists() )
			{
				return null;
			}else
			{
				inputStream = new FileInputStream(idListFile);
				objectInputStream = new ObjectInputStream(inputStream);
				idPicList = (ArrayList<JSONObject>) objectInputStream.readObject();
				return idPicList;
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (StreamCorruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally
		{
			try {
				if ( inputStream != null ) {
					inputStream.close();
				}
				inputStream = null;
				if (objectInputStream != null ) {
					objectInputStream.close();
				}
				objectInputStream = null;
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		return null;
	}
	*/
	public static ModelDataMgr instance;
	public static ModelDataMgr getInstance()
	{
		if ( instance == null ) {
			instance = new ModelDataMgr();
		}
		return instance;
	}
	public void clear()
	{
		File dirFile = new File(ROOT_PATH + PHOTO_DIR );
		dirFile.delete();
		dirFile = new File(ROOT_PATH + SPACE_DIR );
		dirFile.delete();
		dirFile = new File(ROOT_PATH + BLOG_DIR );
		dirFile.delete();
		dirFile = new File(ROOT_PATH + ACTIVITY_DIR );
		dirFile.delete();
		dirFile = new File(ROOT_PATH + VIDEO_DIR );
		dirFile.delete();
		dirFile = new File(ROOT_PATH + PHOTO_LOVE_DIR );
		dirFile.delete();
	}
	public Object getModel(String modelId,String dirname)
	{
		FileInputStream inputStream = null;
		ObjectInputStream objectInputStream = null;
		try {
			File photoDirFile = new File(ROOT_PATH +dirname );
			if( ! photoDirFile.exists() )
			{
				return null;
			}
			String child_files[] = photoDirFile.list();
			for (int i = 0; i < child_files.length; i++) {
				if (modelId.equals(child_files[i])) {
						inputStream = new FileInputStream(ROOT_PATH +dirname  + modelId);
						objectInputStream = new ObjectInputStream(inputStream);
						return  objectInputStream.readObject();
				}
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (StreamCorruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally
		{
			try {
				if ( inputStream != null ) {
					inputStream.close();
				}
				inputStream = null;
				if (objectInputStream != null ) {
					objectInputStream.close();
				}
				objectInputStream = null;
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		return null;
	}

	/*
	public PhotoModel getPhotoModel(String modelId)
	{
		FileInputStream inputStream = null;
		ObjectInputStream objectInputStream = null;
		try {
			File photoDirFile = new File(ROOT_PATH +PHOTO_DIR );
			if( ! photoDirFile.exists() )
			{
				return null;
			}
			String child_files[] = photoDirFile.list();
			for (int i = 0; i < child_files.length; i++) {
				if (modelId.equals(child_files[i])) {
						inputStream = new FileInputStream(ROOT_PATH +PHOTO_DIR  + modelId);
						objectInputStream = new ObjectInputStream(inputStream);
						return (PhotoModel) objectInputStream.readObject();
				}
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (StreamCorruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally
		{
			try {
				if ( inputStream != null ) {
					inputStream.close();
				}
				inputStream = null;
				if (objectInputStream != null ) {
					objectInputStream.close();
				}
				objectInputStream = null;
			} catch (Exception e2) {
				// TODO: handle exception
			}
			
		}
		return null;
	}
*/
	
	public void saveIdList(ArrayList<DataModel> list,String filename)
	{
		FileOutputStream outputStream = null;
		ObjectOutputStream	objectOutputStream = null ;
		try {
//			File dirFile = new File(ROOT_PATH);
			File listFile = new File(ROOT_PATH  + filename );
			if (!listFile.exists()) {
				listFile.createNewFile();
			}else {
				listFile.delete();
				listFile.createNewFile();
			}
			outputStream = new FileOutputStream(listFile);
			objectOutputStream = new ObjectOutputStream(outputStream);
			objectOutputStream.writeObject(list);
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			try {
			if ( outputStream != null ) {
					outputStream.close();
				} 
				outputStream = null ;
			
			if ( objectOutputStream != null ) {
				objectOutputStream.close();
			}
			objectOutputStream = null;
			}catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}
	/*
	public void savePicIdList(ArrayList<JSONObject> list)
	{
		FileOutputStream outputStream = null;
		ObjectOutputStream	objectOutputStream = null ;
		try {
//			File dirFile = new File(ROOT_PATH);
			File listFile = new File(ROOT_PATH +PHOTO_DIR + PHOTO_ID_LIST );
			if (!listFile.exists()) {
				listFile.createNewFile();
			}else {
				listFile.delete();
				listFile.createNewFile();
			}
			outputStream = new FileOutputStream(listFile);
			objectOutputStream = new ObjectOutputStream(outputStream);
			objectOutputStream.writeObject(list);
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			try {
			if ( outputStream != null ) {
					outputStream.close();
				} 
				outputStream = null ;
			
			if ( objectOutputStream != null ) {
				objectOutputStream.close();
			}
			objectOutputStream = null;
			}catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}
	*/
	public void deletePhotoCache()
	{
		
	}
	public void saveModel(DataModel model,String dirname)
	{
		FileOutputStream outputStream = null;
		ObjectOutputStream	objectOutputStream = null ;
		try {
//			File dirFile = new File(ROOT_PATH);
			File photoDirFile = new File(ROOT_PATH +dirname );
			if (!photoDirFile.exists()) {
				photoDirFile.mkdirs();
			}
			String modelIdString = model.id;
			String child_files[] = photoDirFile.list();
			File		tempFile;
			int length = child_files.length;
			boolean isNeedDel = false;
			File 		lastUsedFile = null;
			if ( length >= MAX_COUNT ) {
				isNeedDel = true;
				lastUsedFile = new File(child_files[0]);
			}
			File 		tempLastFile = null;
			
			for (int i = 0; i < child_files.length; i++) {
				if (modelIdString.equals(child_files[i])) {
					tempFile = new File(ROOT_PATH +dirname + modelIdString);
					if( isNeedDel )
					{
						continue;
					}else
						break;
				}
				if( isNeedDel )
				{
					tempLastFile = new File(ROOT_PATH +dirname + modelIdString);
					if( lastUsedFile.lastModified() < tempLastFile.lastModified() )
					{
						lastUsedFile = tempLastFile;
					}
				}
			
			}
			if( isNeedDel )
			{
				lastUsedFile.delete();
			}
			tempFile = new File(ROOT_PATH +dirname + modelIdString);
			tempFile.createNewFile();
			outputStream = new FileOutputStream(tempFile);
			objectOutputStream = new ObjectOutputStream(outputStream);
			objectOutputStream.writeObject(model);
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			try {
			if ( outputStream != null ) {
					outputStream.close();
				} 
				outputStream = null ;
			
			if ( objectOutputStream != null ) {
				objectOutputStream.close();
			}
			objectOutputStream = null;
			}catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}
	
	/*
	public void savePhotoModel(PhotoModel model)
	{
		FileOutputStream outputStream = null;
		ObjectOutputStream	objectOutputStream = null ;
		try {
//			File dirFile = new File(ROOT_PATH);
			File photoDirFile = new File(ROOT_PATH +PHOTO_DIR );
			if (!photoDirFile.exists()) {
				photoDirFile.mkdirs();
			}
			String modelIdString = model.id;
			String child_files[] = photoDirFile.list();
			File		tempFile;
			for (int i = 0; i < child_files.length; i++) {
				if (modelIdString.equals(child_files[i])) {
					tempFile = new File(ROOT_PATH +PHOTO_DIR + modelIdString);
					Log.v("test","delete" + modelIdString + "--->" + tempFile.delete() );
					break;
				}
			}
			tempFile = new File(ROOT_PATH +PHOTO_DIR + modelIdString);
			tempFile.createNewFile();
			outputStream = new FileOutputStream(tempFile);
			objectOutputStream = new ObjectOutputStream(outputStream);
			objectOutputStream.writeObject(model);
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			try {
			if ( outputStream != null ) {
					outputStream.close();
				} 
				outputStream = null ;
			
			if ( objectOutputStream != null ) {
				objectOutputStream.close();
			}
			objectOutputStream = null;
			}catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}
	*/
}
