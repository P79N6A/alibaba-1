package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.BpInfoTag;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.BpInfoTagService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@Controller
@RequestMapping("beipiaoInfoTag")
public class BpInfoTagController {

	/**
	 * 导入log4j日志管理，记录错误信息
	 */
	private Logger logger = Logger.getLogger(SysModuleController.class.getName());

	@Autowired
	private HttpSession session;

	@Autowired

	private BpInfoTagService bpInfoTagService;

	// 列表+搜索
	@RequestMapping("tagList")
	public ModelAndView tagList(Pagination page, BpInfoTag bpInfoTag, ModelAndView mv) {

		List<BpInfoTag> list = null;
		SysUser loginUser = (SysUser) session.getAttribute("user");
		if (loginUser == null) {
			// 判断管理员是否登录
			mv.setViewName("admin/user/userLogin");
		} else {
			// 搜索的筛选条件——标题
			if (bpInfoTag != null) {
				list = bpInfoTagService.queryTagList(page, bpInfoTag);
				mv.addObject("list", list);
				mv.addObject("bpInfoTag", bpInfoTag);
				mv.addObject("page", page);
				mv.setViewName("admin/beipiaoInfo/tagList");
			}
		}
		return mv;
	}

	// 删除标签
	@RequestMapping("delTag")
	@ResponseBody
	public String delTag(String tagId) {
		String result = null;
		SysUser loginUser = (SysUser) session.getAttribute("user");
		try {
			if (loginUser == null) {
				// 判断管理员是否登录
				result = "nologin";
			} else {
				bpInfoTagService.delInfo(tagId, loginUser);
				result = "success";
			}
		} catch (Exception e) {
			logger.info("delInfo error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}

	// 编辑前的数据回显
	@RequestMapping("preEditTag")
	public ModelAndView preEditTag(ModelAndView mv, String tagId) {
		try {
			if (tagId != "" && tagId != null) {
				BpInfoTag bpInfoTag = bpInfoTagService.selectTagById(tagId);
				mv.setViewName("admin/beipiaoInfo/tagEdit");
				mv.addObject("bpInfoTag", bpInfoTag);
			}
		} catch (Exception e) {
			logger.info("preEditTag error {}", e);
			return mv;
		}
		return mv;
	}

	// 编辑+添加
	@RequestMapping("addAndEditTag")
	@ResponseBody
	public String addAndEditTag(BpInfoTag bpInfoTag) {
		String result = null;
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {
				result = bpInfoTagService.addAndEditTag(bpInfoTag, sysUser);
			} else {
				result = "noLogin";
			}
		} catch (Exception e) {
			logger.info("addInfo error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}

	// 跳转至添加页面
	@RequestMapping("tagAddPage")
	public ModelAndView tagAddPage(ModelAndView mv) {

		mv.setViewName("admin/beipiaoInfo/tagAdd");
		return mv;
	}

	// 加载父标签列表
	@RequestMapping("queryParentTag")
	@ResponseBody
	public List<BpInfoTag> queryParentTag() {
		List<BpInfoTag> parentTagList = null;
		parentTagList = bpInfoTagService.queryPTagByStatus();
		return parentTagList;
	}

	// 加载子标签
	@RequestMapping("queryChildTag")
	@ResponseBody
	public List<BpInfoTag> queryChildTag(String parentId) {
		List<BpInfoTag> list = null;
		if (parentId != "" && parentId != null) {
			list = bpInfoTagService.queryChildTag(parentId);
		}
		return list;
	}

	/**
	 *
	 * 根据module加载子标签
	 */
	@RequestMapping("queryChildModule")
	@ResponseBody
	public List<BpInfoTag> queryChildModule(String module) {
		List<BpInfoTag> list = null;
		if (module != "" && module != null) {
			list = bpInfoTagService.queryChildTag(module);
		}
		return list;
	}

	/**
	 *
	 * 根据module加载父标签
	 */
	@RequestMapping("queryTagsByModule")
	@ResponseBody
	public List<BpInfoTag> queryTagsByModule(String module) {
		List<BpInfoTag> list = null;
		if (module != "" && module != null) {
			list = bpInfoTagService.queryTagsByModule(module);
		}
		return list;
	}
}
