package com.culturecloud.service.local.live;

import java.util.List;

import com.culturecloud.model.request.live.CcpLiveMessagePageVO;
import com.culturecloud.model.response.live.CcpLiveMessageVO;
import com.culturecloud.model.response.live.PageCcpLiveMessageVO;

public interface CcpLiveMessageService {

	PageCcpLiveMessageVO getLiveMessageList(CcpLiveMessagePageVO request);
	
	List<CcpLiveMessageVO> getLiveHistoryVideoList( String liveActivityId);
}
