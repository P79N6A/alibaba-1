package com.culturecloud.test.platform.association;

import org.junit.Test;

import com.culturecloud.model.request.association.AssociationResourceListVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpAssociationRes extends TestRestService{

	@Test
	public void associationResourceList(){
		
		AssociationResourceListVO vo=new AssociationResourceListVO();
		vo.setAssociationId("1883b371dbd4403aba8e3aac9166d19c");
		System.out.println(HttpRequest.sendPost(BASE_URL+"/associationRes/associationResourceList", vo));
		
	}
}
