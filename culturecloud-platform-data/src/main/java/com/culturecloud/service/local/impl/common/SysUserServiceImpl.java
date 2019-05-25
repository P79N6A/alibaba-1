package com.culturecloud.service.local.impl.common;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.dao.common.SysUserMapper;
import com.culturecloud.model.bean.common.SysUser;
import com.culturecloud.service.local.common.SysUserService;
import com.culturecloud.utils.MD5Util;

@Service
@Transactional
public class SysUserServiceImpl implements SysUserService {
	
	@Autowired
	private SysUserMapper sysUserMapper;

	@Override
	public SysUser loginCheckUser(String userAccount, String userPassword) {
		SysUser sysUser = new SysUser();
		//sysUser.setUserPassword(MD5Util.toMd5(userPassword));
		sysUser.setUserPassword(userPassword);
		sysUser.setUserAccount(userAccount);
		// 启用状态
		sysUser.setUserIsdisplay(1);
		// 激活状态
		/* sysUser.setUserState(1); */
		List<SysUser> userList = this.sysUserMapper.querySysUserByCondition(sysUser);
		SysUser user = null;
		if (userList != null && userList.size() > 0) {
			user = userList.get(0);
			return user;
		} else {
			return null;
		}	}

}
