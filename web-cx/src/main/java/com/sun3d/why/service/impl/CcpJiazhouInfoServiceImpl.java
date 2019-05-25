package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.ccp.CcpJiazhouInfoMapper;
import com.sun3d.why.model.ccp.CcpJiazhouInfo;
import com.sun3d.why.service.CcpJiazhouInfoService;

@Service
@Transactional
public class CcpJiazhouInfoServiceImpl implements CcpJiazhouInfoService{	
	@Autowired
    private CcpJiazhouInfoMapper ccpJiazhouInfoMapper;

	@Override
	public List<CcpJiazhouInfo> jiazhouInfoList(CcpJiazhouInfo cJiazhouInfo) {
		 Map<String, Object> map = new HashMap<String, Object>();
	       return ccpJiazhouInfoMapper.ccpJiazhouInfoList(map);
	}

	@Override
	public CcpJiazhouInfo getCcpJiazhouInfoDetail(String jiazhouInfoId,String userId) {
		    CcpJiazhouInfo info = new CcpJiazhouInfo();
		    Map<String, Object> map = new HashMap<String, Object>();
		    map.put("type", 6);
			 if (StringUtils.isNotBlank(jiazhouInfoId)) {
				   info = ccpJiazhouInfoMapper.selectByCcpJiazhouInfoId(jiazhouInfoId);	
				   map.put("jiazhouInfoId", jiazhouInfoId);
				   Integer ino = ccpJiazhouInfoMapper.selectByCcpJiazhouInfoLoveCount(map);
			        if (ino!=null) {
			            info.setJiazhouInfoIsWant(ino);
			        } 
					 if (StringUtils.isNotBlank(userId)) {
						 map.put("userId", userId);
						 Integer inn = ccpJiazhouInfoMapper.selectByCcpJiazhouInfoLoveCount(map);
						 if (inn!=null) {
					            info.setJiazhouInfoTF(inn);
					        }
					 }
			    //浏览数
		     /*  if (info.getBrowseCount()!=null) {
		            info.setBrowseCount(info.getBrowseCount() + 1);
		           } else {
		            info.setBrowseCount(1);
		           }	*/				  	
				 }						 
			    return info;
	}

}
