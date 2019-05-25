package com.sun3d.why.controller.wechat;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.model.DcSuggestion;
import com.sun3d.why.model.DcVideo;
import com.sun3d.why.model.DcVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.DcSuggestionService;
import com.sun3d.why.service.DcVideoService;
import com.sun3d.why.util.BindWS;

/**
 * 配送中心H5
 * @author demonkb
 */
@RequestMapping("/wechatDc")
@Controller
public class WechatDcVideoController {

    @Autowired
    private CacheService cacheService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private DcVideoService dcVideoService;
    @Autowired
    private DcSuggestionService suggestionService;

    private Logger logger = LoggerFactory.getLogger(WechatDcVideoController.class);

    /**
     * 跳转配送中心H5首页
     * @param request
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(HttpServletRequest request,Integer tab) throws ParseException{
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("tab", tab);
        if(tab != null){
        	if(tab == 0){
            	request.setAttribute("videoType", "舞蹈");
            }else if(tab == 1){
            	request.setAttribute("videoType", "合唱");
            }else if(tab == 2){
            	request.setAttribute("videoType", "时装");
            }else if(tab == 3){
            	request.setAttribute("videoType", "戏曲/曲艺");
            }else{
            	request.setAttribute("videoType", "舞蹈");
            }
        }else{
        	request.setAttribute("videoType", "舞蹈");
        }
        
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2016-11-17 17:00:00");
		if(time.before(new Date())) {
			request.setAttribute("noVote", 1);
        }
		time = df.parse("2016-11-18 20:00:00");
		if(time.before(new Date())) {
			request.setAttribute("showRanking", 1);
        }
        return "wechat/static/dc/index";
    }
    
    /**
     * 跳转配送中心H5详情页面
     * @param request
     * @return
     * @throws ParseException 
     */
    @RequestMapping(value = "/toDetail")
    public String toDetail(HttpServletRequest request,String videoId) throws ParseException {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("videoId", videoId);
        
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2016-11-17 17:00:00");
		if(time.before(new Date())) {
			request.setAttribute("noVote", 1);
        }
        return "wechat/static/dc/detail";
    }
    
    /**
     * 跳转配送中心H5排名页面
     * @param request
     * @return
     */
    @RequestMapping(value = "/toRanking")
    public String toRanking(HttpServletRequest request,Integer tab) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("tab", tab);
        if(tab != null){
        	if(tab == 0){
            	request.setAttribute("videoType", "舞蹈");
            }else if(tab == 1){
            	request.setAttribute("videoType", "合唱");
            }else if(tab == 2){
            	request.setAttribute("videoType", "时装");
            }else if(tab == 3){
            	request.setAttribute("videoType", "戏曲/曲艺");
            }else{
            	request.setAttribute("videoType", "舞蹈");
            }
        }else{
        	request.setAttribute("videoType", "舞蹈");
        }
        return "wechat/static/dc/ranking";
    }
    
    /**
     * 获取配送中心H5列表
     * @return
     */
    @RequestMapping(value = "/queryDclist")
    @ResponseBody
    public List<DcVideo> queryDclist(DcVideo vo){
    	List<DcVideo> list = null;
    	try {
			list = dcVideoService.queryWcDcVideoByCondition(vo);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return list;
    }
    
    /**
     * 配送中心H5投票
     * @param request
     * @return
     */
    @RequestMapping(value = "/addVote")
    @ResponseBody
    public String addVote(DcVote vo) {
        return dcVideoService.saveDcVote(vo);
    }
    
    /**
     * 打开意见页面
     * @return
     */
    @RequestMapping(value = "/suggestion")
    public String suggestion(HttpServletRequest request){
    	//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
    	return "wechat/static/dc/suggestion";
    }
    
    /**
     * 添加意见
     * @param suggestion
     * @return
     */
    @RequestMapping(value = "/createSuggestion")
    @ResponseBody
    public String createSuggestion(DcSuggestion suggestion){
    	return suggestionService.createDcSuggestion(suggestion);
    }
}
