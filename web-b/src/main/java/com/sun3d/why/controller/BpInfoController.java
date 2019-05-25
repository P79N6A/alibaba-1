package com.sun3d.why.controller;

import com.sun3d.why.model.BpInfo;
import com.sun3d.why.model.BpInfoTag;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.BpInfoService;
import com.sun3d.why.service.BpInfoTagService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("beipiaoInfo")
public class BpInfoController {

	private Logger logger = LoggerFactory.getLogger(BpInfoController.class);

	@Autowired
	private BpInfoService bpInfoService;
	@Autowired
	private BpInfoTagService bpInfoTagService;

	@Autowired
	private HttpSession session;

	// 跳转到添加页面
	@RequestMapping(value = "addPage")
	public String addPage(HttpServletRequest request) {
		String module = request.getParameter("module") ;
		if(StringUtils.isNotBlank(module)) {
			List<BpInfoTag> list = bpInfoTagService.queryChildTagByTagCode(module) ;
			if(list!=null && list.size() > 0 ) {
				request.setAttribute("bpinfo",list.get(0));
			}
		}
		request.setAttribute("module",module);
		String result = null;
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {
				result = "admin/beipiaoInfo/infoAdd";
			} else {
				result = "admin/user/userLogin";
			}
		} catch (Exception e) {
			logger.info("infoPage error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}

	// 查询部门名称
	@RequestMapping(value = "queryDeptName")
	@ResponseBody
	public String queryDeptName(String userDeptId) {

		String userDeptName = bpInfoService.findDeptNameById(userDeptId);
		return userDeptName;
	}

	// 发布资讯
	@RequestMapping("addInfo")
	@ResponseBody
	public String addInfo(BpInfo bpInfo, HttpSession session) {

		String result = null;
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {
				result = bpInfoService.addInfo(bpInfo, sysUser);
			} else {
				result = "noLogin";
			}
		} catch (Exception e) {
			logger.info("addInfo error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}

	// 查询+条件搜索
	@RequestMapping(value = "infoList")
	public ModelAndView infoList(BpInfo bpInfo, String infoTitle, String infoTag,String infoStatus, String infoType, Pagination page) {

		ModelAndView mv = new ModelAndView();
		List<BpInfo> list = null;
		SysUser loginUser = (SysUser) session.getAttribute("user");
		if (loginUser == null) {
			// 判断管理员是否登录
			mv.setViewName("admin/user/userLogin");
		} else {
			// 搜索的筛选条件——标题
			if (StringUtils.isNotBlank(infoTitle)) {
				bpInfo.setBeipiaoinfoTitle(infoTitle);
			}
			// 搜索的筛选条件——专题模块
			if (StringUtils.isNotBlank(infoTag)) {
				bpInfo.setBeipiaoinfoTag(infoTag);
			}
			//搜索的筛选条件——状态
			if (StringUtils.isNotBlank(infoStatus)) {
				bpInfo.setBeipiaoinfoStatus(infoStatus);
			}
			//搜索的筛选条件——展示形式
			if (StringUtils.isNotBlank(infoType)) {
				bpInfo.setBeipiaoinfoShowtype(infoType);
			}
			//搜索的筛选条件——用户ID
			//资讯列表部分也需要分账号权限来显示，目前是各级账号都可以看到所有的资讯，已经出现多次本场馆的资讯被其他单位的管理员误下架的情况
			bpInfo.setBeipiaoinfoCreateUser(loginUser.getUserId());
			if(StringUtils.isBlank(bpInfo.getModule())) {
				bpInfo.setModule("WHZX");
			}

			// 查询条件——分页条件+筛选条件
			list = bpInfoService.queryInfoListByCondition(bpInfo, page,loginUser.getUserDeptPath());
			mv.addObject("infoTitle", infoTitle);
			mv.addObject("infoTag", infoTag);
			mv.addObject("infoStatus", infoStatus);
			mv.addObject("infoType", infoType);
			mv.addObject("list", list);
			mv.addObject("page", page);
			mv.addObject("bpInfo", bpInfo);
			mv.setViewName("admin/beipiaoInfo/infoList");
		}
		return mv;
	}

	// 上下架
	@RequestMapping(value = "changeInfoStatus")
	@ResponseBody
	public String changeInfoStatus(String infoId, String infoStatus) {

		String result = null;
		SysUser loginUser = (SysUser) session.getAttribute("user");
		try {
			if (loginUser == null) {
				// 判断管理员是否登录
				result = "nologin";
			} else {
				bpInfoService.changInfoStatus(infoId, infoStatus,loginUser);
				result = "success";
			}
		} catch (Exception e) {
			logger.info("changeInfoStatus error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}

	// 删除
	@RequestMapping(value = "delInfo")
	@ResponseBody
	public String delInfo(String infoId) {

		String result = null;
		SysUser loginUser = (SysUser) session.getAttribute("user");
		try {
			if (loginUser == null) {
				// 判断管理员是否登录
				result = "nologin";
			} else {
				bpInfoService.delInfo(infoId,loginUser);
				result = "success";
			}
		} catch (Exception e) {
			logger.info("delInfo error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}
	
	// 运营位推荐预览
	@RequestMapping(value ="preRecommendInfo")
	public ModelAndView reRecommendInfo(String infoTag ,String infoId){
		ModelAndView mv = new ModelAndView();
		List<String> resultList = bpInfoService.queryInfoNumber(infoId);
		mv.addObject("resultList", resultList);
		mv.addObject("infoId", infoId);
		mv.setViewName("admin/beipiaoInfo/preRecommend");
		return mv;
	}
	
	// 运营位推荐
	@RequestMapping(value = "recommendInfo")
	@ResponseBody
	public String recommendInfo(String infoId,String infoNumber) {
		String result = null;
		SysUser loginUser = (SysUser) session.getAttribute("user");
		try {
			if (loginUser == null) {
				// 判断管理员是否登录
				result = "nologin";
			} else {
				bpInfoService.recommendInfo(infoId,infoNumber,loginUser);
				result = "success";
			}
		} catch (Exception e) {
			logger.info("recommendInfo error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}
	
	//运营位取消推荐
	@RequestMapping(value="delRecommendInfo")
	@ResponseBody
	public String delRecommendInfo(String infoId) {
		String result = null;
		SysUser loginUser = (SysUser) session.getAttribute("user");
		try {
			if (loginUser == null) {
				// 判断管理员是否登录
				result = "nologin";
			} else {
				bpInfoService.delRecommendInfo(infoId,loginUser);
				result = "success";
			}
		} catch (Exception e) {
			logger.info("delRecommendInfo error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}
	
	//编辑前的数据回显
	@RequestMapping(value="preEditInfo")
	public ModelAndView preEditInfo(String infoId){
		ModelAndView mv = new ModelAndView();
		BpInfo bpInfo = bpInfoService.selectInfoById(infoId);
		if(bpInfo!= null && StringUtils.isNotBlank(bpInfo.getModule())) {
			BpInfoTag tags = bpInfoTagService.selectTagById(bpInfo.getBeipiaoinfoTag()) ;
			if(tags!= null) {
				mv.addObject("bpInfoTag",tags) ;
			}
		}
		mv.addObject("bpInfo", bpInfo);
		mv.setViewName("admin/beipiaoInfo/infoEdit");
		return mv;
	}
	
	//页面载入时查找一级标签
	@RequestMapping("queryFirstLevelTag")
	@ResponseBody
	public List<SysDict> queryFirstLevelTag(String code){
		
		List<SysDict> dictList = null;
		if (code!=null&&code!="") {
			dictList = bpInfoService.queryByCode(code);
		}
		return dictList;
	}
	
	//根据父标签查找字典
	@RequestMapping("queryChildTag")
	@ResponseBody
	public List<SysDict> queryChildTag(String TagId){
		List<SysDict> dictList = new ArrayList<>();
		dictList= bpInfoService.queryChildTagByInfoTag(TagId);
		return dictList;
	}
}
