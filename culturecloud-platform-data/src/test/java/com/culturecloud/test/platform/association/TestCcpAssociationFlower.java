package com.culturecloud.test.platform.association;

import org.junit.Test;

import com.culturecloud.model.request.association.SaveCcpAssociationFlowerVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpAssociationFlower  extends TestRestService{

	@Test
	public void saveCcpAssociationFlower(){
		
		SaveCcpAssociationFlowerVO request=new SaveCcpAssociationFlowerVO();
		
		request.setUserId("33");
		request.setAssociationId("1");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/associationFlower/saveCcpAssociationFlower", request));
		
	}
}
