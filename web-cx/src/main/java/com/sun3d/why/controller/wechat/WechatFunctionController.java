package com.sun3d.why.controller.wechat;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.operation.OperatFunction;
import com.culturecloud.model.bean.vote.CcpVoteItem;
import com.culturecloud.model.request.common.SysUserIntegralReqVO;
import com.culturecloud.model.request.contest.QueryContestTopicDetailVO;
import com.culturecloud.model.request.vote.CcpVoteDetailVO;
import com.culturecloud.model.request.vote.QueryVoteItemListVO;
import com.culturecloud.model.request.vote.QueryVoteUserVO;
import com.culturecloud.model.request.vote.SaveUserTicketVO;
import com.culturecloud.model.request.vote.SaveVoteUserVO;
import com.culturecloud.model.response.contest.CcpContestTopicVO;
import com.culturecloud.model.response.contest.QuestionAnswerInfoVO;
import com.culturecloud.model.response.vote.CcpVoteVO;
import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.annotation.SysBusinessLog;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserAnswer;
import com.sun3d.why.model.SysParamsConfig;
import com.sun3d.why.model.ccp.CcpCityImg;
import com.sun3d.why.model.ccp.CcpCityUser;
import com.sun3d.why.model.ccp.CcpCityVote;
import com.sun3d.why.model.ccp.CcpExhibition;
import com.sun3d.why.model.ccp.CcpMerchantUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpCityImgService;
import com.sun3d.why.service.CcpExhibitionService;
import com.sun3d.why.service.CcpMerchantUserService;
import com.sun3d.why.service.CcpVoteItemService;
import com.sun3d.why.service.CmsUserAnswerService;
import com.sun3d.why.service.SysParamsConfigService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.Constant;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.TerminalUserAppService;

/**
 * 运营功能模块
 * @author demonkb
 */
@RequestMapping("/wechatFunction")
@Controller
public class WechatFunctionController {

    @Autowired
    private CacheService cacheService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CcpExhibitionService ccpExhibitionService;
    @Autowired
    private CmsUserAnswerService userAnswerService;
    @Autowired
    private CcpVoteItemService ccpVoteItemService;
    @Autowired
    private CcpCityImgService ccpCityImgService;
    @Autowired
    private CcpMerchantUserService ccpMerchantUserService;
	@Autowired
	private SysParamsConfigService sysParamsConfigService;
	@Autowired
	private TerminalUserAppService terminalUserAppService;

    private Logger logger = LoggerFactory.getLogger(WechatFunctionController.class);

    
    /***************************************************扫二维码进活动送积分**************************************************************************/
    
    /**
     * 扫二维码进活动送积分（含微信登录）
     * @param param(activityId+integral)
     * @return
     * @throws ParseException 
     */
    @RequestMapping(value = "/toActivityByQR")
    @SysBusinessLog(remark = "扫二维码进活动送积分",operation = OperatFunction.QRJF)
    public String toActivityByQR(HttpServletRequest request,String param) throws ParseException {
    	String activityId = "";
    	String integral = "";
    	if(param.length()==35){
    		activityId = param.substring(0,5)+param.substring(6,7)+param.substring(8,9)+param.substring(10);
        	integral = param.substring(5,6)+param.substring(7,8)+param.substring(9,10);
        	
        	//送积分结束
        	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    		if(df.parse("2016-12-21 00:00:00").before(new Date()) && activityId.equals("f2a170facb7a4fe580197577e60c1116")) {
    			request.setAttribute("activityId", activityId);
    			request.setAttribute("isOver", 1);
    			return "wechat/function/activityByQR";
            }
        	
        	try {
				if(Integer.parseInt(integral)<=999){		//最多加999积分
					CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
					if(terminalUser!=null){
						if(terminalUser.getUserId()!=null){
							SysUserIntegralReqVO vo = new SysUserIntegralReqVO(activityId,terminalUser.getUserId(),integral);
							HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"integral/addIntegralByQR",vo);
							JSONObject jsonObject = JSON.parseObject(res.getData());
							Integer data = JSON.parseObject(jsonObject.get("data").toString(),Integer.class);
							if(data==1){
								request.setAttribute("activityId", activityId);
				            	request.setAttribute("integral", Integer.parseInt(integral));
				            	return "wechat/function/activityByQR";
							}
						}
					}
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
				return "forward:/wechatActivity/preActivityDetail.do?activityId="+activityId;
			}
    	}else{
    		return "forward:/wechat/index.do";
    	}
    	return "forward:/wechatActivity/preActivityDetail.do?activityId="+activityId;
    }
    
    /***************************************************展览模板**************************************************************************/
    
    /**
     * 跳转到展览页
     * @param request
     * @return
     */
    @RequestMapping(value = "/exhibition")
    public String exhibition(HttpServletRequest request,String exhibitionId) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        
        CcpExhibition ccpExhibition = ccpExhibitionService.queryFrontExhibition(exhibitionId);
        request.setAttribute("ccpExhibition", ccpExhibition);
        
        String fullUrl = BindWS.getUrl(request);
        request.setAttribute("fullUrl", fullUrl);
    	request.setAttribute("logo",getLogo());
    	
        return "wechat/static/exhibition";
    }
    
    /***************************************************竞赛模板**************************************************************************/
    
	@RequestMapping(value = "/contestQuiz")
	public String contestQuiz(@RequestParam String topicId, HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		QueryContestTopicDetailVO vo = new QueryContestTopicDetailVO();

		vo.setTopicId(topicId);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestTopic/contestTopicDetail", vo);

		JSONObject jsonObject = JSON.parseObject(res.getData());

		if (jsonObject != null) {

			String status = String.valueOf(jsonObject.get("status"));

			if (status.equals("1")) {

				CcpContestTopicVO contestTopic = JSON.parseObject(jsonObject.get("data").toString(),
						CcpContestTopicVO.class);

				session.setAttribute("sessionTopic", contestTopic);
				
				if(StringUtils.isNotBlank(contestTopic.getTemplateId())){
					// 模板1
					if(contestTopic.getTemplateId().equals("eb11a9fad7d54d82a390f22f9bae6e60")){
						session.setAttribute("sessionTopicTemplate", "model2");
					}
					else if(contestTopic.getTemplateId().equals("d84fce77860341279384822de06d843f")){
						session.setAttribute("sessionTopicTemplate", "model1");
					}
					else
						session.setAttribute("sessionTopicTemplate", "model3");
				}
			}
		}
		
		request.setAttribute("logo",getLogo());

		return "wechat/static/contestQuiz/index";
	}
	
	@RequestMapping(value = "/getTopicQuestionAnswerInfo")
	public String getTopicQuestionAnswerInfo(HttpServletResponse response, QueryContestTopicDetailVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestQuestion/getTopicQuestionAnswerInfo", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	 @RequestMapping(value = "/saveOrUpdateContestQuizAnswer")
	 @ResponseBody
	 @EmojiInspect
	 public String saveOrUpdateContestQuizAnswer(HttpServletRequest request,CmsUserAnswer cmsUserAnswer) {
	     return userAnswerService.saveOrUpdateAnswer(cmsUserAnswer);
	 }
	 
	 @RequestMapping(value = "/contestQuizShare")
	  public String contestQuizShare(HttpServletRequest request,@RequestParam String userId,@RequestParam String topicId,Integer userScore) {
	      
		 	Object sessionTopic=session.getAttribute("sessionTopic");
		 
		 	if(sessionTopic==null){
		 		
		 		return "redirect:/wechatFunction/contestQuiz.do?topicId="+topicId;
		 	}
		 
		 	//微信权限验证配置
	        String url = BindWS.getUrl(request);
	        Map<String, String> sign = BindWS.sign(url, cacheService);
	        request.setAttribute("sign", sign);
	        
	        QueryContestTopicDetailVO vo=new QueryContestTopicDetailVO();
	        vo.setTopicId(topicId);
	        
	        HttpResponseText res = CallUtils
					.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestQuestion/getTopicQuestionAnswerInfo", vo);
		
	        JSONObject jsonObject = JSON.parseObject(res.getData());

	        int sum=0;
	        
			if (jsonObject != null) {
			
				ArrayList<QuestionAnswerInfoVO> list=JSON.parseObject(jsonObject.get("data").toString(),ArrayList.class);
			
				sum=list.size();
			}
			if(sum>0){
				
				if(userScore==sum)
					request.setAttribute("userScore", 100);
				else
					request.setAttribute("userScore", userScore*(100/sum));
			}
			else
				request.setAttribute("userScore", 0);
			
			CmsUserAnswer userAnswer=new CmsUserAnswer();
			userAnswer.setAnswerType(topicId);
			userAnswer.setUserId(userId);
			
			CmsUserAnswer result = userAnswerService.queryUserInfo(userAnswer);
			if(result!=null)
			request.setAttribute("userName", result.getUserName());
			
			request.setAttribute("logo",getLogo());
	     
			return "wechat/static/contestQuiz/share";
	    }
	 
	 @RequestMapping(value = "/contestQuizEnd")
	 public String contestQuizEnd(HttpServletRequest request,String topicId)
	 {
		 request.setAttribute("topicId", topicId);
		 
		 request.setAttribute("logo",getLogo());
		 
		 return "wechat/static/contestQuiz/end";
	 }
	 
	 @RequestMapping(value = "/contestQuizInfo")
	    public String contestQuizInfo(HttpServletRequest request,CmsUserAnswer record) {
		 
			Object sessionTopic=session.getAttribute("sessionTopic");
			 
		 	if(sessionTopic==null){
		 		
		 		return "redirect:/wechatFunction/contestQuiz.do?topicId="+record.getAnswerType();
		 	}
	        //微信权限验证配置
	        String url = BindWS.getUrl(request);
	        Map<String, String> sign = BindWS.sign(url, cacheService);
	        request.setAttribute("sign", sign);
	        
			CmsUserAnswer result = userAnswerService.queryUserInfo(record);
			
			request.setAttribute("userAnswer", result);
			
			request.setAttribute("logo",getLogo());
				
			return "wechat/static/contestQuiz/info";
			
	    }
	 
	 private String getLogo(){
		 
		  String businessName ="applicationContest";
		  
		  
		 Object logo= session.getAttribute("applicationContestLogo");
		 
		 if(logo!=null){
			 return logo.toString();
		 }
		 
		List<SysParamsConfig> list=sysParamsConfigService.queryParamsConfigByBusinessId(businessName);
        	
		if(list.size()>0){
			
			for (SysParamsConfig sysParamsConfig : list) {
				
				if("logo".equals(sysParamsConfig.getConfigName())){
					
					String configValue=sysParamsConfig.getConfigValue();
					
					session.setAttribute("applicationContestLogo", configValue);
					
					return configValue;
				}
			}
		}
		
		 return "";
	 }
	 
	/***************************************************投票模板（后台上传内容）**************************************************************************/
	    
	/**
	 * 跳转到投票首页
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/voteIndex")
	public String voteIndex(HttpServletRequest request,CcpVoteDetailVO vo) {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    
	    HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"vote/voteDtatil",vo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		CcpVoteVO resVo = JSON.parseObject(jsonObject.get("data").toString(), CcpVoteVO.class);
		request.setAttribute("ccpVote", resVo);
		request.setAttribute("logo",getLogo());
	    String fullUrl = BindWS.getUrl(request);
	    request.setAttribute("fullUrl", fullUrl);
	    return "wechat/static/vote/index";
	}
	
	/**
	 * 跳转到投票规则页
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/voteRule")
	public String voteRule(HttpServletRequest request,CcpVoteDetailVO vo) {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    
	    HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"vote/voteDtatil",vo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		CcpVoteVO resVo = JSON.parseObject(jsonObject.get("data").toString(), CcpVoteVO.class);
		request.setAttribute("ccpVote", resVo);
	    
	    String fullUrl = BindWS.getUrl(request);
	    request.setAttribute("fullUrl", fullUrl);
	    return "wechat/static/vote/rule";
	}
	
	/**
	 * 跳转到投票排名页
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/voteRanking")
	public String voteRanking(HttpServletRequest request,CcpVoteDetailVO vo) {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    
	    HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"vote/voteDtatil",vo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		CcpVoteVO resVo = JSON.parseObject(jsonObject.get("data").toString(), CcpVoteVO.class);
		request.setAttribute("ccpVote", resVo);
	    
	    String fullUrl = BindWS.getUrl(request);
	    request.setAttribute("fullUrl", fullUrl);
	    return "wechat/static/vote/ranking";
	}
	
	/**
	 * 跳转到投票详情页
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/voteDetail")
	public String voteDetail(HttpServletRequest request,String voteItemId) {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    
	    CcpVoteItem ccpVoteItem = ccpVoteItemService.queryVoteItemById(voteItemId);
	    request.setAttribute("ccpVoteItem", ccpVoteItem);
	    
	    CcpVoteDetailVO vo = new CcpVoteDetailVO();
	    vo.setVoteId(ccpVoteItem.getVoteId());
	    HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"vote/voteDtatil",vo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		CcpVoteVO resVo = JSON.parseObject(jsonObject.get("data").toString(), CcpVoteVO.class);
		request.setAttribute("ccpVote", resVo);
	    
	    String fullUrl = BindWS.getUrl(request);
	    request.setAttribute("fullUrl", fullUrl);
	    return "wechat/static/vote/detail";
	}
	
	/**
     * 获取投票列表
     * @return
     */
    @RequestMapping(value = "/getVoteItemList")
    public String getVoteItemList(HttpServletResponse response, QueryVoteItemListVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"vote/voteItemList",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 投票
     * @return
     */
    @RequestMapping(value = "/saveUserTicket")
    public String saveUserTicket(HttpServletResponse response, SaveUserTicketVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"vote/saveUserTicket",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 获取投票用户信息
     * @param response
     * @param vo
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/queryVoteUser")
    public String queryVoteUser(HttpServletResponse response, QueryVoteUserVO vo) throws IOException{
    	
    	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"vote/queryVoteUser",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 保存投票用户信息
     * @param response
     * @param vo
     * @return
     * @throws IOException
     * @throws ParseException 
     */
    @RequestMapping(value = "/saveVoteUser")
    @EmojiInspect
    public String saveVoteUser(HttpServletResponse response, SaveVoteUserVO vo) throws IOException, ParseException{
    	JSONObject json=new JSONObject();
		json.put("userId", vo.getUserId());
		json.put("userNickName", vo.getUserName());
		json.put("userTelephone", vo.getUserMobile());
		CmsTerminalUser terminalUser = JSON.parseObject(json.toString(), CmsTerminalUser.class);
		CmsTerminalUser updateTerminalUser = terminalUserAppService.queryTerminalUserByUserId(terminalUser.getUserId());
		terminalUserAppService.editTerminalUserById(updateTerminalUser, terminalUser);
		
    	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"vote/saveVoteUser",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /***************************************************城市名片**************************************************************************/
    
	/**
	 * 跳转到首页
	 * @param request
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping(value = "/cityIndex")
	public String cityIndex(HttpServletRequest request,String tab) throws ParseException {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    
	    request.setAttribute("tab", tab);

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2017-07-27 00:00:00");
		if(time.before(new Date())) {
			request.setAttribute("noControl", 1);
        }
	    return "wechat/static/city/index";
	}
	
	/**
	 * 跳转到排名页
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/cityRanking")
	public String cityRanking(HttpServletRequest request) {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    return "wechat/static/city/ranking";
	}
	
	/**
	 * 跳转到规则页
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/cityRule")
	public String cityRule(HttpServletRequest request) {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    return "wechat/static/city/rule";
	}
	
	/**
	 * 跳转到回顾页
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/cityReview")
	public String cityReview(HttpServletRequest request) {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    return "wechat/static/city/review";
	}
	
	/**
	 * 跳转到详情页
	 * @param request
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping(value = "/cityDetail")
	public String cityDetail(HttpServletRequest request, String cityImgId) throws ParseException {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    
	    request.setAttribute("cityImgId", cityImgId);
	    
	    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2017-07-27 00:00:00");
		if(time.before(new Date())) {
			request.setAttribute("noControl", 1);
        }
	    return "wechat/static/city/detail";
	}
	
	/**
     * 获取图片列表
     * @return
     */
    @RequestMapping(value = "/queryCityImgList")
    @ResponseBody
    public List<CcpCityImg> queryCityImgList(CcpCityImg vo){
    	vo.setCityStatus(1);
        return ccpCityImgService.queryCityImgList(vo);
    }
    
    /**
     * 获取精选图片列表
     * @return
     */
    @RequestMapping(value = "/querySelectCityImgList")
    @ResponseBody
    public List<CcpCityImg> querySelectCityImgList(CcpCityImg vo){
    	vo.setCityStatus(1);
        return ccpCityImgService.querySelectCityImgList(vo);
    }
    
    /**
     * 获取排名列表
     * @return
     */
    @RequestMapping(value = "/queryCityUserRanking")
    @ResponseBody
    public List<CcpCityUser> queryCityUserRanking(Integer cityType){
    	return ccpCityImgService.queryCityUserRanking(cityType);
    }
    
    /**
     * 城市投票
     * @param request
     * @return
     */
    @RequestMapping(value = "/addCityVote")
    @ResponseBody
    public String addCityVote(CcpCityVote vo) {
        return ccpCityImgService.addCityVote(vo);
    }
    
    /**
     * 添加图片
     * @param request
     * @return
     */
    @RequestMapping(value = "/addCityImg")
    @ResponseBody
    @EmojiInspect
    public String addCityImg(CcpCityImg vo) {
        return ccpCityImgService.addCityImg(vo);
    }
    
    /**
     * 添加用户信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/addCityUser")
    @ResponseBody
    @EmojiInspect
    public String addCityUser(CcpCityUser vo) {
    	return ccpCityImgService.addCityUser(vo);
    }
    
    /**
     * 获取用户信息
     * @return
     */
    @RequestMapping(value = "/queryCityUser")
    @ResponseBody
    public Map<String,Object> queryCityUser(String userId){
    	Map<String,Object> data = new HashMap<String,Object>();
    	data.put("ccpCityUser", ccpCityImgService.queryCityUser(userId));
    	return data;
    }

    /***************************************************应用大赛线上报名**************************************************************************/
    
	/**
	 * 跳转到报名页
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/onlineRegister")
	public String onlineRegister(HttpServletRequest request) {
	    //微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
	    return "wechat/function/onlineRegister";
	}
	
	/**
     * 添加报名信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/addMerchantUser")
    @ResponseBody
    @EmojiInspect
    public String addMerchantUser(CcpMerchantUser vo) {
    	return ccpMerchantUserService.addMerchantUser(vo);
    }
}
