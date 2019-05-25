package com.sun3d.why.controller.wechat;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.request.advert.GetAdvertVO;
import com.sun3d.why.controller.wechat.service.CoreService;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserTag;
import com.sun3d.why.model.ccp.CcpAdvertRecommend;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.extmodel.WxInfo;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpAdvertRecommendService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.BaseUtils;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CommonUtil;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.SystemContent;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.ActivityAppService;
import com.sun3d.why.webservice.service.AdvertService;
import com.sun3d.why.webservice.service.CollectAppService;
import com.sun3d.why.webservice.service.CommentAppService;
import com.sun3d.why.webservice.service.TagAppService;
import com.sun3d.why.webservice.service.TerminalUserAppService;
import com.sun3d.why.webservice.service.VenueAppService;

@RequestMapping("/wechat")
@Controller
public class WechatController {

    @Autowired
    private HttpSession session;
    @Autowired
    private WxInfo wxToken;
    @Autowired
    private CacheService cacheService;
    @Autowired
    private CoreService coreService;
    @Autowired
    private CmsActivityService activityService;
    @Autowired
    private ActivityAppService activityAppService;
    @Autowired
    private VenueAppService venueAppService;
    @Autowired
    private AdvertService advertAppService;
    @Autowired
    private CommentAppService commentAppService;
    @Autowired
    private TagAppService tagAppService;
    @Autowired
    private TerminalUserAppService terminalUserAppService;
    @Autowired
    private CmsTerminalUserService terminalUserService;
    @Autowired
    private CcpAdvertRecommendService advertRecommendService;
    @Autowired
	private CollectAppService collectAppService;
    @Autowired
    private BasePath basePath;
    @Autowired
    private StaticServer staticServer;

    private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
    private Logger logger = LoggerFactory.getLogger(WechatController.class);

    /**
     * @param @param  signature 微信加密签名，signature结合了开发者填写的token参数和请求中的timestamp参数、nonce参数。
     * @param @param  timestamp 时间戳
     * @param @param  nonce 随机数
     * @param @param  echostr 随机字符串
     * @param @return
     * @return String
     * @throws
     * @Description: 微信认证
     */
    @RequestMapping(value = "/token")
    public String token(String signature, String timestamp, String nonce, String echostr, HttpServletResponse response) {
        try {
            logger.info("wechat sign：" + dateFormat.format(new Date()));
            logger.info("signature：" + signature);
            logger.info("timestamp：" + timestamp);
            logger.info("nonce：" + nonce);
            logger.info("echostr：" + echostr);

            /**
             * 加密/校验流程如下：
             * 1. 将token、timestamp、nonce三个参数进行字典序排序
             * 2. 将三个参数字符串拼接成一个字符串进行sha1加密
             * 3. 开发者获得加密后的字符串可与signature对比，标识该请求来源于微信
             * */

            String[] array = new String[]{wxToken.getWxToken(), timestamp, nonce};
            array = BaseUtils.bubbleSort(array);
            StringBuilder str = new StringBuilder();
            for (String s : array) {
                str.append(s);
            }

            String signature2 = BaseUtils.sha(str.toString());
            logger.info("signature2：" + signature2);
            if (signature.equals(signature2)) {
                response.getWriter().write(echostr);
            } else {
                response.getWriter().write(echostr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * @param @param  requestbody
     * @param @param  request
     * @param @param  response
     * @param @throws IOException
     * @return void
     * @throws
     * @Description: 微信传递信息
     */
    @ResponseBody
    @RequestMapping(value = "/token", method = RequestMethod.POST)
    public void postInfo(@RequestBody String requestbody, HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 将请求、响应的编码均设置为UTF-8（防止中文乱码）
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // 调用核心业务类接收消息、处理消息
        // requestbody需要进行中文转码
//		String respMessage = coreService.processRequest(request, new String(requestbody.getBytes("ISO-8859-1"), "UTF-8"));
        String respMessage = coreService.processRequest(request, requestbody);
        if(respMessage==null){
        	return;
        }
        logger.info(respMessage);
        // 响应消息
        PrintWriter out = response.getWriter();
        out.print(respMessage);
        out.flush();
        out.close();
    }

    /**
     * 微信引导页
     *
     * @return
     */
    @RequestMapping("/open")
    public String open() {
        return "wechat/open";
    }

    /**
     * 跳转到修改微信引导页
     * @param request
     * @param type	回调地址
     * @return
     */
    @RequestMapping("/openEdit")
    public String openEdit(HttpServletRequest request,String type) {
    	request.setAttribute("type", type);
        return "wechat/openEdit";
    }

    /**
     * 微信引导页保存标签
     * @param userSelectTag 
     * return
     */
    @RequestMapping(value = "/wcEditUser")
    @ResponseBody
    public Map<String, Object> wcEditUser(CmsUserTag cmsUsertag) {
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
            if (user != null) {
                if (cmsUsertag != null && StringUtils.isNotBlank(cmsUsertag.getUserSelectTag())) {

                    //保存用户选择类型
                    cmsUsertag.setUserId(user.getUserId());
                    String json = tagAppService.addUserTags(cmsUsertag);
                    JSONObject obj = JSONObject.fromObject(json);
                    String status = obj.getString("status");

                    if (status.equals("0")) {
                        //用户选择类型存储session
                        user.setActivityThemeTagId(cmsUsertag.getUserSelectTag());
                        session.setAttribute("terminalUser", user);
                        map.put("result", "success");
                    } else {
                        map.put("result", "false");
                    }
                } else {
                    map.put("result", "false");
                }
            } else {
                map.put("result", "false");
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("result", "false");
        }
        return map;
    }

    /**
     * 微信首页
     * @return
     * @throws UnsupportedEncodingException 
     */
    @RequestMapping("/index")
    public String index(HttpServletRequest request) throws UnsupportedEncodingException {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("cityName", staticServer.getCityInfo().split(",")[1]);
        return "wechat/index";
    }

    /**
     * 微信首页根据不同标签推荐活动列表
     *
     * @param Lon       用户经度
     * @param Lat       用户纬度
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     *                  return json     10125系统错误
     */
    @RequestMapping(value = "/activityListIndex")
    public String activityListIndex(String Lon, String Lat, HttpServletResponse response, String pageIndex, String pageNum, PaginationApp pageApp) throws Exception {
        try {
            pageApp.setFirstResult(Integer.valueOf(pageIndex));
            pageApp.setRows(Integer.valueOf(pageNum));
            String json = activityAppService.queryAppActivityList(pageApp, Lon, Lat, Constant.FREE_ACTIVITY, Constant.CHILDREN_ACTIVITY, Constant.WHERE_ACTIVITY);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(json);
            response.getWriter().flush();
            response.getWriter().close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("错误:" + e.toString());
        }

        return null;
    }

    /**
     * weChat首页banner轮播图
     *
     * @return 13108 推荐条数缺失
     */
    @RequestMapping(value = "/wcActivityBanner")
    public String wcActivityBanner(HttpServletResponse response, int type) throws Exception {
        String json = advertAppService.queryAppAdvertBySite(type);
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 跳转到评论添加页面
     *
     * @return
     */
    @RequestMapping(value = "/preAddWcComment")
    public String preAddWcComment(HttpServletRequest request, String moldId, String type, String culturalOrderLargeType) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("moldId", moldId);
        request.setAttribute("type", type);
        request.setAttribute("culturalOrderLargeType", culturalOrderLargeType);
        return "wechat/comment/commentAdd";
    }

    /**
     * 跳转到评论列表
     *
     * @return
     */
    @RequestMapping(value = "/preWcCommentList")
    public String preWcCommentList(HttpServletRequest request, String moldId, String type) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("moldId", moldId);
        request.setAttribute("type", type);
        return "wechat/comment/commentList";
    }

    /**
     * wechat添加评论
     *
     * @param comment 评论对象
     * @return json 0:代表评论成功  1:代表评论失败
     * @throws Exception
     */
    @RequestMapping(value = "/addComment")
    public String addComment(CmsComment comment, HttpServletResponse response) throws Exception {
        String json = "";
        try {
            json = commentAppService.addComment(comment);
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("add comment error!" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 查询某类型评论
     *
     * @param moldId    类型id
     * @param type      评论类型 1.展馆 2.活动 3.藏品 4.专题 5.会员 6.团体 7.活动室
     * @param pageIndex 首页下标
     * @param pageNum   显示条数
     * @return json 10107 活动id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/weChatComment")
    public String weChatComment(HttpServletResponse response, PaginationApp pageApp, String moldId, String type, String pageIndex, String pageNum) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        //每页显示的页数
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (StringUtils.isNotBlank(moldId) && moldId != null) {
                json = commentAppService.queryAppCommentByCondition(moldId, type, pageApp);
            } else {
                json = JSONResponse.commonResultFormat(10107, "评论对象id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 微信上传
     *
     * @param mediaId
     * @param userId
     * @param uploadType(0：默认；1：系列活动；2：身份证/资质认证；3：头像)
     * @return url=1（上传失败）
     */
    @RequestMapping(value = "/wcUpload")
    @ResponseBody
    public String wcUpload(String mediaId, String userId, String uploadType) {
        CmsTerminalUser terminalUser = terminalUserAppService.queryTerminalUserByUserId(userId);
        String url = BindWS.wcUpload(mediaId, terminalUser, cacheService, basePath,uploadType);
        return url;
    }
    
    /**
     * wechat用户上传文件公共接口
     * @param userId 用户id
     * @param uploadType   上传类型 1.多文件 2.用户头像 3.团体用户 4.玩家秀
     * @param modelType  模块类型类型 2.个人头像 3.多图片(评论)
     * @param teamUserId   团体id
     * @return json 10111 用户不存在  10112.不能匹配正在上传的文件，上传处理终止!
     */
    @RequestMapping(value = "/uploadWcFiles")
    public String uploadWcFiles(@RequestParam("file") MultipartFile mulFile,String userId,String uploadType,String modelType, String teamUserId,HttpServletResponse response) throws Exception {
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
     * 微信引导页保存标签
     *
     * @param cmsUsertag return
     */
    @RequestMapping(value = "/wcUserSelectedTag")
    @ResponseBody
    public Map<String, Object> wcUserSelectedTag(CmsUserTag cmsUsertag) {
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            if (cmsUsertag != null && StringUtils.isNotBlank(cmsUsertag.getUserSelectTag())) {
//                session.setAttribute("CmsUserTag", cmsUsertag.getUserSelectTag());
                //用户选择类型存储session
                CmsTerminalUser user = new CmsTerminalUser();
                user.setActivityThemeTagId(cmsUsertag.getUserSelectTag());
                session.setAttribute("terminalUser", user);
                map.put("result", "success");
            } else {
                map.put("result", "false");
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("result", "false");
        }
        return map;
    }

    /**
     * 跳转到地址地图
     *
     * @param request
     * @param lat
     * @param lon
     * @return
     */
    @RequestMapping(value = "/preAddressMap")
    public String preActivityAddressMap(HttpServletRequest request, String lat, String lon) {
        request.setAttribute("lat", lat);
        request.setAttribute("lon", lon);
        return "wechat/map/addressMap";
    }

    /**
     * 跳转到停车场
     * @param request
     * @param lat
     * @param lon
     * @return
     */
    @RequestMapping(value = "/preParking")
    public String preActivityParking(HttpServletRequest request, String lat, String lon) {
        request.setAttribute("lat", lat);
        request.setAttribute("lon", lon);
        return "wechat/map/parking";
    }
    
    /**
     * 跳转到帮助页面
     * @param request
     * @return
     */
    @RequestMapping(value = "/help")
    public String help(HttpServletRequest request, String type) {
        request.setAttribute("type", type);
        return "wechat/help";
    }
    
    /**
     * 获取页面运营位
     * @param advertPostion(2：首页；3：空间；4：热门词汇)
     * @param advertType
     * @param advertSort
     * @return
     */
    @RequestMapping(value = "/getAdvertRecommend")
    @ResponseBody
    public  Map<String,Object> getAdvertRecommend(HttpServletResponse response,GetAdvertVO vo) throws Exception{
	//	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"advertRecommend/pageAdvertRecommend",vo);
	//	response.setContentType("text/html;charset=UTF-8");
     //   response.getWriter().write(res.getData());
     //   response.getWriter().flush();
     //   response.getWriter().close();
      //  return null;
    	

		 Integer advertPostion=vo.getAdvertPostion();

	     String advertType=vo.getAdvertType();

	     Integer advertSort=vo.getAdvertSort();
	     
	     CcpAdvertRecommend model=new CcpAdvertRecommend();
	     model.setAdvertPostion(advertPostion);
	     model.setAdvertType(advertType);
	     model.setAdvertSort(advertSort);
	     
	     List<CcpAdvertRecommend> list= advertRecommendService.queryCcpAdvertRecommend(model);
	     
	     for (CcpAdvertRecommend ccpAdvertRecommend : list) {
	    	 
	    	String advertImgUrl=ccpAdvertRecommend.getAdvertImgUrl();
	    	advertImgUrl=staticServer.getStaticServerUrl()+advertImgUrl;
	    	ccpAdvertRecommend.setAdvertImgUrl(advertImgUrl);
		}
	     
	     Map<String,Object>map=new HashMap<String,Object>();
	     map.put("status", 1);
	     map.put("data", list);
	     
	     return  map;
    }
    
    /**
     * 用户收藏
     * @param userId  用户id
     * @param relateId 关联id
     * @throws Exception
     */
    @RequestMapping(value = "/wcCollect")
    public String wcCollect(HttpServletResponse response, String userId, String relateId, String type) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(relateId)) {
                json = collectAppService.addCollect(userId, relateId, type);
            } else {
                json = JSONResponse.commonResultFormat(10121, "参数缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 取消收藏
     * @param userId     用户id
     * @param relateId 社团id
     * @throws Exception
     */
    @RequestMapping(value = "/wcDelCollect")
    public String wcDelCollect(HttpServletResponse response, String userId, String relateId, String type) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(relateId)) {
                json = collectAppService.delCollect(userId, relateId, type);
            } else {
                json = JSONResponse.commonResultFormat(10121, "参数缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 尽情期待
     * @return
     */
    @RequestMapping(value = "/comingSoon")
    public String comingSoon(HttpServletRequest request){
        return "wechat/comingSoon";
    }
    
    /***************************************************微信调用接口**************************************************************************/
    
    /**
     * 静默调用(获取openId)
     * @param request
     * @param callback	回调地址
     * @return
     */
    @RequestMapping(value = "/getOpenId")
    public ModelAndView silentInvoke(HttpServletRequest request,String callback) throws UnsupportedEncodingException {
        ModelAndView modelAndView = new ModelAndView();
        StringBuffer sb = new StringBuffer("https://open.weixin.qq.com/connect/oauth2/authorize?appid=");
        //回调地址
        String redirectUri = request.getScheme()+"://"+request.getServerName()+"/wechat/getOpenIdBack.do?callback="+callback;
        sb.append(Constant.WX_APP_ID).append("&redirect_uri=")
          .append(URLEncoder.encode(redirectUri, "UTF-8"))
          .append("&response_type=code&scope=snsapi_base&state=").append(request.getContextPath())
          .append("#wechat_redirect");
        modelAndView.setViewName("redirect:"+sb.toString());
        return  modelAndView;
    }
    
    /**
     * 静默调用回调
     * @param code
     * @param state
     * @param callback
     * @return
     */
    @RequestMapping(value = "/getOpenIdBack")
    public ModelAndView silentBack(String code,String state,String callback){
        ModelAndView modelAndView = new ModelAndView();
        String openid = "";
        try{
        	if(StringUtils.isNotBlank(code)){
	        	//根据code获取openId
	            StringBuffer sb = new StringBuffer("https://api.weixin.qq.com/sns/oauth2/access_token?appid=");
	            sb.append(Constant.WX_APP_ID).append("&secret=").append(Constant.WX_APP_SECRET).append("&code=").append(code).append("&grant_type=authorization_code");
	            HttpResponseText res =  CommonUtil.httpsRequest(sb.toString());
	            //返回结果不为空
	            if(res!=null && res.getData()!=null) {
	                JSONObject jsonObject = JSONObject.fromObject(res.getData());
	                openid = jsonObject.getString("openid");
	            }
        	}
        }catch (Exception e){
        	e.printStackTrace();
        }
        
        if(StringUtils.isNotBlank(callback)&&callback.indexOf("?")>-1){
        	modelAndView.setViewName("redirect:"+callback+"&openid="+openid);
        	return modelAndView;
        }
        modelAndView.setViewName("redirect:"+callback+"?openid="+openid);
        return modelAndView;
    }
    
    /**
     * 微信重置accessToken
     * @param 
     */
    @RequestMapping(value = "/resetToken")
    @ResponseBody
    public String resetToken() {
        return BindWS.resetToken(cacheService);
    }
    
    /**
     * 查看当前accessToken
     * @param 
     */
    @RequestMapping(value = "/getToken")
    @ResponseBody
    public String getToken() {
        return "ACCESS_TOKEN："+cacheService.getValueByKey(SystemContent.ACCESS_TOKEN);
    }
    
    /**
     * 获取永久素材列表（根据type）
     * @param
     * http://m.wenhuayun.cn/wechat/getMaterialListByType.do?accessToken=geE354NGRF--1JKfP1munCXHZS-7a9HBufYknU3NB75aexwyhdav5rjt-S0CNAj3pM89T7X7Gy8csm-kVwpxmSac82jZ4eiYTFnS05wG-XQ31ZmUtg3BurZ18UJiGTfaZIUhAEAKTF&type=news&offset=0&count=10
     * @throws Exception 
     */
    @RequestMapping(value = "/getMaterialListByType")
    public String getMaterialListByType(HttpServletResponse response,String accessToken,String type,String offset,String count) throws Exception {
    	HttpResponseText res = BindWS.getMaterialList(accessToken, type, offset, count);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 获取永久素材列表（根据mediaId）
     * @param 
     * @throws Exception 
     */
    @RequestMapping(value = "/getMaterialListByMediaId")
    public String getMaterialListByMediaId(HttpServletResponse response,String mediaId) throws Exception {
    	HttpResponseText res = BindWS.getMaterialList(cacheService,mediaId);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
}