package com.sun3d.why.controller.wechat;

import java.io.IOException;
import java.util.Calendar;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.contest.ContestSystemTypeEnum;
import com.culturecloud.model.request.contest.ContestUserInfoVO;
import com.culturecloud.model.request.contest.QueryContestTopicVO;
import com.culturecloud.model.request.contest.QueryQuestionAnswerInfoVO;
import com.culturecloud.model.request.contest.QueryTopicPassVO;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@RequestMapping("/wechatRedStar")
@Controller
public class WechatRedStarController {

	@Autowired
	private CacheService cacheService;
	
    @Autowired
    private StaticServer staticServer;
    
    @RequestMapping(value = "/welcome")
    public String welcome(HttpServletRequest request){
    	
    	//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
    	
    	return "wechat/static/redStar/welcome";
    }
	
	/**
     * 跳转红星耀中国
     * @return
     */
    @RequestMapping(value = "/index")
	public String index(HttpServletRequest request){
		
		//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        
        Calendar calendar = Calendar.getInstance();
        
        int day = calendar.get(Calendar.DATE);       //日
        int month = calendar.get(Calendar.MONTH) + 1;//月
        int year = calendar.get(Calendar.YEAR);      //年
        
        request.setAttribute("year", year);
        request.setAttribute("month",month);
        request.setAttribute("day",day);
        
        request.setAttribute("staticServerUrl", staticServer.getStaticServerUrl());
        
        //calendar.getD
        return "wechat/static/redStar/index";
	}
    
    /**
     * 邀请好友页面
     * @return
     */
    @RequestMapping(value = "/inviteFriend")
    public String inviteFriend(String toUserId,HttpServletRequest request){
    	//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("toUserId", toUserId);
    	return "wechat/static/redStar/invite"; 
    }
    
    /**
     * 邀请好友页面
     * @return
     */
    @RequestMapping(value = "/help")
    public String help(String toUserId,HttpServletRequest request){
    	//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("toUserId", toUserId);
    	return "wechat/static/redStar/help"; 
    }
    
    /**
     * 获取用户信息
     * @return
     */
    @RequestMapping("/getUserTestInfo")
    public String getUserTestInfo(HttpServletResponse response,@RequestParam String userId) throws Exception{
    	
    	ContestUserInfoVO vo=new ContestUserInfoVO();
    	
    	vo.setUserId(userId);
    	vo.setContestSystemType(ContestSystemTypeEnum.RED_STAR.getValue());
    	
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestUserInfo/getContestUserResult",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 获取点赞排行榜
     * @param response
     * @param userId
     * @return
     */
    @RequestMapping("/getHelpRankingList")
    public String getHelpRankingList(HttpServletResponse response,@RequestParam String userId) throws Exception{
    	
    	ContestUserInfoVO vo=new ContestUserInfoVO();
    	
    	vo.setUserId(userId);
    	vo.setContestSystemType(ContestSystemTypeEnum.RED_STAR.getValue());

    	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestUserInfo/getTopHelpList",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
	}
    

    /**
     * 获取滚动信息
     * @param response
     * @param userId
     * @return
     */
    @RequestMapping("/getJoinInfo")
    public String getJoinInfo(HttpServletResponse response,@RequestParam String userId) throws Exception{
    	
    	ContestUserInfoVO vo=new ContestUserInfoVO();
    	
    	vo.setUserId(userId);
    	vo.setContestSystemType(ContestSystemTypeEnum.RED_STAR.getValue());

    	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestUserInfo/getJoinUserInfo",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
	}
    
    @RequestMapping("/getTopics")
    public String getTopics(HttpServletResponse response) throws IOException{
    	QueryContestTopicVO vo=new QueryContestTopicVO();
		
		vo.setTopicStatus(ContestSystemTypeEnum.RED_STAR.getValue());
	
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestTopic/getSelectTopics",vo);
		response.setContentType("text/html;charset=UTF-8");
	    response.getWriter().write(res.getData());
	    response.getWriter().flush();
	    response.getWriter().close();
	    return null;
    }
    
    /**
     * 减扣次数
     * @param response
     * @param userId
     * @param index
     * @return
     */
    @RequestMapping("/deduction")
    public String deduction(HttpServletResponse response,@RequestParam String userId,@RequestParam Integer index)throws IOException{
    	
    	ContestUserInfoVO vo=new ContestUserInfoVO();
    	vo.setContestSystemType(ContestSystemTypeEnum.RED_STAR.getValue());
    	vo.setUserId(userId);
    	
    	Integer score=null;
    	
    	// 扣积分
    	if(index!=null&&index.intValue()==5)
    	{
    		int []scoreArray=new int []{10,10,10,10,10,50,50,100,100,500};
    		
    		Random r = new Random();
    		
    		int scoreIndex=r.nextInt(scoreArray.length);
    		
    		score=scoreArray[scoreIndex];
    		
    		vo.setCodeCount(score);
    		
    	}
    	
    	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestUserInfo/usedChance",vo);
		
    	JSONObject jsonObject = JSON.parseObject(res.getData());
    	
    	if(score!=null)
    	{
    		jsonObject.put("score", score);
    	}
    	
    	response.setContentType("text/html;charset=UTF-8");
	    response.getWriter().write(jsonObject.toJSONString());
	    response.getWriter().flush();
	    response.getWriter().close();
	    return null;
    }

    
    /**
     * 开始答题
     * @param response
     * @param request
     * @param topicId
     * @return
     * @throws IOException
     */
    @RequestMapping("/startAnswer")
    public String startAnswer(HttpServletResponse response,HttpServletRequest request,String topicId) throws IOException{
    	
    	QueryTopicPassVO vo=new QueryTopicPassVO();
    	
    	vo.setTopicId(topicId);
    	
    	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestTopicPass/getTopicPassInfo",vo);
		response.setContentType("text/html;charset=UTF-8");
		
		JSONObject jsonObject = JSON.parseObject(res.getData());
		Integer status = JSON.parseObject(jsonObject.get("status").toString(),Integer.class);
		
		if(status==1){
			
			JSONObject data=(JSONObject) jsonObject.get("data");
			
			JSONArray questionIdArray=  JSON.parseArray(data.getString("questionIdArray"));
			
			String topicTitle=data.getString("topicTitle");
			
			JSONArray questionArray=  new JSONArray();
			
			for (Object questionId : questionIdArray) {
				
				String id=questionId.toString();
				
				if(StringUtils.isBlank(id))
					continue;
				
				QueryQuestionAnswerInfoVO queryQuestionAnswerInfoVO=new QueryQuestionAnswerInfoVO();
				queryQuestionAnswerInfoVO.setTopicId(topicId);
				queryQuestionAnswerInfoVO.setQuestionId(id);
				
				HttpResponseText res1 = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestQuestion/getQuestionAnswerInfo",queryQuestionAnswerInfoVO);
		
				jsonObject = JSON.parseObject(res1.getData());
				
				status = JSON.parseObject(jsonObject.get("status").toString(),Integer.class);
					
				if(status==1){
						
					questionArray.add(jsonObject.get("data"));
					
				}
			
			}
			
			request.setAttribute("staticServerUrl", staticServer.getStaticServerUrl());
			request.setAttribute("topicName", topicTitle);
			request.setAttribute("questionArray", questionArray);
        	//request.setAttribute("integral", Integer.parseInt(integral));
			
		}
    	
    	return "wechat/static/redStar/startAnswer";
    }
    
    @RequestMapping("/getGift")
    public String getGift(HttpServletResponse response,HttpServletRequest request,String userId) throws IOException{
    	
    	ContestUserInfoVO vo=new ContestUserInfoVO();
    	vo.setUserId(userId);
    	vo.setContestSystemType(ContestSystemTypeEnum.RED_STAR.getValue());
    	
    	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestUserInfo/getGift",vo);
		response.setContentType("text/html;charset=UTF-8");
	    response.getWriter().write(res.getData());
	    response.getWriter().flush();
	    response.getWriter().close();
    	return null;
    }
    
    /**
     * 保存过关信息
     * @param response
     * @param userId
     * @param index
     * @return
     * @throws IOException
     */
    @RequestMapping("/savePass")
    public String savePass(HttpServletResponse response,@RequestParam String userId,@RequestParam Integer index)throws IOException{
    	
    	ContestUserInfoVO vo=new ContestUserInfoVO();
       	vo.setContestSystemType(ContestSystemTypeEnum.RED_STAR.getValue());
    	vo.setUserId(userId);
    	vo.setContestScores(index-1);
    	
    	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestUserInfo/getEditUser",vo);
		response.setContentType("text/html;charset=UTF-8");
	    response.getWriter().write(res.getData());
	    response.getWriter().flush();
	    response.getWriter().close();
    	return null;
    }
    
    @RequestMapping("/saveUserInfo")
    public String saveUserInfo(HttpServletResponse response,ContestUserInfoVO vo
    		)throws IOException{
    	
       	vo.setContestSystemType(ContestSystemTypeEnum.RED_STAR.getValue());
    	
    	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"contestUserInfo/getEditUser",vo);
    	response.setContentType("text/html;charset=UTF-8");
	    response.getWriter().write(res.getData());
	    response.getWriter().flush();
	    response.getWriter().close();
    	return null;
    }
    	
}
