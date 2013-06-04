package com.ze.commontool;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.URL;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.HttpVersion;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HTTP;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;



import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;
 	
public class NetHelper {
	
	
	public static String getDateByHttpClient(String url) {
		String strResult = "";
		try {
			// HttpGet连接对象
			HttpGet httpRequest = new HttpGet(url);
			// 取得HttpClient对象
			HttpClient httpClient = new DefaultHttpClient();
			// 请求HttpClient, 取得HttpResponse
			HttpResponse httpResponse = httpClient.execute(httpRequest);
			if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				// 取得返回的字符串
				strResult = EntityUtils.toString(httpResponse.getEntity(),
						"UTF-8");
				strResult = strResult.substring(strResult.indexOf("{"), 
						strResult.lastIndexOf("}") + 1);
			}
		} catch (Exception e) {
			Log.i("Err",e.toString());
		}

		return strResult;
	}
	public static boolean isNetAble(Context mContext)
	{
		// 网络是否可用
		 ConnectivityManager connectivityManager=(ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE);
		 NetworkInfo net=connectivityManager.getActiveNetworkInfo();
		return net == null ? false : net.isConnected();
	}
	public static String getLocation(String url,String number) {
		String strResult = "";
		try {
			// HttpGet连接对象
			HttpGet httpRequest = new HttpGet(String.format(url,number));
			// 取得HttpClient对象
			HttpClient httpClient = new DefaultHttpClient();
			// 请求HttpClient, 取得HttpResponse
			HttpResponse httpResponse = httpClient.execute(httpRequest);
			if (httpResponse.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				// 取得返回的字符串
				strResult = EntityUtils.toString(httpResponse.getEntity(),
						"gbk");
				strResult = strResult.substring(strResult.indexOf("{"), 
						strResult.lastIndexOf("}") + 1);
			}
		} catch (Exception e) {
			Log.i("Err",e.toString());
		}

		return strResult;
	}
	public static HttpClient newHttpClient = null;
	public static HttpClient getNewHttpClient()
	{
		if(newHttpClient == null)
		{
			try {
				KeyStore trustStore  =  KeyStore.getInstance(KeyStore.getDefaultType());
				trustStore.load(null, null);
				SSLSocketFactory sf = new SSLSocketFactoryEx(trustStore);  
	            sf.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);  
	    
	            HttpParams params = new BasicHttpParams();  
	            HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);  
	            HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);  
	    
	            SchemeRegistry registry = new SchemeRegistry();  
	            registry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));  
	            registry.register(new Scheme("https", sf, 443));  
	    
	            ClientConnectionManager ccm = new ThreadSafeClientConnManager(params, registry);  
	    
	            newHttpClient = new DefaultHttpClient(ccm, params); 
			} catch (KeyStoreException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (NoSuchAlgorithmException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (CertificateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (KeyManagementException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (UnrecoverableKeyException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return newHttpClient;
	}
	public static String getResponByHttpClient(String url) {
		return getDateByHttpClient(url);
	}	
	
	public static String getResponByHttpClient(String url,String arg0) {
		url = String.format(url, arg0);
		return getDateByHttpClient(url);
	}
	public static String getResponByHttpClient(String url,String arg0,String arg1) {
		url = String.format(url, arg0,arg1);
		return getDateByHttpClient(url);
	}
	public static String getResponByHttpClient(String url,String arg0,String arg1,String arg2) {
		url = String.format(url, arg0,arg1,arg2);
		return getDateByHttpClient(url);
	}
	
	public static String getResponByHttpClient(String url,String arg0,String arg1,String arg2,String arg3) {
		url = String.format(url, arg0,arg1,arg2,arg3);
		return getDateByHttpClient(url);
	}
	
	public static String getResponByHttpClient(String url,String arg0,String arg1,String arg2,String arg3,String agr4) {
		url = String.format(url, arg0,arg1,arg2,arg3,agr4);
		return getDateByHttpClient(url);
	}
	
	public static String getResponByHttpClient(String url,String arg0,String arg1,String arg2,String arg3,String agr4,String arg5) {
		url = String.format(url, arg0,arg1,arg2,arg3,agr4,arg5);
		return getDateByHttpClient(url);
	}
	
	public static String getResponByHttpClient(String url,String arg0,String arg1,String arg2,String arg3,String agr4,
			String arg5,String arg6,String arg7,String arg8,String arg9,String arg10) {
		url = String.format(url, arg0,arg1,arg2,arg3,agr4,arg5,arg6,arg7,arg8,arg9,arg10);
		return getDateByHttpClient(url);
	}
	
	/**
	 * 	上传图片
	 */
	public static String uploadPic(String str_url,Drawable drawable,String argJpg)
	{
		boolean status = false;
	    String end = "\r\n";
	    String twoHyphens = "--";
	    String boundary = "*****";
	    try{
	    	URL url =new URL(str_url);
	        HttpURLConnection con=(HttpURLConnection)url.openConnection();
	        /* 允许Input、Output，不使用Cache */
	        con.setDoInput(true);
	        con.setDoOutput(true);
	        con.setUseCaches(false);
	        /* 设置传送的method=POST */
	        con.setRequestMethod("POST");
	        /* setRequestProperty */
	        con.setRequestProperty("Connection", "Keep-Alive");
	        con.setRequestProperty("Charset", "UTF-8");
	        con.setRequestProperty("Content-Type",
	                           "multipart/form-data;boundary="+boundary);
	        /* 设置DataOutputStream */
	        DataOutputStream ds = 
	          new DataOutputStream(con.getOutputStream());
	        ds.writeBytes(twoHyphens + boundary + end);
	        ds.writeBytes("Content-Disposition: form-data; " +
	                      "name=\"" + argJpg  + "\";filename=\"upload.jpg\"" + end);
	        ds.writeBytes(end);   
	
	        /* 取得文件的FileInputStream */
	      //  FileInputStream fStream = new FileInputStream(drawable.);
	        ByteArrayOutputStream baos = new ByteArrayOutputStream();
			Bitmap bitmap = ((BitmapDrawable)drawable).getBitmap();
			bitmap.compress(Bitmap.CompressFormat.JPEG, 80, baos);
			ds.write(baos.toByteArray());
	        /* 设置每次写入1024bytes */
//	        int bufferSize = 1024;
//	        byte[] buffer = new byte[bufferSize];
//	
//	        int length = -1;
//	        /* 从文件读取数据至缓冲区 */
//	        while((length = fStream.read(buffer)) != -1)
//	        {
//	          /* 将资料写入DataOutputStream中 */
//	          ds.write(buffer, 0, length);
//	        }
	        ds.writeBytes(end);
	        ds.writeBytes(twoHyphens + boundary + twoHyphens + end);
	
	        /* close streams */
	       // fStream.close();
	        ds.flush();
	
	        /* 取得Response内容 */
	        InputStream is = con.getInputStream();
	        int ch;
	        StringBuffer b =new StringBuffer();
	        while( ( ch = is.read() ) != -1 )
	        {
	          b.append( (char)ch );
	        }
	        /* 关闭DataOutputStream */
	        ds.close();
	       return b.toString(); 
      }
      catch(Exception e)
      {
    	  status = false;
    	  e.printStackTrace();
      }
		return "";
	}
	
	//将输入流转换成字符串 
	private static String inStream2String(InputStream is) throws Exception { 
		ByteArrayOutputStream baos = new ByteArrayOutputStream(); 
		byte[] buf = new byte[1024]; 
		int len = -1; 
		while ((len = is.read(buf)) != -1) { 
			baos.write(buf, 0, len); 
		} 
		return new String(baos.toByteArray()); 
	} 
	/**
	 * 	Post 
	 */
	public static String uploadByPost(String str_url,Map<String, Object> list,String fileName)
	{
		boolean status = false;
	    String end = "\r\n";
	    String twoHyphens = "--";
	    String boundary = "*****";
	    try{
	    	URL url =new URL(str_url);
	        HttpURLConnection con=(HttpURLConnection)url.openConnection();
	        /* 允许Input、Output，不使用Cache */
	        con.setDoInput(true);
	        con.setDoOutput(true);
	        con.setUseCaches(false);
	        /* 设置传送的method=POST */
	        con.setRequestMethod("POST");
	        /* setRequestProperty */
	        con.setRequestProperty("Connection", "Keep-Alive");
	        //con .setRequestProperty("http.keepAlive", "false"); 
	        con.setRequestProperty("Charset", "UTF-8");
	        con.setRequestProperty("Content-Type",
	                           "multipart/form-data;boundary="+boundary);
	        /* 设置DataOutputStream */
	        DataOutputStream ds = 
	          new DataOutputStream(con.getOutputStream());
	        ds.writeBytes(twoHyphens + boundary + end);
	        int len = list.size();
	        //for (int i = 0; i< len; i++) {
	        	Set<String> key = list.keySet();
	        	String string;
	        	for (Iterator it = key.iterator(); it.hasNext();) {
	        		string = (String)it.next();
	        		if( string.equals(fileName) )
	        		{
	        			ds.writeBytes("\r\n--"+boundary+"\r\nContent-Disposition: form-data; name=\"pic\"; " +
	        					"filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n");
	        			Drawable drawable = (Drawable) list.get(string);
	    				ByteArrayOutputStream baos = new ByteArrayOutputStream();
	    				Bitmap bitmap = ((BitmapDrawable)drawable).getBitmap();
	    				bitmap.compress(Bitmap.CompressFormat.JPEG, 80, baos);
	    	            ds.write(baos.toByteArray());
	        		}else {
	        			ds.writeBytes("Content-Disposition: form-data; " +
      			              "name=\"" + string  + "\";value=\"" + (String)list.get(string) + "\"" + end);
					}
	        		
	        		
	        	}
	        	
			
	       // ds.writeBytes("Content-Disposition: form-data; " +
	       //               "name=\"" + argJpg  + "\";filename=\"upload.jpg\"" + end);
	        ds.writeBytes(end);   
	
	        System.setProperty("http.keepAlive", "false"); 
	        ds.writeBytes(end);
	        ds.writeBytes(twoHyphens + boundary + twoHyphens + end);
	
	        /* close streams */
	       // fStream.close();
	        ds.flush();
	
	        /* 取得Response内容 */
	        InputStream is = con.getInputStream();
	        int ch;
	        StringBuffer b =new StringBuffer();
	        while( ( ch = is.read() ) != -1 )
	        {
	          b.append( (char)ch );
	        }
	        /* 关闭DataOutputStream */
	        ds.close();
	       return b.toString(); 
      }
      catch(Exception e)
      {
    	  status = false;
    	  e.printStackTrace();
      }
		return "";
	}
	/**
	 * 时间戳转换
	 * @param time， 10位时间戳
	 * @return
	 */
	
	public static long 	TIME_A_MIN	= 1000*60;
	public static long 	TIME_A_HOUR	= TIME_A_MIN * 60;
	public static long 	TIME_A_DAY	= TIME_A_HOUR * 24;
	public static long  TIME_A_WEEK = TIME_A_DAY * 7;
	public static String transTimeToString(long time)
	{
		// 直接转为时间
		Date tt = new Date(time * 1000L);
		String timeStr = "" + (tt.getYear()+1900) + "-" + 
		getTimeIncludeZero ( (tt.getMonth()+1) +"" )
		+ "-" + 
		getTimeIncludeZero ( tt.getDate() + "" )
		+ " ";
//		+ 
//		getTimeIncludeZero ( tt.getHours() + "" ) 
//		+ ":" + 
//		getTimeIncludeZero ( tt.getMinutes() + "" );
		return timeStr;
	}
	public static String getTimeIncludeZero(String time)
	{
		if ( time.length() == 1 ) {
			return "0" + time;
		}
		return time;
	}
	public static String transTime(long time){
		String timeStr = "刚刚";
		Date date = new Date(System.currentTimeMillis());
		Date tt = new Date(time * 1000L);
		long now 	= date.getTime();
		long theTime = tt.getTime();
//		long flag	= time*1000;
		long time_dif = now - theTime;
		
		if( time_dif >= TIME_A_WEEK || time_dif < 0 ){
			timeStr = transTimeToString(time);
			return timeStr;
		}else {
			if( time_dif > TIME_A_DAY ){
				timeStr = (time_dif/TIME_A_DAY) + "天前";
				return timeStr;
			}
			if(time_dif > TIME_A_HOUR){
				timeStr = (time_dif/TIME_A_HOUR) + "小时前";
				return timeStr;
			}
			if(time_dif > TIME_A_MIN){
				timeStr = (time_dif/TIME_A_MIN) + "分钟前";
				return timeStr;
			}else {
				timeStr = (time_dif/1000) + "秒前";
				return timeStr;
			}
			
		}
//		return timeStr;
	}
	
	public static String transEndTime(long time){
		String timeStr = "已截止";
		Date date = new Date();
		Date tt = new Date(time * 1000L);
		long now 	= date.getTime();
		long theTime = tt.getTime();
//		long flag	= time*1000;
		long time_dif = theTime - now;
		
		if (time_dif <= 0) {
			return timeStr;
		}
		
		
			if( time_dif > TIME_A_DAY ){
				timeStr = (time_dif/TIME_A_DAY) + "天后";
				return timeStr;
			}
			if(time_dif > TIME_A_HOUR){
				timeStr = (time_dif/TIME_A_HOUR) + "小时后";
				return timeStr;
			}
			if(time_dif > TIME_A_MIN){
				timeStr = (time_dif/TIME_A_MIN) + "分钟后";
				return timeStr;
			}else {
				timeStr = (time_dif/1000) + "秒后";
				return timeStr;
			}
			
//		return timeStr;
	}
	
	
	static class SSLSocketFactoryEx extends SSLSocketFactory {
        
        SSLContext sslContext = SSLContext.getInstance("TLS");
        
        public SSLSocketFactoryEx(KeyStore truststore) 
                        throws NoSuchAlgorithmException, KeyManagementException,
                        KeyStoreException, UnrecoverableKeyException {
                super(truststore);
                
                TrustManager tm = new X509TrustManager() {
                        public java.security.cert.X509Certificate[] getAcceptedIssuers() {return null;}  
    
            @Override  
            public void checkClientTrusted(
                            java.security.cert.X509Certificate[] chain, String authType)
                                            throws java.security.cert.CertificateException {}  
    
            @Override  
            public void checkServerTrusted(
                            java.security.cert.X509Certificate[] chain, String authType)
                                            throws java.security.cert.CertificateException {}
        };  
        sslContext.init(null, new TrustManager[] { tm }, null);  
    }  
    
    @Override  
    public Socket createSocket(Socket socket, String host, int port,boolean autoClose) throws IOException, UnknownHostException {  
            return sslContext.getSocketFactory().createSocket(socket, host, port,autoClose);  
    }  
    
    @Override  
    public Socket createSocket() throws IOException {  
        return sslContext.getSocketFactory().createSocket();  
    }  
}
	
	public static String getStringWithoutHtml(String src)
	{
		if (src == null || src.trim().equals("")) {
			return "";
		}
		String rep = src.replaceAll("\\&[a-zA-Z]{1,10};", "").replaceAll("<[^>]*>", "");
		rep = rep.replaceAll("[(/>)<]", "");
		return rep;
	}
	public static boolean isNetAvailable(Context context)
	{
		NetworkInfo networkInfo = ( (ConnectivityManager)context.getSystemService(context.CONNECTIVITY_SERVICE) )
														.getActiveNetworkInfo();
			
				return networkInfo == null ? false : networkInfo.isAvailable();
	}
	/*
	public static ArrayList<JSONObject> listJsonArray( final JSONArray array )
	{
		ArrayList<JSONObject> result = new ArrayList<JSONObject>();
		
		final int length = array.length();
		JSONObject temp;
		for (int i = 0; i < length; i++) {
			temp = array.getJSONObject(i) ;
			if (temp != null ) {
				result.add(temp);
			}
		}
		return result;
	}
	*/
}
