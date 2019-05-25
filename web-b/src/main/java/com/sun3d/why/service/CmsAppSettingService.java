package com.sun3d.why.service;

import com.sun3d.why.model.SysUser;

import java.util.List;
import java.util.Map;

/**
 * 热门关键词service接口
 */
public interface CmsAppSettingService {

    /**
     * 将传过来的热门关键词根据Id存入Redis
     * @param hotWords
     *
     * @return
     */
    String saveList(String hotWords, String saveId,SysUser sysUser);
    /**
     * 根据传来的saveId查询出对应的redis
     * @param saveId
     *
     * @return
     */
    List<Map<String, Object>> getList(String saveId);
}
