package com.sun3d.why.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.culture.CcpCultureContestUser;
import com.sun3d.why.dao.dto.CcpCultureContestAnswerDto;
import com.sun3d.why.dao.dto.CcpCultureContestQuestionDto;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpCultureContestAnswerService;
import com.sun3d.why.service.CcpCultureContestQuestionService;
import com.sun3d.why.service.CcpCultureContestUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Controller
@RequestMapping("/cultureContest")
public class CcpCultureContestController {
	
	@Autowired
	private CcpCultureContestUserService ccpCultureContestUserService;
	@Autowired
	private CcpCultureContestQuestionService ccpCultureContestQuestionService;
	@Autowired
	private CcpCultureContestAnswerService ccpCultureContestAnswerSerice;
	@Autowired
	private UserIntegralDetailService userIntegralDetailService;
	
	@Autowired
	private StaticServer staticServer;
	
	@RequestMapping(value = "/saveUserInfo")
	@ResponseBody
	public Map<String, String> saveUserInfo(CcpCultureContestUser user,
			@DateTimeFormat(pattern = "yyyy-MM-dd")  Date birthday) {

		try {
			
			user.setUserBirthday(birthday);
			
			Map<String, String> map= ccpCultureContestUserService.saveUserInfo(user);
			
			//添加积分
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralChange(500);
			userIntegralDetail.setChangeType(0);
			userIntegralDetail.setIntegralFrom("2017传统文化知识大赛答题参与答题");
			userIntegralDetail.setIntegralType(IntegralTypeEnum.CULTURE_CONTEST.getIndex());
			userIntegralDetail.setUserId(user.getUserId());
			userIntegralDetail.setUpdateType(1);
			
			userIntegralDetailService.updateIntegralByVo(userIntegralDetail);
			
			return map;
		} catch (Exception e) {

			e.printStackTrace();
			Map<String, String> result = new HashMap<>();
			result.put("result", "error");

			return result;
		}
	}

	@RequestMapping(value = "/queryStageQuestion")
	@ResponseBody
	public Set<CcpCultureContestQuestionDto> queryStageQuestion(HttpServletRequest request,@RequestParam Integer stageNumber) {
	
		Set<CcpCultureContestQuestionDto> questionList=ccpCultureContestQuestionService.queryStageQuestion(stageNumber);
		
		return questionList;
	}
	
	@RequestMapping(value = "/saveAnswer")
	@ResponseBody
	public Map<String, String> saveAnswer(
			String cultureAnswerId,
			String rightAnswer,
			Integer answerTime,
			Integer cultureQuestionId){
		
		try {
			
			return ccpCultureContestQuestionService.saveAnswer(cultureAnswerId, rightAnswer, answerTime, cultureQuestionId);
		} catch (Exception e) {

			e.printStackTrace();
			Map<String, String> result = new HashMap<>();
			result.put("result", "error");

			return result;
		}
	}
	
	@RequestMapping(value = "/queryTestRanking")
	@ResponseBody
	public List<CcpCultureContestAnswerDto> queryTestRanking(HttpServletRequest request, String userId, Integer stageNumber,Integer userGroupType){
		
		
		if(StringUtils.isNotBlank(userId)){
			
			CcpCultureContestUser cultureContestUser=ccpCultureContestUserService.queryUserInfo(userId);
			
			String cultureUserId=cultureContestUser.getCultureUserId();
			
			if(stageNumber==0){
				
				List<CcpCultureContestAnswerDto> answerSumDtoList=ccpCultureContestAnswerSerice.queryAnswerSumRanking(cultureUserId, null, null, cultureContestUser.getUserGroupType(),null);
			
				return answerSumDtoList;
			}
			else{
				List<CcpCultureContestAnswerDto> answerDtoList=ccpCultureContestAnswerSerice.queryAnswerRanking(cultureUserId, stageNumber, null, cultureContestUser.getUserGroupType(),null);
				
				return answerDtoList;
			}
		}else
		{
			
			if(stageNumber==0){
				
				List<CcpCultureContestAnswerDto> answerSumDtoList=ccpCultureContestAnswerSerice.queryAnswerSumRanking(null, null, null, userGroupType,10);
			
				return answerSumDtoList;
			}
			else{
				List<CcpCultureContestAnswerDto> answerDtoList=ccpCultureContestAnswerSerice.queryAnswerRanking(null, stageNumber, null, userGroupType,10);
				
				return answerDtoList;
			}
			
		}
		
		
		
		
	}
}
