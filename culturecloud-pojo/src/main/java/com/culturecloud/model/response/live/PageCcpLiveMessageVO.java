package com.culturecloud.model.response.live;

import java.util.Date;
import java.util.List;

import com.culturecloud.bean.BasePageResultListVO;

public class PageCcpLiveMessageVO extends BasePageResultListVO<CcpLiveMessageVO>{
	
	private Long resultEndTime;
	
	private Long resultStartTime;

	public PageCcpLiveMessageVO(List<CcpLiveMessageVO> result, int sum) {
		super(result,sum);
	}

	public Long getResultEndTime() {
		return resultEndTime;
	}

	public void setResultEndTime(Long resultEndTime) {
		this.resultEndTime = resultEndTime;
	}

	public Long getResultStartTime() {
		return resultStartTime;
	}

	public void setResultStartTime(Long resultStartTime) {
		this.resultStartTime = resultStartTime;
	}

	
	
	
}
