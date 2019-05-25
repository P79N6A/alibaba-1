package com.culturecloud.test.platform.activity;

import org.junit.Test;

import com.culturecloud.model.request.activity.AutomatedNameVO;
import com.culturecloud.model.request.activity.RecommendActivityVO;
import com.culturecloud.model.request.activity.SearchActivityVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCmsActivity extends TestRestService{

	@Test
	public void recommendActivity(){
		
		RecommendActivityVO request=new RecommendActivityVO();
		
		Integer resultIndex=0;
		
		Integer resultSize=5;
		
		request.setResultIndex(resultIndex);
		request.setResultSize(resultSize);
		
		double lon=121.546168;
		
		double lat=31.214124;
		
		request.setLat(lat);
		request.setLon(lon);
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/activity/recommendActivity", request));
		
	}
	
	@Test
	public void searchActivity(){
		
		SearchActivityVO request=new SearchActivityVO();
		
		request.setKeyword("街道");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/activity/searchActivity", request));
	}
	
	@Test
	public void automatedName(){
		
		AutomatedNameVO request=new AutomatedNameVO();
		
		request.setKeyword("上海");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/activity/automatedName", request));
	}
}
