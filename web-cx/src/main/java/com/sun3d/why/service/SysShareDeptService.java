package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.SysShareDept;
import com.sun3d.why.util.Pagination;

public interface SysShareDeptService {


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
     * 根据条件查询 分享的信息
     * @param record
     * @return
     */
    List<SysShareDept> queryShareDeptByCondition(SysShareDept record);

    /**
     * 根据分享主键修改分享表
     * @param record
     * @return
     */
    int editBySysShareDept(SysShareDept record);


    /**
     * 根据部门id 查询该部门的被分享信息
     * @param targetDeptId
     * @return
     */
    List<SysShareDept> queryShareDeptByTargetDeptId(String targetDeptId);
    
    /**
     * 根据部门id 查询该部门的分享信息
     * @param sourceDeptId
     * @param page
     * @return
     */
    List<SysShareDept> queryShareDeptBySourceDeptId(String sourceDeptId,Pagination page);
}