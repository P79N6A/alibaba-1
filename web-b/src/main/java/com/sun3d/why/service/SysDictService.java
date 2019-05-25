package com.sun3d.why.service;

import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

public interface SysDictService {


    /**
     * 根据条件查询字典列表
     *
     * @param sysDict 字典对象
     * @return 返回字典列表
     */
    public List<SysDict> querySysDictByByCondition(SysDict sysDict);

    /**
     * 新增一条数据字典信息记录，该方法判断模型对象中不为空的属性
     *
     * @param dict SysDict 模块模型
     * @return int 执行结果 1：成功 0：失败
     */
    public int addSysDict(SysDict dict);

    /**
     * 根据id查找数据字典信息
     *
     * @param dictId
     * @return
     */
    public SysDict querySysDictByDictId(String dictId);


    /**
     * 根据id逻辑删除
     *
     * @param sysDict
     * @return
     */
    public int editSysDict(SysDict sysDict);


    /**
     * 根据字典编码查询字典列表
     * order by asc
     *
     * @param code 编码
     * @return 返回字典列表
     */
    public List<SysDict> querySysDictByCode(String code);

    /**
     * 传对象里面的属性进行查询
     *
     * @param sysDict
     * @param page
     * @return
     */
    List<SysDict> querySysDictByCode(SysDict sysDict, Pagination page);


    /**
     * 根据字典对象的信息查询满足条件的字典信息
     * @param sysDict
     * @return
     */
    SysDict querySysDict(SysDict sysDict);

    /**
     * 根据map 里面的参数查询满足条件的字典信息
     * @param map
     * @return
     */
    List<SysDict> querySysDictByByMap(Map map);

    /**
     * 根据map 查询满足条件的总数量
     * @param map
     * @return
     */
    Integer querySysDictCountByByMap(Map map);

    /**
     * 检查该数据字典能否被新建
     * @param sysDict
     * @param loginUser
     * @return
     */
    public String checkDictCanSave(SysDict sysDict,SysUser loginUser);


    /**
     * app根据类型获取集合
     * @param sysAntiqueDict
     * @return
     */
    List<SysDict> querySysDictByAntique(SysDict sysAntiqueDict);


    /**
     * 根据状态,parentId为空查询字典列表信息
     * @return 字典对象
     */
    List<SysDict> querySysDictByByState();

    /**
     * app查询藏品朝代
     * @param sysDynastyDict
     * @return
     */
    List<SysDict> queryAppDictByCondition(SysDict sysDynastyDict);

    /**
     * 查询非遗列表名称
     * @param cultureSystem
     * @return
     */
    public String queryAppSysDictByCode(String cultureSystem);



    List<SysDict> querySysDictByParentCode(String parentCode);

    public  List<SysDict> querySysDictListByIds(String ids);


    /**
     * 根据Name查找数据字典信息的id
     *
     * @param dictName
     * @return
     */
    public SysDict querySysDictByDictName(String dictName,String dictCode);

	public List<SysDict> querySysdictName(SysDict sysDynastyDict);


    String selectDictCodeByZJ(String townArea);
}
