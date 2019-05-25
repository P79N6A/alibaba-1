package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.sun3d.why.dao.dto.CcpLiveMessageDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CcpLiveMessageService {

	public List<CcpLiveMessageDto> queryLiveMessageByCondition(CcpLiveMessage message,String liveActvityName,Pagination page);
	
	public CcpLiveMessage findById(String messageId);
	
	public int saveMessage(CcpLiveMessage message,SysUser sysUser);
	
	// 添加马甲消息
	public int saveAutoMessage(CcpLiveMessage message);
	
	
	public int setMessageTop(CcpLiveMessage message,SysUser sysUser);
}
