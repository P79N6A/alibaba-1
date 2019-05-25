package com.sun3d.why.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.model.bean.musicessay.CcpMusicessayUser;
import com.sun3d.why.dao.ccp.CcpMusicessayUserMapper;
import com.sun3d.why.service.CcpMusicessayUserService;

@Service
public class CcpMusicessayUserServiceImpl  implements CcpMusicessayUserService{
	
	@Autowired
	private CcpMusicessayUserMapper ccpMusicessayUserMapper;

	@Override
	public CcpMusicessayUser queryUserInfo(String userId) {
		
		return ccpMusicessayUserMapper.selectByPrimaryKey(userId);
	}

	@Override
	public int saveUserInfo(CcpMusicessayUser user) {
		
		try {
			return ccpMusicessayUserMapper.insertSelective(user);
		} catch (Exception e) {
			e.printStackTrace();
			
			return -1;
		}
		
	}

}
