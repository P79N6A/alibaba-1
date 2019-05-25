package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.SysUserMapper;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.dao.ccp.CcpCityImgMapper;
import com.sun3d.why.dao.ccp.CcpCityUserMapper;
import com.sun3d.why.dao.ccp.CcpCityVoteMapper;
import com.sun3d.why.dao.ccp.CcpMerchantUserMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpCityImg;
import com.sun3d.why.model.ccp.CcpCityUser;
import com.sun3d.why.model.ccp.CcpCityVote;
import com.sun3d.why.model.ccp.CcpMerchantUser;
import com.sun3d.why.service.CcpCityImgService;
import com.sun3d.why.service.CcpMerchantUserService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.UserIntegralService;
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
	public String addMerchantUser(CcpMerchantUser vo) {
		//判断帐号是否被注册过
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userAccount", vo.getUserAccount());
        int sysUserCount = this.sysUserMapper.queryUserCountByCondition(map);
        CcpMerchantUser dto = new CcpMerchantUser();
        dto.setUserAccount(vo.getUserAccount());
		List<CcpMerchantUser> list = ccpMerchantUserMapper.queryMerchantUserByCondition(dto);
		if(list.size()>0||sysUserCount>0){
			return "repeat";
		}

		vo.setMerchantUserId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = ccpMerchantUserMapper.insert(vo);
		if (count > 0) {
			return "200";
		}else{
			return "500";
		}
	}
	
}
