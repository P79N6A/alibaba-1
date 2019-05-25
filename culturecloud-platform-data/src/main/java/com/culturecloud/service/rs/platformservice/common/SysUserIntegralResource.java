package com.culturecloud.service.rs.platformservice.common;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.common.SysUserIntegralMapper;
import com.culturecloud.dao.dto.common.SysUserIntegralDto;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.common.SysUserIntegral;
import com.culturecloud.model.bean.common.SysUserIntegralDetail;
import com.culturecloud.model.request.common.AddOrderIntegralReqVO;
import com.culturecloud.model.request.common.SysUserIntegralReqVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.activity.CcpActivityOrderService;
import com.culturecloud.service.local.common.SysUserIntegralDetailService;
import com.culturecloud.service.local.common.SysUserIntegralService;

@Component
@Path("/integral")
public class SysUserIntegralResource {

	@Autowired
	private SysUserIntegralService sysUserIntegralService;
	@Autowired
	private CcpActivityOrderService ccpActivityOrderService;
    @Autowired
    private SysUserIntegralDetailService userIntegralDetailService;
    @Autowired
	private SysUserIntegralMapper sysUserIntegralMapper;
    
	@Resource
	private BaseService baseService;
	
	@POST
	@Path("/addIntegralByQR")
	@SysBusinessLog(remark="扫二维码进活动送积分")
	@Produces(MediaType.APPLICATION_JSON)
	public int addIntegralByQR(SysUserIntegralReqVO request){
		String integralId = sysUserIntegralService.getUserIntegralByUserId(request.getUserId()).getIntegralId();
		SysUserIntegralDetail sysUserIntegralDetail = new SysUserIntegralDetail();
		sysUserIntegralDetail.setIntegralId(integralId);
		sysUserIntegralDetail.setIntegralFrom(request.getActivityId());
		sysUserIntegralDetail.setIntegralType(IntegralTypeEnum.ACTIVITY_QR.getIndex());
		List<SysUserIntegralDetail> list = baseService.findByModel(sysUserIntegralDetail);
		if(list.size()==0){
			sysUserIntegralService.insertUserIntegral(request.getUserId(), Integer.parseInt(request.getIntegral()), 0, request.getActivityId(), IntegralTypeEnum.ACTIVITY_QR.getIndex());
			return 1;
		}
		return 0;
	}
	
	@POST
	@Path("/validateOrderIntegral")
	@SysBusinessLog(remark="下单验证积分")
	@Produces(MediaType.APPLICATION_JSON)
	public String validateOrderIntegral(AddOrderIntegralReqVO request){
		List<SysUserIntegral> userIntegrals = baseService.find(SysUserIntegral.class, " where user_id='" + request.getUserId() + "'");
        if (userIntegrals != null && userIntegrals.size() > 0) {
            SysUserIntegral userIntegral = userIntegrals.get(0);
            //积分判断
            if (request.getOrderCostTotalCredit() != null) {
                if (Integer.parseInt(request.getOrderCostTotalCredit()) > userIntegral.getIntegralNow()) {
                    return "该用户的积分不够抵扣该活动";
                }
                if (request.getLowestCredit() != null) {
                    if (request.getLowestCredit() > userIntegral.getIntegralNow()) {
                        return "该用户的积分没有达到最低积分门槛";
                    }
                }
            }
            return "success";
        } else {
            return "无用户积分信息";
        }
	}
	
	@POST
	@Path("/addOrderIntegral")
	@SysBusinessLog(remark="下单扣积分")
	@Produces(MediaType.APPLICATION_JSON)
	public String addOrderIntegral(AddOrderIntegralReqVO request){
		List<SysUserIntegral> userIntegrals = baseService.find(SysUserIntegral.class, " where user_id='" + request.getUserId() + "'");
        if (userIntegrals != null && userIntegrals.size() > 0) {
            SysUserIntegral userIntegral = userIntegrals.get(0);
            if (Integer.parseInt(request.getOrderCostTotalCredit()) > 0) {
                userIntegral.setIntegralNow(userIntegral.getIntegralNow() - Integer.parseInt(request.getOrderCostTotalCredit()));
                baseService.update(userIntegral, "where user_id='" + request.getUserId() + "'");
                SysUserIntegralDetail userIntegralDetail = new SysUserIntegralDetail();
                userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
                userIntegralDetail.setCreateTime(new Date());
                userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
                userIntegralDetail.setIntegralChange(Integer.parseInt(request.getOrderCostTotalCredit()));
                userIntegralDetail.setChangeType(1);
                userIntegralDetail.setIntegralFrom("系统扣除活动预订所需积分，订单ID：" + request.getActivityOrderId());
                userIntegralDetail.setIntegralType(IntegralTypeEnum.REDUCE_INTEGRAL.getIndex());
                baseService.create(userIntegralDetail);
            }
            return "success";
        } else {
            return "无用户积分信息";
        }
	}
	
	@POST
	@Path("/checkDayIntegral")
	@SysBusinessLog(remark="检测每日加积分")
	@Produces(MediaType.APPLICATION_JSON)
	public int checkDayIntegral(SysUserIntegralReqVO request){
		return sysUserIntegralService.checkDayIntegral(request.getUserId());
	}
	
	@POST
	@Path("/weekOpenAddIntegral")
	@SysBusinessLog(remark="检测每周加积分")
	@Produces(MediaType.APPLICATION_JSON)
	public int weekOpenAddIntegral(SysUserIntegralReqVO request){
		return userIntegralDetailService.weekOpenAddIntegral(request);
	}
	
	@POST
	@Path("/getUserIntegralByUserId")
	@SysBusinessLog(remark="获取用户当前积分")
	@Produces(MediaType.APPLICATION_JSON)
	public String getUserIntegralByUserId(SysUserIntegralReqVO request){
		SysUserIntegralDto aa=sysUserIntegralMapper.selectUserIntegralByUserId(request.getUserId());
		if(aa!=null)
		{
			return String.valueOf(aa.getIntegralNow());
		}
		return "0";
	}
}
