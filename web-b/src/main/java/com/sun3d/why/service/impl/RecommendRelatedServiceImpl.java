package com.sun3d.why.service.impl;


import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.dao.CmsRecommendRelatedMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsRecommendRelated;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.RecommendRelatedService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
//                this.appActivitySetRedis();
//                this.appActivityListSetRedis();
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
//            this.appActivitySetRedis();
//            this.appActivityListSetRedis();
            return Constant.RESULT_STR_SUCCESS;
        } catch (DataAccessException e) {
            SQLException sqle = (SQLException) e.getCause();
            System.out.println("Error code: " + sqle.getErrorCode());
            System.out.println("SQL state: " + sqle.getSQLState());
            e.printStackTrace();
            return Constant.RESULT_STR_FAILURE;
        }
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