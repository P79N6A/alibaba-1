package com.sun3d.why.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class UserIntegralServiceImpl implements UserIntegralService{
	
	@Autowired
	private UserIntegralMapper userIntegralMapper;
	
	@Autowired
	private CmsTerminalUserMapper cmsTerminalUserMapper;

	@Override
	public int deleteUserIntegralById(String integralId) {
		// TODO Auto-generated method stub
		return userIntegralMapper.deleteByPrimaryKey(integralId);
	}

	@Override
	public int addUserIntegral(UserIntegral record) {
		// TODO Auto-generated method stub
		return userIntegralMapper.insert(record);
	}

	@Override
	public UserIntegral selectUserIntegralById(String integralId) {
		// TODO Auto-generated method stub
		return userIntegralMapper.selectByPrimaryKey(integralId);
	}

	@Override
	public int updateUserIntegral(UserIntegral record) {
		// TODO Auto-generated method stub
		return userIntegralMapper.updateByPrimaryKey(record);
	}

	@Override
	public UserIntegral selectUserIntegralByUserId(String userId) {
			
		UserIntegral userIntegral= userIntegralMapper.selectUserIntegralByUserId(userId);
		
		if(userIntegral!=null)
		{
			return userIntegral;
		}
		else
		{
			userIntegral=new UserIntegral();
			
			userIntegral.setUserId(userId);
        	userIntegral.setIntegralId(UUIDUtils.createUUId());
        	userIntegral.setIntegralNow(0);
        	userIntegral.setIntegralHis(0);
		}
		
		
		return userIntegral;
	}

}
