package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.SysUserMapper;
import com.sun3d.why.dao.ccp.CcpMerchantUserMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpMerchantUser;
import com.sun3d.why.service.CcpMerchantUserService;
import com.sun3d.why.util.MD5Util;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CcpMerchantUserServiceImpl implements CcpMerchantUserService{
    
    @Resource
    private CcpMerchantUserMapper ccpMerchantUserMapper;
    @Autowired
    private SysUserMapper sysUserMapper;
    @Autowired
    private HttpSession session;
	@Override
	public List<CcpMerchantUser> queryMerchantUserByCondition(CcpMerchantUser ccpMerchantUser, Pagination page) {
		Map<String, Object> map = new HashMap<>();
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpMerchantUserMapper.queryMerchantUserCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		return ccpMerchantUserMapper.queryMerchantUserByCondition(map);
	}
	
	@Override
	public String saveSysUser(String merchantUserId) {
		SysUser loginUser = (SysUser)session.getAttribute("user");
		if(loginUser != null){
			CcpMerchantUser ccpMerchantUser = ccpMerchantUserMapper.selectByPrimaryKey(merchantUserId);
			//判断帐号是否被注册过
			Map<String,Object> map=new HashMap<String, Object>();
	        map.put("userAccount", ccpMerchantUser.getUserAccount());
	        int count = this.sysUserMapper.queryUserCountByCondition(map);
	        if (count > 0) {
	            return "repeat";
	        }
	        
	        SysUser sysUser = new SysUser();
	        sysUser.setUserId(UUIDUtils.createUUId());
	        sysUser.setUserNickName(ccpMerchantUser.getUserName());
	        sysUser.setUserAccount(ccpMerchantUser.getUserAccount());
	        String userPassword = ccpMerchantUser.getUserPassword();
	        sysUser.setUserPassword(MD5Util.toMd5(userPassword));
	        sysUser.setUserAddress(ccpMerchantUser.getUserAddress());
	        sysUser.setUserMobilePhone(ccpMerchantUser.getUserMobileNo());
	        sysUser.setUserEmail(ccpMerchantUser.getUserEmail());
	        
	        sysUser.setUserSex(1);
	        sysUser.setUserUpdateUser(loginUser.getUserId());
	        sysUser.setUserCreateUser(loginUser.getUserId());
	        sysUser.setUserUpdateTime(new Date());
	        sysUser.setUserCreateTime(new Date());
	        sysUser.setUserState(1);
	        sysUser.setUserIsdisplay(1);
	        sysUser.setUserIsAssign(1);
	        int result = sysUserMapper.addSysUser(sysUser);
	        if(result == 1){
	        	CcpMerchantUser dto = new CcpMerchantUser();
	        	dto.setMerchantUserId(merchantUserId);
	        	dto.setSysUserId(sysUser.getUserId());
	        	ccpMerchantUserMapper.update(dto);
	        	return "200";
	        }else{
	        	return "500";
	        }
		}else{
			return "500";
		}
	}
    
	
	
}
