package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.live.CcpLiveActivity;
import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.culturecloud.model.bean.live.CcpLiveUser;
import com.sun3d.why.dao.CcpLiveActivityMapper;
import com.sun3d.why.dao.CcpLiveMessageMapper;
import com.sun3d.why.dao.CcpLiveUserMapper;
import com.sun3d.why.dao.dto.CcpLiveActivityDto;
import com.sun3d.why.service.CcpLiveActivityService;
import com.sun3d.why.util.CommentUtil;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CcpLiveActivityServiceImpl implements CcpLiveActivityService {

	@Autowired
	private CcpLiveActivityMapper liveActivityMapper;
	
	@Autowired
	private CcpLiveUserMapper liveUserMapper;
	
	@Autowired
	private CcpLiveMessageMapper ccpLiveMessageMapper;

	@Override
	public List<CcpLiveActivityDto> queryLiveActivityByCondition(String userId,Integer liveActivityTimeStatus, Integer liveStatus,
			Integer liveType,Integer liveCheck, Pagination page) {
		
		Map<String, Object> map = new HashMap<>();

		if (liveActivityTimeStatus!=null) {

			map.put("liveActivityTimeStatus", liveActivityTimeStatus);
		}
		if (liveType!=null) {

			map.put("liveType", liveType);
		}
		if (liveStatus!=null) {

			map.put("liveStatus", liveStatus);
		}
		
		if (liveCheck!=null) {

			map.put("liveCheck", liveCheck);
		}
		
		if(userId!=null)
		{
			map.put("liveCreateUser", userId);
		}
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			
			int total =liveActivityMapper.selectLiveActivityCount(map);

			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}
		
		Date now = new Date();

		List<CcpLiveActivityDto> list = liveActivityMapper.selectLiveActivityList(map);
		
		for (CcpLiveActivityDto ccpLiveActivityDto : list) {
			
			// 已结束
			if(ccpLiveActivityDto.getLiveStatus()!=null&&ccpLiveActivityDto.getLiveStatus()==2)
			{
				ccpLiveActivityDto.setLiveActivityTimeStatus(3);
			}
			// 未发布
			else if (ccpLiveActivityDto.getLiveStatus()!=null&&ccpLiveActivityDto.getLiveStatus()==0){
				ccpLiveActivityDto.setLiveActivityTimeStatus(2);
			}
			else{
				
				// 正在直播
				if(now.after(ccpLiveActivityDto.getLiveStartTime())){
					ccpLiveActivityDto.setLiveActivityTimeStatus(1);
				}
				// 尚未开始
				else 
					ccpLiveActivityDto.setLiveActivityTimeStatus(2);
			}
		}
		
		

		return list;
	}

	@Override
	public int updateLiveActivity(CcpLiveActivity ccpLiveActivity) {

		Integer liveStatus=ccpLiveActivity.getLiveStatus();
		
		Integer liveCheck = ccpLiveActivity.getLiveCheck();
		
		if(liveStatus!=null&&liveStatus==2){
			ccpLiveActivity.setLiveEndTime(new Date());
		}
		
		if(liveCheck!= null&& liveCheck==2){
			ccpLiveActivity.setLiveCheckTime(new Date());
		}

		return liveActivityMapper.updateByPrimaryKeySelective(ccpLiveActivity);
	}

	@Override
	public CcpLiveActivity queryLiveActivityById(String liveActivityId) {
		
		return liveActivityMapper.selectByPrimaryKey(liveActivityId);
	}

	@Override
	public int addManyMessage(String liveActivityId, Integer commontNum, Integer likeNum) {

		CcpLiveActivity liveActivity=liveActivityMapper.selectByPrimaryKey(liveActivityId);

		if(likeNum!=null&&likeNum>0){
			
			for (int i = 0; i < likeNum; i++) {
				
				CcpLiveUser user=new CcpLiveUser();
				
				user.setLiveUserId(UUIDUtils.createUUId());
				user.setUserIsLike(1);
				user.setLiveActivity(liveActivity.getLiveActivityId());
				
				liveUserMapper.insertSelective(user);
			}
		}
		
		if(commontNum!=null&&commontNum>0){
			
			String userIds [] =CommentUtil.COMMENT_USERID;
			String comentArray [] =CommentUtil.COMMENT_CONTEXT;
			
			long liveCreateTime=liveActivity.getLiveStartTime().getTime();
			long now=new Date().getTime();
		
			for (int i = 0; i < commontNum; i++) {
			
			CcpLiveMessage message= new CcpLiveMessage();
			
			message.setMessageId(UUIDUtils.createUUId());
			message.setMessageIsDel(Constant.NORMAL);
			
			message.setMessageIsInteraction(1);
			message.setMessageIsRecommend(0);
			message.setMessageActivity(liveActivity.getLiveActivityId());
		
			int userlength =userIds.length;
			int userIndex=new java.util.Random().nextInt(userlength);
			
			message.setMessageCreateUser(userIds[userIndex]);
			
			int comentlength=comentArray.length;
			int comentIndex=new java.util.Random().nextInt(comentlength);
			
			message.setMessageContent(comentArray[comentIndex]);
			
			long rtn = liveCreateTime + (long)(Math.random() * (now - liveCreateTime));  
			
			message.setMessageCreateTime(new Date(rtn));
			message.setSortTime(rtn);

			ccpLiveMessageMapper.insert(message);
			
			
			}
			
		}
	
		
		return 0;
	}

}
