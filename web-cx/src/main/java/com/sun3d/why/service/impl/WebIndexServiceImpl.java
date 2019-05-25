package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.WebIndexService;
import com.sun3d.why.util.Constant;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Transactional
@Service
public class WebIndexServiceImpl implements WebIndexService {


    @Autowired
    private CmsActivityMapper activityMapper;

    @Autowired
    private CacheService cacheService;

    /**
     *
     * 根据传来的id，将每个活动详情查出，list存到Redis中
     *
     * @param dataList
     * @return
     */
    @Override
    public String activityList(final List<String> dataList, final String Key) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        final List<CmsActivity> list = new ArrayList<CmsActivity>();
        //根据页面传来的活动id查询
        if (CollectionUtils.isNotEmpty(dataList)) {
            for (String data : dataList) {
                Map<String, Object> map = new HashMap<String, Object>();
                CmsActivity cmsActivity = activityMapper.queryCmsActivityByActivityId(data);
                map.put("cmsActivity", cmsActivity);
                listMap.add(map);
                list.add(cmsActivity);
            }
        }
        //存到Redis中
        Runnable runner = new Runnable() {
            @Override
            public void run() {
                if (CollectionUtils.isNotEmpty(list)) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的240小时
                    calendar.add(Calendar.HOUR_OF_DAY, 240);
                    cacheService.setLikeActivityList(Key, list, calendar.getTime());
                }
            }
        }; new Thread(runner).start();
        return Constant.RESULT_STR_SUCCESS;
    }
}
