package com.sun3d.why.service.impl;

import com.sun3d.why.dao.AppAdvertCalendarMapper;
import com.sun3d.why.model.AppAdvertCalendar;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.AppAdvertCalendarService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class AppAdvertCalendarServiceImpl implements AppAdvertCalendarService {
    @Autowired
    protected AppAdvertCalendarMapper appAdvertCalendarMapper;

    /**
     * 根据广告sql语句示例来更新符合的数据，不包涵团队描述字段
     *
     * @param record AppAdvertRecommend 广告信息
     * @param page   Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    @Override
    @Transactional(readOnly = true)
    public List<AppAdvertCalendar> queryAdvertByCondition(AppAdvertCalendar record, Pagination page) {
        List<AppAdvertCalendar> list = null;
        //设置要查询的条件，map中的key值应与mapper中的判断条件一致
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            if (StringUtils.isNotBlank(record.getAdvertId())) {
                map.put("advertId", record.getAdvertId());
            }
            //获得符合条件的总条数，这里需放在设置分页功能的前面执行，为列表页面分页功能提供
            int total = appAdvertCalendarMapper.selectAdvertCount(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
            page.setRows(page.getRows());
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            list = appAdvertCalendarMapper.selectAdvertIndex(map);
        } catch (Exception e) {
        }
        return list;
    }

    @Override
    public String addAdvert(AppAdvertCalendar appadvertcalendar, SysUser user) {
        try {
            String uuid = "";
            int result = 0;
            if (StringUtils.isNotBlank(appadvertcalendar.getAdvertId())) {
                appadvertcalendar.setUpdateBy(user.getUserId());
                appadvertcalendar.setUpdateTime(new Date());
                result = appAdvertCalendarMapper.editAdvert(appadvertcalendar);
            } else {
                uuid = UUIDUtils.createUUId();
                appadvertcalendar.setAdvertId(uuid);
                appadvertcalendar.setAdvState(Constant.NORMAL);
                appadvertcalendar.setCreateBy(user.getUserId());
                appadvertcalendar.setUpdateBy(user.getUserId());
                appadvertcalendar.setCreateTime(new Date());
                appadvertcalendar.setUpdateTime(new Date());
                result = appAdvertCalendarMapper.addAdvert(appadvertcalendar);
            }
            if (result == 1) {
                return Constant.RESULT_STR_SUCCESS;
            } else {
                return Constant.RESULT_STR_FAILURE;
            }
        } catch (Exception e) {
            e.printStackTrace();
            String result = "repeat";
            return result;
        }

    }

    @Override
    public AppAdvertCalendar getAdvert(String advertId) {

        try {
            AppAdvertCalendar appAdvertCalendar = new AppAdvertCalendar();
            if (advertId != null) {
                appAdvertCalendar = appAdvertCalendarMapper.getAdvert(advertId);
            } else {
            }
            return appAdvertCalendar;
        } catch (Exception e) {
            e.printStackTrace();

        }
        return null;

    }
}
