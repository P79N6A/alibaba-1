package com.sun3d.why.dao;

import com.sun3d.why.model.CmsCultureInheritor;

import java.util.List;
import java.util.Map;

public interface CmsCultureInheritorMapper {

    /**
     * 新增非遗传承人
     * @param inheritor
     * @return
     */
    int addCultureInheritor(CmsCultureInheritor inheritor);

    /**
     * 按非遗id查询传承人个数
     * @param map
     * @return
     */
    int queryCultureInheritorCountByCondition(Map<String, Object> map);

    /**
     * 按非遗id查询传承人列表
     * @param map
     * @return
     */
    List<CmsCultureInheritor> queryCultureInheritorByCondition(Map<String, Object> map);

    /**
     * 根据传承人id查询
     * @param inheritorId
     * @return
     */
    CmsCultureInheritor queryCultureInheritorById(String inheritorId);

    /**
     * 更新传承人
     * @param inheritor
     * @return
     */
    int editCultureInheritor(CmsCultureInheritor inheritor);

    /**
     * 根据id删除传承人
     * @param inheritorId
     * @return
     */
    void deleteCultureInheritorById(String inheritorId);
}