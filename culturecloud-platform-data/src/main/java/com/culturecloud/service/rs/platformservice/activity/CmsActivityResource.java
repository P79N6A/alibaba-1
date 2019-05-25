package com.culturecloud.service.rs.platformservice.activity;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.request.activity.ActivityWcDetailVO;
import com.culturecloud.model.request.activity.AutomatedNameVO;
import com.culturecloud.model.request.activity.RecommendActivityVO;
import com.culturecloud.model.request.activity.SearchActivityVO;
import com.culturecloud.model.response.activity.CmsActivityDetailVO;
import com.culturecloud.model.response.activity.CmsActivityRecommendVO;
import com.culturecloud.model.response.activity.CmsActivityVO;
import com.culturecloud.service.local.activity.CmsActivityService;

@Component
@Path("/activity")
public class CmsActivityResource {

	@Resource
	private CmsActivityService cmsActivityService;
	
	@POST
	@Path("/recommendActivity")
	@SysBusinessLog(remark="推荐活动列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CmsActivityRecommendVO> recommendActivity(RecommendActivityVO request){
		List<CmsActivityRecommendVO> list=cmsActivityService.queryRecommendActivity(request);
		return list;
	}
	
	@POST
	@Path("/searchActivity")
	@SysBusinessLog(remark="搜索活动列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CmsActivityVO> searchActivity(SearchActivityVO request)
	{
		String keyword=request.getKeyword();
		
		int limit=50;
		
		return cmsActivityService.searchActivity(limit,keyword);
	}
	
	@POST
	@Path("/automatedName")
	@SysBusinessLog(remark="联想词搜索")
	@Produces(MediaType.APPLICATION_JSON)
	public List<String> automatedName(AutomatedNameVO request){
		
		String keyword=request.getKeyword();
		
		int limit=5;
		
		return cmsActivityService.searchAutomatedName(limit,keyword);
	}
	
	@POST
	@Path("/activityDetail")
	@SysBusinessLog(remark="活动详情")
	@Produces(MediaType.APPLICATION_JSON)
	public CmsActivityDetailVO activityDetail(ActivityWcDetailVO request){
		
		CmsActivityDetailVO vo=cmsActivityService.queryCmsActivityDetail(request);
		
		return vo;
	}
}
