package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpJiazhouInfo;


public interface CcpJiazhouInfoService {
	
	// 查询嘉州列表
	List<CcpJiazhouInfo> jiazhouInfoList(CcpJiazhouInfo cJiazhouInfo);

	//查询嘉州详情
	CcpJiazhouInfo getCcpJiazhouInfoDetail(String jiazhouInfoId,String userId);
    
}