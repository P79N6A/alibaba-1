package com.culturecloud.test.platform.association;

import org.junit.Test;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.model.request.association.AssociationActivityVO;
import com.culturecloud.model.request.association.GetAssociationDetailVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpAssociation extends TestRestService{

	@Test
	public void getAssociationList(){
		
		BaseRequest request=new BaseRequest();
		System.out.println(HttpRequest.sendPost(BASE_URL+"/association/getAssociationList", request));
		
	}
	
	@Test
	public void getAssociationDetail(){
		
		GetAssociationDetailVO vo=new GetAssociationDetailVO();
		
		vo.setAssociationId("0ead672fac2f4e65b0ec12cad960ad98");
		vo.setUserId("34d19243d94441deb50aba5769b404f1");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/association/getAssociationDetail", vo));
	}
	
	@Test
	public void getAssociationActivity(){
		
		AssociationActivityVO vo=new AssociationActivityVO();
		
		vo.setAssociationId("0ead672fac2f4e65b0ec12cad960ad98");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/association/associationActivity", vo));
	}
	
	@Test
	public void getAssociationHistoryActivity(){
		
		AssociationActivityVO vo=new AssociationActivityVO();
		
		vo.setAssociationId("0ead672fac2f4e65b0ec12cad960ad98");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/association/associationHistoryActivity", vo));
	}
}
