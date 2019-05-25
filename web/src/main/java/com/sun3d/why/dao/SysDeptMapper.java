package com.sun3d.why.dao;

import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysDeptVo;

import java.util.List;
import java.util.Map;

public interface SysDeptMapper {


    /**
     * 删除部门信息
     * @param deptId
     * @return
     */
    int deleteByDeptId(String deptId);

    /**
     * 添加部门
     * @param record
     * @return
     */
    int addSysDept(SysDept record);

    /**
     * 跟部门id 查询
     * @param deptId
     * @return
     */
    SysDept querySysDeptByDeptId(String deptId);

    /**
     * 根据部门id  修改部门
     * @param record
     * @return
     */
    int editSysDept(SysDept record);


    /**
     * 根据追到的排序数字
     * @return
     */
    int countMaxSort();


    /**
     * 根据Map 中的参数查询部门信息
     * @param map
     * @return
     */
    List<SysDept> querySysDeptByMap(Map map);

    /**
     * 根据部门对象查询部门信息
     * @param sysDept
     * @return
     */
    List<SysDept> querySysDeptByCondition(SysDept sysDept);


    /**
     * 根据Map 中的参数查询部门总数
     * @param map
     * @return
     */
    public int queryCountByMap(Map map);


    /**
     * 子系统对接，验证场馆名称是否重名
     * @param map
     * @return int
     * @authour hucheng
     * @content add
     * @date 2016/1/18
     */
    public int queryAPICountByMap(Map map);

    /**
     * 根据部门路径查询这个路径中的部门
     * @param deptPath
     * @return
     */
    public SysDept querySysDeptByDeptPath(String deptPath);

    /**
     * 根据部门名称查询
     * @param map
     * @return
     */
    String querySysDeptIdByDeptName(Map map);


    /**
     * 根据直辖市名称查询出直辖市的部门路径
     * @param map
     * @return
     */
    public List<SysDept> queryTerritoryByDeptNames(Map map);

    List<SysDept> selectDeptByDeptCode(String deptCode);

    List<SysDept> queryAreaListByMap(Map map);

    List<SysDept> getSysDeptBySysDep(SysDept sysDept);

    List<SysDept> queryAreaAllList();

    List<SysDeptVo> queryAreaNameAndId(Map map);
}