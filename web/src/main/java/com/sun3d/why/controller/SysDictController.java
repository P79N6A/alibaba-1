package com.sun3d.why.controller;

import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/*
* @auther wangkun
* 数据字典模型管理
*/
@Controller
@RequestMapping(value = "/sysdict")
public class SysDictController {
	/**
	 * 导入log4j日志管理，记录错误信息
	 */
	private Logger logger = Logger.getLogger(SysModuleController.class.getName());
	/**
	 * 模块管理service层对象，注解自动注入
	 */
	@Autowired
	private SysDictService sysDictService;


	@Autowired
	private HttpSession session;

	/**
	 * 点击添加按钮跳转页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/preSaveSysDict")
	public String preSaveSysDict() {
		return "admin/sysdict/sys_add";
	}

	/**
	 * 根据编码查询数据字典信息
	 *
	 */
	@RequestMapping("/queryCode")
	@ResponseBody
	public List queryCode (@RequestParam(value = "dictCode", required = false) String dictCode) {
		SysDict sysDict = new SysDict();
		if (dictCode != null && StringUtils.isNotBlank(dictCode)) {
			sysDict.setDictCode(dictCode);
		}
		// 1-正常 2-删除;
		sysDict.setDictState(Constant.NORMAL);
		List<SysDict> list = sysDictService.querySysDictByByCondition(sysDict);
		return list;
	}

	@RequestMapping("/queryChildCode")
	@ResponseBody
	public List queryChildCode (@RequestParam(value = "dictCode", required = false) String dictCode, HttpServletRequest request, HttpServletResponse response) {
		SysDict sysDict = new SysDict();
		if (dictCode != null && StringUtils.isNotBlank(dictCode)) {
			sysDict.setDictParentId(dictCode);
		}
		// 1-正常 2-删除;
		sysDict.setDictState(Constant.NORMAL);
		List<SysDict> list = sysDictService.querySysDictByByCondition(sysDict);
		return list;
	}
	/**
	 * 根据编码与名称返回id
	 *
	 *
	 */
	@RequestMapping("/queryDict")
	@ResponseBody
	public String queryDict(SysDict sysDict) {
	    SysDict sysDict1=sysDictService.querySysDict(sysDict);
		String dictId = null;
		if(sysDict1!=null){
			dictId=sysDict1.getDictId();
		}
		return dictId;
	}
	 /**
	 * 查询数据字典列表
	 *
	 */
	@RequestMapping("/dictIndex")
	public String dictIndex(Pagination page, Model model,SysDict sysDict) {
		List<SysDict> list = sysDictService.querySysDictByCode(sysDict,page);
		model.addAttribute("list", list);
		model.addAttribute("page", page);
		model.addAttribute("sysDict", sysDict);
		return "admin/sysdict/sys_index";
	}

	/**
	 * 根据前台传过来的属性保存添加字典模块信息
	 *
	 * @param
	 * @return int json数据返回模块信息保存结果 1：成功 0：失败
	 * @throws IOException
	 */
	@RequestMapping(value = "/dictSave", method = RequestMethod.POST)
	@ResponseBody
	public String dictSave(SysDict dict) {
		try {
			SysUser loginUser = (SysUser)session.getAttribute("user");
			return sysDictService.checkDictCanSave(dict, loginUser);
		} catch (RuntimeException re) {
			// 这里用日志功能记录方法报错的信息，以便后期从服务器上面快速查找问题所在
			logger.error("dictSave()方法错误：", re);
			return re.toString();
		}
	}

	/**
	 * 根据id删除数据字典信息
	 *
	 */
	@RequestMapping(value = "/dictDel", method = RequestMethod.POST)
	@ResponseBody
	public String dictDel(HttpServletRequest request, HttpServletResponse response) {
		try {
			String dictId = request.getParameter("dictId");
			if (StringUtils.isNotBlank(dictId)) {
				SysDict sysDict = sysDictService.querySysDictByDictId(dictId);
				sysDict.setDictState(2);
				int status = sysDictService.editSysDict(sysDict);
				if (status > 0) {
					return Constant.RESULT_STR_SUCCESS;
				}
			}
		} catch (Exception e) {
			logger.info("deleteRole error" + e);
			return Constant.RESULT_STR_FAILURE;
		}
		return Constant.RESULT_STR_FAILURE;
	}

	/**
	 * 根据id编辑数据字典信息
	 *
	 */
	@RequestMapping(value = "/updateEdit", method = RequestMethod.GET)
	public String updateEdit(String dictId, Model model, HttpServletRequest request) {
		if (StringUtils.isNotBlank(dictId)) {
			SysDict sysDict = sysDictService.querySysDictByDictId(dictId);
			model.addAttribute("sysDict", sysDict);
		}
		return "admin/sysdict/sys_edit";
	}

	/**
	 * 为新增字典时单独使用
	 *
	 */
	@RequestMapping("/querySysDictByByState")
	@ResponseBody
	public List querySysDictByByState () {
		return sysDictService.querySysDictByByState();
	}

	/**
	 * 根据dictCode得到子节点
	 * @param dictCode
	 * @return
	 */
	@RequestMapping("/queryChildSysDictByDictCode")
	@ResponseBody
	public List<SysDict> queryChildSysDictByDictCode(String dictCode){
		List<SysDict> sysDictList = new ArrayList<SysDict>();
		SysDict dict = new SysDict();
		dict.setDictState(Constant.NORMAL);
		dict.setDictCode(dictCode);
		List<SysDict> dictList = sysDictService.querySysDictByByCondition(dict);
		if(CollectionUtils.isNotEmpty(dictList)){
			SysDict sysDict = dictList.get(0);
			dict.setDictCode(null);
			dict.setDictParentId(sysDict.getDictId());
			sysDictList = sysDictService.querySysDictByByCondition(dict);
		}
		return sysDictList;
	}
}
