package com.culturecloud.service.rs.platformservice.common;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.dao.common.CmsTerminalUserMapper;
import com.culturecloud.dao.dto.common.CmsTerminalUserDto;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.common.CmsTerminalUser;
import com.culturecloud.model.bean.common.SysUser;
import com.culturecloud.model.request.common.LoginSysUserVO;
import com.culturecloud.model.request.common.SendCodeVO;
import com.culturecloud.model.request.common.UserLoginVO;
import com.culturecloud.redis.RedisDAO;
import com.culturecloud.service.local.common.SysUserIntegralService;
import com.culturecloud.service.local.common.SysUserService;
import com.culturecloud.utils.Constant;
import com.culturecloud.utils.MD5Util;
import com.culturecloud.utils.SmsUtil;
import com.culturecloud.utils.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
@Path("/user")
public class CmsTerminalUserResource {

	@Resource
	private RedisDAO<String> redisDao;
	@Resource
	private CmsTerminalUserMapper userMapper;
	@Resource
	private SysUserIntegralService sysUserIntegralService;
	@Resource
	private SysUserService sysUserService;


	@POST
	@Path("/sendCode")
	@SysBusinessLog(remark = "发送短信验证码")
	@Produces(MediaType.APPLICATION_JSON)
	public String sendCode(SendCodeVO request) {

		String mobile = request.getMobileNo();

		String code = new SmsUtil().getValidateCode();

		redisDao.save("send_code_" + mobile, code, 60);

		Map<String, Object> smsParams = new HashMap<>();
		smsParams.put("code", code);
		new SmsUtil().sendActivityCode(mobile, smsParams);

		return code;
	}

	@POST
	@Path("/login")
	@SysBusinessLog(remark = "用户验证码登录")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, String> login(UserLoginVO request) {

		Map<String, String> map = new HashMap<String, String>();

		String mobileNo = request.getMobileNo();
		String code = request.getCode();
		String callback = request.getCallback();
		String registerOrigin=request.getRegisterOrigin();

		String value = redisDao.getData("send_code_" + mobileNo);
		
		if(value==null)
		{
			map.put("errorMsg", "验证码已过期，请重新索取!");
			map.put("status", "error");
			map.put("errorCode", "1");
			return map;
		}

		if (!code.equals(value)) {
			map.put("errorMsg", "验证码不正确!");
			map.put("status", "error");
			map.put("errorCode", "1");
			
			return map;
		}

		CmsTerminalUserDto terminalUser = userMapper.queryTerminalByMobile(mobileNo);
		if (terminalUser != null) {
			if (Constant.USER_NOT_ACTIVATE.equals(terminalUser.getUserIsDisable())) {
				map.put("errorMsg", "会员未激活!");
				map.put("status", "error");
				map.put("errorCode", "2");
			} else if (Constant.USER_IS_FREEZE.equals(terminalUser.getUserIsDisable())) {
				map.put("errorMsg", "用户已冻结!");
				map.put("status", "error");
				map.put("errorCode", "3");
			}
			terminalUser.setLastLoginTime(new Date());
			terminalUser.setLoginType(Constant.LOGIN_TYPE_APP);
			int count = userMapper.editTerminalUserById(terminalUser);

			redisDao.delete("send_code_" + mobileNo);

			map.put("errorMsg", "");
			map.put("status", "success");
			map.put("errorCode", "");
			map.put("userId", terminalUser.getUserId());
		} else {
			// map.put("errorMsg", "用户不存在!");
			// map.put("status", "error");
			// map.put("errorCode", "4");
			CmsTerminalUser insertUser = new CmsTerminalUser();
			insertUser.setUserId(UUIDUtils.createUUId());
			insertUser.setCreateTime(new Date());
			insertUser.setUserIsDisable(Constant.USER_IS_ACTIVATE);
			insertUser.setUserType(1);
			insertUser.setUserIsLogin(1);
			
			if(StringUtils.isNotBlank(registerOrigin)){
				insertUser.setRegisterOrigin(Integer.valueOf(registerOrigin));
			}
			else if(callback!=null && callback.contains("/wechatStatic/cultureTeam")){		//浦东投票
            	insertUser.setRegisterOrigin(12);
            }else{	// 账号来源 10
            	insertUser.setRegisterOrigin(10);
            }
            if(callback!=null){		//用户城市来源
        		//int endIndex = callback.indexOf(".wenhuayun.cn");
        		//insertUser.setUserSiteId(callback.substring(7, endIndex));
        		insertUser.setUserSiteId("hs.hb");//湖北，洪山
            }else{
            	insertUser.setUserSiteId("china");
            }
			// 评论状态正常
			insertUser.setCommentStatus(1);
			// 最后登陆时间
			insertUser.setLastLoginTime(new Date());
			
			//insertUser.setLastSendsmsTime(new Date());
			
			insertUser.setRegisterCount(0);

			insertUser.setUserName("why" + UUIDUtils.createUUId().substring(0, 10));

			String password = (char) (Math.random() * 26 + 'a') + new SmsUtil().getValidateCode();

			insertUser.setUserPwd(MD5Util.toMd5(password));
			
			insertUser.setUserMobileNo(mobileNo);

			int count = userMapper.addTerminalUser(insertUser);
			
			if(count>0){
				
				sysUserIntegralService.insertUserIntegral(insertUser.getUserId(), 1200, 0, "新用户注册奖励积分 用户ID："+insertUser.getUserId(), IntegralTypeEnum.REGISTER.getIndex());
				
				Map<String,Object>smsParams=new HashMap<String,Object>();
				smsParams.put("userName", "新用户");
				smsParams.put("userPassWord", password);
				new SmsUtil().sendUserInfoCode(mobileNo, smsParams);
			}
			map.put("userId", insertUser.getUserId());
			map.put("errorMsg", "");
			map.put("status", "success");
			map.put("errorCode", "");

		}

		return map;
	}
	
	
	@POST
	@Path("/publicLogin")
	@SysBusinessLog(remark = "通用账号登录")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String, Object> publicLogin(LoginSysUserVO request) {

		Map<String, Object> result = new HashMap<String, Object>();

		String userAccount = request.getUserAccount();
		String userPassword = request.getUserPassword();

		SysUser sysUser = sysUserService.loginCheckUser(userAccount, userPassword);

		if (sysUser != null) {

			if (sysUser.getUserState() == 1) {

				sysUser.setUserPassword("");
				result.put("user", sysUser);

				result.put("result", "success");
			} else {
				result.put("result", "freeze");
			}
		} else {

			Map<String, Object> data = new HashMap<String, Object>();
			data.put("userName", userAccount);
			data.put("userPwd", userPassword);
			
			CmsTerminalUser terminalUser=	userMapper.queryTerminalByMobileOrPwd(data);
			
			if(terminalUser!=null)
			{
				  if(Constant.USER_NOT_ACTIVATE.equals(terminalUser.getUserIsDisable())){
		                
		                result.put("result", "activate");
		                
		            }else if(Constant.USER_IS_FREEZE.equals(terminalUser.getUserIsDisable())){
		            	result.put("result", "freeze");
		            }
		            terminalUser.setLastLoginTime(new Date());
		            terminalUser.setLoginType(Constant.LOGIN_TYPE_APP);
		            int count = userMapper.editTerminalUserById(terminalUser);
		            if(count > 0){
		            	Map<String, Object> params = new HashMap<String, Object>();
		                params.put("userTelephone", terminalUser.getUserMobileNo());
		                params.put("userIsDisable", Constant.USER_IS_ACTIVATE);
		                
		                result.put("user", terminalUser);
		            }else {
		            	result.put("result", "error");
		            }
			}
			else
				
				result.put("result", "error");
		}

		return result;
	}

}
