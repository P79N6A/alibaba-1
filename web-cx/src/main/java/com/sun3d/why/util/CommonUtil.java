package com.sun3d.why.util;

import com.sun3d.why.webservice.api.util.HttpResponseText;

import org.apache.commons.lang3.StringUtils;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpServletRequest;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Method;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * 工具类
 */
public class CommonUtil {

    /**
     * 获取访问者IP
     * 在一般情况下使用Request.getRemoteAddr()即可，但是经过nginx等反向代理软件后，这个方法会失效。
     * 本方法先从Header中获取X-Real-IP，如果不存在再从X-Forwarded-For获得第一个IP(用,分割)，
     * 如果还不存在则调用Request .getRemoteAddr()。
     *
     * @param request
     * @return
     */
    public static String getIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Real-IP");
        if (!StringUtils.isBlank(ip) && !"unknown".equalsIgnoreCase(ip)) {
            return ip;
        }
        ip = request.getHeader("X-Forwarded-For");
        if (!StringUtils.isBlank(ip) && !"unknown".equalsIgnoreCase(ip)) {
            // 多次反向代理后会有多个IP值，第一个为真实IP。
            int index = ip.indexOf(',');
            if (index != -1) {
                return ip.substring(0, index);
            } else {
                return ip;
            }
        } else {
            return request.getRemoteAddr();
        }
    }

    public static String enCodeStr(String str) {
        try {
            return new String(str.getBytes("iso-8859-1"), "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean isMobile(String mobileNo) {
            try{
                if(StringUtils.isBlank(mobileNo)){
                    return false;
                }
                //Pattern p = Pattern.compile("^((13[0-9])|(17[678])|(14[57])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$");
                Pattern p = Pattern.compile("^((13[0-9])|(17[678])|(14[57])|(15[^4,\\D])|(18[0-9]))\\d{8}$");
                return  p.matcher(mobileNo).matches();
            }catch (Exception e){
                e.printStackTrace();
            }
            return false;
    }


    public static HttpResponseText httpsRequest(String strUrl) {
        HttpResponseText text=new HttpResponseText();
        HttpsURLConnection conn = null;
        String result="";
        BufferedReader reader=null;
        InputStream in=null;
        try {
            URL url = new URL(strUrl);
            conn = (HttpsURLConnection) url.openConnection();
            conn.setRequestProperty("Content-Type", "plain/text; charset=UTF-8");
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setConnectTimeout(10000);
            conn.setRequestMethod("GET");
            conn.connect();
            conn.getOutputStream().flush();
            conn.getOutputStream().close();
            reader = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
            in = conn.getInputStream();
            int httpCode = conn.getResponseCode();
            text.setHttpCode(httpCode);
            if(httpCode==200){
                    StringBuffer sb = new StringBuffer();
                    String line=null;
                    while((line = reader.readLine())!=null){
                        sb.append(line);
                    }
                    text.setData(sb.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            text.setData(null);
        }
        finally{
            try{
                if(in!=null){
                    in.close();
                }
                if(conn!=null){
                    conn.disconnect();
                }
            }catch (Exception e){
                e.printStackTrace();
            }
        }

        return text;
    }

    public static HttpResponseText httpPost(String strUrl,String jsonStr) {
        HttpResponseText text=new HttpResponseText();
        HttpURLConnection conn=null;
        String result="";
        BufferedReader reader=null;
        try {
            URL url = new URL(strUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestProperty("Content-Type", "plain/text; charset=UTF-8");
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setConnectTimeout(10000);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Connection","keep-alive");

            conn.connect();
            String contentData=jsonStr.toString();
            conn.getOutputStream().write(contentData.getBytes());
            conn.getOutputStream().flush();
            conn.getOutputStream().close();
            reader = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));

            InputStream in = conn.getInputStream();
            int httpCode = conn.getResponseCode();
            text.setHttpCode(httpCode);
            //if(httpCode==200){
            byte[] buffer = new byte[1024];
            StringBuffer sb = new StringBuffer();
            String line=null;
            while((line = reader.readLine())!=null){
                sb.append(line);
            }
            result=sb.toString();
            text.setData(result);
            //}

            in.close();
        } catch (Exception e) {
            e.printStackTrace();
            result = "http error";
            text.setData(e.toString());
        }
        finally{
            if(conn!=null){
                conn.disconnect();
            }
        }
        return text;
    }

    // Map --> Bean 1: 利用Introspector,PropertyDescriptor实现 Map --> Bean  
    public static void transMap2Bean(Map<String, Object> map, Object obj) {  
        try {  
            BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());  
            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();  
  
            for (PropertyDescriptor property : propertyDescriptors) {  
                String key = property.getName();  
                if (map.containsKey(key)) {  
                    Object value = map.get(key);  
                    // 得到property对应的setter方法  
                    Method setter = property.getWriteMethod();  
                    setter.invoke(obj, value);  
                }  
            }  
        } catch (Exception e) {  
            System.out.println("transMap2Bean Error " + e);  
        }  
        return;  
    }  
  
    // Bean --> Map 1: 利用Introspector和PropertyDescriptor 将Bean --> Map  
    public static Map<String, Object> transBean2Map(Object obj) {  
        if(obj == null){  
            return null;  
        }          
        Map<String, Object> map = new HashMap<String, Object>();  
        try {  
            BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());  
            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();  
            for (PropertyDescriptor property : propertyDescriptors) {  
                String key = property.getName();  
                // 过滤class属性  
                if (!key.equals("class")) {  
                    // 得到property对应的getter方法  
                    Method getter = property.getReadMethod();  
                    Object value = getter.invoke(obj);  
                    map.put(key, value);  
                }  
  
            }  
        } catch (Exception e) {  
            System.out.println("transBean2Map Error " + e);  
        }  
        return map;  
    }  

}
