package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.sun3d.why.dao.CcpLiveMessageMapper;
import com.sun3d.why.dao.dto.CcpLiveMessageDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpLiveMessageService;
import com.sun3d.why.util.CommentUtil;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CcpLiveMessageServiceImpl implements CcpLiveMessageService {

	@Autowired
	private CcpLiveMessageMapper liveMessageMapper;

	@Override
	public List<CcpLiveMessageDto> queryLiveMessageByCondition(CcpLiveMessage message,String liveActvityName, Pagination page) {

		Map<String, Object> map = new HashMap<>();

		String messageActivity = message.getMessageActivity();

		if (StringUtils.isNotBlank(messageActivity)) {

			map.put("messageActivity", messageActivity);
		}
		
		String userId=message.getMessageCreateUser();
		
		if(StringUtils.isNotBlank(userId)){
			map.put("liveCreateUser", userId);
		}
		
		Integer messageIsInteraction=message.getMessageIsInteraction();
		
		if(messageIsInteraction!=null){
			
			map.put("messageIsInteraction", messageIsInteraction);
		}	
		
		if(StringUtils.isNotBlank(liveActvityName)){
			
			map.put("liveActvityName", liveActvityName);
		}
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			
			int total = liveMessageMapper.queryLiveMessageCountByCondition(map);

			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}

		List<CcpLiveMessageDto> list = liveMessageMapper.queryLiveMessageByCondition(map);

		return list;
	}

	@Override
	public CcpLiveMessage findById(String messageId) {
		return liveMessageMapper.selectByPrimaryKey(messageId);
	}

	@Override
	public int saveMessage(CcpLiveMessage message, SysUser sysUser) {

		String messageId = message.getMessageId();

		int result = 0;

		if (StringUtils.isBlank(messageId)) {
			message.setMessageId(UUIDUtils.createUUId());
			message.setMessageIsDel(Constant.NORMAL);
			message.setMessageIsTop(0);
			message.setMessageCreateUser(sysUser.getUserId());
			message.setMessageCreateTime(new Date());

			result = liveMessageMapper.insert(message);
		} else {
			result = liveMessageMapper.updateByPrimaryKeySelective(message);
		}

		return result;
	}

	@Override
	public int setMessageTop(CcpLiveMessage message, SysUser sysUser) {

		int result = 1;

		try {
			
			CcpLiveMessage m= liveMessageMapper.selectByPrimaryKey( message.getMessageId());
			
			if(m.getMessageIsTop()!=null&&m.getMessageIsTop()==1)
			{
				m.setMessageIsTop(0);
				return liveMessageMapper.updateByPrimaryKeySelective(m);
				
			}

			Map<String, Object> map = new HashMap<>();

			String messageActivity = message.getMessageActivity();

			if (StringUtils.isNotBlank(messageActivity)) {

				map.put("messageActivity", messageActivity);
			}

			map.put("messageId", message.getMessageId());

			liveMessageMapper.setMessageTop(map);

		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}

		return result;
	}

	@Override
	public int saveAutoMessage(CcpLiveMessage message) {
		
		int result = 0;
		
		message.setMessageId(UUIDUtils.createUUId());
		message.setMessageIsDel(Constant.NORMAL);
		message.setMessageIsTop(0);
		
		String ids [] =CommentUtil.COMMENT_USERID;
		
		int length =ids.length;
		
		int i=new java.util.Random().nextInt(length);
		
		message.setMessageCreateUser(ids[i]);

		result = liveMessageMapper.insert(message);
		
		return result;
	}

}
