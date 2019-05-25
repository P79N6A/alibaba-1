package com.sun3d.why.controller.wechat;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserMovieAnswer;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.publicWebservice.model.HandWritingImg;
import com.sun3d.why.publicWebservice.service.UserPublicService;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsUserMovieAnswerService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.EditorialAppService;

@RequestMapping("/wechatStatic")
@Controller
public class WechatStaticController {

    @Autowired
    private CacheService cacheService;
    @Autowired
    private EditorialAppService editorialAppService;
    @Autowired
    private UserPublicService userPublicService;
    @Autowired
    private CmsUserMovieAnswerService userMovieAnswerService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;

    private Logger logger = LoggerFactory.getLogger(WechatStaticController.class);

    /**
     * 跳转到爱童心
     * @return
     */
    @RequestMapping(value = "/aitongxin")
    public String aitongxin(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/static/aitongxin";
    }
    
    /**
     * 跳转到金山
     * @return
     */
    @RequestMapping(value = "/jinshan")
    public String jinshan(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/static/jinshan";
    }
    
    /**
     * 跳转到轻文艺
     * @return
     */
    @RequestMapping(value = "/qingwenyi")
    public String qingwenyi(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/static/qingwenyi";
    }
    
    /**
     * 跳转到畅想文化生活新体验
     * @return
     */
    @RequestMapping(value = "/guide")
    public String index(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/static/guide";
    }
    
    /**
     * 跳转到文化云活动周刊
     * @param request
     * @param activityType	活动类型ID，全部为空
     * @return
     */
    @RequestMapping(value = "/magazine")
    public String magazine(HttpServletRequest request,String activityType) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("activityType", activityType);
        
        String relativeUrl = BindWS.getRelativeUrl(request);
        request.setAttribute("url", relativeUrl);
        return "wechat/static/magazine";
    }
    
    /**
     * 抓取采编库+活动列表
     * @param response
     * @param activityType
     * @param userId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/wcMagazineList")
    public String wcEditorialList(HttpServletResponse response,String activityType,String userId) throws Exception {
        String json="";
        try {
            json = editorialAppService.queryAppEditAndActivityList(activityType,userId);
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(500, e.getMessage());
            logger.info("query activityBanner error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     *why3.5 app用户报名采编接口
     * @param activityId        采编id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/wcAddEditorialUserWantgo")
    public String wcAddEditorialUserWantgo(HttpServletResponse response,String activityId,String userId) throws Exception {
        String json="";
        try{
            if(StringUtils.isNotBlank(activityId) && StringUtils.isNotBlank(userId)){
                json = editorialAppService.addEditorialUserWantgo(activityId, userId);
            }else{
                json = JSONResponse.toAppResultFormat(10107, "采编id或用户id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(11111, e.getMessage());
            logger.error("appAddEditorialUserWantgo error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     *why3.5 app用户取消报名采编接口
     * @param activityId        采编id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/deleteEditorialUserWantgo")
    public String deleteEditorialUserWantgo(HttpServletResponse response,String activityId,String userId) throws Exception {
        String json="";
        try{
            if(StringUtils.isNotBlank(activityId) && StringUtils.isNotBlank(userId)){
                json = editorialAppService.deleteEditorialUserWantgo(activityId, userId);
            }else{
                json = JSONResponse.toAppResultFormat(10107, "采编id或用户id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(11111, e.getMessage());
            logger.error("deleteEditorialUserWantgo error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 跳转到文化云系列活动
     * @param request
     * @return
     */
    @RequestMapping(value = "/series")
    public String series(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        
        String relativeUrl = BindWS.getRelativeUrl(request);
        request.setAttribute("url", relativeUrl);
        return "wechat/static/series";
    }
    
    /**
     * 系列活动图片列表
     * @param request
     * @return
     */
    @RequestMapping(value = "/seriesImgList")
    @ResponseBody
    public List<HandWritingImg> seriesImgList(HttpServletRequest request,String pageIndex,String pageNum, PaginationApp pageApp,String userId) {
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
    	List<HandWritingImg> list = null;
		try {
			list = userPublicService.querySeriesImgList(pageApp,userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return list;
    }
    
    /**
     * 系列活动保存图片
     * @param request
     * @return
     */
    @RequestMapping(value = "/seriesSaveImg")
    @ResponseBody
    public String seriesSaveImg(HttpServletRequest request,String userId, String url) {
		HandWritingImg handWritingImg = new HandWritingImg();
		handWritingImg.setId(UUIDUtils.createUUId());
		handWritingImg.setUserId(userId);
		handWritingImg.setCreateTime(new Date());
		handWritingImg.setImgUrl(url);
		handWritingImg.setUpdateType(3);
        return userPublicService.insert(handWritingImg);
    }
    
    /**
     * 系列活动删除图片
     * @param request
     * @return
     */
    @RequestMapping(value = "/seriesImgDel")
    @ResponseBody
    public String seriesImgDel(HttpServletRequest request,String userId) {
        return userPublicService.seriesImgDel(userId);
    }
    
    /**
     * 跳转到文化云电影节活动
     * @param request
     * @return
     */
    @RequestMapping(value = "/movies")
    public String movies(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        
        String relativeUrl = BindWS.getRelativeUrl(request);
        request.setAttribute("url", relativeUrl);
        return "wechat/static/movies";
    }
    
    /***************************************************电影节问答**************************************************************************/
    
    /**
     * 跳转到电影节问答首页
     * @param request
     * @return
     */
    @RequestMapping(value = "/movieAnswer")
    public String movieAnswer(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/static/movieAnswer/index";
    }
    
    /**
     * 跳转到电影节分享炫耀页面
     * @param request
     * @return
     */
    @RequestMapping(value = "/movieShare")
    public String movieShare(HttpServletRequest request,Integer userScore) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        
        CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        if(null!=sessionUser){
        	if(StringUtils.isNotBlank(sessionUser.getUserId())){
        		CmsUserMovieAnswer result = userMovieAnswerService.statisticsMovieAnswer(userScore,sessionUser.getUserId());
        		request.setAttribute("total", result.getTotal());
        		request.setAttribute("ranking", result.getRanking());
        		request.setAttribute("proportion", result.getProportion());
        		request.setAttribute("userScore", userScore);
        		request.setAttribute("userName", result.getUserName());
        		String userHeadImgUrl = "";
        		if (StringUtils.isNotBlank(result.getUserHeadImgUrl())){
        			if (result.getUserHeadImgUrl().contains("http://")) {
                        userHeadImgUrl = result.getUserHeadImgUrl();
                    }else{
                        userHeadImgUrl = staticServer.getStaticServerUrl() + result.getUserHeadImgUrl();
                    }
        		}
        		request.setAttribute("userHeadImgUrl", userHeadImgUrl);
        		return "wechat/static/movieAnswer/share";
        	}
        }
        return "wechat/static/movieAnswer/index";
    }
    
    /**
     * 跳转到电影节补填信息页面
     * @param request
     * @return
     */
    @RequestMapping(value = "/movieInfo")
    public String movieInfo(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        
        CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        if(null!=sessionUser){
        	if(StringUtils.isNotBlank(sessionUser.getUserId())){
        		CmsUserMovieAnswer result = userMovieAnswerService.queryMovieUserInfo(sessionUser.getUserId());
        		request.setAttribute("userName", result.getUserName());
        		request.setAttribute("userMobile", result.getUserMobile());
        		return "wechat/static/movieAnswer/info";
        	}
        }
        return "wechat/static/movieAnswer/index";
    }
    
    /**
     * 保存或更新电影节问答信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveOrUpdateMovieAnswer")
    @ResponseBody
    public String saveOrUpdateMovieAnswer(HttpServletRequest request,CmsUserMovieAnswer cmsUserMovieAnswer) {
        return userMovieAnswerService.saveOrUpdateMovieAnswer(cmsUserMovieAnswer);
    }
    
    /**
     * 电影节问答保存虚拟用户数据
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveMovieAnswerData")
    @ResponseBody
    public String saveMovieAnswerData(HttpServletRequest request) {
        return userMovieAnswerService.saveMovieAnswerData();
    }
   
}
