package com.sun3d.why.service.impl;


import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.dao.CmsRecommendRelatedMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsRecommendRelated;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.RecommendRelatedService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.util.*;

@Transactional(rollbackFor = Exception.class)
@Service
public class RecommendRelatedServiceImpl implements RecommendRelatedService {

    private Logger logger = Logger.getLogger(RecommendRelatedServiceImpl.class);

    @Autowired
    private CmsRecommendRelatedMapper recommendMapper;

    @Autowired
    private CmsActivityMapper activityMapper;

    @Autowired
    private CacheService cacheService;

    /**
     * 删除
     *
     * @param recommendId
     * @return int
     */
    @Override
    public String deleteById(String recommendId) {
        CmsRecommendRelated cmsRecommendRelated = new CmsRecommendRelated();
        cmsRecommendRelated.setRecommendId(recommendId);
        try {
            if (StringUtils.isNotBlank(cmsRecommendRelated.getRecommendId())  ) {
                recommendMapper.deleteById(cmsRecommendRelated);
                // why3.4 app首页推荐活动和首页标签活动存入redis by qww 2016-03-17
                this.appActivitySetRedis();
                this.appActivityListSetRedis();
                return Constant.RESULT_STR_SUCCESS;
            } else {
                return Constant.RESULT_STR_FAILURE;
            }
        } catch (DataAccessException e) {
            SQLException sqle = (SQLException) e.getCause();
            System.out.println("Error code: " + sqle.getErrorCode());
            System.out.println("SQL state: " + sqle.getSQLState());
            return Constant.RESULT_STR_FAILURE;
        }
    }

    ;

    /**
     * 插入推荐
     *
     * @param user
     * @return int
     */
    @Override
    public String insert(CmsRecommendRelated cmsRecommendRelated, SysUser user) {
        try {
            cmsRecommendRelated.setRecommendId(UUIDUtils.createUUId());
            cmsRecommendRelated.setRecommendType(1);
            cmsRecommendRelated.setRecommendTime(new Date());
            cmsRecommendRelated.setUpdateTime(new Date());
            cmsRecommendRelated.setUpdateUserId(user.getUserId());
            cmsRecommendRelated.setRecommendTarget(2);
            //0代表未置顶  1代表置顶
            //cmsRecommendRelated.setTopType(1);
            recommendMapper.addRecommendRelated(cmsRecommendRelated);
            // why3.4 app首页推荐活动和首页标签活动存入redis by qww 2016-03-17
            this.appActivitySetRedis();
            this.appActivityListSetRedis();
            return Constant.RESULT_STR_SUCCESS;
        } catch (DataAccessException e) {
            SQLException sqle = (SQLException) e.getCause();
            System.out.println("Error code: " + sqle.getErrorCode());
            System.out.println("SQL state: " + sqle.getSQLState());
            e.printStackTrace();
            return Constant.RESULT_STR_FAILURE;
        }
    }

    // why3.4 app首页推荐活动和首页标签活动存入redis by qww 2016-03-17
    private void appActivitySetRedis(){
        Runnable runner = new Runnable() {
            @Override
            public void run() {
                // why3.4 app首页推荐活动存入redis
                List<CmsActivity> list = activityMapper.queryAppRecommendCmsActivity();
                if(CollectionUtils.isNotEmpty(list)){
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的24小时
                    calendar.add(Calendar.HOUR_OF_DAY, 24);
                    cacheService.setLikeActivityList(CacheConstant.APP_RECOMMEND_ACTIVITY, list, calendar.getTime());
                }

                // why3.4 app首页标签活动存入redis
                List<CmsActivity> activityList = activityMapper.queryActivityThemeByCode(Constant.ACTIVITY_TYPE);
                if(CollectionUtils.isNotEmpty(activityList)){
                    Map<String, Object> map = new HashMap<String, Object>();
                    for(CmsActivity cmsActivity: activityList){
                        map.put("tagId", cmsActivity.getTagId());
                        List<CmsActivity> cmsActivityList = activityMapper.queryAppTopCmsActivity(map);
                        if(CollectionUtils.isNotEmpty(cmsActivityList)){
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(new Date());
                            //设置过期时间为当前时间之后的24小时
                            calendar.add(Calendar.HOUR_OF_DAY, 24);
                            cacheService.setLikeActivityList(CacheConstant.APP_TOP_ACTIVITY + cmsActivity.getTagId(), cmsActivityList, calendar.getTime());
                        }
                    }
                }
            }
        };
        new Thread(runner).start();
    }

    private void appActivityListSetRedis(){
        Runnable runner = new Runnable() {
            @Override
            public void run() {
                // why3.4 app首页推荐活动存入redis
                List<CmsActivity> list = activityMapper.queryAppRecommendActivityList(new HashMap<String, Object>());
                if(CollectionUtils.isNotEmpty(list)){
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date());
                    //设置过期时间为当前时间之后的24小时
                    calendar.add(Calendar.HOUR_OF_DAY, 24);
                    cacheService.setLikeActivityList(CacheConstant.APP_RECOMMEND_CMS_ACTIVITY, list, calendar.getTime());
                }

                // why3.4 app首页标签活动存入redis
                List<CmsActivity> activityList = activityMapper.queryActivityThemeByCode(Constant.ACTIVITY_TYPE);
                if(CollectionUtils.isNotEmpty(activityList)){
                    Map<String, Object> map = new HashMap<String, Object>();
                    for(CmsActivity cmsActivity: activityList){
                        map.put("tagId", cmsActivity.getTagId());
                        List<CmsActivity> cmsActivityList = activityMapper.queryAppTopActivityList(map);
                        if(CollectionUtils.isNotEmpty(cmsActivityList)){
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(new Date());
                            //设置过期时间为当前时间之后的24小时
                            calendar.add(Calendar.HOUR_OF_DAY, 24);
                            cacheService.setLikeActivityList(CacheConstant.APP_TOP_CMS_ACTIVITY + cmsActivity.getTagId(), cmsActivityList, calendar.getTime());
                        }
                    }
                }
            }
        };
        new Thread(runner).start();
    }


    /**
     * 有选择插入
     *
     * @param cmsRecommendRelated
     * @return int
     */
    @Override
    public int addRecommendRelated(CmsRecommendRelated cmsRecommendRelated) {

        return recommendMapper.addRecommendRelated(cmsRecommendRelated);
    }

    @Override
    public List<CmsRecommendRelated> selectByCmsRecommendRelated(CmsRecommendRelated cmsRecommendRelated) {
        return null;
    }


    /**
     * 查询列表
     *
     * @return List<CmsRecommendRelated>
     */

    public List<CmsRecommendRelated> queryRecommendActivity(CmsActivity activity, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (StringUtils.isNoneBlank(activity.getActivityName())) {
            map.put("activityName","%"+activity.getActivityName()+"%");
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            //设置分页的总条数来获取总页数
            page.setTotal(recommendMapper.queryRecommendActivityCount(map));
        }
        return recommendMapper.queryRecommendActivity(map);
    }
    /**
     * 插入推荐
     *
     * @param user
     * @return int
     */
    @Override
    public String insertWeekend(CmsRecommendRelated cmsRecommendRelated, SysUser user) {
        try {
            cmsRecommendRelated.setRecommendId(UUIDUtils.createUUId());
            cmsRecommendRelated.setRecommendType(1);
            cmsRecommendRelated.setRecommendTime(new Date());
            cmsRecommendRelated.setUpdateTime(new Date());
            cmsRecommendRelated.setUpdateUserId(user.getUserId());
            cmsRecommendRelated.setRecommendTarget(1);
            recommendMapper.addRecommendRelated(cmsRecommendRelated);
            return Constant.RESULT_STR_SUCCESS;
        } catch (DataAccessException e) {
            SQLException sqle = (SQLException) e.getCause();
            System.out.println("Error code: " + sqle.getErrorCode());
            System.out.println("SQL state: " + sqle.getSQLState());
            e.printStackTrace();
            return Constant.RESULT_STR_FAILURE;
        }
    }

}