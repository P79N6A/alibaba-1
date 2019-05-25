package com.culturecloud.dao.common;

import java.util.List;
import java.util.Map;

import com.culturecloud.dao.dto.common.CmsTerminalUserDto;
import com.culturecloud.model.bean.common.CmsTerminalUser;

public interface CmsTerminalUserMapper {

	CmsTerminalUserDto queryTerminalUserById(String userId);
	
	CmsTerminalUserDto queryTerminalByMobile(String mobileNo);
	
	int editTerminalUserById( CmsTerminalUser terminalUser);
	
	int addTerminalUser(CmsTerminalUser user);
	
	 /**
     * 前端2.0 根据用户名和密码查询用户
     * @param map
     * @return 会员对象
     */
    CmsTerminalUser queryTerminalByMobileOrPwd(Map<String, Object> map);
    
    List<CmsTerminalUserDto> queryTerminalUserByCondition(Map<String, Object> map);
}
