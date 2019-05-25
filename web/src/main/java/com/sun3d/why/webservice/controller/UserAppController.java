package com.sun3d.why.webservice.controller;
import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.AppImageWithStartMapper;
import com.sun3d.why.model.AppImageWithStart;
import com.sun3d.why.model.CmsFeedback;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;
import com.sun3d.why.webservice.service.CmsFeedbackService;
import com.sun3d.why.webservice.service.TerminalUserAppService;

/**
 * 手机app接口 用户列表
 * Created by Administrator on 2015/7/4
 *
 */
@RequestMapping("/appUser")
@Controller
public class UserAppController {
    private Logger logger = Logger.getLogger(UserAppController.class);
    @Autowired
    private CmsFeedbackService cmsFeedbackService;
    @Autowired
    private TerminalUserAppService terminalUserAppService;

    @Autowired
    private StaticServer staticServer;

    @Autowired
    private SyncCmsTerminalUserService syncCmsTerminalUserService;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    
    @Autowired
	private AppImageWithStartMapper startMapper;
	 
    /**
     * app用户上传文件公共接口
     * @param userId 用户id
     * @param uploadType   上传类型 1.多文件 2.用户头像 3.团体用户 4.玩家秀
     * @param modelType  模块类型类型 2.个人头像 3.多图片(评论)
     * @param teamUserId   团体id
     * @return json 10111 用户不存在  10112.不能匹配正在上传的文件，上传处理终止!
     */
    @RequestMapping(value = "/uploadAppFiles")
    public String uploadAppFiles(@RequestParam("file") MultipartFile mulFile,String userId,String uploadType,String modelType, String teamUserId,HttpServletResponse response) throws Exception {
            String json="";
        try {
            json=terminalUserAppService.queryTerminalUserFilesById(userId,teamUserId,mulFile,uploadType, modelType);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("upload Files error"+e.getMessage());
        }
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app修改用户信息 根据用户id
     * @param terminalUser 用户对象
     * @return json 10111:用户id不存在 13108.查无此人 0.更新成功 1.更新失败
     */
    @RequestMapping(value = "/editTerminalUser")
    public String editTerminalUser(HttpServletResponse response,CmsTerminalUser terminalUser) throws Exception {
        String json="";
        try{
            if(terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserId())){
                CmsTerminalUser updateTerminalUser = terminalUserAppService.queryTerminalUserByUserId(terminalUser.getUserId());

                json=terminalUserAppService.editTerminalUserById(updateTerminalUser,terminalUser);
            }else{
                json=JSONResponse.commonResultFormat(10111,"用户id缺失",null);
            }
        }catch (Exception e){
              e.printStackTrace();
              logger.info("edit terminalUserInformation error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app绑定手机号码
     * @param userId 用户id
     */
    @RequestMapping(value = "/appSendCode")
    public String appSendCode( HttpServletResponse response,String userId,String userMobileNo) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(userId)) {
                if(Constant.isMobile(userMobileNo)){
                    json=terminalUserAppService.bindingMobileNo(userId,userMobileNo);
                }else {
                    json=JSONResponse.commonResultFormat(10222,"手机号码不规范!",null);
                }
            }
            else {
                json=JSONResponse.commonResultFormat(10111,"用户id参数缺失!",null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }


    /**
     * app绑定手机时验证手机号与验证码是不是一致（该接口已废弃）
     * @param cmsTerminalUser  用户对象
     * @return json 10111用户不存在 10119手机验证码错误 0手机号码确定成功
     */
    @RequestMapping(value = "/appValidateCode")
    public String appValidateCode(CmsTerminalUser cmsTerminalUser,HttpServletResponse response) throws Exception {
        String json="";
        try{
            if(cmsTerminalUser!=null){
                //json=terminalUserAppService.queryAppValidateCode(cmsTerminalUser);
            }
            else{
                json=JSONResponse.commonResultFormat(10111,"用户不存在!",null);
            }
        }
        catch (Exception e){
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }
    /**
     *app修改用户密码
     *@param password  用户原密码
     *@param newPassword 用户新密码
     *@param userId 用户id
     * return json 0.更新成功 10120.原密码错误
     */
    @RequestMapping(value = "/appValidatePwd")
    public String appValidatePwd(HttpServletResponse response,String userId,String password,String newPassword) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(userId) && userId!=null) {
                //根据用户id查询用户对象
                CmsTerminalUser updateTerminalUser = terminalUserAppService.queryTerminalUserByUserId(userId);
                json=terminalUserAppService.editTerminalUserPwdById(updateTerminalUser, password, newPassword);
            }else {
                json=JSONResponse.commonResultFormat(10111,"用户id参数缺失!",null);
            }
        }catch (Exception e){
            logger.info("系统出错!");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     *app用户反馈信息
     *@param cmsFeedback 反馈对象
     * return json 0.添加成功
     */
    @RequestMapping(value = "/appFeedInformation")
    public String appFeedInformation(HttpServletResponse response,CmsFeedback cmsFeedback) throws Exception {
        int count=0;
        String json="";
        String feedImgUrl="";
        if(cmsFeedback!=null){
            if(cmsFeedback.getFeedImgUrl()!=null && StringUtils.isNotBlank(cmsFeedback.getFeedImgUrl())){
                String[] feedImgUrls=cmsFeedback.getFeedImgUrl().split(";");
                for(String imgUrls:feedImgUrls){
                    int index=imgUrls.indexOf("front");
                    feedImgUrl += imgUrls.substring(index,imgUrls.length())+ ";";
                }
                feedImgUrl=feedImgUrl.substring(0,feedImgUrl.length() - 1);
                cmsFeedback.setFeedImgUrl(feedImgUrl.toString());
                cmsFeedback.setFeedContent(EmojiFilter.filterEmoji(cmsFeedback.getFeedContent()));
            }
            count=cmsFeedbackService.insertFeedInformation(cmsFeedback);
        }else {
            json=JSONResponse.commonResultFormat(10111,"用户id或反馈内容为空!",null);
        }
        if(count>0){
            json=JSONResponse.commonResultFormat(0,"添加反馈信息成功!",null);
        }else {
            json=JSONResponse.commonResultFormat(1,"添加反馈信息失败!",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app获取用户反馈列表
     * @param userId 用户id
     * @param pageIndex 首页下表
     * @param pageNum 显示条数
     * @return json 10101:用户id缺失
     */
    @RequestMapping(value = "/appFeedInformationIndex")
    public String queryAppFeedInformationIndex(HttpServletResponse response,String userId,String pageIndex,String pageNum, PaginationApp pageApp) throws Exception {
        String json="";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if(userId!=null && StringUtils.isNotBlank(userId)){
                json=cmsFeedbackService.queryAppFeedInformationListById(userId, pageApp);
            }
            else {
                json=JSONResponse.commonResultFormat(10101,"用户id缺失",null);
            }
        }catch (Exception e){
            e.printStackTrace();
            logger.info("query FeedInformation error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app根据用户id返回用户信息
     * @param userId 用户id
     * @return json 10111 用户id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/queryTerminalUserById")
    public String queryTerminalUserById(HttpServletResponse response,String userId) throws Exception {
        String json="";
       try {
           if(userId!=null && StringUtils.isNotBlank(userId)){
               json=terminalUserAppService.queryCmsTerminalUserById(userId);
           }else {
               json=JSONResponse.commonResultFormat(10111,"用户id为空!",null);
           }
        }catch (Exception e){
         e.printStackTrace();
         logger.info("query terminalUser error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app绑定邮箱
     * @param terminalUser 用户对象
     * @return json 0 绑定邮箱成功  1绑定邮箱失败  14144 用户名或邮箱参数缺失
     * @throws Exception
     */
    @RequestMapping(value = "/editTerminalUserByMail")
    public String editTerminalUserByMail(HttpServletResponse response,CmsTerminalUser terminalUser) throws Exception {
        String json="";
        if(StringUtils.isNotBlank(terminalUser.getUserEmail()) && StringUtils.isNotBlank(terminalUser.getUserId())){
            //根据用户id查询用户对象
            CmsTerminalUser updateTerminalUser = terminalUserAppService.queryTerminalUserByUserId(terminalUser.getUserId());
            json=terminalUserAppService.editTerminalUserById(updateTerminalUser,terminalUser);
        }else {
            json=JSONResponse.commonResultFormat(14144,"用户名或邮箱参数缺失!",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * app手机号码验证用户是否已注册
     * @param userMobileNo 用户手机号码
     * @return json 0 发送消息成功  1 发送消息失败  14141 手机号码未注册 13106发送次数超过3次 14144手机号码不存在
     * @throws Exception
     */
    @RequestMapping(value = "/editTerminalUserByMobile")
    public String editTerminalUserByMobile(HttpServletResponse response,String userMobileNo) throws Exception {
        String json="";
        if(StringUtils.isNotBlank(userMobileNo)&& userMobileNo!=null){
            json=terminalUserAppService.queryTerminalUserByMobileNo(userMobileNo);
        }else{
            json=JSONResponse.commonResultFormat(14144,"手机号码不存在",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app找回密码
     * @param userMobileNo 用户号码
     * @param newPassword 新密码
     * @param code 验证码
     * @return 14145手机号码或新密码参数缺失  14141手机号码未注册 14146密码与原密码相同 0找回密码成功 14147验证码错误
     * @throws Exception
     */
    @RequestMapping(value = "/editTerminalUserByPwd")
    public String editTerminalUserByPwd(HttpServletResponse response,String userMobileNo,String newPassword,String code) throws Exception {
        String json="";
        if(StringUtils.isNotBlank(userMobileNo) && StringUtils.isNotBlank(newPassword)){
            json=terminalUserAppService.queryTerminalUserByMobile(userMobileNo,newPassword,code);
        }
        else{
            json=JSONResponse.commonResultFormat(14145,"手机号码或新密码参数缺失",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app绑定第三方账号
     * @param userId 用户id
     * @param openId  第三方登陆openid
     * @param register_type 1 文化云 2 QQ 3 新浪微博 4 微信
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/BindingAccount")
    public String BindingAccount(HttpServletResponse response,String userId,String openId,String register_type) throws Exception {
        String json="";
        if(StringUtils.isNotBlank(userId)&&userId!=null){
            json=terminalUserAppService.queryTerminalUserById(userId,openId,register_type);
        }else {
            json=JSONResponse.commonResultFormat(10111,"用户id为空!",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 判断app版本号，是否需要更新版本
     * @param response
     * @param mobileType 1-ios 2-android
     * @param versionNo app应用版本号
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/checkAppVersionNo")
    public String checkAppVersionNo(HttpServletRequest request,HttpServletResponse response,String mobileType,String versionNo) throws Exception {
    	JSONObject json = new JSONObject();
    	Map<String,Object> map = new HashMap<String,Object>(); 
        try {
        	String userId = request.getHeader("sysUserId");
        	if(StringUtils.isNotBlank(userId)){
				userIntegralDetailService.checkDayIntegral(userId);
			}
        	
			if(StringUtils.isNotBlank(mobileType) && StringUtils.isNotBlank(versionNo)){
				versionNo=versionNo.replaceAll("\\.","");
				versionNo=versionNo.substring(1,versionNo.length());
				int versionNoNum=Integer.valueOf(versionNo);
				
				String nowIosVersion=staticServer.getAppVersionNo().split(";")[0];
				nowIosVersion=nowIosVersion.replaceAll("\\.","");
				nowIosVersion=nowIosVersion.substring(1,nowIosVersion.length());
				int nowIosVersionNo=Integer.valueOf(nowIosVersion);
				
				String nowAndroidVersion=staticServer.getAppVersionNo().split(";")[1];
				nowAndroidVersion=nowAndroidVersion.replaceAll("\\.","");
				nowAndroidVersion=nowAndroidVersion.substring(1,nowAndroidVersion.length());
				int nowAndroidVersionNo=Integer.valueOf(nowAndroidVersion);
				
			    if("1".equals(mobileType)){
			    	json.put("status", 200);
			    	map.put("updateVersion", staticServer.getAppVersionNo().split(";")[0]);
			        if(versionNoNum>=nowIosVersionNo){
			        	map.put("updateType", 0);
			        	map.put("msg", "无需更新!");
			        }else{
			        	map.put("msg", staticServer.getAppUpdateType().equals("1")?"普通更新!":"强制更新!");
			        	map.put("updateType", staticServer.getAppUpdateType());
			        	map.put("updateLink", staticServer.getAppIosUrl());
			        	map.put("updateDescription", new String(staticServer.getAppVersionDescription().getBytes("ISO-8859-1"), "gbk"));
			        }
			    }else if("2".equals(mobileType)){
			    	json.put("status", 200);
			    	map.put("updateVersion", staticServer.getAppVersionNo().split(";")[1]);
					if(versionNoNum>=nowAndroidVersionNo){
						map.put("updateType", 0);
						map.put("msg", "无需更新!");
					}else{
						map.put("msg", staticServer.getAppUpdateType().equals("1")?"普通更新!":"强制更新!");
						map.put("updateType", staticServer.getAppUpdateType());
						map.put("updateLink", staticServer.getAppAndroidUrl());
						map.put("updateDescription", new String(staticServer.getAppVersionDescription().getBytes("ISO-8859-1"), "gbk"));
					}
			    }else{
			    	json.put("status", 500);
			    	map.put("msg", "手机类型传参错误!");
			    }
			}else {
				json.put("status", 500);
				map.put("msg", "手机类型或版本号缺失!");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json.put("status", 500);
			map.put("msg", e.getMessage());
		}
        json.put("data", map);
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json.toString());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app获取开机页图片
     * @return
     */
    @RequestMapping(value = "/getMobileImage")
    public String getMobileImage(HttpServletResponse response,HttpServletRequest request, String height, String width,String cityCode)throws Exception{
        String json = "";
        try{
            if(StringUtils.isBlank(width) || StringUtils.isBlank(height)){
                json = JSONResponse.toAppResultFormat(300, "宽度或高度缺失");
            }else{
            	AppImageWithStart startupImg = startMapper.queryStartupImg();
        		String imageurlRetina = startupImg.getImageurlRetina();
        		String imageurlNormal = startupImg.getImageurlNormal();
        		if (StringUtils.isNotBlank(imageurlRetina)) {
                	if(imageurlRetina.indexOf("http:")>-1)
                	imageurlRetina = startupImg.getImageurlRetina();
                	else
                    imageurlRetina = staticServer.getStaticServerUrl() + imageurlRetina;
                }
        		if (StringUtils.isNotBlank(imageurlNormal)) {
                	if(imageurlNormal.indexOf("http:")>-1)
                	imageurlNormal = startupImg.getImageurlNormal();
                	else
                	imageurlNormal = staticServer.getStaticServerUrl() + imageurlNormal;
                }
        		JSONObject jsonObject = new JSONObject();
        		jsonObject.put("imageurlRetina", imageurlRetina);
        		jsonObject.put("imageurlNormal", imageurlNormal);
        		if(width.equals("1242")){
        			json = JSONResponse.toAppResultFormat(100,imageurlRetina);
        		}
        		if(width.equals("640")){
        			json = JSONResponse.toAppResultFormat(100,imageurlNormal);
        		}
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(500, "服务器响应失败");
            e.printStackTrace();
            logger.info("query getMobileImage error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 3.5.2 app 用户近30天积分列表
     * 
     * @param response
     * @param userId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/appUserIntegralDetail")
    public String queryUserIntegralDetail( PaginationApp pageApp,Integer pageIndex,Integer pageNum,HttpServletResponse response,String userId)throws Exception
    {
    	 String json="";
    	 try {
             if (StringUtils.isNotBlank(userId) ) {
            	 if (pageIndex != null && pageNum != null) {
 					pageApp.setFirstResult(Integer.valueOf(pageIndex));
 					pageApp.setRows(Integer.valueOf(pageNum));
 				}

 				Calendar calendar = Calendar.getInstance();
 				calendar.setTime(new Date());
 				calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 30);
 				Date beforeDate = calendar.getTime();

 				json = terminalUserAppService.queryUserIntegralDetail(pageApp, userId, beforeDate);
             } else {
                json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
             }
         } catch (Exception e) {
             e.printStackTrace();
             logger.info("appUserIntegralDetail error"+e.getMessage());
         }
    	 response.setContentType("text/html;charset=UTF-8");
         response.getWriter().print(json);
         response.getWriter().flush();
         response.getWriter().close();
         return null; 
    }
    
    /**
     * 3.5.2 app 用户详细积分列表
     * 
     * @param response
     * @param userId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/appUserIntegralDetailList")
    public String queryUserIntegralDetailList( PaginationApp pageApp,Integer pageIndex,Integer pageNum,HttpServletResponse response,String userId)throws Exception
    {
    	String json="";
   	 	try {
            if (StringUtils.isNotBlank(userId) ) {
            	if (pageIndex != null && pageNum != null) {
					pageApp.setFirstResult(Integer.valueOf(pageIndex));
					pageApp.setRows(Integer.valueOf(pageNum));
				}

				json = terminalUserAppService.queryUserIntegralDetail(pageApp, userId, null);
            } else {
               json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("appUserIntegralDetailList error"+e.getMessage());
        }
   	 	response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;  
    }
    
    /**
     * 实名认证 发送验证码
     * @param userId 用户id
     */
    @RequestMapping(value = "/sendAuthCode")
    public String sendAuthCode( HttpServletResponse response,String userId,String userMobileNo) throws Exception {
        String json="";
        try {
            if(StringUtils.isNotBlank(userId)) {
                if(Constant.isMobile(userMobileNo)){
                	 CmsTerminalUser terminalUser = terminalUserAppService.queryTerminalUserByUserId(userId);
                	
                    json=terminalUserAppService.sendAuthCode(terminalUser,userMobileNo);
                }else {
                    json=JSONResponse.commonResultFormat(10222,"手机号码不规范!",null);
                }
            }
            else {
                json=JSONResponse.commonResultFormat(10111,"用户id参数缺失!",null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }
    
    /**
     *  用户实名认证
     * 
     * @param userId
     * @param realName
     * @param code
     * @param idCardNo
     * @param idCardPhotoUrl
     * @return
     * @throws IOException 
     */
    @RequestMapping(value = "/userAuth")
    public String userAuth(HttpServletResponse response, String userId,
    						    String nickName,
    						    String userTelephone,
    						    String code,
    						    String idCardNo,
    						    String idCardPhotoUrl,String userEmail) throws IOException
    {
    	
    	String json="";
    	
        try {
        	
        	json=terminalUserAppService.userAuth(userId, nickName,userTelephone, code, idCardNo, idCardPhotoUrl,userEmail);
        	
        }catch (Exception e) {
            json = JSONResponse.toAppResultFormat(10112, e.getMessage());
            logger.info("实名认证失败 error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
     
        return null;
    }
    
    /**
     * 转发添加积分
     * 
     * @param response
     * @param userId
     * @param url
     * @return
     * @throws IOException 
     */
    @RequestMapping(value = "/forwardingIntegral")
    public String forwardingIntegral(HttpServletResponse response,@RequestParam String userId,@RequestParam String shareLink) throws IOException{
    	String json="";
    	try {
    		if(userId != null){
    			userIntegralDetailService.forwardAddIntegral(userId, shareLink);
                json = JSONResponse.toAppResultFormat(200, "请求成功");
    		}else{
    			json = JSONResponse.toAppResultFormat(500, "参数缺失");
    		}
    	}catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10112, e.getMessage());
			logger.info("转发添加积分失败 error"+e.getMessage());
        }
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
}