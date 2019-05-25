package com.culturecloud.service.local.impl.common;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.common.CmsTerminalUserMapper;
import com.culturecloud.dao.common.SysUserIntegralDetailMapper;
import com.culturecloud.dao.common.SysUserIntegralMapper;
import com.culturecloud.dao.dto.common.CmsTerminalUserDto;
import com.culturecloud.dao.dto.common.SysUserIntegralDto;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.common.SysUserIntegral;
import com.culturecloud.model.bean.common.SysUserIntegralDetail;
import com.culturecloud.service.local.common.SysUserIntegralService;

@Transactional
@Service
public class SysUserIntegralServiceImpl implements SysUserIntegralService {
	
	
	@Autowired
	private CmsTerminalUserMapper cmsTerminalUserMapper;
	
	@Autowired
	private SysUserIntegralMapper sysUserIntegralMapper; 
	

	@Override
	public SysUserIntegral getUserIntegralByUserId(String userId) {

		SysUserIntegralDto userIntegral= sysUserIntegralMapper.selectUserIntegralByUserId(userId);
		
		if(userIntegral!=null)
		{
			return userIntegral;
		}
		else
		{
			SysUserIntegral newIntegral=new SysUserIntegral();
			newIntegral.setUserId(userId);
			newIntegral.setIntegralId(UUIDUtils.createUUId());
			newIntegral.setIntegralNow(1200);
			newIntegral.setIntegralHis(1200);
        	
			sysUserIntegralMapper.insert(newIntegral);

			return newIntegral;
		}
		
	}

}
