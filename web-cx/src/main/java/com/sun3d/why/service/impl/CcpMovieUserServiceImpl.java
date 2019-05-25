package com.sun3d.why.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.culturecloud.model.bean.moviessay.CcpMoviessayUser;
import com.sun3d.why.dao.ccp.CcpMoviessayUserMapper;
import com.sun3d.why.service.CcpMoviessayUserService;
@Service
public class CcpMovieUserServiceImpl implements CcpMoviessayUserService{
	
	@Autowired
	private CcpMoviessayUserMapper ccpMoviessayUserMapper;
	
	//查询用户信息
	@Override
	public CcpMoviessayUser queryUserInfo(String userId) {
		return ccpMoviessayUserMapper.selectByPrimaryKey(userId);
	}
	
	//新增用户信息
	@Override
	public int saveUserInfo(CcpMoviessayUser user) {
		try {
			return ccpMoviessayUserMapper.insertSelective(user);
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}

	@Override
	public String selectByUserId(String userId) {
		return ccpMoviessayUserMapper.selectByUserId(userId);
	}	
}
