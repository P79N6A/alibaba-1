package com.sun3d.why.webservice.service;

import com.sun3d.why.model.BpAntique;
import com.sun3d.why.util.PaginationApp;

public interface BpAntiqueService {
	/**
	 * 查询文物列表
	 * @param pageApp
	 * @return
	 */
	String queryBpAntiqueList(PaginationApp pageApp);
	/**
	 * 根据id查询文物信息
	 * @param antiqueId
	 * @param userId
	 * @return
	 */
	BpAntique queryBpAntiqueById(String antiqueId,String userId);


}
