package com.sun3d.why.util;
import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsCultureUserStatistcs;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CollectService;
import com.sun3d.why.statistics.service.StatisticCultureUserService;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.concurrent.Callable;

/**
 * 多线程中添加用户非遗
 * Created by Administrator on 2015/9/14.
 */
public class CultureCallable implements Callable {
    private Logger logger = Logger.getLogger(CultureCallable.class);
    private CmsTerminalUserService terminalUserService;
    private StatisticCultureUserService statisticCultureUserService;
    private CollectService collectService;
    private Integer operateType;
    private String id;
    private HttpServletRequest request;
    private CmsTerminalUser user;
    public CultureCallable(int operateType, String id, HttpServletRequest request, CmsTerminalUser user, CmsTerminalUserService terminalUserService, StatisticCultureUserService statisticCultureUserService, CollectService collectService){
        this.operateType = operateType;
        this.id=id;
        this.request=request;
        this.user=user;
        this.terminalUserService=terminalUserService;
        this.statisticCultureUserService=statisticCultureUserService;
        this.collectService=collectService;
    }
    @Override
    public Integer call() throws Exception {
        int flag = 0;
        CmsCultureUserStatistcs c = new CmsCultureUserStatistcs();
        c.setId(UUIDUtils.createUUId());
        c.setOperateType(operateType);
        c.setIp(CommonUtil.getIpAddr(request));
        c.setCultureId(id);
        c.setCreateTime(new Date());
        c.setUpdateTime(new Date());
        if (user != null) {
            //操作类型 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
            if (operateType != 0 && operateType != 3) {
                int count = statisticCultureUserService.cultureUserByCount(id, operateType, IpUtil.getIpAddress(request), user.getUserId(), Constant.STATIS2);
                if (count > 0) {
                    logger.debug("当天用户非遗数据已存在不会进行重复保存数据");
                    return collectService.getHotNum(id, Constant.COLLECT_CULTURE);
                }
            }
            c.setUserId(user.getUserId());
            //  c.setCreateUser(user.getUserName());
            c.setStatus(2);
        } else {
            String userId = terminalUserService.getTerminalUserId(Constant.DEFAULT_SESSION_USER_NAME);
            if (operateType != 0 && operateType != 3) {
                int count = statisticCultureUserService.cultureUserByCount(id, operateType, IpUtil.getIpAddress(request), userId, Constant.STATUS1);
                if (count > 0) {
                    logger.debug("当天非遗游客数据已存在不会进行重复保存数据");
                    return collectService.getHotNum(id, Constant.COLLECT_CULTURE);
                }
            }
            c.setUserId(userId);
            c.setStatus(1);
        }
        flag = statisticCultureUserService.addCultureUserStatistics(c);
        if (flag>0) {
            if (operateType != 0 && operateType == 3) {
                CmsCollect cmsCollect = new CmsCollect();
                cmsCollect.setUserId(c.getUserId());
                cmsCollect.setRelateId(id);
                cmsCollect.setType(Constant.COLLECT_CULTURE);
                collectService.insertSelective(cmsCollect);
            }
            return collectService.getHotNum(id, Constant.COLLECT_CULTURE);
        }else {
            logger.debug("保存用户非遗出错!");
            return 0;
        }
    }
 }

