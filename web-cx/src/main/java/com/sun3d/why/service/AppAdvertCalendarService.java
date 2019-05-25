package com.sun3d.why.service;


import com.sun3d.why.model.AppAdvertCalendar;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface AppAdvertCalendarService {
    /**
     * 保存活动信息
     * 验证活动名称不能重复
     *
     * @param appadvertcalendar 广告对象
     * @return failure 失败,success 成功 ,repeat 活动名称重复
     */
    String addAdvert(AppAdvertCalendar appadvertcalendar, SysUser user);
    /**
     * 根据团队会员sql语句示例来更新符合的数据，不包涵团队描述字段
     *
     * @param record AppAdvertRecommend 广告信息
     * @param page Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    List<AppAdvertCalendar> queryAdvertByCondition(AppAdvertCalendar record, Pagination page);
    /**
     * 根据活动对象查询活动列表信息
     *
     * @return 活动列表信息
     */
    AppAdvertCalendar getAdvert(String advertId);
}
