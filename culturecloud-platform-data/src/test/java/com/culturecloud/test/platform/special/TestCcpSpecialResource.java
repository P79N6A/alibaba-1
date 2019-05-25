package com.culturecloud.test.platform.special;

import org.junit.Test;

import com.culturecloud.model.request.special.GetSpecCodeReqVO;
import com.culturecloud.model.request.special.SpecialCodeReqVO;
import com.culturecloud.model.request.special.SpecialNameReqVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpSpecialResource extends TestRestService{

	@Test
	public void getImageByChannelName()
	{
		SpecialNameReqVO vo=new SpecialNameReqVO();
		vo.setSpecialName("2312");
		System.out.println(HttpRequest.sendPost(BASE_URL+"/specialchange/getImageByChannelName", vo));
	}
	
	@Test
	public void getYCode()
	{
		GetSpecCodeReqVO vo=new GetSpecCodeReqVO();
		vo.setEnterId("51ed69a4ae114e3fa067450b4133d075");
		vo.setName("张顺");
		vo.setTelphone("13818888888");
		System.out.println(HttpRequest.sendPost(BASE_URL+"/specialchange/getYCode", vo));
	}
	
	@Test
	public void getActivityListByCode()
	{
		SpecialCodeReqVO vo=new SpecialCodeReqVO();
		vo.setSpecialCode("1234");
		System.out.println(HttpRequest.sendPost(BASE_URL+"/specialchange/getActivityListByCode", vo));
	}
	
	
}
