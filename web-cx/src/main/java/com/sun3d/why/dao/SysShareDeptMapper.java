package com.sun3d.why.dao;

import com.sun3d.why.model.SysShareDept;

import java.util.List;
import java.util.Map;

public interface SysShareDeptMapper {


    /**
     * 删除分享信息
     * @param shareId
     * @return
     */
    int deleteByShareId(String shareId);

    /**
     * 添加部门分享信息
     * @param record
     * @return
     */
    int addSysShareDept(SysShareDept record);

    /**
     * 根据shareId查询 分享的信息
     * @param shareId
     * @return
     */
    SysShareDept querySysShareDeptByShareId(String shareId);

    /**
     * 根据分享主键修改分享表
     * @param record
     * @return
     */
    int editBySysShareDept(SysShareDept record);


    /**
     * 根据部门id 查询该部门的被分享信息
     * @param map
     * @return
     */
    List<SysShareDept> queryShareDeptByTargetDeptId(Map map);

    /**
     * 查询该部门的分享信息
     * @param map
     * @return
     */
    List<SysShareDept> queryShareDeptByCondition(Map map);
    
    /**
     * 查询该部门的分享信息总数
     * @param map
     * @return
     */
    int queryShareDeptByCount(Map map);
}