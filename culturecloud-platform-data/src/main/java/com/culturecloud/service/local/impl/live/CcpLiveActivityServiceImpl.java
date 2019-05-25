package com.culturecloud.service.local.impl.live;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.dao.dto.live.CcpLiveActivityDto;
import com.culturecloud.dao.live.CcpLiveActivityMapper;
import com.culturecloud.kafka.PpsConfig;
import com.culturecloud.model.request.common.SysUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveActivityPageVO;
import com.culturecloud.model.request.live.CcpRecommendLiveListVO;
import com.culturecloud.model.response.live.CcpLiveActivityVO;
import com.culturecloud.service.local.live.CcpLiveActivityService;

@Service
@Transactional
public class CcpLiveActivityServiceImpl implements CcpLiveActivityService {

	@Resource
	private CcpLiveActivityMapper ccpLiveActivityMapper;

	private String staticServerUrl = PpsConfig.getString("staticServerUrl");

	@Override
	public BasePageResultListVO<CcpLiveActivityVO> getLiveActivityList(CcpLiveActivityPageVO liveActivityPageVO) {

		List<CcpLiveActivityVO> result = new ArrayList<CcpLiveActivityVO>();

		int sum = ccpLiveActivityMapper.selectLiveActivityCount(liveActivityPageVO);

		if (sum > 0) {

			List<CcpLiveActivityDto> list = ccpLiveActivityMapper.selectLiveActivityList(liveActivityPageVO);

			Date now = new Date();

			for (int i = 0; i < list.size(); i++) {

				CcpLiveActivityDto liveActivityDto = list.get(i);

				CcpLiveActivityVO vo = new CcpLiveActivityVO(liveActivityDto);

				vo.setUserName(liveActivityDto.getUserName());

				String userHeadImgUrl = "";

				if (vo.getUserHeadImgUrl() != null && vo.getUserHeadImgUrl().indexOf("http:") > -1)

					userHeadImgUrl = vo.getUserHeadImgUrl();
				else if (StringUtils.isBlank(vo.getUserHeadImgUrl())) {

					userHeadImgUrl = "";
				} else
					userHeadImgUrl = staticServerUrl + vo.getUserHeadImgUrl();

				vo.setUserHeadImgUrl(userHeadImgUrl);

				// 已结束
				if (vo.getLiveStatus() != null && vo.getLiveStatus() == 2) {
					vo.setLiveActivityTimeStatus(3);
				}
				// 未发布
				else if (vo.getLiveStatus() != null && vo.getLiveStatus() == 0) {
					vo.setLiveActivityTimeStatus(2);
				} else {

					// 正在直播
					if (now.after(vo.getLiveStartTime())) {
						vo.setLiveActivityTimeStatus(1);
					}
					// 尚未开始
					else
						vo.setLiveActivityTimeStatus(2);
				}

				result.add(vo);
			}
		}

		BasePageResultListVO<CcpLiveActivityVO> basePageResultListVO = new BasePageResultListVO<CcpLiveActivityVO>(
				result, sum);
		basePageResultListVO.setResultSize(liveActivityPageVO.getResultSize());
		basePageResultListVO.setResultIndex(liveActivityPageVO.getResultIndex());
		basePageResultListVO.setResultFirst(liveActivityPageVO.getResultFirst());

		return basePageResultListVO;
	}

	@Override
	public CcpLiveActivityVO queryByLiveActivityId(String liveActivityId) {

		CcpLiveActivityDto liveActivity = ccpLiveActivityMapper.selectByPrimaryKey(liveActivityId);

		Integer hot = liveActivity.getLiveHot();

		if (hot == null) {
			liveActivity.setLiveHot(1);
		} else
			liveActivity.setLiveHot(hot + 1);

		ccpLiveActivityMapper.updateByPrimaryKeySelective(liveActivity);

		CcpLiveActivityVO vo = new CcpLiveActivityVO(liveActivity);

		Date now = new Date();

		vo.setUserName(liveActivity.getUserName());

		String userHeadImgUrl = "";

		if (vo.getUserHeadImgUrl() != null && vo.getUserHeadImgUrl().indexOf("http:") > -1)

			userHeadImgUrl = vo.getUserHeadImgUrl();
		else if (StringUtils.isBlank(vo.getUserHeadImgUrl())) {

			userHeadImgUrl = "";
		} else
			userHeadImgUrl = staticServerUrl + vo.getUserHeadImgUrl();

		vo.setUserHeadImgUrl(userHeadImgUrl);

		// 已结束
		if (vo.getLiveStatus() != null && vo.getLiveStatus() == 2) {
			vo.setLiveActivityTimeStatus(3);
		}
		// 未发布
		else if (vo.getLiveStatus() != null && vo.getLiveStatus() == 0) {
			vo.setLiveActivityTimeStatus(2);
		} else {

			// 正在直播
			if (now.after(vo.getLiveStartTime())) {
				vo.setLiveActivityTimeStatus(1);
				
				long nowLong = new Date().getTime();
				long starLong = vo.getLiveStartTime().getTime();

				long started =  (nowLong - starLong)/1000/60;
				
				if(started<=120){
					
					Integer hot1 = liveActivity.getLiveHot();

					int i=new Random().nextInt(100) +1;
					
					liveActivity.setLiveHot(hot1+i);
					
					ccpLiveActivityMapper.updateByPrimaryKeySelective(liveActivity);
				}
				
			}
			// 尚未开始
			else {

				long nowLong = new Date().getTime();
				long starLong = vo.getLiveStartTime().getTime();

				long countDown = starLong - nowLong;

				vo.setCountDown(countDown);
				vo.setLiveActivityTimeStatus(2);

			}

		}

		vo.setShareUrl("http://m.wenhuayun.cn/wechatLive/liveActivity.do?liveActivityId=" + vo.getLiveActivityId());

		return vo;
	}

	@Override
	public Integer selectIndexNum(CcpLiveActivityPageVO request) {
		return ccpLiveActivityMapper.selectIndexNum(request);
	}

	@Override
	public CcpLiveActivityVO queryUserInfo(SysUserDetailVO request) {

		CcpLiveActivityDto liveActivity = ccpLiveActivityMapper.queryUserInfo(request);

		CcpLiveActivityVO vo = new CcpLiveActivityVO(liveActivity);

		vo.setUserName(liveActivity.getUserName());

		String userHeadImgUrl = "";

		if (vo.getUserHeadImgUrl() != null && vo.getUserHeadImgUrl().indexOf("http:") > -1)

			userHeadImgUrl = vo.getUserHeadImgUrl();
		else if (StringUtils.isBlank(vo.getUserHeadImgUrl())) {

			userHeadImgUrl = "";
		} else
			userHeadImgUrl = staticServerUrl + vo.getUserHeadImgUrl();

		vo.setUserHeadImgUrl(userHeadImgUrl);

		return vo;
	}

	@Override
	public List<CcpLiveActivityVO> getLiveActivityHotList() {

		List<CcpLiveActivityVO> result = new ArrayList<CcpLiveActivityVO>();

		int sum = 10;

		List<CcpLiveActivityDto> list = ccpLiveActivityMapper.selectLiveActivityHotList();

		Date now = new Date();

		for (int i = 0; i < list.size(); i++) {

			CcpLiveActivityDto liveActivityDto = list.get(i);

			CcpLiveActivityVO vo = new CcpLiveActivityVO(liveActivityDto);

			vo.setUserName(liveActivityDto.getUserName());

			String userHeadImgUrl = "";

			if (vo.getUserHeadImgUrl() != null && vo.getUserHeadImgUrl().indexOf("http:") > -1)

				userHeadImgUrl = vo.getUserHeadImgUrl();
			else if (StringUtils.isBlank(vo.getUserHeadImgUrl())) {

				userHeadImgUrl = "";
			} else
				userHeadImgUrl = staticServerUrl + vo.getUserHeadImgUrl();

			vo.setUserHeadImgUrl(userHeadImgUrl);

			// 已结束
			if (vo.getLiveStatus() != null && vo.getLiveStatus() == 2) {
				vo.setLiveActivityTimeStatus(3);
			}
			// 未发布
			else if (vo.getLiveStatus() != null && vo.getLiveStatus() == 0) {
				vo.setLiveActivityTimeStatus(2);
			} else {

				// 正在直播
				if (now.after(vo.getLiveStartTime())) {
					vo.setLiveActivityTimeStatus(1);
				}
				// 尚未开始
				else
					vo.setLiveActivityTimeStatus(2);
			}

			result.add(vo);
		}

		return result;
	}

	@Override
	public Map<String, Object> userLiveTotalInfo(String userId) {
		
		Map<String,Object> map=new HashMap<>();
		
		Integer userTotalLive=ccpLiveActivityMapper.userTotalLive(userId);
		
		Integer userTotalLiveLike=ccpLiveActivityMapper.userTotalLiveLike(userId);
		
		Integer userTotalLiveMessage=ccpLiveActivityMapper.userTotalLiveMessage(userId);
		
		CcpLiveActivityPageVO liveActivityPageVO=new CcpLiveActivityPageVO();
		
		liveActivityPageVO.setLiveCreateUser(userId);
		
		int sum=ccpLiveActivityMapper.selectLiveActivityCount(liveActivityPageVO);
		
		if(sum>0){
			map.put("isPulishLive", 1);
		}else
			map.put("isPulishLive", 0);
		
		map.put("userTotalLive", userTotalLive);
		map.put("userTotalLiveLike", userTotalLiveLike);
		map.put("userTotalLiveMessage", userTotalLiveMessage);
		
		return map;
	}

	@Override
	public List<CcpLiveActivityVO> getLiveActivityRecommendList(CcpRecommendLiveListVO request) {
		
		List<CcpLiveActivityVO> result = new ArrayList<CcpLiveActivityVO>();
		
		List<CcpLiveActivityDto> list = ccpLiveActivityMapper.selectLiveActivityRecommendList(request);

		Date now = new Date();

		for (int i = 0; i < list.size(); i++) {

			CcpLiveActivityDto liveActivityDto = list.get(i);

			CcpLiveActivityVO vo = new CcpLiveActivityVO(liveActivityDto);

			vo.setUserName(liveActivityDto.getUserName());

			String userHeadImgUrl = "";

			if (vo.getUserHeadImgUrl() != null && vo.getUserHeadImgUrl().indexOf("http:") > -1)

				userHeadImgUrl = vo.getUserHeadImgUrl();
			else if (StringUtils.isBlank(vo.getUserHeadImgUrl())) {

				userHeadImgUrl = "";
			} else
				userHeadImgUrl = staticServerUrl + vo.getUserHeadImgUrl();

			vo.setUserHeadImgUrl(userHeadImgUrl);

			// 已结束
			if (vo.getLiveStatus() != null && vo.getLiveStatus() == 2) {
				vo.setLiveActivityTimeStatus(3);
			}
			// 未发布
			else if (vo.getLiveStatus() != null && vo.getLiveStatus() == 0) {
				vo.setLiveActivityTimeStatus(2);
			} else {

				// 正在直播
				if (now.after(vo.getLiveStartTime())) {
					vo.setLiveActivityTimeStatus(1);
				}
				// 尚未开始
				else
					vo.setLiveActivityTimeStatus(2);
			}

			result.add(vo);
		}

		return result;
	}

}
