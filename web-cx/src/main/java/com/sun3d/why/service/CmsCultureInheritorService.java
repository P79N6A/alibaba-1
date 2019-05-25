package com.sun3d.why.service;

import com.sun3d.why.model.CmsCultureInheritor;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface CmsCultureInheritorService {

    /**
     * 新增非遗传承人
     * @param inheritor
     * @param sysUser
     * @return
     */
    String addCultureInheritor(CmsCultureInheritor inheritor, SysUser sysUser);

    /**
     * 按非遗id查询传承人列表
     * @param inheritor
     * @param page
     * @return
     */
    List<CmsCultureInheritor> queryCultureInheritorByCondition(CmsCultureInheritor inheritor, Pagination page);

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
    String editCultureInheritor(CmsCultureInheritor inheritor, SysUser sysUser);

    /**
     * 根据id删除传承人
     * @param inheritorId
     */
    void deleteCultureInheritorById(String inheritorId);
}
