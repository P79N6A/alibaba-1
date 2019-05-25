package com.culturecloud.service.local.impl.contest;

import java.util.TreeSet;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.contest.CcpContestUserResultMapper;
import com.culturecloud.dao.dto.contest.CcpContestUserResultDto;
import com.culturecloud.model.bean.contest.CcpContestUserResult;
import com.culturecloud.model.request.contest.SaveContestUserResultVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.contest.CcpContestUserResultService;

@Service
public class CcpContestUserResultServiceImpl implements CcpContestUserResultService{
	
	private final Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private BaseService baseService;
	
	@Resource
	private CcpContestUserResultMapper contestUserResultMapper; 

	/* (non-Javadoc)
	 * @see com.culturecloud.service.local.CcpContestUserResultService#saveContestUserResult(com.culturecloud.service.vo.request.SaveContestUserResultVO)
	 */
	@Override
	public int saveContestUserResult(SaveContestUserResultVO saveContestUserResultVO) {
 
		int result=1;
			
			String userId=saveContestUserResultVO.getUserId();
			
			String topicId=saveContestUserResultVO.getTopicId();
			
			CcpContestUserResultDto contestUserResult=contestUserResultMapper.queryUserContestResult(userId,topicId);
			
			CcpContestUserResult userResult=new CcpContestUserResult();
			
			if(contestUserResult==null)
			{
				userResult.setUserId(userId);
				userResult.setTopicId(topicId);
				userResult.setUserTopicResultId(UUIDUtils.createUUId());
				 
				baseService.create(userResult);
			}
			else
			{
				userResult.setUserTopicResultId(contestUserResult.getUserTopicResultId());
			}
		
			
			// 回答的试题
			Integer answerQuestionNumber=saveContestUserResultVO.getAnswerQuestionNumber();
			
			if(answerQuestionNumber!=null){
				
				// 所有回答的试题
				String allQuestionNumber=contestUserResult.getAllQuestionNumber();
				
				TreeSet<Integer> allQuestionNumberSet=new TreeSet<>();
				
				if(StringUtils.isNotBlank(allQuestionNumber))
				{
					String allQuestionNumberArray[]=allQuestionNumber.split(",");
					
					for (String questionNumber : allQuestionNumberArray) {
						
						try {
							Integer number=Integer.valueOf(questionNumber);
							allQuestionNumberSet.add(number);
							
						} catch (NumberFormatException e) {
							continue;
						}
					}
				}
				allQuestionNumberSet.add(answerQuestionNumber);
				
				allQuestionNumber=StringUtils.join(allQuestionNumberSet, ",");
				
				userResult.setAllQuestionNumber(allQuestionNumber);
				
			}
			// 回答正确度的试题
			Integer trueQuestionNumber=saveContestUserResultVO.getTrueQuestionNumber();
			
			if(trueQuestionNumber!=null){
				
				// 所有回答正确的试题
				String allTrueQuestionNumber=contestUserResult.getTrueQuestionNumber();
				
				TreeSet<Integer> trueQuestionNumberSet=new TreeSet<>();
				
				if(StringUtils.isNotBlank(allTrueQuestionNumber))
				{
					String allTrueQuestionNumberArray[]=allTrueQuestionNumber.split(",");
					
					for (String questionNumber : allTrueQuestionNumberArray) {
						
						try {
							Integer number=Integer.valueOf(questionNumber);
							trueQuestionNumberSet.add(number);
							
						} catch (NumberFormatException e) {
							continue;
						}
					}
				}
				trueQuestionNumberSet.add(trueQuestionNumber);
				
				allTrueQuestionNumber=StringUtils.join(trueQuestionNumberSet, ",");
				
				userResult.setTrueQuestionNumber(allTrueQuestionNumber);
			}
			
			if(answerQuestionNumber!=null||trueQuestionNumber!=null){
				baseService.update(userResult, "where user_topic_result_id='"+userResult.getUserTopicResultId()+"'");
			}
			
	
		return result;
	}

}
