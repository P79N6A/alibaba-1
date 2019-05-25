package com.sun3d.why.controller;

import com.culturecloud.model.bean.common.CcpInformationModule;
import com.sun3d.why.dao.CcpInformationModuleMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpInformationModuleService;
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

import javax.servlet.http.HttpSession;
import java.util.List;

@RequestMapping("/ccpInformationModule")
@Controller
public class CcpInformationModuleController {

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private HttpSession session;

	@Autowired
	private CcpInformationModuleService ccpInformationModuleService;
	@Autowired
	private CcpInformationModuleMapper ccpInformationModuleMapper;

	/**
	 * 资讯设置列表页
	 * @param information
	 * @param page
	 * @return
	 */
	@RequestMapping("/informationModuleIndex")
	public ModelAndView informationModuleIndex(CcpInformationModule ccpInformationModule, Pagination page) {
		ModelAndView model = new ModelAndView();
		try {
			List<CcpInformationModule> informationModuleList = ccpInformationModuleService.queryInformationModuleList(ccpInformationModule, page);
			model.addObject("informationModule", ccpInformationModule);
			model.addObject("informationModuleList", informationModuleList);
			model.addObject("page", page);
			model.setViewName("admin/informationModule/informationModuleIndex");
		} catch (Exception e) {
			logger.error("informationModuleIndex error {}", e);
		}
		return model;
	}

	/**
	 * 资讯模块编辑页
	 * @return
	 */
	@RequestMapping("/preInformationModule")
	public ModelAndView preInformationModule(String informationModuleId) {
		ModelAndView model = new ModelAndView();
		try {
			if(StringUtils.isNotBlank(informationModuleId)){
				CcpInformationModule ccpInformationModule = ccpInformationModuleMapper.selectByPrimaryKey(informationModuleId);
				model.addObject("info", ccpInformationModule);
				model.addObject("informationModuleId", informationModuleId);
			}
			model.setViewName("admin/informationModule/informationModule");
		} catch (Exception e) {
			logger.error("preInformationModule error {}", e);
		}
		return model;
	}

	/**
	 * 添加编辑资讯模块
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdateInformationModule")
	@ResponseBody
	public String saveOrUpdateInformationModule(CcpInformationModule ccpInformationModule) {
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {
				int result = ccpInformationModuleService.saveOrUpdateInformationModule(sysUser,ccpInformationModule);

				if (result > 0) {
					return Constant.RESULT_STR_SUCCESS;
				} else
					return Constant.RESULT_STR_FAILURE;

			} else {
				return Constant.RESULT_STR_FAILURE;
			}
		} catch (Exception e) {
			logger.info("saveOrUpdateInformationModule error {}", e);
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
	}
	
}
