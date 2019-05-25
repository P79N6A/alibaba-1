package com.sun3d.why.dao;

import com.sun3d.why.model.SysModule;

import java.util.List;

/**
 * 模块管理的数据操作层，这里直接对应的sqlmaps文件夹下面的mapping文件映射，由Mybatis Generator自动生成
 * 如果不想用自动生成的方法，可以自定义添加方法实现，这里的dao文件对应sqlmaps下面的xml文件
 * 方法名称对应Mybatis文件中的id
 *
 * @author wangfan 2015/04/22
 */
public interface SysModuleMapper {

    /**
     *根据角色id查询权限
     * @param roleId
     * @return 权限列表信息
     */
    List<SysModule> queryModuleByRoleId(String roleId);

    /**
     *根据状态查询权限
     * @param moduleState
     * @return 权限列表信息
     */
    List<SysModule> queryModuleByModuleState(Integer moduleState);

    /**
     * 登录是需要
     *
     * @param userId String
     * @return List<SysModule>
     */
    List<SysModule> selectModuleByUserId(String userId);

    /**
     * 权限父节点
     * @param moduleUrl
     * @return 权限对象
     */
    SysModule queryParentModuleByUrl(String moduleUrl);

    /**
     * 权限子节点
     * @param moduleUrl
     * @return 权限对象
     */
    SysModule queryChildModuleByUrl(String moduleUrl);

    /**
     *根据id编辑权限
     * @param record
     * @return
     */
    int editModuleById(SysModule record);


    /**
     * 新增权限
     *
     * @param record SysModule 模块模型
     * @return int 执行结果 1：成功 0：失败
     */
    int addModule(SysModule record);
}