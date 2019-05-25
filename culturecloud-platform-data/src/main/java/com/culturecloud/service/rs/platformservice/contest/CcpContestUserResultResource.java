package com.culturecloud.service.rs.platformservice.contest;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BaseRequest;
import com.culturecloud.dao.contest.CcpContestUserResultMapper;
import com.culturecloud.dao.dto.contest.CcpContestTopicDto;
import com.culturecloud.dao.dto.contest.CcpContestUserResultDto;
import com.culturecloud.model.request.contest.QueryUserTopicResultVO;
import com.culturecloud.model.request.contest.SaveContestUserResultVO;
import com.culturecloud.model.response.contest.CcpContestTopicVO;
import com.culturecloud.model.response.contest.CcpContestUserResultVO;
import com.culturecloud.service.local.contest.CcpContestUserResultService;

/**
 * 用户主题结果 resource
 * @author zhangshun
 *
 */
@Component
@Path("/contestUserResult")
public class CcpContestUserResultResource {

	@Resource
	private CcpContestUserResultMapper contestUserResultMapper;
	
	@Resource
	private CcpContestUserResultService contestUserResultService;
	
	
	/**
	 * 查询用户主题答题情况
	 * @param contestUserResultVO
	 * @return
	 */
	@POST
	@Path("/getContestUserResult")
	@SysBusinessLog(remark="查询用户主题答题情况")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpContestUserResultVO getContestUserResult(QueryUserTopicResultVO queryUserTopicResultVO)
	{
		String userId=queryUserTopicResultVO.getUserId();
		
		String topicId=queryUserTopicResultVO.getTopicId();
		
		CcpContestUserResultDto userResult=contestUserResultMapper.queryUserContestResult(userId,topicId);
		
		if(userResult!=null)
		{
			CcpContestUserResultVO vo=new CcpContestUserResultVO(userResult);
			
			return vo;
		}
		else
			return null;
	}
	
	@POST
	@Path("/saveContestUserResult")
	@SysBusinessLog(remark="保存用户主题回答答案")
	@Produces(MediaType.APPLICATION_JSON)
	public void saveContestUserResult(SaveContestUserResultVO saveContestUserResultVO)
	{
		contestUserResultService.saveContestUserResult(saveContestUserResultVO);
		
	}
	
	/**
	 * 获取所有参与人数
	 * @return
	 */
	@POST
	@Path("/getAllUserNum")
	@SysBusinessLog(remark="获取所有参与人数")
	@Produces(MediaType.APPLICATION_JSON)
	public String getAllUserNum(BaseRequest request){
		return contestUserResultMapper.getAllUserNum();
	}
}
