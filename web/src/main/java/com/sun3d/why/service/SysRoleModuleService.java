package com.sun3d.why.service;

/**
 * 模块管理Service接口
 * <p/>
     * Created by qiuweiwei on 2015/4/22.
 */
public interface SysRoleModuleService {

    /**
     * 新增角色权限关联表
     * @param roleId
     * @param moduleArr
     * @return success ：成功  failure:失败
     */
    String saveRoleModule(String roleId,String[] moduleArr);
}
