	package com.culturecloud.service.local.common;

import com.culturecloud.model.bean.common.SysUser;

public interface SysUserService {

	/**
     * 检查用户是否能登录后台
     * @param userAccount
     * @param userPassword
     * @return null 表示失败
     */
    public SysUser loginCheckUser(String userAccount, String userPassword);
}
