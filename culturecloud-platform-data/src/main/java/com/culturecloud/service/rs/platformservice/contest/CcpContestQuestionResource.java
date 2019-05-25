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
import com.culturecloud.dao.contest.CcpContestQuestionMapper;
import com.culturecloud.dao.contest.CcpContestTopicPassMapper;
import com.culturecloud.dao.contest.CcpContestTopicQuestionMapper;
import com.culturecloud.dao.contest.CcpContestUserResultMapper;
import com.culturecloud.dao.dto.contest.CcpContestTopicQuestionDto;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.contest.CcpContestAnswer;
import com.culturecloud.model.bean.contest.CcpContestQuestion;
import com.culturecloud.model.bean.contest.CcpContestTopic;
import com.culturecloud.model.bean.contest.CcpContestTopicPass;
import com.culturecloud.model.bean.contest.CcpContestTopicQuestion;
import com.culturecloud.model.bean.contest.CcpContestTopicQuestionKey;
import com.culturecloud.model.bean.contest.CcpContestUserInfo;
import com.culturecloud.model.request.contest.QueryContestTopicDetailVO;
import com.culturecloud.model.request.contest.QueryQuestionAnswerInfoVO;
import com.culturecloud.model.request.contest.QueryQuestionShareInfoVO;
import com.culturecloud.model.response.contest.CcpContestAnswerVO;
import com.culturecloud.model.response.contest.QuestionAnswerInfoVO;
import com.culturecloud.model.response.contest.QuestionShareInfoVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.utils.StringUtils;

/**
 * @author zhangshun
 */
@Component
@Path("/contestQuestion")
public class CcpContestQuestionResource {

	@Resource
	private CcpContestTopicQuestionMapper contestTopicQuestionMapper;

	@Resource
	private CcpContestTopicPassMapper contestTopicPassMapper;

	@Resource
	private CcpContestQuestionMapper contestQuestionMapper;

	@Resource
	private CcpContestUserResultMapper contestUserResultMapper;

	@Resource
	private BaseService baseService;

	@POST
	@Path("/getTopicQuestionAnswerInfo")
	@SysBusinessLog(remark = "获取分类所有题目信息")
	@Produces(MediaType.APPLICATION_JSON)
	public ArrayList<QuestionAnswerInfoVO> getTopicQuestionAnswerInfo(QueryContestTopicDetailVO request) {

		ArrayList<QuestionAnswerInfoVO> result = new ArrayList<QuestionAnswerInfoVO>();

		String topicId = request.getTopicId();

		List<CcpContestTopicQuestionDto> list = contestTopicQuestionMapper.queryTopicAllQuestion(topicId);
		
		for (CcpContestTopicQuestionDto ccpContestTopicQuestionDto : list) {
			
			QuestionAnswerInfoVO vo=new QuestionAnswerInfoVO();
			
			vo.setQuestionId(ccpContestTopicQuestionDto.getQuestionId());
			vo.setQuestionTitle(ccpContestTopicQuestionDto.getQuestionTitle());
			vo.setQuestionNumber(ccpContestTopicQuestionDto.getQuestionNumber());
			
			List<CcpContestAnswerVO> answerVOList = new ArrayList<CcpContestAnswerVO>();

			for (CcpContestAnswer ccpContestAnswer : ccpContestTopicQuestionDto.getAnswerList()) {

				answerVOList.add(new CcpContestAnswerVO(ccpContestAnswer));
			}
			vo.setAnswerList(answerVOList);
			
			result.add(vo);
		}

		return result;
	}

	@POST
	@Path("/getQuestionAnswerInfo")
	@SysBusinessLog(remark = "获取试题的题目信息")
	@Produces(MediaType.APPLICATION_JSON)
	public QuestionAnswerInfoVO getQuestionAnswerInfo(QueryQuestionAnswerInfoVO queryQuestionAnswerInfoVO) {

		QuestionAnswerInfoVO result = new QuestionAnswerInfoVO();

		String questionId = queryQuestionAnswerInfoVO.getQuestionId();
		String topicId = queryQuestionAnswerInfoVO.getTopicId();

		CcpContestTopic topic = baseService.findById(CcpContestTopic.class, topicId);

		result.setTopicId(topic.getTopicId());
		result.setTopicName(topic.getTopicName());

		CcpContestQuestion question = baseService.findById(CcpContestQuestion.class, questionId);

		result.setQuestionId(question.getQuestionId());
		result.setQuestionTitle(question.getQuestionTitle());

		CcpContestTopicQuestionKey id = new CcpContestTopicQuestionKey(questionId, topicId);

		CcpContestTopicQuestion contestTopicQuestion = contestTopicQuestionMapper.selectByPrimaryKey(id);

		if (contestTopicQuestion == null) {
			BizException.Throw("试题在主题中不存在！");
		} else {
			result.setQuestionNumber(contestTopicQuestion.getQuestionNumber());
		}
		List<CcpContestAnswer> answerList = baseService.find(CcpContestAnswer.class,
				"where question_id='" + questionId + "' order by answer_id asc");

		List<CcpContestAnswerVO> answerVOList = new ArrayList<CcpContestAnswerVO>();

		for (CcpContestAnswer ccpContestAnswer : answerList) {

			answerVOList.add(new CcpContestAnswerVO(ccpContestAnswer));
		}
		result.setAnswerList(answerVOList);

		return result;

	}

	@POST
	@Path("/getQuestionShareInfo")
	@SysBusinessLog(remark = "获取过关分享信息")
	@Produces(MediaType.APPLICATION_JSON)
	public QuestionShareInfoVO getQuestionShareInfo(QueryQuestionShareInfoVO questionShareInfoVO) {
		QuestionShareInfoVO result = new QuestionShareInfoVO();
		CcpContestTopicPass ccpContestTopicPass = contestTopicPassMapper
				.queryCcpContestTopicPassByVo(questionShareInfoVO);
		result.setPassName(ccpContestTopicPass.getPassName());
		result.setRanking(contestUserResultMapper.queryTopicPassRanking(questionShareInfoVO));
		CcpContestTopic topic = baseService.findById(CcpContestTopic.class, questionShareInfoVO.getTopicId());
		result.setTopicName(topic.getTopicName());
		result.setTopicTitle(topic.getTopicTitle());
		return result;
	}

	@POST
	@Path("/getQuestionInfoWithUserId")
	@SysBusinessLog(remark = "获取试题的题目信息")
	@Produces(MediaType.APPLICATION_JSON)
	public QuestionAnswerInfoVO getQuestionInfoWithUserId(QueryQuestionAnswerInfoVO queryQuestionAnswerInfoVO) {
		QuestionAnswerInfoVO result = new QuestionAnswerInfoVO();
		if (StringUtils.isBlank(queryQuestionAnswerInfoVO.getUserId())) {
			BizException.Throw("400", "请上传用户ID");
		} else {
			result = this.getQuestionAnswerInfo(queryQuestionAnswerInfoVO);
			CcpContestTopic topic = baseService.findById(CcpContestTopic.class, queryQuestionAnswerInfoVO.getTopicId());
			List<CcpContestUserInfo> users = baseService.find(CcpContestUserInfo.class,
					"where user_id='" + queryQuestionAnswerInfoVO.getUserId() + "' and contest_system_type='"
							+ topic.getTopicStatus() + "'");
			CcpContestUserInfo user = users.get(0);
			if (user.getChanceTemporaryNumber() > 0) {
				user.setChanceTemporaryNumber(user.getChanceTemporaryNumber() - 1);
			} else if (user.getChancePermanentNumber() > 0) {
				user.setChancePermanentNumber(user.getChanceTemporaryNumber() - 1);
			} else {
				BizException.Throw("400", "机会不足");
			}
			baseService.update(user, "where user_id='" + queryQuestionAnswerInfoVO.getUserId()
					+ "' and contest_system_type='" + topic.getTopicStatus() + "'");
		}
		return result;
	}
}
