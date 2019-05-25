package com.culturecloud.service.rs.openplatform.user;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.common.CmsTerminalUserMapper;
import com.culturecloud.dao.dto.common.CmsTerminalUserDto;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.common.CmsTerminalUser;
import com.culturecloud.model.request.api.UserCreateApi;
import com.culturecloud.model.request.api.UserCreateVO;
import com.culturecloud.model.request.ticketmachine.GetUserInfoVO;
import com.culturecloud.model.response.api.CreateResponseApi;
import com.culturecloud.model.response.api.CreateResponseVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.common.SysUserIntegralService;
import com.culturecloud.utils.Constant;
import com.culturecloud.utils.StringUtils;

@Component
@Path("/api/user")
public class UserResource {


		@Resource
		private BaseService baseService;

		@Resource
		private CmsTerminalUserMapper userMapper;
		
		@Resource
		private SysUserIntegralService sysUserIntegralService;

		/**
	 * 新增用户
	 * */
	@POST
	@Path("/create")
	@SysBusinessLog(remark="新增用户")
	@Produces(MediaType.APPLICATION_JSON)
	public CreateResponseVO createUser(UserCreateVO userCreateVO)
	{
		CmsTerminalUser user=new CmsTerminalUser();
		CreateResponseVO vo = new CreateResponseVO();
		CreateResponseApi api = new CreateResponseApi();
		List<CreateResponseApi> list = new ArrayList<CreateResponseApi>();
		for(UserCreateApi createUser:userCreateVO.getUserList()){
			try {
				PropertyUtils.copyProperties(user, createUser);
			} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
				e.printStackTrace();
			}
			if (StringUtils.isBlank(createUser.getUserTelephone())) {
				BizException.Throw("400", "用户手机不能为空");
			}else{
				List<CmsTerminalUser> ven = baseService.find(CmsTerminalUser.class, " where USER_MOBILE_NO='" + createUser.getUserTelephone() + "'");
				if (ven.size() > 0) {
					BizException.Throw("400", "该用户已存在");
				}
				user.setUserMobileNo(createUser.getUserTelephone());
			}
			if (StringUtils.isBlank(createUser.getUserId())) {
				BizException.Throw("400", "用户ID不能为空");
			}else{
				List<CmsTerminalUser> ven = baseService.find(CmsTerminalUser.class, " where SYS_ID='" + createUser.getUserId() + "'");
				if (ven.size() > 0) {
					BizException.Throw("400", "该用户已存在");
				}
			}
			user.setSysId(createUser.getUserId());
			user.setUserId(createUser.getUserId());
			baseService.create(user);
			api.setInputId(createUser.getUserId());
			api.setOutputId(user.getUserId());
			list.add(api);
		}
		vo.setList(list);
		return vo;

	}
	
	@POST
	@Path("/getUserInfo")
	@SysBusinessLog(remark="根据身份证获取用户信息")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> getTicketInfo(GetUserInfoVO req)
	{
		Map<String, Object> result = new HashMap<String, Object>();
		if(req.getUserCardNo() != null){
			Map<String,Object> map=new HashMap<String, Object>();
	        map.put("userCardNo",req.getUserCardNo());
	        List<CmsTerminalUserDto> list = userMapper.queryTerminalUserByCondition(map);
	        if (list.size()>0) {
	        	if(list.get(0).getUserIsDisable().equals(0)){
	        		result.put("status", 500);
	        		result.put("data", "账号未激活");
	        	}else if(list.get(0).getUserIsDisable().equals(2)){
	        		result.put("status", 500);
	        		result.put("data", "账号被冻结");
	        	}else{
	        		Map<String, Object> obj = new HashMap<String, Object>();
	        		obj.put("userId", list.get(0).getUserId());
	        		obj.put("userName", list.get(0).getUserName());
	        		obj.put("userNickName", list.get(0).getUserNickName());
	        		obj.put("userMobileNo", list.get(0).getUserMobileNo());
	        		obj.put("userTelephone", list.get(0).getUserTelephone());
	        		obj.put("userCardNo", list.get(0).getUserCardNo());
	        		result.put("status", 200);
	        		result.put("data", obj);
	        	}
	        }else{
	        	CmsTerminalUser insertUser = new CmsTerminalUser();
				insertUser.setUserId(UUIDUtils.createUUId());
				insertUser.setUserCardNo(req.getUserCardNo());
				insertUser.setCreateTime(new Date());
				insertUser.setUserIsDisable(Constant.USER_IS_ACTIVATE);
				insertUser.setUserType(1);
				insertUser.setUserIsLogin(1);
	            insertUser.setRegisterOrigin(17);
	            insertUser.setUserSiteId("china");
				insertUser.setCommentStatus(1);
				insertUser.setLastLoginTime(new Date());
				insertUser.setLastSendsmsTime(new Date());
				insertUser.setRegisterCount(0);
				insertUser.setUserName("why" + UUIDUtils.createUUId().substring(0, 10));
				int count = userMapper.addTerminalUser(insertUser);
				if(count>0){
					sysUserIntegralService.insertUserIntegral(insertUser.getUserId(), 1200, 0, "新用户注册奖励积分 用户ID："+insertUser.getUserId(), IntegralTypeEnum.REGISTER.getIndex());
				}
				Map<String, Object> obj = new HashMap<String, Object>();
				obj.put("userId", insertUser.getUserId());
				obj.put("userName", insertUser.getUserName());
				obj.put("userCardNo", insertUser.getUserCardNo());
        		result.put("status", 200);
        		result.put("data", obj);
	        }
		}else{
			result.put("status", 404);
    		result.put("data", "参数缺失");
		}
		return result;
	}
	
}
