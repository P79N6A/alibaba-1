package com.culturecloud.service.rs.platformservice.association;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.bean.association.CcpAssociationFlower;
import com.culturecloud.model.request.association.SaveCcpAssociationFlowerVO;
import com.culturecloud.service.local.association.CcpAssociationFlowerService;

@Component
@Path("/associationFlower")
public class CcpAssociationFlowerResource {

	@Resource
	private CcpAssociationFlowerService ccpAssociationFlowerService;
	
	@POST
	@Path("/saveCcpAssociationFlower")
	@SysBusinessLog(remark="社团浇花")
	@Produces(MediaType.APPLICATION_JSON)
	public void saveCcpAssociationFlower(SaveCcpAssociationFlowerVO request){
		
		String associationId=request.getAssociationId();
		
		String userId=request.getUserId();
		
		CcpAssociationFlower ccpAssociationFlower=new CcpAssociationFlower();
		ccpAssociationFlower.setAssnId(associationId);
		ccpAssociationFlower.setUserId(userId);
		
		ccpAssociationFlowerService.saveCcpAssociationFlower(ccpAssociationFlower);
		
	}
}
