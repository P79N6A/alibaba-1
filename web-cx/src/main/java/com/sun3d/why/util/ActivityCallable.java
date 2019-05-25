package com.sun3d.why.util;
import com.sun3d.why.model.ActivityUserStatistics;
import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CollectService;
import com.sun3d.why.statistics.service.StatisticActivityUserService;
import org.apache.log4j.Logger;
import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.concurrent.Callable;
/**
 * 多线程中添加用户活动统计
 * Created by Administrator on 2015/9/14.
 */
public class ActivityCallable implements Callable {
    private Logger logger = Logger.getLogger(ActivityCallable.class);
    private Integer operateType;
    private String activityId;
    private HttpServletRequest request;
    private  CmsTerminalUser user;
    private StatisticActivityUserService statisticActivityUserService;
    private CollectService collectService;
    private CmsTerminalUserService terminalUserService;
    public ActivityCallable(Integer operateType, String activityId, HttpServletRequest request,CmsTerminalUser user,StatisticActivityUserService statisticActivityUserService,CollectService collectService,CmsTerminalUserService terminalUserService) {
        this.operateType=operateType;
        this.activityId=activityId;
        this.request=request;
        this.user=user;
        this.statisticActivityUserService=statisticActivityUserService;
        this.collectService=collectService;
        this.terminalUserService=terminalUserService;
    }
    @Override
    public Integer call() throws Exception {
        int flag = 0;
        ActivityUserStatistics activityUserStatistics = new ActivityUserStatistics();
        activityUserStatistics.setIp(CommonUtil.getIpAddr(request));
        activityUserStatistics.setActivityId(activityId);
        activityUserStatistics.setOperateType(operateType);
        activityUserStatistics.setCreateTime(new Timestamp(System.currentTimeMillis()));
        activityUserStatistics.setUpdateTime(new Timestamp(System.currentTimeMillis()));
        activityUserStatistics.setId(UUIDUtils.createUUId());
        if (user != null) {
            //操作类型 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
            if (operateType != 0 && operateType != 3) {
                int count = statisticActivityUserService.activityUserCountByCondition(activityId, operateType, CommonUtil.getIpAddr(request), user.getUserId(), Constant.STATIS2);
                if (count > 0) {
                    //代表当天重复操作了 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
                    logger.error("当天用户活动状态数据已存在不会重复保存数据");
                    return collectService.getHotNum(activityId, Constant.COLLECT_ACTIVITY);
                }
            }
            activityUserStatistics.setUserId(user.getUserId());
            // activityUserStatistics.setCreateUser(user.getUserName());
            activityUserStatistics.setStatus(Constant.STATIS2);
        } else {
            String userId = terminalUserService.getTerminalUserId(Constant.DEFAULT_SESSION_USER_NAME);
            if (operateType != 0 && operateType != 3) {
                int count = statisticActivityUserService.activityUserCountByCondition(activityId, operateType, CommonUtil.getIpAddr(request), userId, Constant.STATUS1);
                if (count > 0) {
                    //代表该天重复操作了这个状态  1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
                    logger.debug("当天游客活动数据已存在不会进行重复保存数据");
                    return collectService.getHotNum(activityId, Constant.COLLECT_ACTIVITY);
                }
            }
            activityUserStatistics.setUserId(userId);
            activityUserStatistics.setStatus(Constant.STATUS1);
        }
        flag = statisticActivityUserService.addActivityUserStatistics(activityUserStatistics);
        if (flag>0) {
            if (operateType != 0 && operateType == 3) {
                CmsCollect cmsCollect = new CmsCollect();
                cmsCollect.setUserId(activityUserStatistics.getUserId());
                cmsCollect.setRelateId(activityId);
                cmsCollect.setType(Constant.COLLECT_ACTIVITY);
                collectService.insertSelective(cmsCollect);
            }
            return collectService.getHotNum(activityId, Constant.COLLECT_ACTIVITY);
        }else {
            logger.debug("保存用户活动出错!");
            return  0;
        }
    }
}
