package com.sun3d.why.util;
import com.sun3d.why.model.AntiqueUserStatistics;
import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CollectService;
import com.sun3d.why.statistics.service.StatisticAntiqueUserService;
import org.apache.log4j.Logger;
import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.concurrent.Callable;
/**
 * 多线程保存藏品用户
 * Created by Administrator on 2015/9/15.
 */
public class AntiqueCallable implements Callable {
    private Logger logger = Logger.getLogger(AntiqueCallable.class);
    private Integer operateType;
    private String  antiqueId;
    private CmsTerminalUser user;
    private StatisticAntiqueUserService statisticAntiqueUserService;
    private CollectService collectService;
    private CmsTerminalUserService terminalUserService;
    private  HttpServletRequest request;
    public AntiqueCallable(Integer operateType, String antiqueId, HttpServletRequest request, CmsTerminalUser user, StatisticAntiqueUserService statisticAntiqueUserService, CollectService collectService, CmsTerminalUserService terminalUserService) {
        this.operateType=operateType;
        this.antiqueId=antiqueId;
        this.request=request;
        this.user=user;
        this.statisticAntiqueUserService=statisticAntiqueUserService;
        this.collectService=collectService;
        this.terminalUserService=terminalUserService;
    }

    @Override
    public Integer call() throws Exception {
        int flag=0;
        AntiqueUserStatistics antiqueUserStatistics=new AntiqueUserStatistics();
        antiqueUserStatistics.setIp(CommonUtil.getIpAddr(request));
        antiqueUserStatistics.setAntiqueId(antiqueId);
        antiqueUserStatistics.setOperateType(operateType);
        antiqueUserStatistics.setCreateTime(new Timestamp(System.currentTimeMillis()));
        antiqueUserStatistics.setUpdateTime(new Timestamp(System.currentTimeMillis()));
        antiqueUserStatistics.setId(UUIDUtils.createUUId());
        if(user!=null){
          if(operateType!=0 && operateType!=3){
            //操作类型 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
            int count=statisticAntiqueUserService.antiqueUserCountByCondition(antiqueId, operateType, CommonUtil.getIpAddr(request), user.getUserId(),Constant.STATIS2);
            if(count>0){
                logger.debug("当天用户藏品数据已存在不会进行重复保存数据");
                return collectService.getHotNum(antiqueId,Constant.COLLECT_ANTIQUE);
              }
            }
            antiqueUserStatistics.setStatus(Constant.STATIS2);
            antiqueUserStatistics.setUserId(user.getUserId());
        }else {
            String userId = terminalUserService.getTerminalUserId(Constant.DEFAULT_SESSION_USER_NAME);
            if(operateType!=0 && operateType!=3){
                int count=statisticAntiqueUserService.antiqueUserCountByCondition(antiqueId, operateType,CommonUtil.getIpAddr(request), userId, Constant.STATUS1);
                if(count>0){
                    //代表当天重复操作了这个状态  1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
                    logger.debug("当天游客藏品数据已存在不会进行重复保存数据");
                    return collectService.getHotNum(antiqueId,Constant.COLLECT_ANTIQUE);
                }
             }
            antiqueUserStatistics.setStatus(Constant.STATUS1);
            antiqueUserStatistics.setUserId(userId);
          }
        flag=statisticAntiqueUserService.addAntiqueUserStatistics(antiqueUserStatistics);
        if(flag>0){
            if (operateType != 0 && operateType == 3) {
                CmsCollect cmsCollect = new CmsCollect();
                cmsCollect.setUserId(antiqueUserStatistics.getUserId());
                cmsCollect.setRelateId(antiqueId);
                cmsCollect.setType(Constant.COLLECT_ANTIQUE);
                collectService.insertSelective(cmsCollect);
            }
            return collectService.getHotNum(antiqueId, Constant.COLLECT_ANTIQUE);
        }else {
            logger.debug("保存藏品用户数据失败!");
            return 0;
        }
    }
}
