package com.culturecloud.test.platform.contest;

import org.junit.Test;

import com.culturecloud.enumeration.SystemSourceEnum;
import com.culturecloud.model.request.contest.QueryUserTopicResultVO;
import com.culturecloud.model.request.contest.SaveContestUserResultVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpContestUserResult extends TestRestService{

	
	@Test
	public void getContestUserResult(){
		
		QueryUserTopicResultVO vo=new QueryUserTopicResultVO();
		
		
		vo.setTopicId("sdsdasd");
		vo.setUserId("00073ebac6534f11bf036d4ec6659c4b");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/contestUserResult/getContestUserResult", vo));
		
	}
	
	@Test
	public void saveContestUserResult(){
		
		SaveContestUserResultVO vo=new SaveContestUserResultVO();
		
		vo.setTopicId("sdsdasd");
		vo.setUserId("00073ebac6534f11bf036d4ec6659c4b");
		
		vo.setAnswerQuestionNumber(1);
		vo.setTrueQuestionNumber(2);
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/contestUserResult/saveContestUserResult", vo));
		
	}
}
