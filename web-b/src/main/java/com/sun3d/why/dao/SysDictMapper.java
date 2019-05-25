package com.sun3d.why.dao;

import com.sun3d.why.model.SysDict;

import java.util.List;
import java.util.Map;

public interface SysDictMapper {

    //根据字典编码查询字典列表
    List<SysDict> querySysDictByByCondition(SysDict data);


    List<SysDict> querySysDictByByMap(Map map);

    int deleteSysDictByDictId(String dictId);

    int addSysDict(SysDict record);

    SysDict querySysDictByDictId(String dictId);

    SysDict querySysDictByDictName(Map<String, Object> map);

    int editSysDict(SysDict record);

//	int deleteSysDictIds(List<String> dictIds);

    int querySysDictCount(Map<String, Object> map);

    List<SysDict> querySysDictCode(Map<String, Object> map);

    SysDict querySysDict(Map<String, Object> map);

    public Integer querySysDictCountByByMap(Map map);


    /**
     * app根据类别code获取类别list
     * @param map
     * @return
     */
    List<SysDict> querySysDictByAntique(Map<String, Object> map);


    /**
     * 根据状态,parentId为空查询字典列表信息
     * @param map
     * @return 字典对象
     */
    List<SysDict> querySysDictByByState(Map<String, Object> map);

    /**
     * app查询朝代
     * @param sysDynastyDict
     * @return
     */
    List<SysDict> queryAppDictByCondition(SysDict sysDynastyDict);

    /**
     * app获取非遗名称
     * @param map
     * @return
     */
    List<SysDict> queryAppSysDictByCode(Map<String, Object> map);

    List<SysDict> querySysDictByParentCode(String parentCode);

    List<SysDict> querySysDictListByIds(List<String> idList);

    /**
     * 首页栏目推荐判断用户选择的是活动类型还是主题
     * @param  activityTheme (一个id也有可能是ActivityType)
     * @return String  dictName
     * @authour hucheng
     * @date 2016/01/15
     * @content add
     */
    String queryDictNameByActivityTheme(String activityTheme);

    List<SysDict> queryAllArea(Map<String, Object> map);


	List<SysDict> querySysdictName(SysDict sysDynastyDict);


	SysDict querySysDictByName(String dictName);

    String selectDictCodeByZJ(String townArea);
}