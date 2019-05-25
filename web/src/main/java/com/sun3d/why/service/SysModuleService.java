package com.sun3d.why.service;

import com.sun3d.why.model.SysModule;

import java.util.List;

/**
 * 模块管理Service接口
 * <p/>
 * Created by wangfan on 2015/4/22.
 */
public interface SysModuleService {

    /**
     *根据角色id查询权限
     * @param roleId
     * @return 权限列表信息
     */
    List<SysModule> queryModuleByRoleId(String roleId);

    /**
     * 查询所有权限
     * @param moduleState
     * @return 权限列表信息
     */
    List<SysModule> queryModuleByModuleState(Integer moduleState);

    /**
     * 登录是需要调用此借口，用于屏蔽掉非关联权限
     *
     * @param userId String 模块sql语句示例
     * @return List<SysModule> 模块模型集合
     */
    List<SysModule> selectModuleByUserId(String userId);

    /**
     * 初始化权限
     * @param userId
     * @return
     */
    String initModule(String userId);
}
