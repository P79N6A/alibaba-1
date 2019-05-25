package com.culturecloud.service.local.impl.live;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.dao.dto.live.CcpLiveMessageDto;
import com.culturecloud.dao.live.CcpLiveActivityMapper;
import com.culturecloud.dao.live.CcpLiveMessageMapper;
import com.culturecloud.kafka.PpsConfig;
import com.culturecloud.model.bean.live.CcpLiveActivity;
import com.culturecloud.model.request.live.CcpLiveMessagePageVO;
import com.culturecloud.model.response.live.CcpLiveMessageVO;
import com.culturecloud.model.response.live.PageCcpLiveMessageVO;
import com.culturecloud.service.local.live.CcpLiveMessageService;

@Service
@Transactional
public class CcpLiveMessageServiceImpl implements CcpLiveMessageService{
	
	@Resource
	private CcpLiveMessageMapper ccpLiveMessageMapper;
	
	@Resource
	private CcpLiveActivityMapper ccpLiveActivityMapper;
	
	private String staticServerUrl=PpsConfig.getString("staticServerUrl");

	@Override
	public PageCcpLiveMessageVO getLiveMessageList(CcpLiveMessagePageVO liveMessagePageVO) {
		
		List<CcpLiveMessageVO> result=new ArrayList<CcpLiveMessageVO>();
		
		//是否是互动直播信息 0.否 1.是
		Integer messageIsInteraction=liveMessagePageVO.getMessageIsInteraction();
		
		 Long resultStartTime=liveMessagePageVO.getResultStartTime();
		
		 Long resultEndTime=liveMessagePageVO.getResultEndTime();
		 
		 if(messageIsInteraction==null&& resultStartTime==null&&resultEndTime==null){
			 resultStartTime=new Date().getTime();
			 liveMessagePageVO.setResultStartTime(resultStartTime);
		 }
		
		int sum=ccpLiveMessageMapper.selectLiveMessageCount(liveMessagePageVO);
	
		if(sum>0){
			
			CcpLiveActivity liveMessage=ccpLiveActivityMapper.selectByPrimaryKey(liveMessagePageVO.getMessageActivity());

			liveMessagePageVO.setLiveStatus(liveMessage.getLiveStatus());
			
			List<CcpLiveMessageDto> list=ccpLiveMessageMapper.selectLiveMessageList(liveMessagePageVO);
			
			for (int i = 0; i < list.size(); i++) {
				
				CcpLiveMessageDto liveMessageDto=list.get(i);
				
				CcpLiveMessageVO message=new CcpLiveMessageVO(liveMessageDto);
				message.setSortTime(message.getSortTime());
				message.setUserName(message.getUserName());
				
				String userHeadImgUrl = "";
				
				if(message.getUserHeadImgUrl()!=null&&message.getUserHeadImgUrl().indexOf("http:")>-1)
            		
            		userHeadImgUrl=message.getUserHeadImgUrl();
				
				else if(StringUtils.isBlank(message.getUserHeadImgUrl())){
					
					userHeadImgUrl="";
				}
            	else
            		userHeadImgUrl = staticServerUrl + message.getUserHeadImgUrl();
			
				message.setUserHeadImgUrl(userHeadImgUrl);
				result.add(message);
				
				if(resultEndTime!=null&&i==0){
					resultEndTime=message.getSortTime();
				}
			}
		}
		
		
		PageCcpLiveMessageVO vo=new PageCcpLiveMessageVO(result, sum);
		
		vo.setResultSize(liveMessagePageVO.getResultSize());
		vo.setResultIndex(liveMessagePageVO.getResultIndex());
		vo.setResultFirst(liveMessagePageVO.getResultFirst());
		
		if(resultStartTime!=null)
			vo.setResultStartTime(resultStartTime);
		if(resultEndTime !=null)
			vo.setResultEndTime(resultEndTime);
		
		return vo;
	}

	@Override
	public List<CcpLiveMessageVO> getLiveHistoryVideoList(String liveActivityId) {
		
		List<CcpLiveMessageVO> result=new ArrayList<CcpLiveMessageVO>();
		
		List<CcpLiveMessageDto> list=ccpLiveMessageMapper.getLiveHistoryVideoList(liveActivityId);
		
		for (int i = 0; i < list.size(); i++) {
			
			CcpLiveMessageDto liveMessageDto=list.get(i);
			
			CcpLiveMessageVO message=new CcpLiveMessageVO(liveMessageDto);
			
			result.add(message);
		}
		return result;
	}
	
}
