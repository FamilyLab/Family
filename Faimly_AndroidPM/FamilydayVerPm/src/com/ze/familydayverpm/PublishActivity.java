package com.ze.familydayverpm;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.net.URI;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.MobclickAgent;
import com.ze.commontool.LoadImageMgr;
import com.ze.commontool.NetHelper;
import com.ze.commontool.PullDownView;
import com.ze.commontool.PullDownView.DataHandler;
import com.ze.familydayverpm.adapter.ImageAdapter;
import com.ze.familydayverpm.adapter.PhoneListViewAdapter;
import com.ze.familydayverpm.adapter.SpaceListInDialogListViewAdapter;
import com.ze.familydayverpm.userinfo.Componet;
import com.ze.familydayverpm.userinfo.UserInfoManager;
import com.ze.model.BlogModel;
import com.ze.model.DataModel;
import com.ze.model.ModelDataMgr;
import com.ze.model.PhotoModel;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Gallery;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.TextView;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.SimpleAdapter;
import android.widget.Toast;

public class PublishActivity extends Activity {
		
		private 			View 					mBtnBack;
		private 			Button 					mBtnTopSel;
		private 			Button 					mBtnTopSelArrow;
		private 			Button 					mBtnTag;
		private 			EditText					mEtMessage;
		private 			ImageButton 					mBtnPublish;
		private 			PullDownView 	mDownView;
		private 			String 					reblogContext;
		private static ArrayList<Map<String, Object>> TXT_LIST;
		static
		{
			
		}
		private Gallery gallery;
		private ImageAdapter imageAdapter;
		ArrayList<Drawable> photoes = new ArrayList<Drawable>();
		private AlertDialog 	dialog;
		private int 					gallerySelect;
		private AlertDialog	tagListAlertDialog;
		private Drawable       galleryAddDrawable;
		private View 				footView;
		public 	View 				editDialogView;
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			// TODO Auto-generated method stub
			super.onCreate(savedInstanceState);
			setContentView(R.layout.activity_publish);
			dialog = new AlertDialog.Builder(this).setMessage(R.string.dialog_warning_delete).setPositiveButton(R.string.dialog_button_sure,
					dialogClickListener).setNegativeButton(R.string.dialog_button_cancel, null).create();
			mBtnBack = findViewById(R.id.publish_back);
			mBtnTopSel = (Button)findViewById(R.id.publish_topLabel);
			mBtnTopSelArrow = (Button)findViewById(R.id.publish_topLabelarrow);
			mEtMessage = (EditText)findViewById(R.id.publish_text);
			mBtnPublish = (ImageButton)findViewById(R.id.publish_send);
			mBtnPublish.setOnClickListener(buttonClickListener);
			mBtnTopSel.setOnClickListener(buttonClickListener);
			mBtnTopSelArrow.setOnClickListener(buttonClickListener);
			mBtnBack.setOnClickListener(buttonClickListener);
			galleryAddDrawable = getResources().getDrawable(R.drawable.add_symbol);
			photoes.add(galleryAddDrawable);
			gallery = (Gallery)findViewById(R.id.publish_img_layout);
			gallery.setSpacing(20);
			imageAdapter = new ImageAdapter(this,photoes);
			gallery.setAdapter(imageAdapter);
			Intent intent = getIntent();
			if (intent != null) {
				reblogType = intent.getStringExtra("type");
				reblogId = intent.getStringExtra("id");
				if ( reblogType != null ) {
					isReblog = true;
					mBtnTopSel.setOnClickListener(null);
					mBtnTopSelArrow.setBackgroundColor(Color.WHITE);
					mBtnTopSelArrow.setOnClickListener(null);
					mBtnTopSel.setText(R.string.reblog);
					if(reblogType.equals(SpaceDetailActivity.DETAIL_BLOG) || reblogType.equals(SpaceDetailActivity.DETAIL_REBLOG) )
					{
						gallery.setVisibility(View.GONE);
						mEtMessage.setHint(R.string.reblog_text_hint);
						reblogContext = getIntent().getStringExtra("blogcontext");
					}else
					{
						ArrayList<String> pics = intent.getStringArrayListExtra("imgarray");
						imageAdapter = new ImageAdapter(this,pics);
						gallery.setAdapter(imageAdapter);
						mEtMessage.setHint(R.string.reblog_pic_hint);
						mEtMessage.setFocusable(false);
						mEtMessage.setOnClickListener(buttonClickListener);
					}
				}
			}
			
			
			
			gallerySelect = -1;
			if(isReblog)
			{
				gallery.setOnItemClickListener(null);
			}else {
				gallery.setOnItemClickListener(new OnItemClickListener() {

					@Override
					public void onItemClick(AdapterView<?> arg0, View arg1,
							int arg2, long arg3) {
						// TODO Auto-generated method stub
						if ( arg2 == photoes.size()-1 && photoes.get(arg2) == galleryAddDrawable) {
							showPickDialog();
						}else 
						{
							gallerySelect = arg2;
							dialog.show();
						}
					}
					
				});
			}
			
			mBtnTag = (Button)findViewById(R.id.publish_photoset);
			mBtnTag.setOnClickListener(buttonClickListener);
			if (TXT_LIST == null ) {
				TXT_LIST = new ArrayList<Map<String,Object>>();
				Map<String, Object> object;
				object = new HashMap<String, Object>();
				object.put("item", getResources().getString(R.string.pulish_pic_txt));
				object.put("arrow", "0");
				TXT_LIST.add(object);
				object = new HashMap<String, Object>();
				object.put("item", getResources().getString(R.string.pulish_note_txt));
				object.put("arrow", "0");
				TXT_LIST.add(object);
				object = new HashMap<String, Object>();
				object.put("item", getResources().getString(R.string.pulish_activity_txt));
				object.put("arrow", "1");
//				TXT_LIST.add(object);object = new HashMap<String, Object>();
//				object.put("item", getResources().getString(R.string.pulish_video_txt));
				TXT_LIST.add(object);
			}
			uploadDialog = new ProgressDialog(this);
			mProgressDialog = new ProgressDialog(this);
			mProgressDialog.setCanceledOnTouchOutside(false);
			mProgressDialog.setMessage(getResources().getString(R.string.dialog_msg_load));
//			uploadDialog.setMessage(message)
			
			Componet componet = UserInfoManager.getInstance(PublishActivity.this).getItem("usedspace");
			if ( componet == null ) {
				mBtnTag.setText(R.string.space_init);
			}else {
				mBtnTag.setText(componet.getValue());
			}
			footView = LayoutInflater.from(this).inflate(R.layout.tag_listview_foot, null);
			btnTagFootMore = (Button)footView.findViewById(R.id.tag_lv_foot_show_disscuss);
			pbTagFootMore = ( ProgressBar )footView.findViewById(R.id.tag_lv_foot_progressbar);
			pbTagFootMore.setVisibility(View.INVISIBLE);
			btnTagFootMore.setVisibility(View.VISIBLE);
			btnTagFootMore.setOnClickListener(buttonClickListener);
//			editDialogView = 
		}
		private AlertDialog editDialog;
		private RadioGroup radioGroup;
		private EditText		editDialogEditText;
		private String 	reblogType ;
		private String 	reblogId;
		private boolean isReblog = false;
		public void showEditDialog()
		{
			if ( editDialog == null ) {
				editDialogView	= LayoutInflater.from(this).inflate(R.layout.publish_edit_dialog_view, null);
				editDialogEditText = (EditText)editDialogView.findViewById(R.id.publish_edit_dialog_text);
				radioGroup  = (RadioGroup)editDialogView.findViewById(R.id.publish_edit_dialog_select);
				radioGroup.setOnCheckedChangeListener(new OnCheckedChangeListener() {
					
					@Override
					public void onCheckedChanged(RadioGroup group, int checkedId) {
						// TODO Auto-generated method stub
						editDialogEditText.setText( ( ( RadioButton) group.findViewById(checkedId) ).getText().toString());
					}
				});
				editDialog = new AlertDialog.Builder(this).setView(editDialogView).
						setPositiveButton(R.string.dialog_button_sure, dialogClickListener).
						setNegativeButton(R.string.dialog_button_cancel, null).setTitle(R.string.reblog).create();
			}
			editDialog.show();
		}
		public void tagListSelect(CharSequence tagname)
		{
			mBtnTag.setText(tagname);
			// 保存最近一次选择的相册
			Componet componet = UserInfoManager.getInstance(PublishActivity.this).getItem("usedspace");
			if ( componet == null ) {
				componet = new Componet("usedspace");
			}
			componet.setValue(tagname.toString());
			UserInfoManager.getInstance(PublishActivity.this).add(componet);
			UserInfoManager.getInstance(PublishActivity.this).save(componet);
		}
		public ListView tagListView;
		public Button  btnTagFootMore;
		public TextView	tvTagFootMore;
		public BaseAdapter tagAdapter;
		public ProgressBar		pbTagFootMore;
		public void initTagListDialog()
		{
//			CharSequence[] itemsCharSequences = new CharSequence[tagInfos.size()];
//			for (int i = 0; i < itemsCharSequences.length; i++) {
//				itemsCharSequences[i] = tagInfos.get(i).nameString;
//			}
			if( tagListView == null )
			{
				tagListView = new ListView(this);
				tagAdapter = new SpaceListInDialogListViewAdapter(this, tagInfos);
				tagListView.setOnItemClickListener(itemClickListener);
				tagListView.addFooterView(footView);
				tagListView.setAdapter(tagAdapter);
			}
//			tagListAlertDialog
			tagAdapter.notifyDataSetChanged();
//			if (tagListAlertDialog != null ) {
//				tagListAlertDialog.dismiss();
//			}
			if( tagListAlertDialog == null )
			{
				tagListAlertDialog = new AlertDialog.Builder(this).setTitle(R.string.dialog_title_spacelist).
						setView(tagListView).
						setNeutralButton(R.string.dialog_button_close, null).create();
			}
//			
//			if(  ! tagListAlertDialog.isShowing() )
			if( tagInfos.size() == 0 ||  tagInfos.size() % 5 != 0 )
			{
					tagListView.removeFooterView(footView);
			}
				tagListAlertDialog.show();
		}
		public void changePublishUI()
		{
			if ( gallery.getVisibility() == View.VISIBLE ) {
				// change to Pic UI
				LayoutParams params = (LayoutParams) mEtMessage.getLayoutParams();
				params.height = (int)(params.height / 1.2);
				mEtMessage.setLayoutParams(params);
				mEtMessage.setHint(R.string.pulish_text_hint);
			}else {
				// change to blog UI
				LayoutParams params = (LayoutParams) mEtMessage.getLayoutParams();
				params.height = (int)( params.height * 1.2);
				mEtMessage.setLayoutParams(params);
				mEtMessage.setHint(R.string.pulishblog_text_hint);
			}
		}
		public void startPhotoZoom(Uri uri) {  
	        Intent intent = new Intent("com.android.camera.action.CROP");  
	        intent.setDataAndType(uri, "image/*");  
	        //下面这个crop=true是设置在开启的Intent中设置显示的VIEW可裁剪  
	        intent.putExtra("crop", "true");  
	        // aspectX aspectY 是宽高的比例  
	        intent.putExtra("aspectX", 480);  
	        intent.putExtra("aspectY", 800);  
	        // outputX outputY 是裁剪图片宽高  
	        intent.putExtra("outputX", 480);  
	        intent.putExtra("outputY", 800);  
	        intent.putExtra("return-data", true);  
	        startActivityForResult(intent, 3);  
	    }  
		@Override
		protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
			if ( data == null )
			 {
				 if( requestCode != 2 )
				 {
//					 Toast.makeText(this, text, duration)
					 return;
				 }
			 }
		        switch (requestCode) {  
		        // 如果是直接从相册获取  
		        case 1:  
//		            startPhotoZoom(data.getData());  
		        	  if(data != null){  
			                setPicToView(data.getData());  
			            }  
		            break;  
		        // 如果是调用相机拍照时  
		        case 2:  
		        	if (resultCode == -1 ) {
		        		File temp = new File(ModelDataMgr.ROOT_PATH
			                    + ModelDataMgr.ICON_TEMP);  
			            if(temp.exists())
			            	setPicToView(Uri.fromFile(temp));  
					}
		            break;  
		        // 取得裁剪后的图片  
		        case 3:  
		            /**  
		             * 非空判断大家一定要验证，如果不验证的话，  
		             * 在剪裁之后如果发现不满意，要重新裁剪，丢弃  
		             * 当前功能时，会报NullException，小马只  
		             * 在这个地方加下，大家可以根据不同情况在合适的  
		             * 地方做判断处理类似情况  
		             *   
		             */ 
		            if(data != null){  
		                setPicToView(data);  
		            }  
		            File file = new File(ModelDataMgr.ROOT_PATH
		                    + ModelDataMgr.ICON_TEMP);  
		            if( file != null )
		            	file.delete();
		            break;  
		        default:  
		            break;  
		 
		        }  
		        super.onActivityResult(requestCode, resultCode, data);  
		}
//		private ArrayList<Bitmap> uploadList = new ArrayList<Bitmap>();
		private void setPicToView(Intent picdata) {  
//			Bitmap cameraBitmap = (Bitmap) picdata.getExtras().get("data");
	        Bundle extras = picdata.getExtras();  
	        if (extras != null) {  
	            Bitmap photo = extras.getParcelable("data");  
//	            uploadList.add(photo);
	            final Drawable drawable = new BitmapDrawable(photo); 
	            photoes.add(photoes.size()-1,drawable );
	            notifyGallery();
				imageAdapter.notifyDataSetChanged();
	        }  
	    }  
		private void setPicToView(File temp) {  
	        if (temp != null) {  
	        	FileInputStream inputStream = null;
	        	ObjectInputStream objectInputStream = null ;
	        	try {
	        		inputStream = new FileInputStream(temp);
					objectInputStream = new ObjectInputStream(inputStream);
					byte[] buffer = (byte[]) objectInputStream.readObject();
					Drawable drawable = LoadImageMgr.getInstance().ByteArray2Drawable( buffer);
					 photoes.add(photoes.size()-1,drawable );
			            notifyGallery();
						imageAdapter.notifyDataSetChanged();
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}finally{
					try {
						if (objectInputStream != null) {
							objectInputStream.close();
							objectInputStream = null;
						}
						if (inputStream != null) {
							inputStream.close();
							inputStream = null;
						}
					} catch (Exception e2) {
						// TODO: handle exception
						e2.printStackTrace();
					}
				}
	           
	        }  
	    }  
		private void setPicToView(Uri picUri) {  
			 ContentResolver cr = this.getContentResolver();  
			try {
				 Bitmap bitmap = BitmapFactory.decodeStream(cr.openInputStream(picUri)); 
				   final Drawable drawable = new BitmapDrawable(bitmap); 
		            photoes.add(photoes.size()-1,drawable );
		            notifyGallery();
					imageAdapter.notifyDataSetChanged();
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			} 
	    }  
		public void showPickDialog() {  
//			iconImageView = (ImageView) view;
		        new AlertDialog.Builder(this)  
		                .setTitle("上传图片")  
		                .setNegativeButton("相册", new DialogInterface.OnClickListener() {  
		                    public void onClick(DialogInterface dialog, int which) {  
		                        dialog.dismiss();  
		                        Intent intent = new Intent(Intent.ACTION_PICK, null); 
		                        intent.setDataAndType(  
		                                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,  
		                                "image/*");  
		                        startActivityForResult(intent, 1);  
		                    }  
		                })  
		                .setPositiveButton("拍照", new DialogInterface.OnClickListener()	 {  
		                    public void onClick(DialogInterface dialog, int whichButton) {  
		                        dialog.dismiss();  
		                        Intent intent = new Intent(  
		                                MediaStore.ACTION_IMAGE_CAPTURE);  
		                        //下面这句指定调用相机拍照后的照片存储的路径  
		                        intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri  
		                                .fromFile(new File(ModelDataMgr.ROOT_PATH,  
		                                		ModelDataMgr.ICON_TEMP)));  
//		                        intent.putExtra(MediaStore.EXTRA_OUTPUT, );
		                        startActivityForResult(intent, 2);  
		                    }  
		                }).show();  
		    } 
		private OnClickListener buttonClickListener = new OnClickListener(){

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
			 if( v == mBtnBack )
				{
					PublishActivity.this.finish();
				}else if( v == mBtnTopSel || v == mBtnTopSelArrow)
				{
					mBtnTopSelArrow.setVisibility(View.INVISIBLE);
					if ( mDownView == null ) {
						mDownView = new PullDownView(PublishActivity.this, (View)v.getParent(),v ,TXT_LIST , new DataHandler()
						{

							@Override
							public Object selected(int index) {
								// TODO Auto-generated method stub
								( (Button)mBtnTopSel ).setText( (String)TXT_LIST.get(index).get("item") );
								mBtnTopSel.setTag(index + "");
								boolean needChange = false;
								if ( index == 0 ) {
									needChange = (gallery.getVisibility() == View.GONE);
									gallery.setVisibility(View.VISIBLE);
								}else
								{
									needChange = (gallery.getVisibility() == View.VISIBLE);
									gallery.setVisibility(View.GONE);
								}
								if( needChange )
									changePublishUI();
								
								return null;
							}

							@Override
							public void onPullDownViewDissmiss() {
								// TODO Auto-generated method stub
								mBtnTopSelArrow.setVisibility(View.VISIBLE);
							}
							
						});
					
					}
					mDownView.show(v);
				}else if( v == mBtnTag )
				{
					loadTagInfo(false);
				}else if( v == mBtnPublish )
				{
					InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);  
					imm.hideSoftInputFromWindow(PublishActivity.this.getCurrentFocus().getWindowToken(), 0);
					if( ! mBtnTag.getText().toString().equals("") )
					{
						if(isReblog)
						{
							Toast.makeText(PublishActivity.this, R.string.tips_msg_back_send, Toast.LENGTH_SHORT).show();
							publishRebolgTask();
							PublishActivity.this.finish();
						}else {
							if( gallery.getVisibility() == View.VISIBLE )
							{
								if( ! photoes.get(0).equals(galleryAddDrawable))
								{	
									number = 0;
									Toast.makeText(PublishActivity.this, R.string.tips_msg_back_send, Toast.LENGTH_SHORT).show();
									uploadPic(photoes.get(0));
									PublishActivity.this.finish();
								}else
									Toast.makeText(PublishActivity.this, R.string.tips_msg_noset_pic, Toast.LENGTH_SHORT).show();
							}else
							{
								if( mEtMessage.getText().toString().length() > 0)
								{	
									Toast.makeText(PublishActivity.this, R.string.tips_msg_back_send, Toast.LENGTH_SHORT).show();
									publishBlogTask();
									PublishActivity.this.finish();
								}else
									Toast.makeText(PublishActivity.this, R.string.tips_msg_noset_blog, Toast.LENGTH_SHORT).show();
							}
						}
						
						
					}else
					{
						Toast.makeText(PublishActivity.this, R.string.tips_msg_noset_tag, Toast.LENGTH_SHORT).show();
						loadTagInfo(false);
					}
				}else if( v == btnTagFootMore )
				{
					pbTagFootMore.setVisibility(View.VISIBLE);
					loadTagInfo(true);
				}else if( v== mEtMessage ){
					showEditDialog();
				}
			}
			
		};
		private boolean loadingTagFlag = false;
		private ProgressDialog mProgressDialog;
		public ArrayList<TagInfo> loadTagInfo(final boolean needMore)
		{
			if ( tagInfos == null  || needMore ) {
				if( loadingTagFlag == true )
				{
					return null;
				}
				if( needMore )
				{
					if( tagInfos.size() == 0 ||  tagInfos.size() % 5 != 0 )
					{
						if( tagListView != null )
						{
							tagListView.removeFooterView(footView);
						}
						return null;
					}
				}
				new AsyncTask<String, String, String>()
				{
					protected void onPreExecute() {
						loadingTagFlag = true;
						if( ! needMore )
							mProgressDialog.show();
					};
					@Override
					protected String doInBackground(String... params) {
						// TODO Auto-generated method stub
						if( ! needMore )
						{
							Componet tagComponet = UserInfoManager.getInstance(PublishActivity.this).getItem("tag");
							if ( tagComponet !=null ) {
								return tagComponet.getValue();
							}
						}
						String responString = NetHelper.getResponByHttpClient(getResources().getString(R.string.http_zone_list), 
								UserInfoManager.getInstance(PublishActivity.this).getItem("m_auth").getValue()
								,(tagInfos == null ? 0 : tagInfos.size() / 5) + 1 +  "",""
								);
						return responString;
					}
					protected void onPostExecute(String result) {
						if(mProgressDialog.isShowing())
							mProgressDialog.hide();
						
						loadingTagFlag = false;
						try {
							JSONObject jsonObject = new JSONObject(result);
							JSONArray array = jsonObject.getJSONObject("data").getJSONArray("spacelist");
							int size = array.length();
							JSONObject temp;
							TagInfo object;
							if( tagInfos == null )
								 tagInfos= new ArrayList<PublishActivity.TagInfo>() ;
							
							for (int i = 0; i < size; i++) {
								temp = array.getJSONObject(i);
								object = new TagInfo();
								object.tagid =temp.getString("tagid");
								object.nameString = temp.getString("tagname");
								tagInfos.add(object);
							}
							if( size == 0 || size % 5 != 0 )
							{
								if( tagListView != null )
									tagListView.removeFooterView(footView);
							}else
							{
								pbTagFootMore.setVisibility(View.INVISIBLE);
							}
							if( !needMore)
								initTagListDialog();
							else {
								tagAdapter.notifyDataSetChanged();
							}
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					};
				}.execute("");
			}else
			{
				initTagListDialog();
			}
			return tagInfos;
		}
		@Override
		public void onResume() {
		    super.onResume();
		    MobclickAgent.onResume(this);
		}
		@Override
		public void onPause() {
		    super.onPause();
		    MobclickAgent.onPause(this);
		}
		private ArrayList<TagInfo> tagInfos = null;
		private android.content.DialogInterface.OnClickListener dialogClickListener = new 
				android.content.DialogInterface.OnClickListener() { 
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				if( dialog == editDialog )
				{
					mEtMessage.setText( editDialogEditText.getText() );
				}else {
					if( gallerySelect != -1 )
					{
						photoes.remove(gallerySelect);
						notifyGallery();
						imageAdapter.notifyDataSetChanged();
						gallerySelect = -1;
					}
				}
				
			}
		};
		public final static int MAX_PIC_COUNT = 3;
		public void notifyGallery()
		{
			if ( photoes.get( photoes.size()-1 ) != galleryAddDrawable  && photoes.size() < MAX_PIC_COUNT ) {
				photoes.add(galleryAddDrawable );
				return;
			}
			if( photoes.get( photoes.size()-1 ) ==galleryAddDrawable && photoes.size() > MAX_PIC_COUNT)
			{
				photoes.remove(photoes.size()-1);
				return;
			}
			
		}
		private ProgressDialog uploadDialog;
		private ArrayList<String> uploadPicids = new ArrayList<String>();
		private int number = 0;
		public void uploadPic(final Drawable drawable)
		{
			new AsyncTask<String, Integer, String>()
			{
				protected void onPreExecute() {
					for(int i=0; i<photoes.size(); i++)
					{
						if ( photoes.get(i).equals(drawable) )
						{
							number = i+1;
							break;
						}
					}
//					uploadDialog.setMessage(String.format(getResources().getString(R.string.dialog_msg_uploadpic),number+""));
//					uploadDialog.show();
//					uploadDialog.setCancelable(false);
				};
				
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String urlString = String.format(getResources().getString(R.string.http_upload_pic));
					String responString = NetHelper.uploadPicWithArgs(urlString, drawable, "Filedata",
							new String[]{"ac","op","m_auth"},
							new String[]{"upload","uploadphoto",UserInfoManager.getInstance(PublishActivity.this).getItem("m_auth").getValue()});
					
					return responString;
				}
				protected void onPostExecute(String result) {
					JSONObject object;
//					if (uploadDialog.isShowing()) {
//						uploadDialog.hide();
//					}
					try {
						object = new JSONObject(result);
						if (object.getInt("error") == 0 ) {
							uploadPicids.add(object.getJSONObject("data").getString("picid"));
							if ( number < photoes.size() ) {
								Drawable drawable = photoes.get(number);
								if ( ! drawable.equals(galleryAddDrawable)) {
									uploadPic(drawable);
									return;
								}
							}
							publishTask();
						}else
						{
							Toast.makeText(PublishActivity.this, getResources().getString(R.string.dialog_msg_check_mauth), Toast.LENGTH_SHORT).show();
						}
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				};
			}.execute("");
		}
		public void publishRebolgTask()
		{
			new AsyncTask<String, Integer, String>()
			{
				@Override
				protected void onPreExecute() {
					// TODO Auto-generated method stub
					super.onPreExecute();
//					uploadDialog.setMessage(getResources().getString(R.string.dialog_msg_reblog));
//					uploadDialog.show();
				}
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = null;
					try {
						if(reblogType.equals(SpaceDetailActivity.DETAIL_BLOG) || reblogType.equals(SpaceDetailActivity.DETAIL_REBLOG) )
						{
							responString = NetHelper.uploadPicWithArgs(getResources().getString(R.string.http_publish_pic), null, "", 
									new String[]{"ac","blogid","m_auth","message","friend","tags","come","makefeed","blogsubmit"},
									new String[]{
									"reblog",
									reblogId,
									UserInfoManager.getInstance(PublishActivity.this).getItem("m_auth").getValue(),
									"<p>" + mEtMessage.getText().toString() + "</p>\n" + reblogContext,
//									 mEtMessage.getText().toString()  + reblogContext,
									"1",
									mBtnTag.getText().toString(),
									"androidVerPm","1","1",
							});
						}else 
						{
							responString = NetHelper.uploadPicWithArgs(getResources().getString(R.string.http_publish_pic), null, "", 
									new String[]{"ac","photoid","m_auth","message","friend","tags","come","makefeed","photosubmit"},
									new String[]{
									"rephoto",
									reblogId,
									UserInfoManager.getInstance(PublishActivity.this).getItem("m_auth").getValue(),
									mEtMessage.getText().toString(),
									"1",
									mBtnTag.getText().toString(),
									"androidVerPm","1","1"
							});
						}
						
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					
					return responString;
				}
				@Override
				protected void onPostExecute(String result) {
					// TODO Auto-generated method stub
					super.onPostExecute(result);
//					if (uploadDialog.isShowing()) {
//						uploadDialog.hide();
//					}
					try {
						JSONObject object = new JSONObject(result);
						if(object.getInt("error") == 0 )
						{
//							Toast.makeText(PublishActivity.this, R.string.tips_msg_finish_publish, Toast.LENGTH_SHORT).show();
//							PublishActivity.this.finish();
							return;
						}
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
//					Toast.makeText(PublishActivity.this, R.string.tips_send_fail, Toast.LENGTH_SHORT).show();
				}
			}.execute("");
		}
		
		public void publishBlogTask()
		{
			new AsyncTask<String, Integer, String>()
			{
				@Override
				protected void onPreExecute() {
					// TODO Auto-generated method stub
					super.onPreExecute();
//					uploadDialog.setMessage(getResources().getString(R.string.dialog_msg_publicpic));
//					uploadDialog.show();
				}
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String responString = null;
					try {
						responString = NetHelper.uploadPicWithArgs(getResources().getString(R.string.http_publish_pic), null, "", 
								new String[]{"ac","m_auth","message","friend","tags","come","makefeed","blogsubmit"},
								new String[]{
								"blog",
								UserInfoManager.getInstance(PublishActivity.this).getItem("m_auth").getValue(),
								 mEtMessage.getText().toString(),
								"1",
								mBtnTag.getText().toString(),
								"androidVerPm","1","1",
						});
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					
					return responString;
				}
				@Override
				protected void onPostExecute(String result) {
					// TODO Auto-generated method stub
					super.onPostExecute(result);
//					if (uploadDialog.isShowing()) {
//						uploadDialog.hide();
//					}
					/*
					try {
						JSONObject object = new JSONObject(result);
						if(object.getInt("error") == 0 )
						{
							object = object.getJSONObject("data");
							String uid = object.getString("uid");
							String id = object.getString("id");
							String type = object.getString("idtype");
							Toast.makeText(PublishActivity.this, R.string.tips_msg_finish_publish, Toast.LENGTH_SHORT).show();
							Intent intent = new Intent();
							intent.setClass(PublishActivity.this, SpaceDetailActivity.class);
							intent.putExtra("frompublish", true);
							intent.putExtra("id", id);
							intent.putExtra("uid", uid);
							intent.putExtra("type", type);
							startActivity(intent);
							PublishActivity.this.finish();
							//TODO: open detail
							return;
						}else
						{
							String errorMsg = object.getString("msg");
							Toast.makeText(PublishActivity.this,errorMsg, Toast.LENGTH_SHORT).show();
						}
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					Toast.makeText(PublishActivity.this, R.string.tips_send_fail, Toast.LENGTH_SHORT).show();
					*/
				}
			}.execute("");
		}
		
		
		
		public void publishTask()
		{
			new AsyncTask<String, Integer, String>()
			{
				@Override
				protected void onPreExecute() {
					// TODO Auto-generated method stub
					super.onPreExecute();
//					uploadDialog.setMessage(getResources().getString(R.string.dialog_msg_publicpic));
//					uploadDialog.show();
				}
				@Override
				protected String doInBackground(String... params) {
					// TODO Auto-generated method stub
					String picsString = "";
					for (int i = 0; i < uploadPicids.size(); i++) {
						picsString += uploadPicids.get(i);
						if( i < uploadPicids.size() - 1 )
						{
							picsString += "/|";
						}
					}
					String responString = null;
					try {
						responString = NetHelper.uploadPicWithArgs(getResources().getString(R.string.http_publish_pic), null, "", 
								new String[]{"ac","m_auth","message","friend","tags","come","makefeed","photosubmit","picids"},
								new String[]{
								"photo",
								UserInfoManager.getInstance(PublishActivity.this).getItem("m_auth").getValue(),
								mEtMessage.getText().toString(),
								"1",
								mBtnTag.getText().toString(),
								"androidVerPm","1","1",picsString
						});
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					
					return responString;
				}
				@Override
				protected void onPostExecute(String result) {
					// TODO Auto-generated method stub
					super.onPostExecute(result);
//					if (uploadDialog.isShowing()) {
//						uploadDialog.hide();
//					}
					/*
					try {
						JSONObject object = new JSONObject(result);
						if(object.getInt("error") == 0 )
						{
							object = object.getJSONObject("data");
							String uid = object.getString("uid");
							String id = object.getString("id");
							String type = object.getString("idtype");
							Toast.makeText(PublishActivity.this, R.string.tips_msg_finish_publish, Toast.LENGTH_SHORT).show();
							Intent intent = new Intent();
							intent.setClass(PublishActivity.this, SpaceDetailActivity.class);
							intent.putExtra("frompublish", true);
							intent.putExtra("id", id);
							intent.putExtra("uid", uid);
							intent.putExtra("type", type);
							startActivity(intent);
							PublishActivity.this.finish();
							//TODO: open detail
							return;
						}else
						{
							String errorMsg = object.getString("msg");
							Toast.makeText(PublishActivity.this,errorMsg, Toast.LENGTH_SHORT).show();
						}
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					*/
				}
			}.execute("");
		}
		public static class TagInfo
		{
			public String nameString;
			public String tagid;
		}
		public OnItemClickListener itemClickListener = new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				// TODO Auto-generated method stub
//				if (arg2 == tagAdapter.getCount() -1 ) {
//					// 
//					tagInfos.remove(arg2);
//					loadTagInfo(true);
////					return;
//				}else
//				{
					tagListSelect(tagInfos.get(arg2).nameString);
//				}
				tagListAlertDialog.hide();
			}
		};
}
