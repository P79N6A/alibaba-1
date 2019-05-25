package com.sun3d.why.aop;

import com.sun3d.why.dao.StatisticsFlowWapMapper;
import com.sun3d.why.dao.StatisticsFlowWebMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.StatisticsFlowWap;
import com.sun3d.why.model.StatisticsFlowWeb;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import org.apache.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;

/**
 * 统计controller aop拦截器
 * @author ldq
 */
@Aspect
@Component
public class StatisticsControllerAop {
	
	private  final Logger log = Logger.getLogger(StatisticsControllerAop.class);
	
	@Autowired
    private HttpSession session;

	@Autowired
	private StatisticsFlowWapMapper statisticsFlowWapMapper;
	@Autowired
	private StatisticsFlowWebMapper statisticsFlowWebMapper;

	/**
	 * PC流量统计
	 * @param joinPoint
	 * @param request
	 */
	@After("(execution(* com.sun3d.why.controller.front.FrontIndexController.index(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.FrontActivityController.activityList(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.FrontActivityController.frontActivityDetail(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.FrontCmsVenueController.venueList(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.FrontCmsVenueController.venueDetail(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.FrontCmsVenueController.toVenueMap(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.FrontCultureMapController.cultureMapList(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.BpInfoFrontController.chuanzhouIndex(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.BpInfoFrontController.bpInfoDetail(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.FrontCmsResourceController.resourceIndex(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.FrontTerminalUserController.userLogin(..)) ||"
			+ " execution(* com.sun3d.why.controller.front.FrontTerminalUserController.userRegister(..)))"
			+ " && args(request,..)")
	public void statisticsFlowWebAfter(JoinPoint joinPoint,HttpServletRequest request) {
		try {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			StatisticsFlowWeb statisticsFlowWeb = statisticsFlowWebMapper.queryStatisticsFlowWebByDate(df.format(new Date()));
			if(statisticsFlowWeb!=null){
				statisticsFlowWeb.setPv(statisticsFlowWeb.getPv()+1);
				CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
				if(sessionUser != null){
					if(statisticsFlowWeb.getUvstr() != null){
						if(!Arrays.asList(statisticsFlowWeb.getUvstr().split(",")).contains(sessionUser.getUserId())){
							statisticsFlowWeb.setUv(statisticsFlowWeb.getUv()+1);
							statisticsFlowWeb.setUvstr(statisticsFlowWeb.getUvstr()+","+sessionUser.getUserId());
						}
					}else{
						statisticsFlowWeb.setUv(1);
						statisticsFlowWeb.setUvstr(sessionUser.getUserId());
					}
				}
				if(!Arrays.asList(statisticsFlowWeb.getIpstr().split(",")).contains(getRemoteAddr(request))){
					statisticsFlowWeb.setIp(statisticsFlowWeb.getIp()+1);
					statisticsFlowWeb.setIpstr(statisticsFlowWeb.getIpstr()+","+getRemoteAddr(request));
				}
				statisticsFlowWebMapper.update(statisticsFlowWeb);
			}else{
				CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
				int result;
				if(sessionUser != null){
					result = statisticsFlowWebMapper.insert(new StatisticsFlowWeb(UUIDUtils.createUUId(),df.format(new Date()),1,1,1,sessionUser.getUserId(),getRemoteAddr(request)));
				}else{
					result = statisticsFlowWebMapper.insert(new StatisticsFlowWeb(UUIDUtils.createUUId(),df.format(new Date()),1,0,1,null,getRemoteAddr(request)));
				}

				//清除昨天数据记录，节省数据库空间
				if(result == 1){
					StatisticsFlowWeb prePoemStatistics = statisticsFlowWebMapper.queryStatisticsFlowWebByDate(df.format(new Date(new Date().getTime()-24*60*60*1000)));
					if(prePoemStatistics != null){
						prePoemStatistics.setIpstr("");
						prePoemStatistics.setUvstr("");
						statisticsFlowWebMapper.update(prePoemStatistics);
					}
				}
			}
		} catch (Throwable e) {
			e.printStackTrace();
		}
	}

	/**
	 * 移动流量统计
	 * @param joinPoint
	 * @param request
	 */
	@After("(execution(* com.sun3d.why.controller.wechat.WechatController.index(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.index(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.preActivityListTagSub(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.preActivityDetail(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatVenueController.index(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatVenueController.preVenueList(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatVenueController.venueDetailIndex(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatVenueController.preMap(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatUserController.preTerminalUser(..)) ||"
			+ " execution(* com.sun3d.why.controller.mobile.MuserController.login(..)) ||"
			+ " execution(* com.sun3d.why.controller.mobile.MuserController.register(..)))"
			+ " && args(request,..)")
	public void statisticsFlowWapAfter(JoinPoint joinPoint,HttpServletRequest request) {
		try {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			StatisticsFlowWap statisticsFlowWap = statisticsFlowWapMapper.queryStatisticsFlowWapByDate(df.format(new Date()));
			if(statisticsFlowWap!=null){
				statisticsFlowWap.setPv(statisticsFlowWap.getPv()+1);
				CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
				if(sessionUser != null){
					if(statisticsFlowWap.getUvstr() != null){
						if(!Arrays.asList(statisticsFlowWap.getUvstr().split(",")).contains(sessionUser.getUserId())){
							statisticsFlowWap.setUv(statisticsFlowWap.getUv()+1);
							statisticsFlowWap.setUvstr(statisticsFlowWap.getUvstr()+","+sessionUser.getUserId());
						}
					}else{
						statisticsFlowWap.setUv(1);
						statisticsFlowWap.setUvstr(sessionUser.getUserId());
					}
				}
				if(!Arrays.asList(statisticsFlowWap.getIpstr().split(",")).contains(getRemoteAddr(request))){
					statisticsFlowWap.setIp(statisticsFlowWap.getIp()+1);
					statisticsFlowWap.setIpstr(statisticsFlowWap.getIpstr()+","+getRemoteAddr(request));
				}
				statisticsFlowWapMapper.update(statisticsFlowWap);
			}else{
				CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
				int result;
				if(sessionUser != null){
					result = statisticsFlowWapMapper.insert(new StatisticsFlowWap(UUIDUtils.createUUId(),df.format(new Date()),1,1,1,sessionUser.getUserId(),getRemoteAddr(request)));
				}else{
					result = statisticsFlowWapMapper.insert(new StatisticsFlowWap(UUIDUtils.createUUId(),df.format(new Date()),1,0,1,null,getRemoteAddr(request)));
				}

				//清除昨天数据记录，节省数据库空间
				if(result == 1){
					StatisticsFlowWap prePoemStatistics = statisticsFlowWapMapper.queryStatisticsFlowWapByDate(df.format(new Date(new Date().getTime()-24*60*60*1000)));
					if(prePoemStatistics != null){
						prePoemStatistics.setIpstr("");
						prePoemStatistics.setUvstr("");
						statisticsFlowWapMapper.update(prePoemStatistics);
					}
				}
			}
		} catch (Throwable e) {
			e.printStackTrace();
		}
	}



	//获取IP
	public static String getRemoteAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
