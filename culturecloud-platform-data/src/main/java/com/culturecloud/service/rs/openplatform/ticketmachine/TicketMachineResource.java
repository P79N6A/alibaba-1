package com.culturecloud.service.rs.openplatform.ticketmachine;

import java.lang.reflect.InvocationTargetException;
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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BaseRequest;
import com.culturecloud.dao.common.CmsTagMapper;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.bean.common.CmsTag;
import com.culturecloud.model.bean.ticketmachine.TicketMachineHeart;
import com.culturecloud.model.request.activity.ActivityOrderVO;
import com.culturecloud.model.request.ticketmachine.CheckTicketVO;
import com.culturecloud.model.request.ticketmachine.GetActListVO;
import com.culturecloud.model.request.ticketmachine.GetTicketInfoVO;
import com.culturecloud.model.request.ticketmachine.GetValidateCode;
import com.culturecloud.model.request.ticketmachine.TicketMachineHeartVO;
import com.culturecloud.req.openrs.SysSourceToDept;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.activity.CmsActivityService;
import com.culturecloud.service.local.ticketmachine.TicketMachineService;
import com.culturecloud.util.JSONResponse;
import com.culturecloud.utils.StringUtils;

@Component
@Path("/ticketMachine")
public class TicketMachineResource {

	@Resource
	private BaseService baseService;
	@Resource
	private TicketMachineService ticketMachineService;
	@Resource
	private CmsTagMapper cmsTagMapper;
	@Autowired
	private CmsActivityService cmsActivityService;
	
	
	@POST
	@Path("/heartBeat")
	@SysBusinessLog(remark="取票机心跳机制")
	@Produces(MediaType.APPLICATION_JSON)
	public void heartBeat(TicketMachineHeartVO req)
	{
		TicketMachineHeart o=new TicketMachineHeart();
		o.setMachineId(StringUtils.getUUID());
		o.setMachineCode(req.getMachineCode());
		o.setDateTime(new Date());
		baseService.create(o);
	}
	
	@POST
	@Path("/getTicketInfo")
	@SysBusinessLog(remark="根据取票码或身份证获取订单信息")
	@Produces(MediaType.APPLICATION_JSON)
	public JSONObject getTicketInfo(GetTicketInfoVO req)
	{
		if(req!=null && !StringUtils.isBlank(req.getOrderValidateCode())){
			return ticketMachineService.getTicketInfoByOrderValidateCode(req.getOrderValidateCode());
		}else if(req!=null && !StringUtils.isBlank(req.getOrderIdentityCard())){
			return ticketMachineService.getTicketInfoByOrderIdentityCard(req.getOrderIdentityCard());
		}else{
			return JSONResponse.getResultFormat(404, "参数缺失");
		}
	}
	
	@POST
	@Path("/getValidateCode")
	@SysBusinessLog(remark="根据订单号查找取票码")
	@Produces(MediaType.APPLICATION_JSON)
	public JSONObject getValidateCode(GetValidateCode req)
	{
		if (null!=req && !StringUtils.isBlank(req.getActivityOrderId())) {
			return ticketMachineService.getValidateCodeByOrderId(req.getActivityOrderId());
		}else{
			return JSONResponse.getResultFormat(404, "参数缺失");
		}
	}
	
	@POST
	@Path("/checkTicket")
	@SysBusinessLog(remark="根据取票码验票")
	@Produces(MediaType.APPLICATION_JSON)
	public JSONObject checkTicket(CheckTicketVO req)
	{
		if(req!=null && !StringUtils.isBlank(req.getOrderValidateCode())){
			try {
				return ticketMachineService.checkTicketByOrderValidateCode(req.getOrderValidateCode());
			} catch (Exception e) {
				e.printStackTrace();
				return JSONResponse.getResultFormat(500, e.getMessage());
			}
		}else{
			return JSONResponse.getResultFormat(404, "参数缺失");
		}
	}
	
	@POST
	@Path("/getActTag")
	@SysBusinessLog(remark="获取活动类别")
	@Produces(MediaType.APPLICATION_JSON)
	public JSONObject getActTag(BaseRequest req)
	{
		JSONArray array = new JSONArray();
		try {
			List<CmsTag> tagList = cmsTagMapper.queryActivityTagByDictCode("ACTIVITY_TYPE");
			for(CmsTag dto : tagList){
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("tagName", dto.getTagName());
				jsonObj.put("tagId", dto.getTagId());
				array.add(jsonObj);
			}
			return JSONResponse.getResultFormat(200, array);
		} catch (Exception e) {
			e.printStackTrace();
			return JSONResponse.getResultFormat(500, e.getMessage());
		}
	}
	
	@POST
	@Path("/getActList")
	@SysBusinessLog(remark="获取活动列表")
	@Produces(MediaType.APPLICATION_JSON)
	public JSONObject getActList(GetActListVO req)
	{
		req.setDeptId(SysSourceToDept.toDept(req.getDeptId()));
		return cmsActivityService.queryTicketActivityByCidition(req);
	}
	
	@POST
    @Path("/addOrder")
    @SysBusinessLog(remark = "下订单")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public String addOrder(ActivityOrderVO VO) {
        String json = "";
        try {
            CmsActivityOrder cmsActivityOrder = new CmsActivityOrder();
            String seatId = VO.getSeatIds();
            try {
                PropertyUtils.copyProperties(cmsActivityOrder, VO);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
            json = ticketMachineService.addTicketActivityOrder(cmsActivityOrder, seatId);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        if(json.length()!=10&&json.length()!=32){
            BizException.Throw("400", json);
        }
        return json;
    }
}
