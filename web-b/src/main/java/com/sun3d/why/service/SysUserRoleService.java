package com.sun3d.why.service;

/**
 * 模块管理Service接口
 * <p/>
     * Created by qiuweiwei on 2015/4/22.
 */
public interface SysUserRoleService {

    /**
     * 用户角色保存
     * @param userId
     * @param roleArr
     * @return success:成功  failure:失败
     */
    String saveUserRole(String userId, String[] roleArr);
}
