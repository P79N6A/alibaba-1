package com.culturecloud.service.rs.platformservice.special;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.dao.special.CcpSpecialActivityMapper;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.activity.CmsActivityEvent;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.bean.special.CcpSpecialCustomer;
import com.culturecloud.model.bean.special.CcpSpecialEnter;
import com.culturecloud.model.bean.special.CcpSpecialGet;
import com.culturecloud.model.bean.special.CcpSpecialPageActivity;
import com.culturecloud.model.bean.special.CcpSpecialYcode;
import com.culturecloud.model.request.activity.ActivityOrderVO;
import com.culturecloud.model.request.special.GetSpecCodeReqVO;
import com.culturecloud.model.request.special.SpecialCodeReqVO;
import com.culturecloud.model.request.special.SpecialCodeUseReqVO;
import com.culturecloud.model.request.special.SpecialNameReqVO;
import com.culturecloud.model.response.special.SpecActivityByPageResVO;
import com.culturecloud.model.response.special.SpecChangeIndexResVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.activity.CcpActivityOrderService;
import com.culturecloud.utils.StringUtils;

@Component
@Path("/specialchange")
public class SpecialChangeResource {

	@Resource
	private BaseService baseService;
	
	@Resource
	private CcpSpecialActivityMapper ccpSpecialActivityMapper;
	
	@Autowired
    private CcpActivityOrderService ccpActivityOrderService;
	
	/**
	 * 根据渠道名称获取渠道图片
	 * */
	@POST
	@Path("/getImageByChannelName")
	@SysBusinessLog(remark="根据渠道名称获取渠道图片")
	@Produces(MediaType.APPLICATION_JSON)
	public SpecChangeIndexResVO getImageByChannelName(SpecialNameReqVO req)
	{
		List<CcpSpecialEnter> objects=baseService.find(CcpSpecialEnter.class, " where enter_parame_path='"+req.getSpecialName()+"'");
		if(objects!=null&&objects.size()>0)
		{
			SpecChangeIndexResVO res=new SpecChangeIndexResVO();
			res.setEnterId(objects.get(0).getEnterId());
			res.setEnterName(objects.get(0).getEnterName());
			res.setLogoImage(objects.get(0).getEnterLogoImageUrl());
			return res;
		}
		return null;
	}
	
	
	/** 索取Y码*/
	@POST
	@Path("/getYCode")
	@SysBusinessLog(remark="索取Y码")
	@Produces(MediaType.APPLICATION_JSON)
	public void getYCode(GetSpecCodeReqVO req)
	{
		List<CcpSpecialGet> objects=baseService.find(CcpSpecialGet.class, " where telphone='"+req.getTelphone()+"'");
		if(objects!=null&&objects.size()>0)
		{
			BizException.Throw("10001", "您的手机号已提交过,无需重复提交");
		}
		CcpSpecialGet object=new CcpSpecialGet();
		object.setId(StringUtils.getUUID());
		object.setName(req.getName());
		object.setEnterId(req.getEnterId());
		object.setTelphone(req.getTelphone());
		baseService.create(object);
	}
	
	/** 根据Y码展示活动LIST */
	@POST
	@Path("/getActivityListByCode")
	@SysBusinessLog(remark = "根据Y码展示活动LIST")
	@Produces(MediaType.APPLICATION_JSON)
	public List<SpecActivityByPageResVO> getActivityListByCode(SpecialCodeReqVO req) {
		List<CcpSpecialYcode> objects = baseService.find(CcpSpecialYcode.class,
				" where ycode='" + req.getSpecialCode() + "'");
		if (objects != null && objects.size() > 0) {
			if (objects.get(0).getCodeStatus() == 2) {
				BizException.Throw("10001", "您输入的Y码已被使用过");
			}

			if (objects.get(0).getCodeStatus() == 0) {
				BizException.Throw("10001", "该Y码未生效");
			}

			CcpSpecialCustomer objects1 = baseService.findById(CcpSpecialCustomer.class,
					objects.get(0).getCustomerId());
			if (objects1 != null) {
				
				if(this.compare_date(new Date(),objects1.getYcodeStartTime())==-1)
				{
					BizException.Throw("10001", "Y码未到生效时间");
				}
				
				if(this.compare_date(new Date(),objects1.getYcodeEndTime())==1)
				{
					BizException.Throw("10001", "Y码已过期");
				}
				
				List<CcpSpecialPageActivity> activitys=baseService.find(CcpSpecialPageActivity.class, " where page_id='"+objects1.getPageId()+"'");
				if(activitys!=null&&activitys.size()>0)
				{
					return ccpSpecialActivityMapper.getActivityListByPage(objects1.getPageId());
				}
				else
				{
					BizException.Throw("10001", "活动关联出错！");
				}
				
			}

		} else {
			BizException.Throw("10001", "输入Y码有误");
		}
		return null;
	}
	
	
	/** 兑换活动 
	 * @throws Exception */
	@POST
	@Path("/changeActivity")
	@SysBusinessLog(remark = "兑换活动")
	@Produces(MediaType.APPLICATION_JSON)
	@Transactional(isolation = Isolation.SERIALIZABLE)
	public String changeActivity(SpecialCodeUseReqVO req) throws Exception
	{
		List<CcpSpecialYcode> objects = baseService.find(CcpSpecialYcode.class,
				" where ycode='" + req.getSpecialCode() + "'");
		if (objects != null && objects.size() > 0) {
			if (objects.get(0).getCodeStatus() == 2) {
				BizException.Throw("10001", "您输入的Y码已被使用过");
			}

			if (objects.get(0).getCodeStatus() == 0) {
				BizException.Throw("10001", "该Y码未生效");
			}
			
			CcpSpecialYcode object=objects.get(0);
			object.setYcodeUseTime(new Date());
			object.setUseActivityId(req.getActivityId());
			object.setUserId(req.getUserId());
			object.setCodeStatus(2);
			baseService.update(object, " where ycode='"+req.getSpecialCode()+"'");

			List<CmsActivityEvent> cmsActivityEvents=baseService.find(CmsActivityEvent.class, " where ACTIVITY_ID='"+req.getActivityId()+"'");
			if(cmsActivityEvents!=null&&cmsActivityEvents.size()>0)
			{
				CmsActivityEvent object1=cmsActivityEvents.get(0);
//				object1.setAvailableCount(cmsActivityEvents.get(0).getAvailableCount()-1);
//				baseService.update(object1, " where EVENT_ID='"+object1.getEventId()+"'");
				
				CmsActivityOrder cmsActivityOrder = new CmsActivityOrder();
	            
				
				ActivityOrderVO vo=new ActivityOrderVO();
				vo.setActivityId(req.getActivityId());
				vo.setCostTotalCredit("0");
				vo.setEventId(object1.getEventId());
				vo.setOrderName(req.getSpecialCode());
				vo.setOrderPhoneNo(req.getTelphone());
				vo.setOrderVotes(1);
				vo.setOrderPrice(BigDecimal.ZERO);
				vo.setUserId(req.getUserId());
				
				String seatId = vo.getSeatIds();
				try {
	                PropertyUtils.copyProperties(cmsActivityOrder, vo);
	            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
	                e.printStackTrace();
	            }
	            String json = ccpActivityOrderService.addActivityOrder(cmsActivityOrder, seatId);
	            if(json.length()!=15){
	                BizException.Throw("10001", "抢票失败~");
	            }
				//System.out.println(json);
				return json;
			}
			
		}
		return null;
	}
	
	
	public static int compare_date(Date dt1, Date dt2) {
	  try {
			if (dt1.getTime() > dt2.getTime()) {
				return 1;
			} else if (dt1.getTime() < dt2.getTime()) {
				return -1;
			} else {
				return 0;
			}
		} catch (Exception exception) {
			exception.printStackTrace();
		}
		return 0;
	}
}
