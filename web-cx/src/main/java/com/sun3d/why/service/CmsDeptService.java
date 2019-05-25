package com.sun3d.why.service;

import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysUser;

import java.util.List;
import java.util.Map;

/**
 * Created by yujinbing on 2015/4/29.
 */
public interface CmsDeptService {

    /**
     * 根据部门Id删除部门
     * @param deptId 部门Id
     * @return 1成功 0失败
     */
    int deleteSysDeptByDeptId(String deptId);

    /**
     * 部门信息
     * @param record
     * @return 1成功 0失败
     */
    int addSysDept(SysDept record);

    /**
     * 根据部门Id查询部门信息
     * @param deptId
     * @return
     */
    SysDept querySysDeptByDeptId(String deptId);

    /**
     * 根据部门Id 修改部门信息
     * @param record
     * @return 1成功 0失败
     */
    int editSysDept(SysDept record);

    /**
     * 得到排序的最大值
     * @return
     */
    int countMaxSort();

    /**
     * 根据hashMap 的条件查询部门信息
     * @param map
     * @return
     */
    List<SysDept> querySysDeptByMap(Map map);

    /**
     * 根据部门对象查询满足条件的部门数据
     * @param sysDept
     * @return
     */
    List<SysDept> querySysDeptByCondition(SysDept sysDept);

    public Map updateSysDept(String deptId,String deptName,String pId, SysUser loginUser);

    public SysDept querySysDeptByDeptPath(String deptPath);

    public int queryCountByMap(Map map);

    String querySysDeptIdByDeptName(String deptName);

    /**
     * 子系统对接，验证场馆名称是否重名
     * @param map
     * @return int
     * @authour hucheng
     * @content add
     * @date 2016/1/18
     */
    public int queryAPICountByMap(Map map);

}
