package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.contest.CcpContestAnswer;
import com.culturecloud.model.bean.contest.CcpContestQuestion;
import com.sun3d.why.dao.dto.CcpContestTopicQuestionDto;
import com.sun3d.why.model.CmsUserAnswer;
import com.sun3d.why.util.Pagination;

public interface CcpContestTopicQuestionService {
	
	/**
	 * 查询主题试题
	 * @param topicId
	 * @return
	 */
	public List<CcpContestTopicQuestionDto> queryCcpContestTopicQuestions(String topicId, Pagination page);

	/**
	 * 保存试题
	 * @param question
	 * @param topicId
	 * @param answerPicUrl
	 * @param answerText
	 * @param isTrue
	 * @return
	 */
	public int saveCcpContestQuestion(CcpContestQuestion question,String topicId,String[]answerPicUrl,String[]answerText,String []isTrue);

	/**查询试题
	 * @param questionId
	 * @return
	 */
	public CcpContestQuestion queryCcpContestQuestionById(String questionId);
	
	public List<CcpContestAnswer> queryQuestionAnswer(String questionId);

	public List<CmsUserAnswer> queryUserMessage(String topicId,
			Pagination page, CmsUserAnswer cmsUserAnswer);


	
}
