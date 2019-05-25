package com.sun3d.why.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.culture.CcpCultureContestUser;
import com.sun3d.why.dao.dto.CcpCultureContestAnswerDto;
import com.sun3d.why.service.CcpCultureContestUserService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/CultureContestUser")
@Controller
public class CcpCultureContestUserController {
	private Logger logger = LoggerFactory.getLogger(CmsActivityController.class);
	@Autowired
	private CcpCultureContestUserService cultureContestUserService;

	/**
	 * 查询用户信息返回到页面展现
	 *
	 * @param String
	 *            Name 名称或者手机号
	 * @param page
	 *            Pagination 分页功能类
	 * @param String
	 *            userStage 阶段
	 * @param String
	 *            orderType 排序类型
	 * @param Integer
	 *            userGroupType 排序类型                  
	 *
	 * @return ModelAndView 页面及参数
	 */
	@RequestMapping(value = "/queryUserInfo")
	public ModelAndView queryCultureContestUser(String Name, String userStage, String orderType, Pagination page,
			Integer userGroupType) {

		ModelAndView model = new ModelAndView();
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			if (StringUtils.isNotBlank(Name) && !"请输入姓名\\手机号".equals(Name)) {
				if (Name.matches("^1[3|4|5|7|8][0-9]{9}$")) {
					map.put("userTelephone", Name);
				} else {
					map.put("userName", Name);
				}
			} else {
				map.put("userTelephone", null);
				map.put("userName", null);
			}
			if (StringUtils.isNotBlank(userStage)) {
				map.put("userStage", userStage);
			} else {
				map.put("userStage", 0);
			}
			if (StringUtils.isNotBlank(orderType)) {
				if ("1".equals(orderType)) {
					map.put("sortType", "answer_create_time DESC");
				} else if ("2".equals(orderType)) {
					map.put("sortType", "sum DESC");
				} else {
					map.put("sortType", "sum");
				}
			} else {
				map.put("sortType", null);
			}
			map.put("userGroupType", userGroupType);
			List<CcpCultureContestAnswerDto> userList = cultureContestUserService.queryUserContestAnswerAllList(map,page);
			model.addObject("userList", userList);
			model.addObject("page", page);
			if (Name != null) {
				model.addObject("Name", Name);
			}
			model.addObject("userGroupType", userGroupType);
			model.addObject("orderType", orderType);
			model.addObject("userStage", userStage);
			model.setViewName("admin/cultureContest/cultureContestUser");
		} catch (Exception e) {
			logger.error("CultureContestUser error {}", e);
		}
		return model;
	}

	/**
	 * 查询用户信息返回到页面展现
	 *
	 * @param role
	 *            SysRole 角色信息模型
	 * @param page
	 *            Pagination 分页功能类
	 * @return ModelAndView 页面及参数
	 */
	@RequestMapping(value = "/queryUserDetail")
	public ModelAndView queryCultureContestUser(String cultureUserId, String userName, int userGroupType) {
		ModelAndView model = new ModelAndView();
		CcpCultureContestUser ccpCultureContestUser = null;
		String username = null;
		try {
			List<CcpCultureContestUser> info = cultureContestUserService.queryDetailByUserId(cultureUserId);
			if (info.size() != 0) {
				ccpCultureContestUser = info.get(0);
				model.addObject("userInfo", ccpCultureContestUser);
			}
			String userId = ccpCultureContestUser.getUserId();
			if(StringUtils.isNotBlank(userId)){
				username = cultureContestUserService.queryUsernameByUserId(userId);
			}
			List<CcpCultureContestAnswerDto> list = cultureContestUserService
					.queryUserContestAnswerDetailList(cultureUserId);
			Map<String, Object> mm = new HashMap<String, Object>();
			// 明细查询 一共有九条记录
			for (int i = 0; i < list.size(); i++) {
				CcpCultureContestAnswerDto answerDto = list.get(i);
				// 把回答的记录数分割后，就是回答的题数
				String answer_number = answerDto.getAnswerNumber();
				if (StringUtils.isNotBlank(answer_number)) {
					answer_number = answer_number.split(",").length + "";
				}
				// 获取答题数
				answerDto.setAnswerNumber(answer_number);
				// 用来取排名和最大值
				if ((i + 1) % 3 == 0) {
					Map<String, Object> mapType = new HashMap<String, Object>();
					mapType.put("userGroupType", userGroupType);
					mapType.put("stageNumber", (i + 1) / 3);
					mapType.put("cultureUserId", cultureUserId);

					// 这个值里面包含排名和最大值
					List sortList = cultureContestUserService.queryUserContestAnswerSort(mapType);
					mm.put("key" + i, sortList);
					if (i == 8) {
						mapType.put("stageNumber", null);
						sortList = cultureContestUserService.queryUserContestAnswerSortAll(mapType);
						mm.put("key" + (i + 1), sortList);
					}
				}
			}
			model.addObject("userName", username);
			model.addObject("detailInfo", list);
			model.addObject("sortInfo", mm);
			model.setViewName("admin/cultureContest/cultureContestDetail");
		} catch (Exception e) {
			logger.error("CultureContestUser error {}", e);
		}
		return model;
	}
}
