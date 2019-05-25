package com.culturecloud.dao.common;

import com.culturecloud.dao.dto.common.CmsTerminalUserDto;

public interface CmsTerminalUserMapper {

	CmsTerminalUserDto queryTerminalUserById(String userId);
}
