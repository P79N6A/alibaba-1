package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;

import com.culturecloud.model.bean.contest.CcpContestAnswer;
import com.culturecloud.model.bean.contest.CcpContestQuestion;
import com.culturecloud.model.bean.contest.CcpContestTopicQuestion;
import com.sun3d.why.dao.CcpContestAnswerMapper;
import com.sun3d.why.dao.CcpContestQuestionMapper;
import com.sun3d.why.dao.CcpContestTopicQuestionMapper;
import com.sun3d.why.dao.CmsUserAnswerMapper;
import com.sun3d.why.dao.CmsUserCnAnswerMapper;
import com.sun3d.why.dao.dto.CcpContestTopicDto;
import com.sun3d.why.dao.dto.CcpContestTopicQuestionDto;
import com.sun3d.why.model.CmsUserAnswer;
import com.sun3d.why.service.CcpContestTopicQuestionService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CcpContestTopicQuestionServiceImpl implements CcpContestTopicQuestionService {

	@Autowired
	private CcpContestTopicQuestionMapper contestTopicQuestionMapper;
	
	@Autowired
	private CcpContestQuestionMapper contestQuestionMapper;
	
	@Autowired
	private CcpContestAnswerMapper contestAnswerMapper;
	
	@Autowired
	private CmsUserAnswerMapper userAnswerMapper;
	
	/* (non-Javadoc)
	 * @see com.sun3d.why.service.CcpContestTopicQuestionService#queryCcpContestTopicQuestions(java.lang.String, com.sun3d.why.util.Pagination)
	 */
	@Override
	public List<CcpContestTopicQuestionDto> queryCcpContestTopicQuestions(String topicId, Pagination page) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("topicId", topicId);
		  //分页
	     if (page != null && page.getFirstResult() != null && page.getRows() != null) {
		     map.put("firstResult", page.getFirstResult());
	       map.put("rows", page.getRows());
	       int total = contestTopicQuestionMapper.queryContestTopicQuestionCount(map);
	       page.setTotal(total);
	     }
     
	     List<CcpContestTopicQuestionDto>contestTopicQuestionList=contestTopicQuestionMapper.queryCcpContestTopicQuestion(map);
	
	     return contestTopicQuestionList;
	}
 
	/* (non-Javadoc)
	 * @see com.sun3d.why.service.CcpContestTopicQuestionService#saveCcpContestQuestion(com.culturecloud.model.bean.contest.CcpContestQuestion, java.lang.String, java.lang.String[], java.lang.String[], java.lang.String[])
	 */
	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public int saveCcpContestQuestion(CcpContestQuestion question, String topicId, String[] answerPicUrl,
			String[] answerText, String[] isTrueCheck) {
		
		int result=0;

		String questionId=question.getQuestionId();
		
		if(StringUtils.isBlank(questionId))
		{
			questionId=UUIDUtils.createUUId();
			question.setQuestionId(questionId);
			
			result=contestQuestionMapper.insert(question);
			
			if(result>0)
			{
				Integer questionNumber=contestTopicQuestionMapper.questionTopicQuestionMaxNumber(topicId);
				
				if(questionNumber==null)
					questionNumber=1;
				else
					questionNumber+=1;
				
				CcpContestTopicQuestion contestTopicQuestion=new CcpContestTopicQuestion();
				contestTopicQuestion.setQuestionId(questionId);
				contestTopicQuestion.setTopicId(topicId);
				contestTopicQuestion.setQuestionNumber(questionNumber);
				
				contestTopicQuestionMapper.insert(contestTopicQuestion);
				
				this.saveAnswer(questionId, answerPicUrl, answerText, isTrueCheck);
			}
		}
		else
		{
			result=contestQuestionMapper.updateByPrimaryKey(question);
			
			this.saveAnswer(questionId, answerPicUrl, answerText, isTrueCheck);
		}
		
		return result;
	}
	
	private void saveAnswer(String questionId,String[] answerPicUrls,
			String[] answerTexts, String[] isTrues)
	{
		contestAnswerMapper.deleteByQuestionId(questionId);
		
		for (int i = 0; i < answerPicUrls.length; i++) {
			
			String answerPicUrl=answerPicUrls[i];
			String answerText=answerTexts[i];
			String isTrue=isTrues[i];
			
			CcpContestAnswer answer=new CcpContestAnswer();
			answer.setAnswerId(UUIDUtils.createUUId());
			answer.setAnswerText(answerText);
			answer.setAnswerPicUrl(answerPicUrl);
			answer.setIsTrue(Integer.valueOf(isTrue));
			answer.setQuestionId(questionId);
			contestAnswerMapper.insert(answer);
			
		}
		
	}

	@Override
	public CcpContestQuestion queryCcpContestQuestionById(String questionId) {
		
		return contestQuestionMapper.selectByPrimaryKey(questionId);
	}

	@Override
	public List<CcpContestAnswer> queryQuestionAnswer(String questionId) {
		
		return contestAnswerMapper.queryQuestionAnswers(questionId);
	}


	@Override
	public List<CmsUserAnswer> queryUserMessage(String topicId,
			Pagination page, CmsUserAnswer cmsUserAnswer) {
		    Map<String, Object> map = new HashMap<String, Object>();
			map.put("answerType", topicId);
			if(StringUtils.isNotBlank(cmsUserAnswer.getUserName())){
				map.put("userName",cmsUserAnswer.getUserName());
			}
			  //分页
		     if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			     map.put("firstResult", page.getFirstResult());
		       map.put("rows", page.getRows());
		       int total = userAnswerMapper.queryUserList(map);
		       page.setTotal(total);
		     }
	     
		     List<CmsUserAnswer> userAnswerList=userAnswerMapper.queryUserMessage(map);
		
		     return userAnswerList;
	}		

}
