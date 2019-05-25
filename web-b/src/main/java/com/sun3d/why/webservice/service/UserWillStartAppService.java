package com.sun3d.why.webservice.service;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsUserWillStart;
import com.sun3d.why.util.PaginationApp;

import java.text.ParseException;
import java.util.Map;

/**
 * Created by Administrator on 2015/7/2.
 */
public interface UserWillStartAppService {
    /**
     * 根据用户id查询
     * @param map
     * @return
     */
    CmsUserWillStart queryUserWillStartByUserId(Map<String, Object> map);

    /**
     * app端点击即将开始时的活动数目
     * @param map
     * @return
     */
    int queryAppWillStartActivityCount(Map<String, Object> map);

    /**
     * app端点击即将开始时新增数据
     * @param userWillStart
     * @return
     */
    int addAppWillStart(CmsUserWillStart userWillStart);

    /**
     * app端点击即将开始时新增数据编辑
     * @param userWillStart
     * @return
     */
    int editAppWillStartByUserId(CmsUserWillStart userWillStart);

    /**
     * 根据用户id查询数量
     * @param map
     * @return
     */
    int queryUserWillStartCountByUserId(Map<String, Object> map);
}
