package com.culturecloud.service.rs.platformservice.common;

import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.bean.common.SysUser;
import com.culturecloud.model.request.common.LoginSysUserVO;
import com.culturecloud.model.request.common.SysUserDetailVO;
import com.culturecloud.model.request.common.UpdateSysUserVO;
import com.culturecloud.model.response.common.SysUserVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.common.SysUserService;

@Component
@Path("/sysUser")
public class SysUserResource {

	@Autowired
	private SysUserService sysUserService;
	@Autowired
	private BaseService baseService;

	@POST
	@Path("/loginCheckUser")
	@SysBusinessLog(remark="管理员账号登录")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String,Object> loginCheckUser(LoginSysUserVO request) {

		 String userAccount = request.getUserAccount();
         String userPassword = request.getUserPassword();
         
         Map<String,Object> result=new HashMap<String,Object>();

         SysUser sysUser  = sysUserService.loginCheckUser(userAccount, userPassword);
         
         if (sysUser != null) {

			if (sysUser.getUserState() == 1) {
				
				sysUser.setUserPassword("");
				result.put("sysUser", sysUser);
				
				result.put("result", "success");
			} else {
				result.put("result", "freeze");
			}
		} else {
			result.put("result", "error");
			
		}
         
         return result;
	}
	
	@POST
	@Path("/toDetail")
	@SysBusinessLog(remark="获取管理员信息详情")
	@Produces(MediaType.APPLICATION_JSON)
	public SysUserVO toDetail(SysUserDetailVO request){
		
		String userId=request.getUserId();
		
		SysUser user=baseService.findById(SysUser.class, userId);
		
		SysUserVO vo=new SysUserVO();
		
		if(user!=null){
			vo=new SysUserVO(user);
		}
		
		return vo;
	}
	
	@POST
	@Path("/updateSysUser")
	@SysBusinessLog(remark="更新管理员信息")
	@Produces(MediaType.APPLICATION_JSON)
	public int updateSysUser(UpdateSysUserVO request){
		
		String userId=request.getUserId();
		String userNickName=request.getUserNickName();
		String userHeadImgUrl=request.getUserHeadImgUrl();
		
		SysUser user=new SysUser();
		user.setUserId(userId);
		user.setUserNickName(userNickName);
		user.setUserHeadImgUrl(userHeadImgUrl);
		baseService.update(user, " where USER_ID='"+userId+"'");
		
		return 1;
	}
}
