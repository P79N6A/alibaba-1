package com.culturecloud.test.platform.contest;

import org.junit.Test;

import com.culturecloud.enumeration.SystemSourceEnum;
import com.culturecloud.model.request.contest.QueryQuestionAnswerInfoVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpContestQuestion extends TestRestService{

	@Test
	public void getQuestionAnswerInfo(){
		
		QueryQuestionAnswerInfoVO queryQuestionAnswerInfoVO =new QueryQuestionAnswerInfoVO();
		queryQuestionAnswerInfoVO.setQuestionId("2");
		queryQuestionAnswerInfoVO.setTopicId("sdsdasd");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/contestQuestion/getQuestionAnswerInfo", queryQuestionAnswerInfoVO));
		
		
	}
}
