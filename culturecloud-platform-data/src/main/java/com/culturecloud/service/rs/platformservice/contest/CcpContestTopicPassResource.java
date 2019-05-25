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
import com.culturecloud.dao.contest.CcpContestTopicPassMapper;
import com.culturecloud.dao.contest.CcpContestTopicQuestionMapper;
import com.culturecloud.dao.contest.CcpContestUserResultMapper;
import com.culturecloud.dao.dto.contest.CcpContestTopicQuestionDto;
import com.culturecloud.model.bean.contest.CcpContestTopic;
import com.culturecloud.model.bean.contest.CcpContestTopicPass;
import com.culturecloud.model.request.contest.QueryTopicPassShareVO;
import com.culturecloud.model.request.contest.QueryTopicPassVO;
import com.culturecloud.model.response.contest.CcpContestTopicPassVO;
import com.culturecloud.model.response.contest.TopicPassInfoVO;
import com.culturecloud.model.response.contest.TopicShareInfoVO;
import com.culturecloud.service.BaseService;

@Component
@Path("/contestTopicPass")
public class CcpContestTopicPassResource {
	
	@Resource
	private CcpContestTopicPassMapper contestTopicPassMapper;
	
	@Resource
	private CcpContestTopicQuestionMapper contestTopicQuestionMapper;
	
	@Resource
	private CcpContestUserResultMapper contestUserResultMapper;
	
	@Resource
	private BaseService baseService;

	@POST
	@Path("/getTopicPassInfo")
	@SysBusinessLog(remark="获取主题下的关卡信息")
	@Produces(MediaType.APPLICATION_JSON)
	public TopicPassInfoVO getTopicPassInfo (QueryTopicPassVO queryTopicPassVO)
	{
		TopicPassInfoVO vo=new TopicPassInfoVO();
		
		String topicId= queryTopicPassVO.getTopicId();
		
		CcpContestTopic topic=baseService.findById(CcpContestTopic.class, topicId);
		
		// 试题过关集合
		List<CcpContestTopicPass> contestTopicPassList=baseService.find(CcpContestTopicPass.class, "where topic_id='"+topicId+"' order by pass_number asc");
		
		List<CcpContestTopicPassVO> contestTopicPassVOList=new ArrayList<CcpContestTopicPassVO>();		
		
		for (CcpContestTopicPass ccpContestTopicPass : contestTopicPassList) {
			
			CcpContestTopicPassVO contestTopicPassVO =new CcpContestTopicPassVO(ccpContestTopicPass);
			contestTopicPassVOList.add(contestTopicPassVO);
		}
		
		vo.setTopicPassVOList(contestTopicPassVOList);
		vo.setTopicId(topicId);
		
		// 主题下总题数
		List<CcpContestTopicQuestionDto> contestTopicQuestionList=contestTopicQuestionMapper.queryTopicQuestion(topicId);
		
		String [] questionIdArray =new String[contestTopicQuestionList.size()];
		
		for (int i = 0; i < contestTopicQuestionList.size(); i++) {
			String questionid=contestTopicQuestionList.get(i).getQuestionId();
			questionIdArray[i]=questionid;
		}
		
		vo.setSum(contestTopicQuestionList.size());
		vo.setQuestionIdArray(questionIdArray);
		vo.setTopicName(topic.getTopicName());
		vo.setTopicTitle(topic.getTopicTitle());
		
		return vo;
	}	
	
	@POST
	@Path("/getTopicShareInfo")
	@SysBusinessLog(remark="获取主题通关分享信息")
	@Produces(MediaType.APPLICATION_JSON)
	public TopicShareInfoVO getTopicShareInfo (QueryTopicPassShareVO queryTopicPassShareVO){
		TopicShareInfoVO result = new TopicShareInfoVO();
		CcpContestTopic topic=baseService.findById(CcpContestTopic.class, queryTopicPassShareVO.getTopicId());
		result.setTopicName(topic.getTopicName());
		result.setTopicTitle(topic.getTopicTitle());
		result.setPassName(topic.getPassName());
		result.setPassText(topic.getPassText());
		result.setRanking(contestUserResultMapper.queryTopicAllPassRanking(queryTopicPassShareVO));
		return result;
	}
}
