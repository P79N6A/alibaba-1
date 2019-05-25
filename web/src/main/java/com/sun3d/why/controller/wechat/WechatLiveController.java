package com.sun3d.why.controller.wechat;

import java.io.IOException;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.culturecloud.model.request.common.SysUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveActivityDetailVO;
import com.culturecloud.model.request.live.CcpLiveActivityPageVO;
import com.culturecloud.model.request.live.CcpRecommendLiveListVO;
import com.culturecloud.model.request.live.SaveCcpLiveMessageVO;
import com.culturecloud.model.request.live.UpdateCcpLiveMessageVO;
import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.dao.CcpLiveMessageMapper;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Controller
@RequestMapping("/wechatLive")
public class WechatLiveController {

	@Autowired
	private CacheService cacheService;

	@Autowired
	private StaticServer staticServer;
	
	@Autowired
	private CcpLiveMessageMapper ccpLiveMessageMapper;
	
	@Autowired
    private UserIntegralDetailService userIntegralDetailService;
	
	@RequestMapping(value = "/index")
	public String index(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("toDay", new Date().getTime());
		return "wechat/live/index";
	}

	@RequestMapping(value = "/getLiveActivityList")
	public String getLiveActivityList(HttpServletResponse response, CcpLiveActivityPageVO liveActivityPageVO)
			throws IOException {

		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "liveActivity/liveActivityList", liveActivityPageVO);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	
	@RequestMapping(value = "/liveActivity")
	public String liveActivity(HttpServletRequest request,@RequestParam String liveActivityId,String template,Integer integralChange) {

		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		
		CcpLiveActivityDetailVO liveActivityDetailVO=new CcpLiveActivityDetailVO();
		
		liveActivityDetailVO.setLiveActivityId(liveActivityId);
		
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "liveActivity/toDetail", liveActivityDetailVO);
		
		
		request.setAttribute("sign", sign);
		request.setAttribute("liveActivityId", liveActivityId);
		request.setAttribute("liveActivityDetail", res.getData());
		request.setAttribute("integralChange", integralChange);
		request.setAttribute("template", template);
		request.setAttribute("toDay", new Date().getTime());
		
		if ("2".equals(template))
			return "wechat/live/liveActivity2";
		else if ("3".equals(template))
			return "wechat/live/liveActivity3";
		else
			return "wechat/live/liveActivity";
	}
	
	@RequestMapping(value = "/userActivityIndex")
	public String userActivityIndex(HttpServletRequest request,@RequestParam String liveCreateUser){
		
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("liveCreateUser", liveCreateUser);
		
		return "wechat/live/userActivityIndex";
	}
	
	@RequestMapping(value = "/createUserInfo")
	public String createUserInfo(HttpServletResponse response,SysUserDetailVO sysUserDetailVO) throws IOException{
		
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "liveActivity/createUserInfo", sysUserDetailVO);
		
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	
	@RequestMapping(value = "/toLiveActivityDetail")
	public String toLiveActivityDetail(HttpServletResponse response, CcpLiveActivityDetailVO liveActivityDetailVO)
			throws IOException{
		
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "liveActivity/toDetail", liveActivityDetailVO);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "/addComment")
	public String addComment(HttpServletRequest request,@RequestParam String liveActivityId,String tab,String template){
		
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("liveActivityId", liveActivityId);
		request.setAttribute("tab", tab);
		request.setAttribute("template", template);
		
		 String aliImgUrl=staticServer.getAliImgUrl();
	    	
		 request.setAttribute("aliImgUrl", aliImgUrl);
		
		return "wechat/live/addComment";
	}
	

	/**
	 * 跳转到关于直播
	 */
	@RequestMapping(value = "/about")
	public String about(String type, HttpServletRequest request,String version) {
		// 1.ios 2.安卓
		request.setAttribute("type", type);
		request.setAttribute("version", version!=null?version:"1.0");
		return "wechat/live/about";
	}
	
	@RequestMapping(value = "/help")
	public String help( HttpServletRequest request){
		
		return "wechat/live/help";
	}
	
	@RequestMapping(value = "/createMessage")
	@EmojiInspect
	public String createMessage(HttpServletResponse response, SaveCcpLiveMessageVO saveCcpLiveMessageVO)
			throws IOException{
		
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "live/createMessage", saveCcpLiveMessageVO);
		response.setContentType("text/html;charset=UTF-8");
		
		JSONObject jsonObject = JSON.parseObject(res.getData());
    	
    	String status=String.valueOf(jsonObject.get("status"));
    	
    	if("1".equals(status)){
    		
    		CcpLiveMessage message =new CcpLiveMessage();
    		message.setMessageActivity(saveCcpLiveMessageVO.getMessageActivity());
    		message.setMessageImg(saveCcpLiveMessageVO.getMessageImg());
    		message.setMessageCreateUser(saveCcpLiveMessageVO.getMessageCreateUser());
    		
    		int result = userIntegralDetailService.liveCommentAddIntegral(message);
    		
    		try {
    			
    			jsonObject.put("integralChange", result);
				
			} catch (Exception e) {
				jsonObject.put("integralChange", 0);
			}
    	}
		
		response.getWriter().write(jsonObject.toJSONString());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "/deleteMessage")
	public String deleteMessage(HttpServletResponse response, UpdateCcpLiveMessageVO updateCcpLiveMessageVO) throws IOException{
		
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "live/updateMessage", updateCcpLiveMessageVO);
		response.setContentType("text/html;charset=UTF-8");
		
		JSONObject jsonObject = JSON.parseObject(res.getData());
    	
    	String status=String.valueOf(jsonObject.get("status"));
		
		if("1".equals(status)){
    		
    		CcpLiveMessage message =ccpLiveMessageMapper.selectByPrimaryKey(updateCcpLiveMessageVO.getMessageId());
    		
    		userIntegralDetailService.liveCommentDeleteIntegral(message);
    	}
		
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;

	}
	
	@RequestMapping(value = "/getLiveHistoryVideoList")
	public String getLiveHistoryVideoList(HttpServletResponse response, CcpLiveActivityDetailVO vo) throws IOException{
		
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "live/liveHistoryVideoList", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "/selectIndexNum")
	public String selectIndexNum(HttpServletResponse response, CcpLiveActivityPageVO liveActivityPageVO)
			throws IOException {
		
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "liveActivity/selectIndexNum", liveActivityPageVO);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	@RequestMapping(value = "/getLiveActivityRecommendList")
	public String getLiveActivityRecommendList(HttpServletResponse response, CcpRecommendLiveListVO recommendLiveListVO)
			throws IOException {
		
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "liveActivity/recommendLiveList", recommendLiveListVO);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
}
