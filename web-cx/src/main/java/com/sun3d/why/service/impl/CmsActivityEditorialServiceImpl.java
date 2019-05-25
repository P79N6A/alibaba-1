package com.sun3d.why.service.impl;

import com.sun3d.why.dao.ActivityEditorialMapper;
import com.sun3d.why.model.ActivityEditorial;
import com.sun3d.why.model.SysShareDept;
import com.sun3d.why.service.CmsActivityEditorialService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Transactional(rollbackFor = Exception.class)
@Service
public class CmsActivityEditorialServiceImpl implements CmsActivityEditorialService {

    private Logger logger = Logger.getLogger(CmsActivityEditorialServiceImpl.class);

    @Autowired
    private ActivityEditorialMapper activityEditorialMapper;

    @Override
    public boolean saveActivityEditorial(ActivityEditorial example) {
        if (null == example) {
            return false;
        }
        try {

            example.setActivityCreateTime(new Date());
            example.setActivityUpdateTime(new Date());
            int count = activityEditorialMapper.saveActivityEditorial(example);
            if (count > 0) {
                return true;
            }
        } catch (Exception e) {
            logger.error("saveActivityEditorial error", e);
            return false;
        }

        return false;
    }

    @Override
    public boolean editActivityEditorial(ActivityEditorial example) {
        if (null == example) {
            return false;
        }
        try {
            if (StringUtils.isBlank(example.getRatingsInfo())) {
                example.setActivityUpdateTime(new Date());
            }
            if (example.isPublish()) {
                example.setActivityCreateTime(new Date());
            }
            int count = activityEditorialMapper.editActivityEditorial(example);
            if (count > 0) {
                return true;
            }
        } catch (Exception e) {
            logger.error("editActivityEditorial error", e);
            return false;
        }

        return false;
    }


    /**
     * 根据採編活动对象查询活动列表信息
     *
     * @param editorial 活动对象
     * @param page      分页对象
     * @return 活动采編列表信息
     */
    public List<ActivityEditorial> queryActivityEditorialByCondition(ActivityEditorial editorial, Pagination page) {

        if (editorial != null) {
            Map<String, Object> map = new HashMap<String, Object>();
            //数据状态
            if (editorial.getActivityIsDel() == Constant.DELETE) {
                map.put("activityIsDel", Constant.DELETE);
            } else if (editorial.getActivityIsDel() == Constant.NORMAL) {
                map.put("activityIsDel", Constant.NORMAL);

            }
            //活动類型
            if (StringUtils.isNotBlank(editorial.getActivityType())) {
                map.put("activityType", "%" + editorial.getActivityType() + "%");
            }
            //活动状态
            if (editorial.getActivityState() != null) {
                map.put("activityState", editorial.getActivityState());

            }
            //是否免费
            if (editorial.getActivityIsFree() != null) {
                map.put("activityIsFree", editorial.getActivityIsFree());
            }
            //发布时间
            if (editorial.getActivityCreateTime() != null) {
                map.put("activityCreateTime", editorial.getActivityCreateTime());
            }
            if (editorial.getActivityUpdateTime() != null) {
                map.put("activityUpdateTime", editorial.getActivityUpdateTime());
            }
//活动评级
            if (editorial != null && StringUtils.isNotBlank(editorial.getRatingsInfo())) {
                map.put("ratingsInfo", editorial.getRatingsInfo());
            }
            //分页
            if (page != null && page.getFirstResult() != null && page.getRows() != null) {
                map.put("firstResult", page.getFirstResult());
                map.put("rows", page.getRows());
                int total = activityEditorialMapper.queryActivityEditorialCountByCondition(map);
                page.setTotal(total);
            }

            return activityEditorialMapper.queryActivityEditorialByCondition(map);
        }
        return null;
    }

    @Override
    public ActivityEditorial queryActivityEditorialByActivityId(String activityId) {
        if (StringUtils.isNoneBlank(activityId)) {
            return activityEditorialMapper.queryActivityEditorialByActivityId(activityId);
        }
        return null;
    }

    @Override
    public boolean updateStatusByActivityId(String status, String activityId) {
        if (StringUtils.isBlank(status) || StringUtils.isBlank(activityId)) {
            return false;
        }
        try {
            int count = activityEditorialMapper.updateStatusByActivityId(status, activityId);
            if (count > 0) {
                return true;
            }
        } catch (Exception e) {
            logger.error("updateStatusByActivityId error", e);
            return false;

        }
        return false;

    }

    @Override
    public boolean isExistsActivityName(String activityName) {
        if(StringUtils.isBlank(activityName)){
            return false;
        }
        try {
            int count = activityEditorialMapper.isExistsActivityName(activityName);
            if (count > 0) {
                return true;
            }
        } catch (Exception e) {
            logger.error("isExistsActivityName error", e);
            return false;

        }
        return false;
    }

    @Override
    public String queryEditorialRatingsInfoById(String activityId) {
        if(StringUtils.isBlank(activityId)){
            return null;
        }
        return activityEditorialMapper.queryEditorialRatingsInfoById(activityId);
    }
}
