package com.sun3d.why.service.impl;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.CmsUserTagMapper;
import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserTag;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.extmodel.SmsConfig;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.CommonUtil;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.MD5Util;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.RandomUtils;
import com.sun3d.why.util.SmsSend;
import com.sun3d.why.util.SmsUtil;
import com.sun3d.why.util.SymmetricEncoder;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;

@Service
@Transactional
public class CmsTerminalUserServiceImpl implements CmsTerminalUserService {
	@Autowired
	private CmsUserMessageService userMessageService;

	@Autowired
	private CmsTerminalUserMapper userMapper;

	@Autowired
	private CmsUserTagMapper cmsUserTagMapper;

	@Autowired
	private SmsConfig smsConfig;

	private Logger logger = Logger.getLogger(CmsTerminalUserServiceImpl.class);

	@Autowired
	private StaticServer staticServer;

	@Autowired
	private SyncCmsTerminalUserService syncCmsTerminalUserService;

	@Autowired
	private UserIntegralDetailService userIntegralDetailService;

	@Autowired
	private UserIntegralService userIntegralService;
	
	@Autowired
    private HttpSession session;

	/**
	 * 根据用户名称获取该用户的用户ID
	 * 
	 * @param userName
	 * @return String userId
	 * @author cj
	 */
	@Override
	public String getTerminalUserId(String userName) {
		return userMapper.getTerminalUserId(userName);
	}

	/**
	 * 根据手机号获取该用户的用户ID
	 * 
	 * @param userMobileNo
	 * @return String userId
	 * @author qww
	 */
	@Override
	public String getTerminalUserIdByMobileNo(String userMobileNo) {
		return userMapper.getTerminalUserIdByMobileNo(userMobileNo);
	}

	/**
	 * 根据第三方用户ID获取文化云系统用户ID
	 *
	 * @param sysId
	 * @return String sysId
	 * @author cj
	 */
	@Override
	public String getTerminalUserIdBySysId(String sysId) {

		return userMapper.getTerminalUserIdBySysId(sysId);
	}

	/**
	 * 查询会员列表
	 * 
	 * @param user
	 *            会员对象
	 * @param page
	 *            分页
	 * @return 会员对象集合
	 */
	@Override
	public List<CmsTerminalUser> queryTerminalUserByCondition(CmsTerminalUser user, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(user.getUserMobileNo())) {
			map.put("userMobileNo", "%" + user.getUserMobileNo() + "%");
		}
		if (user.getUserType() != null) {
			map.put("userType", user.getUserType());
		}
		if (user.getUserIsDisable() != null) {
			map.put("userIsDisable", user.getUserIsDisable());
		}

		if (user.getCommentStatus() != null) {
			map.put("commentStatus", user.getCommentStatus());
		}

		if (StringUtils.isNotBlank(user.getUserArea())) {
			map.put("userArea", "%" + user.getUserArea() + "%");
		}

		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());

			int total = userMapper.queryTerminalUserCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		return userMapper.queryTerminalUserByCondition(map);
	}

	/**
	 * 查询符合条件的会员条数
	 * 
	 * @param map
	 * @return 符合条件的会员条数
	 */
	@Override
	public int queryTerminalUserIsExists(Map<String, Object> map) {
		return userMapper.queryTerminalUserIsExists(map);
	}

	/**
	 * 新增会员
	 * 
	 * @param user
	 * @return success:成功 failure:失败 repeat:重复 mobileRepeat:手机重复 disPwd:密码不一致
	 */
	@Override
	public String addTerminalUser(CmsTerminalUser user) {
		try {
			if (user != null) {
				// 验证会员名称是否存在
				/********** 2015.11.11 注释 by niu 添加用户不验证用户名 可随意修改 ************/
				/*
				 * if(StringUtils.isNotBlank(user.getUserName())){
				 * CmsTerminalUser terminalUser = new CmsTerminalUser();
				 * terminalUser.setUserName(user.getUserName());
				 * if(terminalUserIsExists(terminalUser)){ return
				 * Constant.RESULT_STR_REPEAT; } }
				 */
				/*
				 * // 验证密码相同 if(!user.getUserPwd().equals(confirmPassword)){
				 * return Constant.RESULT_STR_DISPWD; }
				 */
				// 验证手机不可重复
				if (StringUtils.isNotBlank(user.getUserMobileNo())) {
					CmsTerminalUser terminalUser = new CmsTerminalUser();
					terminalUser.setUserMobileNo(user.getUserMobileNo());
					if (terminalUserIsExists(terminalUser)) {
						return Constant.RESULT_STR_MOBILE_REPEAT;
					}
				}

				// 验证身份证号
				if (StringUtils.isNotBlank(user.getUserCardNo())) {
					CmsTerminalUser terminalUser = new CmsTerminalUser();
					terminalUser.setUserCardNo(user.getUserCardNo());
					if (terminalUserIsExists(terminalUser)) {
						return Constant.RESULT_STR_CARD_NO_REPEAT;
					}
				}

				if (StringUtils.isNotBlank(user.getUserBirthStr())) {
					SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
					user.setUserBirth(format.parse(user.getUserBirthStr()));
				}

				String userPwd = RandomUtils.getPassWord();
				user.setUserId(UUIDUtils.createUUId());
				user.setUserPwd(MD5Util.toMd5(userPwd));
				/* user.setUserPwd(MD5Util.toMd5(user.getUserPwd())); */
				user.setCreateTime(new Timestamp(System.currentTimeMillis()));
				user.setCommentStatus(1);
				if (!CommonUtil.isMobile(user.getUserMobileNo())) {
					return Constant.RESULT_STR_FAILURE;
				}
				insertTerminalUser(user);

				// 同步文化云用户至文化嘉定云
				final CmsTerminalUser finalCmsTerminalUser = user;
				Runnable runnable = new Runnable() {
					@Override
					public void run() {
						if (staticServer.isSyncServerState()) {
							finalCmsTerminalUser.setSourceCode(TerminalUserConstant.SOURCE_CODE_SHANGHAI);
							finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.INSERT_USER_INFO);
							syncCmsTerminalUserService.addTerminalUser(finalCmsTerminalUser);
						}
					}
				};
				Thread thread = new Thread(runnable);
				thread.start();

				sendPasswordToMobil(user, userPwd, user.getUserMobileNo());

				return Constant.RESULT_STR_SUCCESS;
			}
		} catch (Exception e) {
			logger.info("addTerminalUser error", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return Constant.RESULT_STR_FAILURE;
	}

	private void sendPasswordToMobil(final CmsTerminalUser user, final String userPwd, final String userMobileNo) {
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("userName", user.getUserName());
				map.put("userPassWord", userPwd);
				// String smsContent =
				// userMessageService.getSmsTemplate(Constant.ADD_TERMINAL_USER_MESSAGE,
				// map);
				// String smsContent = "您的文化云用户已注册成功，密码 123456789 请登录修改密码！";
				// sendSmsMessage(user.getUserMobileNo(), smsContent);
				SmsUtil.sendUserInfoCode(userMobileNo, map);
			}
		};
		Thread thread = new Thread(runnable);
		thread.start();
	}

	/**
	 * 验证用户名或手机号是否存在
	 * 
	 * @param terminalUser
	 * @return
	 */
	@Override
	public boolean terminalUserIsExists(CmsTerminalUser terminalUser) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(terminalUser.getUserName())) {
			map.put("userName", terminalUser.getUserName());
		}
		if (StringUtils.isNotBlank(terminalUser.getUserMobileNo())) {
			map.put("userMobileNo", terminalUser.getUserMobileNo());
		}
		if (StringUtils.isNotBlank(terminalUser.getUserCardNo())) {
			map.put("userCardNo", terminalUser.getUserCardNo());
		}
		return queryTerminalUserIsExists(map) > 0;
	}

	/**
	 * 根据id查询会员对象
	 * 
	 * @param userId
	 * @return 会员对象
	 */
	@Override
	public CmsTerminalUser queryTerminalUserById(String userId) {
		return userMapper.queryTerminalUserById(userId);
	}

	/**
	 * 根据id更新会员
	 * 
	 * @param user
	 * @return success:成功 failure:失败 repeat:重复 mobileRepeat:手机重复
	 */
	@Override
	public String editTerminalUserById(CmsTerminalUser user) {
		try {
			if (user != null) {
				CmsTerminalUser terminalUser = queryTerminalUserById(user.getUserId());
				if (terminalUser != null) {
					// 会员名称有更新，则验证重复
					/******************
					 * 2015.11.11 注释 by niu 添加用户不验证用户名
					 *************************/
					/*
					 * if (StringUtils.isNotBlank(user.getUserName())) { if
					 * (!user.getUserName().equals(terminalUser.getUserName()))
					 * { CmsTerminalUser cmsTerminalUser = new
					 * CmsTerminalUser();
					 * cmsTerminalUser.setUserName(user.getUserName());
					 * //验证会员名称是否存在 if (terminalUserIsExists(cmsTerminalUser)) {
					 * return Constant.RESULT_STR_REPEAT; } } }
					 */
					/*
					 * // 验证密码相同 if(!user.getUserPwd().equals(confirmPassword)){
					 * return Constant.RESULT_STR_DISPWD; }
					 */

					// 验证电话重复
					if (StringUtils.isNotBlank(user.getUserMobileNo())) {
						if (!user.getUserMobileNo().equals(terminalUser.getUserMobileNo())) {
							CmsTerminalUser cmsTerminalUser = new CmsTerminalUser();
							cmsTerminalUser.setUserMobileNo(user.getUserMobileNo());
							// 验证手机号码是否存在
							if (terminalUserIsExists(cmsTerminalUser)) {
								return Constant.RESULT_STR_MOBILE_REPEAT;
							}
						}
					}

					// 验证身份证号
					/*
					 * if (StringUtils.isNotBlank(user.getUserCardNo())) { if
					 * (!user.getUserCardNo().equals(terminalUser.getUserCardNo(
					 * ))) { CmsTerminalUser terminal = new CmsTerminalUser();
					 * terminal.setUserCardNo(user.getUserCardNo()); if
					 * (terminalUserIsExists(terminalUser)) { return
					 * Constant.RESULT_STR_CARD_NO_REPEAT; } } }
					 */

					// 验证身份证号
					if (StringUtils.isNotBlank(user.getUserCardNo())) {
						CmsTerminalUser cmsTerminalUser = new CmsTerminalUser();
						cmsTerminalUser.setUserCardNo(user.getUserCardNo());
						if (terminalUserIsExists(cmsTerminalUser)) {
							return Constant.RESULT_STR_CARD_NO_REPEAT;
						}
					}
					if (StringUtils.isNotBlank(user.getUserBirthStr())) {
						SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
						user.setUserBirth(format.parse(user.getUserBirthStr()));
					}
					updateTerminalUserById(user);

					// 同步文化云用户至文化嘉定云
					/*
					 * final CmsTerminalUser finalCmsTerminalUser = user;
					 * finalCmsTerminalUser.setSourceCode(terminalUser.
					 * getSourceCode());
					 * finalCmsTerminalUser.setSysId(terminalUser.getSysId());
					 * Runnable runnable = new Runnable() {
					 * 
					 * @Override public void run() {
					 * if(staticServer.isSyncServerState()){
					 * finalCmsTerminalUser.setFunctionCode(TerminalUserConstant
					 * .UPDATE_USER_INFO);
					 * syncCmsTerminalUserService.editTerminalUser(
					 * finalCmsTerminalUser); } } }; Thread thread=new
					 * Thread(runnable); thread.start();
					 */

					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.Forgive;
				}
			}
		} catch (Exception e) {
			logger.info("editTerminalUserById error", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return Constant.RESULT_STR_FAILURE;
	}

	/**
	 * 后端2.0 某个团体下的成员列表
	 * 
	 * @param applyJoinTeam
	 * @param userName
	 * @return 会员对象列表
	 */
	@Override
	public List<CmsTerminalUser> queryTeamTerminalUserByTuserId(CmsApplyJoinTeam applyJoinTeam, String userName,
			Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("applyCheckState", Constant.APPLY_ALREADY_PASS);
		if (StringUtils.isNotBlank(applyJoinTeam.getTuserId())) {
			map.put("tuserId", applyJoinTeam.getTuserId());
		}

		if (StringUtils.isNotBlank(userName)) {
			map.put("userName", "%" + userName + "%");
		}

		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());

			// 设置分页的总条数来获取总页数
			page.setTotal(userMapper.queryTeamTerminalUserCountByTuserId(map));
		}
		return userMapper.queryTeamTerminalUserByTuserId(map);
	}

	/**
	 * 后端2.0某个团体下成员查看
	 * 
	 * @param applyId
	 * @return
	 */
	public CmsTerminalUser queryTeamTerminalUserByApplyId(String applyId) {
		return userMapper.queryTeamTerminalUserByApplyId(applyId);
	}

	/**
	 * 更新会员
	 * 
	 * @param user
	 * @return
	 */
	@Override
	public int updateTerminalUserById(final CmsTerminalUser user) {
        return userMapper.editTerminalUserById(user);
	}

	/**
	 * 新增会员(前端)
	 * 
	 * @param user
	 * @return
	 */
	@Override
	public int insertTerminalUser(CmsTerminalUser user) {
		return userMapper.addTerminalUser(user);
	}

	/**
	 * 激活或冻结
	 * 
	 * @param userId
	 * @param userIsDisable
	 * @return
	 */
	@Override
	public boolean editTerminalUserDisableById(String userId, int userIsDisable) {
		if (StringUtils.isNotBlank(userId)) {
			CmsTerminalUser user = new CmsTerminalUser();
			user.setUserId(userId);
			user.setUserIsDisable(userIsDisable);
			return updateTerminalUserById(user) > 0;
		}
		return false;
	}

	/**
	 * 禁止评论
	 * 
	 * @param userId
	 * @return
	 */
	@Override
	public boolean disableTerminalUserComment(String userId, int commentStatus) {
		if (StringUtils.isNotBlank(userId)) {
			CmsTerminalUser user = new CmsTerminalUser();
			user.setUserId(userId);
			user.setCommentStatus(commentStatus);
			return updateTerminalUserById(user) > 0;
		}
		return false;
	}

	/**
	 * 前端2.0会员登陆
	 * 
	 * @param user
	 * @param session
	 * @return
	 */
	@Override
	public String terminalLogin(CmsTerminalUser user, HttpSession session) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userName", user.getUserName());
		map.put("userPwd", MD5Util.toMd5(user.getUserPwd()));
		CmsTerminalUser terminalUser = userMapper.webLogin(map);
		if (terminalUser != null) {
			// 判断会员是否激活，未激活状态下不可登录并提示
			if (Constant.USER_NOT_ACTIVATE.equals(terminalUser.getUserIsDisable())) {
				return Constant.RESULT_STR_NOACTIVE;
			} else if (Constant.USER_IS_FREEZE.equals(terminalUser.getUserIsDisable())) {
				return Constant.RESULT_STR_FREEZE;
			}
			session.setAttribute("terminalUser", terminalUser);
			// 更新登录状态
			final CmsTerminalUser terminal = new CmsTerminalUser();
			terminal.setUserIsLogin(Constant.LOGIN_SUCCESS);
			terminal.setUserId(terminalUser.getUserId());
			terminal.setLastLoginTime(new Date());
			if (user.getLoginType() != null && user.getLoginType() == 1) {
				terminal.setLoginType(1);
			}
			Runnable r = new Runnable() {
				@Override
				public void run() {
					userMapper.editTerminalUserById(terminal);
				}
			};
			new Thread(r).start();
			return Constant.RESULT_STR_SUCCESS;
		}
		return Constant.RESULT_STR_FAILURE;
	}

	/***
	 * 优化登录 只查询需要用的字段
	 * 
	 * @param user
	 * @param session
	 * @return
	 */
	@Override
	public String webLogin(CmsTerminalUser user, HttpSession session) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userName", user.getUserName());
		map.put("userPwd", MD5Util.toMd5(user.getUserPwd()));
		// 只查询一次
		CmsTerminalUser terminalUser = userMapper.webLogin(map);
		if (terminalUser != null) {
			// 判断会员是否激活，未激活状态下不可登录并提示
			if (Constant.USER_NOT_ACTIVATE.equals(terminalUser.getUserIsDisable())) {
				return Constant.RESULT_STR_NOACTIVE;
			} else if (Constant.USER_IS_FREEZE.equals(terminalUser.getUserIsDisable())) {
				return Constant.RESULT_STR_FREEZE;
			}

			// 获取用户标签
			try {
				// 添加用户选择类型
				List<CmsUserTag> userTagList = cmsUserTagMapper.queryActivityUserTagListById(terminalUser.getUserId());
				if (CollectionUtils.isNotEmpty(userTagList)) {
					String activityThemeTagId = "";
					for (CmsUserTag cmsUserTag : userTagList) {
						activityThemeTagId += cmsUserTag.getUserSelectTag() + ",";
					}
					if (activityThemeTagId.length() > 0) {
						terminalUser.setActivityThemeTagId(
								activityThemeTagId.substring(0, activityThemeTagId.length() - 1));
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			user.setUserId(terminalUser.getUserId()); // 方便回参调用userId
			session.setAttribute(Constant.terminalUser, terminalUser);

			// 更新登录状态
			final CmsTerminalUser terminal = new CmsTerminalUser();
			terminal.setUserIsLogin(Constant.LOGIN_SUCCESS);
			terminal.setUserId(terminalUser.getUserId());
			terminal.setLastLoginTime(new Date());
			if (terminalUser.getLoginType() != null && terminalUser.getLoginType() == 1) {
				terminal.setLoginType(1);
			}
			Runnable command = new Runnable() {
				@Override
				public void run() {
					userMapper.editTerminalUserById(terminal);
				}
			};
			new Thread(command).start();
			return Constant.RESULT_STR_SUCCESS;
		}
		return Constant.RESULT_STR_FAILURE;

	}

	/**
	 * 前端2.0我管理的团体-消息审核
	 * 
	 * @param team
	 * @param page
	 * @param pageApp
	 * @return
	 */
	@Override
	public List<CmsTerminalUser> queryCheckTerminalUser(CmsApplyJoinTeam team, Pagination page, PaginationApp pageApp) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (team.getApplyIsState() != null) {
			map.put("applyIsState", team.getApplyIsState());
		}
		if (StringUtils.isNotBlank(team.getUserId())) {
			map.put("userId", team.getUserId());
		}
		if (StringUtils.isNotBlank(team.getTuserId())) {
			map.put("tuserId", team.getTuserId());
		}
		// 网页分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());

			int total = userMapper.queryCheckTerminalUserCount(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		// app分页
		if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
			map.put("firstResult", pageApp.getFirstResult());
			map.put("rows", pageApp.getRows());
		}
		return userMapper.queryCheckTerminalUser(map);
	}

	/**
	 * 前端2.0我管理的团体-消息审核个数
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public int queryCheckTerminalUserCount(Map<String, Object> map) {
		return userMapper.queryCheckTerminalUserCount(map);
	}

	/**
	 * 后端2.0根据省市区查询管理员用户
	 * 
	 * @param terminalUser
	 * @return 会员对象集合
	 */
	@Override
	public List<CmsTerminalUser> queryTerminalUserByArea(CmsTerminalUser terminalUser) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(terminalUser.getUserProvince())) {
			map.put("userProvince", "%" + terminalUser.getUserProvince() + "%");
		}
		if (StringUtils.isNotBlank(terminalUser.getUserCity())) {
			map.put("userCity", "%" + terminalUser.getUserCity() + "%");
		}
		if (StringUtils.isNotBlank(terminalUser.getUserArea())) {
			map.put("userArea", "%" + terminalUser.getUserArea() + "%");
		}
		return userMapper.queryTerminalUserByArea(map);
	}

	/**
	 * 前端2.0 团体详情 管理人
	 * 
	 * @param tuserId
	 * @return
	 */
	@Override
	public String queryUserNickNameByTuserId(String tuserId) {
		return userMapper.queryUserNickNameByTuserId(tuserId);
	}

	@Override
	public List<CmsTerminalUser> getCmsTerminalUserList(Map<String, Object> params) {

		return userMapper.getCmsTerminalUserList(params);
	}

	@Override
	public CmsTerminalUser getCmsTerminalUserByMobile(String userMobileNo) {
		return userMapper.getCmsTerminalUserByMobile(userMobileNo);
	}

	/**
	 * 发送注册码后 先插入数据库 验证通过后更新数据库 2015.07.06
	 * 
	 * @param userMobileNo(手机号码)
	 * @return
	 */

	@Override
	public Map<String, Object> sendSmsCode(final String userMobileNo, String userName, String userPwd, Integer userSex)
			throws ParseException {
		Map<String, Object> result = new HashMap<String, Object>();
		if (!CommonUtil.isMobile(userMobileNo)) {
			result.put("result", Constant.RESULT_STR_FAILURE);
			return result;
		}
		// 查讯手机是否已经注册
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userMobileNo", userMobileNo);
		/************ 2015.11.17 查询所有状态的用户 保证手机号码唯一 ***************/
		List<CmsTerminalUser> extList = this.getCmsTerminalUserList(param);
		if (!CollectionUtils.isEmpty(extList)
				&& !Constant.USER_NOT_ACTIVATE.equals(extList.get(0).getUserIsDisable())) {
			result.put("result", Constant.RESULT_STR_REPEAT);
			return result;
		}
		Date date = new Date();
		final String registerCode = SmsUtil.getValidateCode();
		Runnable command = new Runnable() {
			@Override
			public void run() {
				Map<String, Object> smsParams = new HashMap<>();
				smsParams.put("code", registerCode);
				smsParams.put("product", Constant.PRODUCT);
				SmsUtil.sendRegisterCode(userMobileNo, smsParams);
			}
		};
		if (!CollectionUtils.isEmpty(extList)) { // 已经发送过(未激活的号码已经存在)
			CmsTerminalUser tuser = extList.get(0);
			if (null == tuser.getLastSendSmsTime()) {
				tuser.setLastSendSmsTime(new Date());
			}
			if (DateUtils.isToday(tuser.getLastSendSmsTime())) {
				// 当天发送过
				int registerCount = tuser.getRegisterCount() == null ? 0 : tuser.getRegisterCount();
				if (registerCount >= 3) { // 最多可每天发送3次，否则可继续发送
					result.put("result", "third");
					return result;
				}
				tuser.setRegisterCount(registerCount + 1);
				tuser.setRegisterCode(registerCode);
				tuser.setLastSendSmsTime(date);
				this.updateTerminalUserById(tuser);
				result.put("result", Constant.RESULT_STR_SUCCESS);
				result.put("userId", tuser.getUserId());
				new Thread(command).start();
				return result;
			} else {
				tuser.setRegisterCount(1);
				tuser.setRegisterCode(registerCode);
				tuser.setLastSendSmsTime(date);
				this.updateTerminalUserById(tuser);
				result.put("userId", tuser.getUserId());
				result.put("result", Constant.RESULT_STR_SUCCESS);
				new Thread(command).start();
				return result;
			}
		}
		// 该号码不存在，可以发送
		// 发送成功返回 新增用户
		CmsTerminalUser user = new CmsTerminalUser();
		user.setUserName(userName);
		user.setUserPwd(MD5Util.toMd5(userPwd));
		user.setUserSex(userSex);
		user.setUserType(1);

		user.setCreateTime(date);
		user.setLastSendSmsTime(date);
		String uuIdStr = UUIDUtils.createUUId();
		user.setUserId(uuIdStr);
		user.setUserIsDisable(Constant.USER_NOT_ACTIVATE);
		user.setRegisterCode(registerCode);
		user.setRegisterCount(1);
		user.setUserMobileNo(userMobileNo);
		user.setCommentStatus(1);
		if (this.insertTerminalUser(user) > 0) {
			result.put("userId", uuIdStr);
			result.put("result", Constant.RESULT_STR_SUCCESS);
			new Thread(command).start();
			return result;
		}
		result.put("result", Constant.RESULT_STR_FAILURE);
		return result;
	}

	@Override
	public Map<String, Object> sendSmsCode(String userMobileNo) throws ParseException {
		Date date = new Date();
		Map<String, Object> result = new HashMap<String, Object>();
		String registerCode = RandomStringUtils.random(6, false, true);
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
		Calendar cal = Calendar.getInstance();
		Date start = format.parse(format.format(cal.getTime()));
		cal.add(Calendar.DATE, 1);
		Date end = format.parse(format.format(cal.getTime()));
		// 查讯手机是否已经注册
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userMobileNo", userMobileNo);
		param.put("userIsDisable", Constant.USER_IS_ACTIVATE);
		List<CmsTerminalUser> list = this.getCmsTerminalUserList(param);
		if (!CollectionUtils.isEmpty(list)) {
			result.put("result", Constant.RESULT_STR_REPEAT);
			return result;
			// return Constant.RESULT_STR_REPEAT;
		}
		String smsContent = "文化云注册激活码 " + registerCode + " 30分钟内有效,请及时输入。如非本人操作，请忽略。";
		// 验证当天超过3次
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userMobileNo", userMobileNo);
		params.put("userIsDisable", Constant.USER_NOT_ACTIVATE);
		List<CmsTerminalUser> tusers = this.getCmsTerminalUserList(params);
		if (tusers != null && tusers.size() > 0) { // 已经发送过(未激活的号码已经存在)
			CmsTerminalUser tuser = tusers.get(0);
			if (tuser.getCreateTime().getTime() >= start.getTime() && tuser.getCreateTime().getTime() < end.getTime()) { // 当天发送过
				/*
				 * int registerCount = tuser.getRegisterCount() == null ? 0 :
				 * tuser.getRegisterCount(); if (registerCount >= 3) { //
				 * 最多可每天发送3次，否则可继续发送 result.put("result","third"); return
				 * result; }
				 */
				// 发短信
				if (!"100".equals(sendSmsMessage(userMobileNo, smsContent))) { // 发送未成功返回，否则更新
					result.put("result", Constant.SmsCodeErr);
					return result;
				}
				// tuser.setRegisterCount(registerCount + 1);
				tuser.setUserMobileNo(userMobileNo);
				tuser.setRegisterCode(registerCode);
				tuser.setCreateTime(date);
				this.updateTerminalUserById(tuser);
				result.put("result", Constant.RESULT_STR_SUCCESS);
				result.put("userId", tuser.getUserId());
				result.put("code", registerCode);
				return result;
			} else {
				// 发短信
				// 隔天发送
				if (!"100".equals(sendSmsMessage(userMobileNo, smsContent))) { // 发送未成功返回，否则更新
					result.put("result", Constant.SmsCodeErr);
					return result;
				}

				// this.updateTerminalUser(tuser, 1, registerCode, date,
				// userMobileNo);
				// result.put("message", "success");
				// result.put("userId", tuser.getUserId());
				// return result;
				tuser.setRegisterCount(1);
				tuser.setRegisterCode(registerCode);
				tuser.setCreateTime(date);
				this.updateTerminalUserById(tuser);
				result.put("userId", tuser.getUserId());
				result.put("result", Constant.RESULT_STR_SUCCESS);
				result.put("code", registerCode);
				return result;
			}
		}

		// 该号码不存在，可以发送
		if (!"100".equals(sendSmsMessage(userMobileNo, smsContent))) {
			result.put("result", Constant.SmsCodeErr);
			return result;
		}
		// 发送未成功返回，否则更新
		CmsTerminalUser user = new CmsTerminalUser();

		/**
		 * 初始注册设置用户名密码
		 */
		user.setUserType(1);
		String uuIdStr = UUIDUtils.createUUId();
		user.setUserId(uuIdStr);
		user.setCreateTime(date);
		user.setUserIsDisable(Constant.USER_NOT_ACTIVATE);
		user.setUserIsLogin(Constant.LOGIN_ERROR);
		user.setRegisterCode(registerCode);
		user.setRegisterCount(1);
		user.setUserMobileNo(userMobileNo);
		user.setUserIsDisable(0);
		if (this.insertTerminalUser(user) > 0) {
			result.put("userId", uuIdStr);
			result.put("code", registerCode);
			result.put("result", Constant.RESULT_STR_SUCCESS);
			return result;
		}
		result.put("result", Constant.RESULT_STR_FAILURE);
		return result;
	}

	/**
	 * 验证验证码 如果通过验证 则更新数据库 激活用户
	 * 
	 * @param user
	 *            用户信息
	 * @param code
	 *            短信码
	 * @return
	 */
	@Override
	public String saveUser(CmsTerminalUser user, String code, HttpSession session) {
		CmsTerminalUser tuser = this.queryTerminalUserById(user.getUserId());
		if (tuser != null) {
			// 短信码验证失败
			if (!code.equals(tuser.getRegisterCode())) {
				return Constant.SmsCodeErr;
			}
			if (!user.getUserMobileNo().equals(tuser.getUserMobileNo())) {
				return Constant.RESULT_STR_FAILURE;
			}
			tuser.setUserName(user.getUserName());
			tuser.setUserPwd(user.getUserPwd());
			user.setUserPwd(MD5Util.toMd5(user.getUserPwd()));
			user.setCreateTime(new Date());
			user.setUserIsDisable(Constant.USER_IS_ACTIVATE);
			user.setUserId(tuser.getUserId());
			user.setUserType(1);
		}
		// app修改用户信息
		/*
		 * else{ CmsTerminalUser terminalUser =
		 * this.queryTerminalUserByCode(code,user.getUserMobileNo());
		 * user.setUserPwd(MD5Util.toMd5(user.getUserPwd()));
		 * user.setCreateTime(new Date());
		 * user.setUserIsDisable(Constant.USER_IS_ACTIVATE);
		 * user.setUserId(terminalUser.getUserId()); user.setUserType(1); }
		 */
		// 更新user;
		int rows = this.updateTerminalUserById(user);

		/**
		 * 更新成功放入会话
		 */
		session.setAttribute(Constant.terminalUser, tuser);
		return Constant.RESULT_STR_SUCCESS;
	}

	@Override
	public String saveRegUser(CmsTerminalUser user, String code, HttpSession session) {
		if (user == null || StringUtils.isBlank(user.getUserId())) {
			return "NoValMobile";
		}
		CmsTerminalUser tuser = this.queryTerminalUserById(user.getUserId());
		// 相差分钟数
		/*
		 * long diff =(new
		 * Date().getTime()-tuser.getCreateTime().getTime())/60000; if(diff>30){
		 * return "timeOut"; }
		 */
		if (tuser != null) {
			// 短信码验证失败
			if (!code.equals(tuser.getRegisterCode())) {
				return Constant.SmsCodeErr;
			}
			if (!user.getUserMobileNo().equals(tuser.getUserMobileNo())) {
				return Constant.RESULT_STR_FAILURE;
			}
			/****************
			 * 2015 11.18 add niu 以最后提交的userName passWord为准
			 ******************/
			tuser.setUserName(user.getUserName());
			tuser.setUserPwd(MD5Util.toMd5(user.getUserPwd()));

			tuser.setUserBirth(user.getUserBirth());
			tuser.setUserSex(user.getUserSex());
			tuser.setCreateTime(new Date());
			tuser.setUserIsDisable(Constant.USER_IS_ACTIVATE);
			tuser.setLastLoginTime(new Date());
		} else {
			return "NoUser";
		}
		// 更新user;
		this.updateTerminalUserById(tuser);

		// 注册加积分
		userIntegralDetailService.registerAddIntegral(tuser.getUserId());

		// 同步文化云用户至文化嘉定云
		final CmsTerminalUser finalCmsTerminalUser = tuser;
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				if (staticServer.isSyncServerState()) {
					finalCmsTerminalUser.setSourceCode(TerminalUserConstant.SOURCE_CODE_SHANGHAI);
					finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.INSERT_USER_INFO);
					syncCmsTerminalUserService.addTerminalUser(finalCmsTerminalUser);
				}
			}
		};
		Thread thread = new Thread(runnable);
		thread.start();

		session.setAttribute(Constant.terminalUser, tuser);
		return Constant.RESULT_STR_SUCCESS;
	}

	/**
	 * app根据code查询用户对象
	 *
	 * @param
	 * @param code
	 * @return
	 */
	private CmsTerminalUser queryTerminalUserByCode(String code, String mobileNum) {
		return userMapper.queryTerminalUserByCode(code, mobileNum);
	}

	// 更新手机时发送验证 更改绑定手机

	/*
	 * Map<String, Object> params = new HashMap<String, Object>();
	 * params.put("userMobileNo", userMobileNo); params.put("userIsDisable",
	 * Constant.USER_NOT_ACTIVATE); List<CmsTerminalUser> tusers =
	 * this.getCmsTerminalUserList(params); if (tusers!=null&&tusers.size()>0) {
	 * // 已经发送过(未激活的号码已经存在) CmsTerminalUser tuser = tusers.get(0); if
	 * (tuser.getCreateTime().getTime() >= start.getTime() &&
	 * tuser.getCreateTime().getTime() < end.getTime()) { // 当天发送过 int
	 * registerCount = tuser.getRegisterCount() == null ? 0 :
	 * tuser.getRegisterCount();
	 * 
	 * if (registerCount >= 3) { // 最多可每天发送3次，否则可继续发送
	 * result.put("result","third"); return result; }
	 * 
	 * if (!"100".equals(sendSmsMessage(userMobileNo,smsContent))) { //
	 * 发送未成功返回，否则更新 result.put("result", Constant.SmsCodeErr); return result; }
	 * 
	 * tuser.setRegisterCount(registerCount + 1);
	 * //tuser.setUserMobileNo(userMobileNo);
	 * tuser.setRegisterCode(registerCode); tuser.setCreateTime(date);
	 * this.updateTerminalUserById(tuser);
	 * result.put("result",Constant.RESULT_STR_SUCCESS);
	 * result.put("userId",tuser.getUserId()); result.put("code",registerCode);
	 * return result; } else { //发短信 // 隔天发送
	 * if(!"100".equals(sendSmsMessage(userMobileNo,smsContent))){ //
	 * 发送未成功返回，否则更新 result.put("result", Constant.SmsCodeErr); return result; }
	 * 
	 * //this.updateTerminalUser(tuser, 1, registerCode, date, userMobileNo);
	 * //result.put("message", "success"); //result.put("userId",
	 * tuser.getUserId()); //return result; tuser.setRegisterCount(1);
	 * tuser.setRegisterCode(registerCode); tuser.setCreateTime(date);
	 * this.updateTerminalUserById(tuser);
	 * result.put("userId",tuser.getUserId()); result.put("result",
	 * Constant.RESULT_STR_SUCCESS); result.put("code",registerCode); return
	 * result; } }
	 */

	@Override
	public String modifyInfoSendCode(String userId, final String userMobileNo) throws ParseException {
		if (!CommonUtil.isMobile(userMobileNo)) {
			return Constant.RESULT_STR_FAILURE;
		}
		/**
		 * 验证手机号合法性
		 */
		CmsTerminalUser user = this.queryTerminalUserById(userId);
		// 该用户不存在
		if (user == null) {
			return Constant.RESULT_STR_FAILURE;
		}

		if (null != user.getOperId()) {
			if (userMobileNo.equals(user.getUserTelephone())) {
				return "NoChange";
			} /*
				 * else{ //验证更新的手机号是否已经注册 CmsTerminalUser valUser = new
				 * CmsTerminalUser(); valUser.setUserMobileNo(userMobileNo);
				 * if(this.terminalUserIsExists(valUser)){ return
				 * Constant.RESULT_STR_MOBILE_REPEAT; } }
				 */
		} else {
			if (userMobileNo.equals(user.getUserMobileNo())) {
				return "NoChange";
			} else {
				// 验证更新的手机号是否已经注册
				CmsTerminalUser valUser = new CmsTerminalUser();
				valUser.setUserMobileNo(userMobileNo);
				if (this.terminalUserIsExists(valUser)) {
					return Constant.RESULT_STR_MOBILE_REPEAT;
				}
			}
		}

		Date date = new Date();
		final String registerCode = SmsUtil.getValidateCode();
		if (user.getLastSendSmsTime() == null) {
			user.setLastSendSmsTime(date);
		}
		Runnable command = new Runnable() {
			@Override
			public void run() {
				Map<String, Object> smsParams = new HashMap<>();
				smsParams.put("code", registerCode);
				smsParams.put("product", Constant.PRODUCT);
				SmsUtil.sendUpdateCode(userMobileNo, smsParams);
			}
		};
		// 最后发送短信的时候是否是今天
		if (DateUtils.isToday(user.getLastSendSmsTime())) {
			int registerCount = user.getRegisterCount() == null ? 0 : user.getRegisterCount();
			if (registerCount >= 3) { // 最多可每天发送3次，否则可继续发送
				return "third";
			}
			user.setRegisterCount(registerCount + 1);
			user.setRegisterCode(registerCode);
			user.setLastSendSmsTime(date);
			this.updateTerminalUserById(user);
			new Thread(command).start();
			return Constant.RESULT_STR_SUCCESS;
		} else {
			// 隔天重新设置发送次数
			user.setRegisterCount(1);
			user.setRegisterCode(registerCode);
			user.setLastSendSmsTime(date);
			this.updateTerminalUserById(user);
			new Thread(command).start();
			return Constant.RESULT_STR_SUCCESS;
		}

	}

	@Override
	public CmsTerminalUser queryByOpenId(Map<String, Object> params) {
		if (params == null || params.size() == 0) {
			return null;
		}
		return userMapper.queryByOpenId(params);
	}

	@Override
	public CmsTerminalUser queryByWebOpenId(Map<String, Object> params) {
		return userMapper.queryByWebOpenId(params);
	}

	/**
	 * 发短信(通用)
	 * 
	 * @param userMobileNo
	 * @param smsContent
	 * @return
	 */
	@Override
	public String sendSmsMessage(String userMobileNo, String smsContent) {
		/**
		 * 发短信验证手机号码是否合法
		 */
		if (!CommonUtil.isMobile(userMobileNo)) {
			return "0000";
		}
		String code = "";
		try {
			SmsSend send = new SmsSend();
			// code =
			// send.sendSmsMessage(smsConfig.getSmsUrl(),smsConfig.getuId(),smsConfig.getPwd(),userMobileNo,smsContent);
			return code;
		} catch (Exception e) {
			logger.info("sendSms error", e);
		}
		return code;
	}

	public void sendSmsMessage(String userMobileNo, String smsContent, SmsConfig config) {
		/**
		 * 发短信验证手机号码是否合法
		 */
		if (!CommonUtil.isMobile(userMobileNo)) {
			return;
		}

		try {
			// new SmsSend().sendSmsMessage(config.getSmsUrl(), config.getuId(),
			// config.getPwd(), userMobileNo, smsContent);
		} catch (Exception e) {
			logger.info("sendSms error", e);
		}
	}

	// 2016.1.18
	@Override
	public Map<String, Object> completeInfoSendCode(String userId, final String userMobileNo) throws ParseException {
		Map<String, Object> result = new HashMap<String, Object>();
		if (!CommonUtil.isMobile(userMobileNo)) {
			result.put("result", Constant.RESULT_STR_FAILURE);
			return result;
		}
		Date date = new Date();
		String registerCode = RandomStringUtils.random(6, false, true);
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
		Calendar cal = Calendar.getInstance();
		Date start = format.parse(format.format(cal.getTime()));
		cal.add(Calendar.DATE, 1);
		Date end = format.parse(format.format(cal.getTime()));
		// 查讯手机是否已经注册
		/*
		 * Map<String, Object> param = new HashMap<String, Object>();
		 * param.put("userMobileNo", userMobileNo); List<CmsTerminalUser> list =
		 * this.getCmsTerminalUserList(param); if
		 * (!CollectionUtils.isEmpty(list)) {
		 * result.put("result",Constant.RESULT_STR_REPEAT); return result; }
		 */

		final String smsContent = "文化云完善信息动态验证码 " + registerCode + " 请及时输入。如非本人操作，请忽略。";

		CmsTerminalUser extUser = this.queryTerminalUserById(userId);

		if (extUser == null) {
			return null;
		}

		if (extUser.getLastSendSmsTime() == null) {
			extUser.setLastSendSmsTime(date);
		}
		final SmsConfig config = smsConfig;
		Runnable command = new Runnable() {
			@Override
			public void run() {
				sendSmsMessage(userMobileNo, smsContent, config);
			}
		};

		CmsTerminalUser updateUser = new CmsTerminalUser();
		updateUser.setUserId(extUser.getUserId());

		// 当天发送过
		if (extUser.getLastSendSmsTime().getTime() >= start.getTime()
				&& extUser.getLastSendSmsTime().getTime() < end.getTime()) {
			int registerCount = extUser.getRegisterCount() == null ? 0 : extUser.getRegisterCount();
			if (registerCount >= 3) { // 最多可每天发送3次，否则可继续发送
				result.put("result", "third");
				return result;
			}
			// 发短信
			/*
			 * if (!"100".equals(sendSmsMessage(userMobileNo,smsContent))) { //
			 * 发送未成功返回，否则更新 result.put("result", Constant.SmsCodeErr); return
			 * result; }
			 */
			updateUser.setRegisterCount(registerCount + 1);
			updateUser.setRegisterCode(registerCode);
			updateUser.setLastSendSmsTime(date);
			this.updateTerminalUserById(updateUser);
			result.put("result", Constant.RESULT_STR_SUCCESS);
			result.put("userId", extUser.getUserId());
			new Thread(command).start();
			return result;
		} else {
			// 隔天发送
			/*
			 * if(!"100".equals(sendSmsMessage(userMobileNo,smsContent))){ //
			 * 发送未成功返回，否则更新 result.put("result", Constant.SmsCodeErr); return
			 * result; }
			 */
			updateUser.setRegisterCount(1);
			updateUser.setRegisterCode(registerCode);
			updateUser.setLastSendSmsTime(date);
			this.updateTerminalUserById(updateUser);
			result.put("userId", extUser.getUserId());
			result.put("result", Constant.RESULT_STR_SUCCESS);
			new Thread(command).start();
			return result;
		}

	}

	@Override
	public Map<String, Object> completeInfoSendCode2(String userId, final String userMobileNo) throws ParseException {
		Map<String, Object> result = new HashMap<String, Object>();
		if (!CommonUtil.isMobile(userMobileNo)) {
			result.put("result", Constant.RESULT_STR_FAILURE);
			return result;
		}
		Date date = new Date();
		final String registerCode = SmsUtil.getValidateCode();

		CmsTerminalUser extUser = this.queryTerminalUserById(userId);

		if (extUser == null) {
			return null;
		}
		if (extUser.getLastSendSmsTime() == null) {
			extUser.setLastSendSmsTime(date);
		}
		Runnable command = new Runnable() {
			@Override
			public void run() {
				Map<String, Object> smsParams = new HashMap<>();
				smsParams.put("code", registerCode);
				smsParams.put("product", Constant.PRODUCT);
				SmsUtil.sendForgetCode(userMobileNo, smsParams);
			}
		};

		CmsTerminalUser updateUser = new CmsTerminalUser();
		updateUser.setUserId(extUser.getUserId());

		if (extUser.getLastSendSmsTime() == null) {
			extUser.setLastSendSmsTime(date);
		}

		// 当天发送过
		if (DateUtils.isToday(extUser.getLastSendSmsTime())) {
			int registerCount = extUser.getRegisterCount() == null ? 0 : extUser.getRegisterCount();
			if (registerCount >= 3) { // 最多可每天发送3次，否则可继续发送
				result.put("result", "third");
				return result;
			}
			updateUser.setRegisterCount(registerCount + 1);
			updateUser.setRegisterCode(registerCode);
			updateUser.setLastSendSmsTime(date);
			this.updateTerminalUserById(updateUser);
			result.put("result", Constant.RESULT_STR_SUCCESS);
			result.put("userId", extUser.getUserId());
			new Thread(command).start();
			return result;
		} else {
			// 隔天发送
			/*
			 * if(!"100".equals(sendSmsMessage(userMobileNo,smsContent))){ //
			 * 发送未成功返回，否则更新 result.put("result", Constant.SmsCodeErr); return
			 * result; }
			 */
			updateUser.setRegisterCount(1);
			updateUser.setRegisterCode(registerCode);
			updateUser.setLastSendSmsTime(date);
			this.updateTerminalUserById(updateUser);
			result.put("userId", extUser.getUserId());
			result.put("result", Constant.RESULT_STR_SUCCESS);
			new Thread(command).start();
			return result;
		}

	}

	/**
	 * app根据手机号码查询数据
	 * 
	 * @param userMobile
	 * @return
	 */
	@Override
	public CmsTerminalUser terminalUserMobileExists(String userMobile) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(userMobile)) {
			map.put("userMobile", userMobile);
		}
		return userMapper.terminalUserMobileExists(map);
	}

	@Override
	public CmsTerminalUser queryFrontTerminalUser(Map<String, Object> map) {
		return userMapper.queryFrontTerminalUser(map);
	}
	/*
	 * @Override public int editAppTerminalUserById(CmsTerminalUser
	 * terminalUser) { if(terminalUser!=null &&
	 * StringUtils.isNotBlank(terminalUser.getUserHeadImgUrl())){
	 * terminalUser.setUserHeadImgUrl(terminalUser.getUserHeadImgUrl()); }
	 * return userMapper.editAppTerminalUserById(terminalUser); }
	 */

	/**
	 * app
	 * 
	 * @param user
	 *            用户对象
	 * @return
	 */
	@Override
	public CmsTerminalUser queryAppTerminalUserByCondition(CmsTerminalUser user) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (user != null && StringUtils.isNotBlank(user.getUserName())) {
			map.put("userName", user.getUserName());
		}
		if (user != null && StringUtils.isNotBlank(user.getUserPwd())) {
			map.put("userPwd", MD5Util.toMd5(user.getUserPwd()));
		}
		return userMapper.queryAppTerminalUserByCondition(map);
	}

	@Override
	public Map<String, Object> sendForgetSmsCode(String userMobileNo) throws ParseException {
		Map<String, Object> result = new HashMap<String, Object>();

		if (!CommonUtil.isMobile(userMobileNo)) {
			result.put("result", Constant.RESULT_STR_FAILURE);
			return result;
		}

		Date date = new Date();
		String registerCode = RandomStringUtils.random(6, false, true);
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
		Calendar cal = Calendar.getInstance();
		Date start = format.parse(format.format(cal.getTime()));
		cal.add(Calendar.DATE, 1);
		Date end = format.parse(format.format(cal.getTime()));

		// 查讯手机是否已经注册
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userMobileNo", userMobileNo);
		param.put("userIsDisable", Constant.USER_IS_ACTIVATE);
		List<CmsTerminalUser> userList = this.getCmsTerminalUserList(param);
		/**
		 * 未找到用户
		 */
		if (CollectionUtils.isEmpty(userList)) {
			result.put("result", "NotFound");
			return result;
		}

		String smsContent = "文化云注册找回密码验证码 " + registerCode + " 请及时输入。如非本人操作，请忽略。";

		CmsTerminalUser tuser = userList.get(0);
		if (tuser.getCreateTime().getTime() >= start.getTime() && tuser.getCreateTime().getTime() < end.getTime()) { // 当天发送过
			int registerCount = tuser.getRegisterCount() == null ? 0 : tuser.getRegisterCount();

			if (registerCount >= 3) { // 最多可每天发送3次，否则可继续发送
				result.put("result", "third");
				return result;
			}

			if (!"100".equals(sendSmsMessage(userMobileNo, smsContent))) { // 发送未成功返回，否则更新
				result.put("result", Constant.SmsCodeErr);
				return result;
			}

			tuser.setRegisterCount(registerCount + 1);
			tuser.setRegisterCode(registerCode);
			tuser.setCreateTime(date);
			this.updateTerminalUserById(tuser);
			result.put("result", Constant.RESULT_STR_SUCCESS);
			result.put("userId", tuser.getUserId());
			result.put("code", registerCode);
			return result;
		} else {
			// 发短信 隔天发送
			if (!"100".equals(sendSmsMessage(userMobileNo, smsContent))) { // 发送未成功返回，否则更新
				result.put("result", Constant.SmsCodeErr);
				return result;
			}
			tuser.setRegisterCount(1);
			tuser.setRegisterCode(registerCode);
			tuser.setCreateTime(date);
			this.updateTerminalUserById(tuser);
			result.put("userId", tuser.getUserId());
			result.put("result", Constant.RESULT_STR_SUCCESS);
			result.put("code", registerCode);
			return result;
		}

	}

	/**
	 * web端找回密码不与app共用 重载方法 不将code返回客户端 2015.11.3 add by niu
	 * 
	 * @param userMobileNo
	 * @param from
	 * @return
	 * @throws ParseException
	 */
	@Override
	public Map<String, Object> sendForgetSmsCode(final String userMobileNo, String from, HttpSession session)
			throws ParseException {
		Map<String, Object> result = new HashMap<String, Object>();
		if (!CommonUtil.isMobile(userMobileNo)) {
			result.put("result", Constant.RESULT_STR_FAILURE);
			return result;
		}
		CmsTerminalUser tuser = userMapper.queryUserByMobile(userMobileNo);
		if (tuser == null) {
			result.put("result", "NotFound");
			return result;
		}
		if (!Constant.USER_IS_ACTIVATE.equals(tuser.getUserIsDisable())) {
			if (Constant.USER_IS_FREEZE.equals(tuser.getUserIsDisable())) {
				result.put("result", "Freeze");
				return result;
			} else {
				result.put("result", "NotReg");
				return result;
			}
		}
		Date date = new Date();
		final String registerCode = SmsUtil.getValidateCode();
		Runnable command = new Runnable() {
			@Override
			public void run() {
				Map<String, Object> smsParams = new HashMap<>();
				smsParams.put("code", registerCode);
				smsParams.put("product", Constant.PRODUCT);
				SmsUtil.sendForgetCode(userMobileNo, smsParams);
			}
		};
		if (tuser.getLastSendSmsTime() == null) {
			tuser.setLastSendSmsTime(date);
		}
		String sessionUserCode = UUIDUtils.createUUId();
		if (DateUtils.isToday(tuser.getLastSendSmsTime())) { // 当天发送过
			int registerCount = tuser.getRegisterCount() == null ? 0 : tuser.getRegisterCount();
			if (registerCount >= 3) { // 最多可每天发送3次，否则可继续发送
				result.put("result", "third");
				return result;
			}
			tuser.setRegisterCount(registerCount + 1);
			tuser.setRegisterCode(registerCode);
			tuser.setLastSendSmsTime(date);
			this.updateTerminalUserById(tuser);
			result.put("resCode", sessionUserCode);
			result.put("result", Constant.RESULT_STR_SUCCESS);
			session.setAttribute(Constant.SESSION_USER_ID, tuser.getUserId());
			session.setAttribute(Constant.SESSION_USER_CODE, sessionUserCode);
			new Thread(command).start();
			return result;
		} else {
			tuser.setRegisterCount(1);
			tuser.setRegisterCode(registerCode);
			tuser.setLastSendSmsTime(date);
			this.updateTerminalUserById(tuser);
			result.put("resCode", sessionUserCode);
			result.put("result", Constant.RESULT_STR_SUCCESS);
			session.setAttribute(Constant.SESSION_USER_ID, tuser.getUserId());
			session.setAttribute(Constant.SESSION_USER_CODE, sessionUserCode);
			new Thread(command).start();
			return result;
		}
	}

	@Override
	public int queryByIp(Map<String, Object> params) {
		return userMapper.queryByIp(params);
	}

	@Override
	public String testAddTerminalUser(CmsTerminalUser user) {
		try {
			if (user != null) {
				// 验证会员名称是否存在
				if (StringUtils.isNotBlank(user.getUserName())) {
					CmsTerminalUser terminalUser = new CmsTerminalUser();
					terminalUser.setUserName(user.getUserName());
					if (terminalUserIsExists(terminalUser)) {
						return Constant.RESULT_STR_REPEAT;
					}
				}

				if (StringUtils.isNotBlank(user.getUserBirthStr())) {
					SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
					user.setUserBirth(format.parse(user.getUserBirthStr()));
				}
				user.setUserType(1);
				user.setUserId(UUIDUtils.createUUId());
				user.setUserPwd(MD5Util.toMd5(user.getUserPwd()));
				user.setUserIsDisable(Constant.USER_IS_ACTIVATE);
				user.setCreateTime(new Timestamp(System.currentTimeMillis()));
				user.setCommentStatus(1);
				insertTerminalUser(user);
				return Constant.RESULT_STR_SUCCESS;
			}
		} catch (Exception e) {
			logger.info("addTerminalUser error", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return Constant.RESULT_STR_FAILURE;
	}

	@Override
	public CmsTerminalUser queryByWxOpenId(String wxOpenId) {
		return userMapper.queryByWxOpenId(wxOpenId);
	}

	@Override
	public CmsTerminalUser publicLogin(CmsTerminalUser user) {
		return userMapper.publicLogin(user);
	}

	@Override
	public List<CmsTerminalUser> queryTerminalUserbehaviorAnalysis(CmsTerminalUser user, String curDateStart,
			String curDateEnd, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();

		if (StringUtils.isNotBlank(user.getUserMobileNo())) {
			map.put("telephone", user.getUserMobileNo());
		} else {
			SimpleDateFormat sdf = new SimpleDateFormat(DateUtils.DEFAULT_FORMAT);

			if (StringUtils.isNotBlank(curDateStart)) {

				Date startDate;
				try {
					startDate = sdf.parse(curDateStart);
					map.put("startDate", startDate);
				} catch (ParseException e) {
				}

			}

			if (StringUtils.isNotBlank(curDateEnd)) {

				Date endDate;
				try {
					endDate = sdf.parse(curDateEnd);
					map.put("endDate", DateUtils.calculateEndOfDay(endDate));
				} catch (ParseException e) {
				}
			}
		}

		if (user.getUserType() != null) {
			map.put("userType", user.getUserType());
		}
		if (user.getUserIsDisable() != null) {
			map.put("userIsDisable", user.getUserIsDisable());
		}

		if (user.getCommentStatus() != null) {
			map.put("commentStatus", user.getCommentStatus());
		}

		if (StringUtils.isNotBlank(user.getUserArea())) {
			map.put("userArea", "%" + user.getUserArea() + "%");
		}
		if(StringUtils.isNotBlank(user.getUserId())){
			map.put("userId", user.getUserId());
		}

		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());

			int total = userMapper.queryTerminalUserbehaviorAnalysisCount(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}

		List<CmsTerminalUser> userList = userMapper.queryTerminalUserbehaviorAnalysis(map);

		for (CmsTerminalUser cmsTerminalUser : userList) {

			String userId = cmsTerminalUser.getUserId();

			UserIntegral userIntegral = userIntegralService.selectUserIntegralByUserId(userId);

			cmsTerminalUser.setIntegralNow(userIntegral.getIntegralNow());
		}

		return userList;
	}

	@Override
	public List<Integer> queryByRegisterDate(String curDateStart, String curDateEnd) {

		Map<String, Object> map = new HashMap<String, Object>();

		List<Integer> result = new ArrayList<>();

		SimpleDateFormat sdf = new SimpleDateFormat(DateUtils.DEFAULT_FORMAT);

		if (StringUtils.isNotBlank(curDateStart)) {

			Date startDate;
			try {
				startDate = sdf.parse(curDateStart);
				map.put("startDate", startDate);
			} catch (ParseException e) {
			}

		}

		if (StringUtils.isNotBlank(curDateEnd)) {

			Date endDate;
			try {
				endDate = sdf.parse(curDateEnd);
				map.put("endDate", DateUtils.calculateEndOfDay(endDate));
			} catch (ParseException e) {
			}
		}

		// 今日微信关注数
		int wxRegisterCount = userMapper.queryWXRegister(map);
		// 子平台注册数
		int sysRegisterCount = userMapper.querySysRegister(map);
		// 平台注册数
		int allRegisterCount = userMapper.queryAllRegister(map);

		result.add(wxRegisterCount);
		result.add(sysRegisterCount);
		result.add(allRegisterCount);

		return result;
	}

	@Override
	public List<String> importUser(SysUser sysUser, List<List<String>> dataList, Integer registerOrigin) {

		// 错误信息集合
		List<String> errorInfo = new ArrayList<String>();

		Set<String> uploadMoblieSet = new HashSet<String>();
		
		List<CmsTerminalUser> newTerminalUserList =new ArrayList<CmsTerminalUser>();

		for (int i = 0; i < dataList.size(); i++) {

			List<String> list = dataList.get(i);

			String userNickName = "";
			String userMobileNo = "";
			int line = 0;

			for (int j = 0; j < list.size(); j++) {

				String text = list.get(j).trim();

				switch (j) {
				case 0:
					userNickName = text;
					break;

				case 1:
					userMobileNo = text;
					break;

				case 2:
					line = Integer.valueOf(text);
					break;
				}
			}

			if (uploadMoblieSet.contains(userMobileNo)) {
				String error = "第" + line + "行手机号'" + userMobileNo + "'重复！";
				errorInfo.add(error);
				continue;
			} else {

				CmsTerminalUser terminalUser = new CmsTerminalUser();
				terminalUser.setUserMobileNo(userMobileNo);
				if (terminalUserIsExists(terminalUser)) {
					String error = "第" + line + "行手机号'" + userMobileNo + "'已存在！";
					errorInfo.add(error);
					continue;
				}
				else{
					uploadMoblieSet.add(userMobileNo);
					terminalUser.setUserId(UUIDUtils.createUUId());
					terminalUser.setCreateTime(new Timestamp(System.currentTimeMillis()));
					terminalUser.setCommentStatus(1);
					terminalUser.setUserNickName(userNickName);
					terminalUser.setRegisterOrigin(registerOrigin);
					
					newTerminalUserList.add(terminalUser);
					
				}
					
			}
		}
		if(errorInfo.size()>0)
			return errorInfo;
		else
		{
			for (CmsTerminalUser cmsTerminalUser : newTerminalUserList) {
				
				insertTerminalUser(cmsTerminalUser);
			}
		}

		return errorInfo;
	}

	@Override
	public void aestomd5() {
		// TODO Auto-generated method stub
		List<CmsTerminalUser> list = userMapper.queryAllTerminalUser();
		for(CmsTerminalUser user:list){
			user.setUserPwd(MD5Util.toMd5(SymmetricEncoder.AESDncode("", user.getUseAddress())));
			userMapper.editTerminalUserAesToMd5(user);
		}
	}
}
