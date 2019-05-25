package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.ccp.CcpJiazhouInfo;

public interface CcpJiazhouInfoMapper {

	List<CcpJiazhouInfo> ccpJiazhouInfoList(Map<String, Object> map);
	
	CcpJiazhouInfo selectByCcpJiazhouInfoId(String jiazhouInfoId);

	Integer selectByCcpJiazhouInfoLoveCount(Map<String, Object> map);

}