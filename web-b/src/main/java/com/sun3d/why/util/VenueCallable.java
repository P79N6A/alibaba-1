package com.sun3d.why.util;
import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.VenueUserStatistics;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CollectService;
import com.sun3d.why.statistics.service.StatisticVenueUserService;
import org.apache.log4j.Logger;
import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.concurrent.Callable;
/**
 * 多线程添加展馆用户
 * Created by Administrator on 2015/9/15.
 */
public class VenueCallable implements Callable{
    private Logger logger = Logger.getLogger(VenueCallable.class);
    private Integer operateType;
    private String  venueId;
    private HttpServletRequest request;
    private CmsTerminalUser user;
    private StatisticVenueUserService statisticVenueUserService;
    private CollectService collectService;
    private CmsTerminalUserService terminalUserService;
    public VenueCallable(Integer operateType, String venueId, HttpServletRequest request, CmsTerminalUser user, StatisticVenueUserService statisticVenueUserService, CollectService collectService, CmsTerminalUserService terminalUserService) {
        this.operateType=operateType;
        this.venueId=venueId;
        this.request=request;
        this.user=user;
        this.statisticVenueUserService=statisticVenueUserService;
        this.collectService=collectService;
        this.terminalUserService=terminalUserService;
    }

    @Override
    public Integer call() throws Exception {
        int flag = 0;
        VenueUserStatistics venueUserStatistics = new VenueUserStatistics();
        venueUserStatistics.setIp(CommonUtil.getIpAddr(request));
        venueUserStatistics.setVenueId(venueId);
        venueUserStatistics.setOperateType(operateType);
        venueUserStatistics.setCreateTime(new Timestamp(System.currentTimeMillis()));
        venueUserStatistics.setUpdateTime(new Timestamp(System.currentTimeMillis()));
        venueUserStatistics.setId(UUIDUtils.createUUId());
        if (user != null) {
            if (operateType != 0 && operateType != 3) {
                int count = statisticVenueUserService.venueUserCountByCondition(venueId, operateType, CommonUtil.getIpAddr(request), user.getUserId(), Constant.STATIS2);
                if (count > 0) {
                    //代表当天重复操作了这个状态  1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
                    logger.debug("当天用户场馆数据已存在不会进行重复保存数据");
                    return collectService.getHotNum(venueId, Constant.COLLECT_VENUE);
                }
            }
            venueUserStatistics.setStatus(Constant.STATIS2);
            venueUserStatistics.setUserId(user.getUserId());
        } else {
            String userId = terminalUserService.getTerminalUserId(Constant.DEFAULT_SESSION_USER_NAME);
            if (operateType != 0 && operateType != 3) {
                int count = statisticVenueUserService.venueUserCountByCondition(venueId, operateType, CommonUtil.getIpAddr(request), userId, Constant.STATUS1);
                if (count > 0) {
                    //代表当天重复操作了这个状态  1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
                    logger.debug("当天游客场馆数据已存在不会进行重复保存数据");
                    return collectService.getHotNum(venueId, Constant.COLLECT_VENUE);
                }
            }
            venueUserStatistics.setStatus(Constant.STATUS1);
            venueUserStatistics.setUserId(userId);
        }
        flag = statisticVenueUserService.addVenueUserStatistics(venueUserStatistics);
        if(flag>0) {
            if (operateType != 0 && operateType == 3) {
                CmsCollect cmsCollect = new CmsCollect();
                cmsCollect.setUserId(venueUserStatistics.getUserId());
                cmsCollect.setRelateId(venueId);
                cmsCollect.setType(Constant.COLLECT_VENUE);
                collectService.insertSelective(cmsCollect);
            }
            return collectService.getHotNum(venueId, Constant.COLLECT_VENUE);
        }else {
            logger.debug("保存用户展馆出错!");
            return 0;
        }
    }
}
