package com.culturecloud.service.rs.platformservice.heritage;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.request.heritage.CcpHeritageReqVO;
import com.culturecloud.model.response.heritage.CcpHeritageResVO;
import com.culturecloud.service.local.heritage.CcpHeritageService;

@Component
@Path("/heritage")
public class CcpHeritageResource {

	@Resource
	private CcpHeritageService ccpHeritageService;

	@POST
	@Path("/getCcpHeritageList")
	@SysBusinessLog(remark="获取非遗列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpHeritageResVO> getCcpHeritageList(CcpHeritageReqVO request){
		return ccpHeritageService.getCcpHeritageList(request);
	}
	
	@POST
	@Path("/getCcpHeritageById")
	@SysBusinessLog(remark="根据ID获取非遗")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpHeritageResVO getCcpHeritageById(CcpHeritageReqVO request){
		return ccpHeritageService.getCcpHeritageById(request);
	}
	
	/**
	 * 用于后台编辑
	 * @param request
	 * @return
	 */
	@POST
	@Path("/getHeritageById")
	@SysBusinessLog(remark="根据ID获取非遗")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpHeritageResVO getHeritageById(CcpHeritageReqVO request){
		return ccpHeritageService.getHeritageById(request);
	}
	
	@POST
	@Path("/saveCcpHeritage")
	@SysBusinessLog(remark="添加非遗")
	@Produces(MediaType.APPLICATION_JSON)
	public void saveCcpHeritage(CcpHeritageReqVO request){
		ccpHeritageService.insertHeritage(request);
	}
	
	@POST
	@Path("/updateCcpHeritage")
	@SysBusinessLog(remark="编辑非遗")
	@Produces(MediaType.APPLICATION_JSON)
	public void updateCcpHeritage(CcpHeritageReqVO request){
		ccpHeritageService.updateHeritage(request);
	}
	
}
