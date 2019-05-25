package com.culturecloud.service.local.heritage;

import java.util.List;

import com.culturecloud.model.request.heritage.CcpHeritageReqVO;
import com.culturecloud.model.response.heritage.CcpHeritageResVO;

public interface CcpHeritageService {

	public List<CcpHeritageResVO> getCcpHeritageList(CcpHeritageReqVO request);
	
	public CcpHeritageResVO getCcpHeritageById(CcpHeritageReqVO request);
	
	/**
	 * 用于后台编辑
	 * @param request
	 * @return
	 */
	public CcpHeritageResVO getHeritageById(CcpHeritageReqVO request);
	
	public void insertHeritage(CcpHeritageReqVO request);	
	
	public void updateHeritage(CcpHeritageReqVO request);	
}
