package com.sun3d.why.service.impl;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpAdvertRecommend;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpAdvertRecommendService;
import com.sun3d.why.service.CmsAppSettingService;
import com.sun3d.why.util.Constant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 热门关键词实现类
 * 将关键词转化为list存到redis中
 */
@Service
@Transactional
public class CmsAppSettingServicelmpl implements CmsAppSettingService {
    @Autowired
    private CacheService cacheService;

    @Autowired
    private CcpAdvertRecommendService ccpAdvertRecommendService;

    /**
     * 保存热门关键词汇
     * 根据的id，将传来的关键词转为List，并存入Redis。
     *
     * @param hotWords
     * @return
     */
    @Override
    public String saveList(String hotWords, final String saveId, SysUser sysUser) {

        CcpAdvertRecommend advert = new CcpAdvertRecommend();
        advert.setAdvertTitle(saveId);
        advert.setAdvertPostion(5);
        List<CcpAdvertRecommend> advertRecommendList = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
        advert.setAdvertUrl(hotWords);
        if (advertRecommendList.size()>0) {
            ccpAdvertRecommendService.updateAdvert(advert, sysUser);
        } else {
            ccpAdvertRecommendService.insertAdvert(advert, sysUser);
        }

//        Map<String, Object> paramMap = new HashMap<String, Object>();
//        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
//        final List<String> list = new ArrayList<>();
//        if (StringUtils.isNotBlank(hotWords)) {
//            String[] hotWord = hotWords.split(",");
//            for (String id : hotWord) {
//                list.add(id);
//            }
//            //存到Redis中
//            Runnable runner = new Runnable() {
//                @Override
//                public void run() {
//                    if (CollectionUtils.isNotEmpty(list)) {
//                        Calendar calendar = Calendar.getInstance();
//                        calendar.setTime(new Date());
//                        //设置过期时间为当前时间之后的240小时
//                        calendar.add(Calendar.HOUR_OF_DAY, 240);
//                        cacheService.saveList(saveId, list, calendar.getTime());
//                    }
//                }
//            };
//            new Thread(runner).start();
//        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 从Redis中查出活动详情查出，list返回
     *
     * @param
     * @return
     */
    @Override
    public List<Map<String, Object>> getList(final String saveId) {
        CcpAdvertRecommend advert = new CcpAdvertRecommend();
        advert.setAdvertTitle(saveId);
        advert.setAdvertPostion(5);
        List<CcpAdvertRecommend> advertRecommendList = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);

        if (advertRecommendList.size()>0) {
            String hotWords = advertRecommendList.get(0).getAdvertUrl();
            String[] hotWord = hotWords.split(",");
            List list = new ArrayList<>();
            for (String id : hotWord) {
                list.add(id);
            }
            return list;
        } else {
            return null;
        }

//        final List HotList= cacheService.getList(saveId);
//        //存到Redis中
//        Runnable go = new Runnable() {
//            @Override
//            public void run() {
//                if (CollectionUtils.isNotEmpty(HotList)) {
//                    Calendar calendar = Calendar.getInstance();
//                    calendar.setTime(new Date());
//                    //设置过期时间为当前时间之后的240小时
//                    calendar.add(Calendar.HOUR_OF_DAY, 240);
//                    cacheService.saveList(saveId, HotList, calendar.getTime());
//                }
//            }
//        };
//        new Thread(go).start();
//        return list;
    }


}
