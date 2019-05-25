package com.culturecloud.service.rs.platformservice.volunteer;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BaseRequest;
import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;
import com.culturecloud.model.request.volunteer.SaveVolunteerApplyVO;
import com.culturecloud.model.request.volunteer.VolunteerRecruitDetailVO;
import com.culturecloud.model.response.volunteer.CcpVolunteerRecruitVO;
import com.culturecloud.service.local.volunteer.CcpVolunteerApplyService;
import com.culturecloud.service.local.volunteer.CcpVolunteerRecruitService;

@Component
@Path("/volunteerRecruit")
public class CcpVolunteerRecruitSource {
	
	@Resource
	private CcpVolunteerRecruitService ccpVolunteerRecruitService;
	
	@Resource
	private CcpVolunteerApplyService ccpVolunteerApplyService;
	
	@POST
	@Path("/recruitList")
	@SysBusinessLog(remark="志愿者招募列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpVolunteerRecruitVO> recruitList(BaseRequest request)
	{
		
		return ccpVolunteerRecruitService.queryVolunteerRecruitList();
	}
	
	@POST
	@Path("/recruitDetail")
	@SysBusinessLog(remark="志愿者招募详情")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpVolunteerRecruitVO recruitDetail(VolunteerRecruitDetailVO request)
	{
		String recruitId=request.getRecruitId();
		
		CcpVolunteerRecruitVO vo= ccpVolunteerRecruitService.queryVolunteerRecruitDetail(recruitId);
		
		return vo;
	}
	
	@POST
	@Path("/applyVolunteer")
	@SysBusinessLog(remark="志愿者报名")
	@Produces(MediaType.APPLICATION_JSON)
	public void saveVolunteerApply(SaveVolunteerApplyVO request){
		
		CcpVolunteerApply volunteerApply=request.getAcpVolunteerApply();
		
		String []volunteerApplyPic=request.getVolunteerApplyPic();
		
		ccpVolunteerApplyService.saveVolunteerApply(volunteerApply, volunteerApplyPic);
		
	}
}
