package com.sun3d.why.util;
import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsTeamUserStatistics;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CollectService;
import com.sun3d.why.statistics.service.StatisticTermUserService;
import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.concurrent.Callable;
import org.apache.log4j.Logger;
/**
 * 多线程添加团体用户
 * Created by Administrator on 2015/9/15.
 */
public class TuserCallable implements Callable {
     private Logger logger = Logger.getLogger(TuserCallable.class);
    private Integer operateType;
    private String tuserId;
    private HttpServletRequest request;
    private CmsTerminalUser user;
    private  StatisticTermUserService statisticTermUserService;
    private CollectService collectService;
    private CmsTerminalUserService terminalUserService;
    public TuserCallable(Integer operateType, String tuserId, HttpServletRequest request, CmsTerminalUser user, StatisticTermUserService statisticTermUserService,CollectService collectService, CmsTerminalUserService terminalUserService) {
     this.operateType=operateType;
     this.tuserId=tuserId;
     this.request=request;
     this.user=user;
     this.statisticTermUserService=statisticTermUserService;
     this.collectService=collectService;
     this.terminalUserService=terminalUserService;
    }

    @Override
    public Integer call() throws Exception {
        int flag=0;
        CmsTeamUserStatistics cmsTeamUserStatistics=new CmsTeamUserStatistics();
        cmsTeamUserStatistics.setIp(CommonUtil.getIpAddr(request));
        cmsTeamUserStatistics.setTuserId(tuserId);
        cmsTeamUserStatistics.setOperateType(operateType);
        cmsTeamUserStatistics.setCreateTime(new Timestamp(System.currentTimeMillis()));
        cmsTeamUserStatistics.setUpdateTime(new Timestamp(System.currentTimeMillis()));
        cmsTeamUserStatistics.setId(UUIDUtils.createUUId());
        if(user!=null){
            if(operateType!=0 && operateType!=3){
                int count = statisticTermUserService.termUserCountByCondition(tuserId, operateType,CommonUtil.getIpAddr(request),user.getUserId(),Constant.STATIS2);
                if (count > 0) {
                    logger.debug("当天用户藏品数据已存在不会进行重复保存数据");
                    return collectService.getHotNum(tuserId,Constant.COLLECT_TEAMUSER);
                }
            }
            cmsTeamUserStatistics.setStatus(Constant.STATIS2);
            cmsTeamUserStatistics.setUserId(user.getUserId());
        }else {
            String  userId = terminalUserService.getTerminalUserId(Constant.DEFAULT_SESSION_USER_NAME);
            int count=statisticTermUserService.termUserCountByCondition(tuserId, operateType, CommonUtil.getIpAddr(request), userId, Constant.STATUS1);
             if(count>0){
                logger.debug("当天团体游客数据已存在不会进行重复保存数据");
                 return collectService.getHotNum(tuserId,Constant.COLLECT_TEAMUSER);
            }
            cmsTeamUserStatistics.setStatus(Constant.STATUS1);
            cmsTeamUserStatistics.setUserId(userId);
        }
        flag=statisticTermUserService.addTermUserStatistics(cmsTeamUserStatistics);
        if(flag>0){
            if (operateType != 0 && operateType == 3) {
                CmsCollect cmsCollect = new CmsCollect();
                cmsCollect.setUserId(cmsTeamUserStatistics.getUserId());
                cmsCollect.setRelateId(tuserId);
                cmsCollect.setType(Constant.COLLECT_TEAMUSER);
                collectService.insertSelective(cmsCollect);
            }
            return collectService.getHotNum(tuserId, Constant.COLLECT_TEAMUSER);
        }else {
            logger.debug("添加团体用户错误!");
            return 0;
        }
    }
}
