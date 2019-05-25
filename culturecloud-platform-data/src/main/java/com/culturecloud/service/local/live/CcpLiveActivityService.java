package com.culturecloud.service.local.live;

import java.util.List;
import java.util.Map;

import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.model.request.common.SysUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveActivityPageVO;
import com.culturecloud.model.request.live.CcpRecommendLiveListVO;
import com.culturecloud.model.response.live.CcpLiveActivityVO;

public interface CcpLiveActivityService {

	BasePageResultListVO<CcpLiveActivityVO> getLiveActivityList(CcpLiveActivityPageVO request);

	CcpLiveActivityVO queryByLiveActivityId(String liveActivityId);

	Integer selectIndexNum(CcpLiveActivityPageVO request);

	CcpLiveActivityVO queryUserInfo(SysUserDetailVO request);

	List<CcpLiveActivityVO> getLiveActivityHotList();

	Map<String, Object> userLiveTotalInfo(String userId);

	List<CcpLiveActivityVO> getLiveActivityRecommendList(CcpRecommendLiveListVO request);
}
