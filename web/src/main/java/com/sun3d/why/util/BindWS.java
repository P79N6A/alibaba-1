package com.sun3d.why.util;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Formatter;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.google.gson.Gson;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.WxInfo;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.webservice.api.util.HttpResponseText;

/**
 * @Description: 微信端接口
 * @author ldq
 */
public class BindWS {
	@Autowired
    private static WxInfo wxInfo;
	@Autowired
    private static HttpSession session;
	@Autowired
    private CacheService cacheService;
	
	private static Logger logger = Logger.getLogger(BindWS.class);
	
	/**
	  * @Fields dateFormat : 日期格式化 
	  */
	private final static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	private static String APPID =WxInfo.getAppId();
	private static String SECRET =WxInfo.getAppSecret();

	/**
	  * @Fields gson : 初始化 Gson 工具 
	  */
	private static Gson gson = new Gson();
	
	/**
	 * 完整地址
	 * @param request
	 * @return
	 */
	public static String getUrl(HttpServletRequest request) {
		String url = request.getScheme() + "://" + request.getServerName();
		if(request.getServerPort() != 80) {
			url += ":"+request.getServerPort() ;
		}
		url += request.getRequestURI();
		if (request.getQueryString() != null && !"".equals(request.getQueryString())) {
			url = url + "?" + request.getQueryString();
		}
		return url;
	}
	
	/**
	 * 相对地址
	 * @param request
	 * @return
	 */
	public static String getRelativeUrl(HttpServletRequest request) {
		String url = request.getRequestURI();
		if (request.getQueryString() != null && !"".equals(request.getQueryString())) {
			url = url + "?" + request.getQueryString();
		}
		return url;
	}
	
	/**
	 * @Description: 处理接口返回字符串"null({\"TSR_MSG\":\"成功！\",\"TSR_RESULT\":\"0\",\"curBill\":\"45.83\"})"
	 * @param @param str
	 * @param @return
	 * @return String
	 * @throws
	 */
	private static String getResult(String str) {
		try {
			if (str.indexOf("null(") == 0 && str.contains("(") && str.contains(")"))
				return str.substring(str.indexOf("(") + 1, str.lastIndexOf(")"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return str;
	}
	
	/**
	  * @Description: 根据code获取access_token
	  * @param code
	  * @return access_token  
	  */
	public static String bindQuery(String code) throws Exception {
		String request;
		Map<String, String> params = new HashMap<String, String>();
		try {
			params.put("appid",APPID);
			params.put("secret",SECRET);
			params.put("code",code);
			params.put("grant_type","authorization_code");
			String result = CallUtils.callUrl4("https://api.weixin.qq.com/sns/oauth2/access_token", params);
			request = getResult(result);
			return request;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	  * @Description: 根据access_token，openid拉取用户信息
	  * @param access_token
	  * @param openid
	  * @return userinfo  
	  */
	public static String bind2Query(String access_token,String openid) throws Exception {
		String request;
		Map<String, String> params = new HashMap<String, String>();
		try {
			params.put("access_token", access_token);
			params.put("openid",openid);
			params.put("lang","zh_CN");
			String result = CallUtils.callUrl4("https://api.weixin.qq.com/sns/userinfo", params);
			request = getResult(result);
			return request;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
   /**
	  * 获取access_token
	  * @return 
	  */
	public static String getAccessToken() throws Exception {
		String request = "";
		Map<String, String> params = new HashMap<String, String>();
		try {
			params.put("appid",APPID);
			params.put("secret",SECRET);
			params.put("grant_type","client_credential");
			String result = CallUtils.callUrl4("https://api.weixin.qq.com/cgi-bin/token", params);
			if(result!=null){
				logger.info("--------------access_token："+result);
				request = result.substring(result.indexOf(":\"") + 2, result.lastIndexOf("\",\""));
			}
			return request;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 解析userinfo
	 * @param userinfo
	 * @return 
	 */
	public static String bindUserInfo(String userinfo) throws Exception {
		userinfo=userinfo.substring(1, userinfo.length() - 1);
		userinfo=userinfo.replaceAll("\"", "");
		String[] strbox1 = userinfo.split(",");
		String str1 = strbox1[1].split(":")[1];//微信昵称
		return str1;
	}
	
	/**
	 * 往redis中存放ACCESS_TOKEN,JS_TOKEN
	 * @param cacheService
	 */
    public static void checkToken(CacheService cacheService){
    	try{
        	//从缓存中取出token的存在时间
        	if(StringUtils.isBlank(cacheService.getValueByKey(SystemContent.ACCESS_TOKEN)) ||
        			StringUtils.isBlank(cacheService.getValueByKey(SystemContent.JS_TOKEN))){
        		//获取过期时间（ACCESS_TOKEN过期时间为2小时，redis过期时间提前60分钟）
        		long curren = System.currentTimeMillis();
        		curren += 60 * 60 * 1000;
        		Date da = new Date(curren);
        	 	String access_token = BindWS.getAccessToken();
        	 	cacheService.setValueToRedis(SystemContent.ACCESS_TOKEN, access_token, da);
        	 	String jsToken = BindWS.getJSToken(access_token);
        	 	cacheService.setValueToRedis(SystemContent.JS_TOKEN, jsToken, da);
	    	}
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    
    /**
	 * 往redis中存放ACCESS_TOKEN,JS_TOKEN（重置用）
	 * @param cacheService
	 */
    public static String resetToken(CacheService cacheService){
    	try{
    		//获取过期时间（ACCESS_TOKEN过期时间为2小时，redis过期时间提前60分钟）
    		long curren = System.currentTimeMillis();
    		curren += 60 * 60 * 1000;
    		Date da = new Date(curren);
    	 	String access_token = BindWS.getAccessToken();
    	 	cacheService.setValueToRedis(SystemContent.ACCESS_TOKEN, access_token, da);
    	 	String jsToken = BindWS.getJSToken(access_token);
    	 	cacheService.setValueToRedis(SystemContent.JS_TOKEN, jsToken, da);
    	 	return "success";
        }catch (Exception e){
            e.printStackTrace();
            return "false";
        }
    }
	
    /**
     * 获取微信配置信息
     * @param url
     * @param cacheService
     * @return
     */
	public static Map<String, String> sign(String url,CacheService cacheService) {
		//检测access_token
		checkToken(cacheService);
		//取出token
    	String jsapi_ticket = (String)cacheService.getValueByKey(SystemContent.JS_TOKEN);
    	logger.info("--------------jsapi_ticket："+jsapi_ticket);
        Map<String, String> ret = new HashMap<String, String>();
        String nonce_str = RandomStringGenerator.getRandomStringByLength(32);
        String timestamp = create_timestamp();
        String string1;
        String signature = "";

        //注意这里参数名必须全部小写，且必须有序
        string1 = "jsapi_ticket=" + jsapi_ticket +
                  "&noncestr=" + nonce_str +
                  "&timestamp=" + timestamp +
                  "&url=" + url;
		try{
            MessageDigest crypt = MessageDigest.getInstance("SHA-1");
            crypt.reset();
            crypt.update(string1.getBytes("UTF-8"));
            signature = byteToHex(crypt.digest());
        }catch (Exception e){
            e.printStackTrace();
        }
        ret.put("appId", APPID);
        ret.put("url", url);
        ret.put("jsapi_ticket", jsapi_ticket);
        ret.put("nonceStr", nonce_str);
        ret.put("timestamp", timestamp);
        ret.put("signature", signature);
        return ret;
    }
	
	/**
	 * 获取js_token
	 * @param access_token
	 * @return  
	 */
	public static String getJSToken(String access_token) throws Exception {
		String request;
		Map<String, String> params = new HashMap<String, String>();
		try {
			params.put("access_token",access_token);
			params.put("type","jsapi");
			String result = CallUtils.callUrl4("https://api.weixin.qq.com/cgi-bin/ticket/getticket", params);
			request = result.substring(result.indexOf("ticket") + 9, result.lastIndexOf("\",\""));
			logger.info("--------------js_token："+result);
			return request;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private static String byteToHex(final byte[] hash) {
	   Formatter formatter = new Formatter();
	   for (byte b : hash)
	   {
	       formatter.format("%02x", b);
	   }
	   String result = formatter.toString();
	   formatter.close();
	   return result;
	}
	
	//当前时间戳
	private static String create_timestamp() {
	   return Long.toString(System.currentTimeMillis() / 1000);
	}
	
	/**
	 * wechat上传图片到服务器
	 * @param mediaId
	 * @param updateTerminalUser
	 * @param cacheService
	 * @param basePath
	 * @return
	 */
	public static String wcUpload(String mediaId,CmsTerminalUser terminalUser,CacheService cacheService,BasePath basePath,String uploadType){
		//检测access_token
		checkToken(cacheService);
		String accessToken = cacheService.getValueByKey(SystemContent.ACCESS_TOKEN);
		InputStream is = null;
		String url = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=" + accessToken + "&media_id=" + mediaId;
		//String url = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=MXdU4cGuyxuR0o0bq1-9IV44WwljB37frRFDukbyc6ODLViBfYv1a0TMR3kBN5BfdKjKaMAtdhwf97jqOneGkmiFheG6n7IxEbHojad9DWYXqPgNwy0EJE84hEuvWhgkTCGdACAPYC&media_id=Y5uPNFpJx29c8Ams5VeuIp55IlWOm2L_A7D8DR8DzOecAeejDrZWIIHptWKv7qF1";
		System.out.println(url);
		String result = "";
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet.openConnection();
			http.setRequestMethod("GET"); // 必须是get方式请求
			http.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");// 连接超时30秒
			System.setProperty("sun.net.client.defaultReadTimeout", "30000"); // 读取超时30秒
			http.connect();
			// 获取文件转化为byte流
			is = http.getInputStream();
			result = saveImageToDisk(is,basePath,terminalUser,uploadType);
			if(result.equals("1")){
				try {
					long curren = System.currentTimeMillis();
					curren += 60 * 60 * 1000;
					Date da = new Date(curren);
					String access_token = BindWS.getAccessToken();
					cacheService.setValueToRedis(SystemContent.ACCESS_TOKEN, access_token, da);
				} catch (Exception e1) {
					e1.printStackTrace();
					return "1";
				}
			}
		} catch (IOException e) {
            e.printStackTrace();
            return "1";
        } catch (Exception e) {
			e.printStackTrace();
			//重新获取accessToken
			try {
				long curren = System.currentTimeMillis();
				curren += 60 * 60 * 1000;
				Date da = new Date(curren);
				String access_token = BindWS.getAccessToken();
				cacheService.setValueToRedis(SystemContent.ACCESS_TOKEN, access_token, da);
			} catch (Exception e1) {
				e1.printStackTrace();
				return "1";
			}
			return "1";
		}
		return result;
	}
	
	//保存图片到本地服务器
	public static String saveImageToDisk(InputStream is,BasePath basePath,CmsTerminalUser terminalUser,String uploadType){
		byte[] data = new byte[1024];
	    int len = 0;
	    
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        
	    String newName = Constant.IMG + UUIDUtils.createUUId();
	    
        StringBuffer uploadCode=new StringBuffer();		//拼接图片路径
        uploadCode.append(Constant.type_front + "/");
        if(terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
            uploadCode.append(terminalUser.getUserMobileNo().substring(0, 7)+"/");
        }else {
            uploadCode.append("0000000"+"/");
        }
        uploadCode.append(sdf.format(new Date()));
        uploadCode.append("/" + Constant.IMG);
        
        StringBuffer dirPath = new StringBuffer();		//返回地址
        dirPath.append(uploadCode.toString());
        dirPath.append(File.separator);
        dirPath.append(newName);
        dirPath.append(".jpg");
        
	    StringBuffer filePath = new StringBuffer();
        StringBuffer fullFilePath = new StringBuffer();
        filePath.append(basePath.getBasePath());
        filePath.append(uploadCode.toString());
        filePath.append(File.separator);
        fullFilePath.append(filePath.toString());
        fullFilePath.append(newName);
        String imagePath = fullFilePath.toString();		//压缩路径（不含后缀）
        fullFilePath.append(".jpg");

        File file = new File(filePath.toString());
		if (!file.exists()) {
            file.mkdirs();
        }
	    
		FileOutputStream fileOutputStream = null;
        try {
        	File newFile = new File(fullFilePath.toString());
            fileOutputStream = new FileOutputStream(newFile);
            while ((len = is.read(data)) != -1) {
               fileOutputStream.write(data, 0, len);
            }
            zoomFile(newFile,imagePath,uploadType);
            return dirPath.toString();
        } catch (IOException e) {
            e.printStackTrace();
            return "1";
        }catch (Exception e) {
			e.printStackTrace();
			return "1";
		} finally {
            if (is != null) {
               try {
                   is.close();
               } catch (IOException e) {
                   e.printStackTrace();
               }
            }
            if (fileOutputStream != null) {
               try {
                   fileOutputStream.close();
               } catch (IOException e) {
                   e.printStackTrace();
               }
            }
        }
	}
	
	public static void zoomFile(File newFile,String imagePath,String uploadType) throws Exception{
		BufferedImage src = javax.imageio.ImageIO.read(newFile);
		// 拼接图片绝对路径
		String imageNewPath = imagePath + ".jpg";
		InputStream is = new FileInputStream(imageNewPath);
		BufferedImage buff = ImageIO.read(is);
		int width = buff.getWidth();// 得到图片的宽度
		int height = buff.getHeight(); // 得到图片的高度

		String fileNameSmall = imagePath + "_300_300" + ".jpg";
		String fileNameBig = imagePath + "_750_500" + ".jpg";
		String fileNameSmallApp = imagePath + "_72_72" + ".jpg";
		String fileNameMidApp = imagePath + "_150_150" + ".jpg";
		String fileNameBigApp = imagePath + "_200_100" + ".jpg";
		String fileNameSeries = imagePath + "_360_360" + ".jpg";

		// 根据宽度的比例进行修改高度
		float blSmall = (float) 300 / (float) width;
		float newSmallHeight = (float) (blSmall * (float) height);
		float blBig = (float) 750 / (float) width;
		float newBigHeight = (float) (blBig * (float) height);
		float blSmallApp = (float) 72 / (float) width;
		float newSmallHeightApp = (float) (blSmallApp * (float) height);
		float blMidApp = (float) 150 / (float) width;
		float newMidHeightApp = (float) (blMidApp * (float) height);
		float blBigApp = (float) 200 / (float) width;
		float newBigHeightApp = (float) (blBigApp * (float) height);
		float blSeries = (float) 360 / (float) width;
		float newSeriesHeight = (float) (blSeries * (float) height);
		is.close();
		if(uploadType.equals("1")){		//系列活动
			String imgPathSeries = UploadFile.resizeImage(src, fileNameSeries, 360, newSeriesHeight);
		}else if(uploadType.equals("2")){	//身份证/资质认证
			String imgPathBig = UploadFile.resizeImage(src, fileNameBig, 750, newBigHeight);
			String imgPathSmall = UploadFile.resizeImage(src, fileNameSmall, 300, newSmallHeight);
			String imgPathMidApp = UploadFile.resizeImage(src, fileNameMidApp, 150, newMidHeightApp);
		}else if(uploadType.equals("3")){	//头像
			String imgPathSmall = UploadFile.resizeImage(src, fileNameSmall, 300, newSmallHeight);
			String imgPathSmallApp = UploadFile.resizeImage(src, fileNameSmallApp, 72, newSmallHeightApp);
			String imgPathMidApp = UploadFile.resizeImage(src, fileNameMidApp, 150, newMidHeightApp);
		}else{
			String imgPathSmall = UploadFile.resizeImage(src, fileNameSmall, 300, newSmallHeight);
			String imgPathBig = UploadFile.resizeImage(src, fileNameBig, 750, newBigHeight);
			String imgPathSmallApp = UploadFile.resizeImage(src, fileNameSmallApp, 72, newSmallHeightApp);
			String imgPathMidApp = UploadFile.resizeImage(src, fileNameMidApp, 150, newMidHeightApp);
			String imgPathBigApp = UploadFile.resizeImage(src, fileNameBigApp, 200, newBigHeightApp);
		}
	}
	
	/**
	  * 获取永久素材列表（根据mediaId）
	  * @return 
	  */
	public static HttpResponseText getMaterialList(CacheService cacheService,String mediaId) throws Exception {
		//检测access_token
		checkToken(cacheService);
		String accessToken = cacheService.getValueByKey(SystemContent.ACCESS_TOKEN);
		try {
			String jsonStr = "{\"media_id\":\""+mediaId+"\"}";	//指定素材
			HttpResponseText res = CallUtils.callUrlHttpsPost("https://api.weixin.qq.com/cgi-bin/material/get_material?access_token="+accessToken, jsonStr);
			return res;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	  * 获取永久素材列表（根据type）
	  * @return 
	  */
	public static HttpResponseText getMaterialList(String accessToken,String type,String offset,String count) throws Exception {
		try {
			String jsonStr = "{\"type\":\""+type+"\",\"offset\":"+offset+",\"count\":"+count+"}";	//指定素材
			HttpResponseText res = CallUtils.callUrlHttpsPost("https://api.weixin.qq.com/cgi-bin/material/batchget_material?access_token="+accessToken, jsonStr);
			return res;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
}
