package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CcpJiazhouInfo;


public interface CcpJiazhouInfoMapper {

	int jiazhouInfoListCount(Map<String, Object> map);

	List<CcpJiazhouInfo> jiazhouInfoList(Map<String, Object> map);

	int insertJiazhouInfo(CcpJiazhouInfo record);

	int updateJiazhouInfo(CcpJiazhouInfo record);

	CcpJiazhouInfo selectByJiazhouInfoId(String jiazhouInfoId);

	void delJiazhouInfo(String jiazhouInfoId);
	
}