package com.sun3d.why.service.impl;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsAppSettingService;
import com.sun3d.why.util.Constant;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * 热门关键词实现类
 * 将关键词转化为list存到redis中
 */
@Service
@Transactional
public class CmsAppSettingServicelmpl implements CmsAppSettingService {
    @Autowired
    private CacheService cacheService;

    /**
     * 保存热门关键词汇
     * 根据的id，将传来的关键词转为List，并存入Redis。
     *
     * @param hotWords
     * @return
     */
    @Override
    public String saveList(String hotWords, final String saveId) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        final List<String> list = new ArrayList<>();
        if (StringUtils.isNotBlank(hotWords)) {
            String[] hotWord = hotWords.split(",");
            for (String id : hotWord) {
                list.add(id);
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
                        cacheService.saveList(saveId, list, calendar.getTime());
                    }
                }
            };
            new Thread(runner).start();
        } else {
        }
        return Constant.RESULT_STR_SUCCESS;
    }
    /**
     *
     * 从Redis中查出活动详情查出，list返回
     *
     * @param
     * @return
     */
    @Override
    public List<Map<String, Object>> getList(final String saveId) {
        final List HotList= cacheService.getList(saveId);
        //存到Redis中
        Runnable go = new Runnable() {
            @Override
            public void run() {
                if (CollectionUtils.isNotEmpty(HotList)) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的240小时
                    calendar.add(Calendar.HOUR_OF_DAY, 240);
                    cacheService.saveList(saveId, HotList, calendar.getTime());
                }
            }
        };
        new Thread(go).start();
        return HotList;
    }


}
