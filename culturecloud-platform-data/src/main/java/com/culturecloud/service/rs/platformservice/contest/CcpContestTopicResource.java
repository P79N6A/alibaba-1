package com.culturecloud.service.rs.platformservice.contest;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BaseRequest;
import com.culturecloud.dao.contest.CcpContestTopicMapper;
import com.culturecloud.dao.dto.contest.CcpContestTopicDto;
import com.culturecloud.model.bean.contest.CcpContestTopic;
import com.culturecloud.model.request.contest.QueryContestTopicDetailVO;
import com.culturecloud.model.request.contest.QueryContestTopicVO;
import com.culturecloud.model.response.contest.CcpContestTopicVO;
import com.culturecloud.service.BaseService;

/**
 * 主题 resource
 * @author zhangshun
 *
 */
@Component
@Path("/contestTopic")
public class CcpContestTopicResource {

	@Resource
	private BaseService baseService;
	
	@Resource
	private CcpContestTopicMapper contestTopicMapper;
	
	/**
	 * 查询获取所有主题
	 * @param request
	 * @return
	 */
	@POST
	@Path("/getAllTopics")
	@SysBusinessLog(remark="获取所有主题分类")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpContestTopicVO> getAllTopics(BaseRequest request)
	{
		List<CcpContestTopicDto> contestTopicDtoList=contestTopicMapper.getAllTopics();
		
		List<CcpContestTopicVO> resultList=new ArrayList<CcpContestTopicVO>();
		
		for (CcpContestTopicDto ccpContestTopicDto : contestTopicDtoList) {
			CcpContestTopicVO vo=new CcpContestTopicVO(ccpContestTopicDto);
			resultList.add(vo);
		}
		 
		return resultList;
	}
	/**
	 * 查询获取所有主题
	 * @param request
	 * @return
	 */
	@POST
	@Path("/getSelectTopics")
	@SysBusinessLog(remark="获取所选主题分类")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpContestTopicVO> getSelectTopics(QueryContestTopicVO request)
	{
		List<CcpContestTopic> contestTopicDtoList=baseService.find(CcpContestTopic.class,"where topic_status='" + request.getTopicStatus() + "'");

		List<CcpContestTopicVO> resultList=new ArrayList<CcpContestTopicVO>();

		for (CcpContestTopic ccpContestTopicDto : contestTopicDtoList) {
			CcpContestTopicVO vo=new CcpContestTopicVO(ccpContestTopicDto);
			resultList.add(vo);
		}

		return resultList;
	}
	
	@POST
	@Path("/contestTopicDetail")
	@SysBusinessLog(remark="获取问答分类详情")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpContestTopicVO contestTopicDetail(QueryContestTopicDetailVO request){
		
		String topicId=request.getTopicId();
		
		CcpContestTopicDto topic=contestTopicMapper.queryContestTopicDetial(topicId);
		
		CcpContestTopicVO vo=new CcpContestTopicVO();
	
		 try {
	            PropertyUtils.copyProperties(vo, topic);
	        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
	            e.printStackTrace();
	        }
		
		return vo;
	}
}
