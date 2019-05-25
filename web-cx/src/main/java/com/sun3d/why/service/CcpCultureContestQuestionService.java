package com.sun3d.why.service;

import java.util.Map;
import java.util.Set;

import com.sun3d.why.dao.dto.CcpCultureContestQuestionDto;

public interface CcpCultureContestQuestionService {

	public Set<CcpCultureContestQuestionDto> queryStageQuestion(Integer stageNumber);
	
	public Map<String, String> saveAnswer(String cultureAnswerId,
			String rightAnswer,
			Integer useTime,
			Integer cultureQuestionId);
}
