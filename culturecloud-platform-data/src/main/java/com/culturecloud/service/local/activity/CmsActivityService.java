package com.culturecloud.service.local.activity;

import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.culturecloud.dao.dto.activity.ActivityDTO;
import com.culturecloud.model.request.activity.ActivityWcDetailVO;
import com.culturecloud.model.request.activity.RecommendActivityVO;
import com.culturecloud.model.request.ticketmachine.GetActListVO;
import com.culturecloud.model.response.activity.CmsActivityDetailVO;
import com.culturecloud.model.response.activity.CmsActivityRecommendVO;
import com.culturecloud.model.response.activity.CmsActivityVO;
import com.culturecloud.open.req.ActivitysRequest;

public interface CmsActivityService {

	/**
	 * 查询推荐活动
	 * 
	 * @return
	 */
	public List<CmsActivityRecommendVO> queryRecommendActivity(RecommendActivityVO request);

	/**
	 * 关键字搜索
	 * 
	 * @param limit
	 * @param keyword
	 * @return
	 */
	public List<CmsActivityVO> searchActivity(int limit, String keyword);

	/**
	 * 搜索联想词名称
	 * 
	 * @param limit
	 * @param name
	 * @return
	 */
	public List<String> searchAutomatedName(int limit, String name);

	/**
	 * 活动详情
	 * 
	 * @param request
	 * @return
	 */
	public CmsActivityDetailVO queryCmsActivityDetail(ActivityWcDetailVO request);

	/*ActivityDTO getActiviyList(ActivitysRequest open);*/

	public JSONObject queryTicketActivityByCidition(GetActListVO request);
}
