package com.sun3d.why.controller;

import com.culturecloud.model.bean.common.CcpInformation;
import com.culturecloud.model.bean.common.CcpInformationModule;
import com.sun3d.why.dao.CcpInformationModuleMapper;
import com.sun3d.why.dao.dto.CcpInformationDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpInformationService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RequestMapping("/ccpInformation")
@Controller
public class CcpInformationController {

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private HttpSession session;

	@Autowired
	private CcpInformationService ccpInformationService;
	@Autowired
	private CcpInformationModuleMapper ccpInformationModuleMapper;

	/**
	 * 资讯列表页
	 *
	 * @param information
	 * @param page
	 * @return
	 */
	@RequestMapping("/informationIndex.do")
	public ModelAndView informationIndex(CcpInformation information, Pagination page) {
		ModelAndView model = new ModelAndView();
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			List<CcpInformationDto> informationList = ccpInformationService.informationList(information, page, sysUser);
			model.addObject("information", information);
			model.addObject("informationList", informationList);
			model.addObject("page", page);
			CcpInformationModule infoModule = ccpInformationModuleMapper.selectByPrimaryKey(information.getInformationModuleId());
			model.addObject("infoModule", infoModule);
			model.setViewName("admin/information/informationIndex");
		} catch (Exception e) {
			logger.error("informationIndex error {}", e);
		}
		return model;
	}

	/**
	 * 资讯内容编辑页
	 *
	 * @return
	 */
	@RequestMapping("/preAddInformation")
	public ModelAndView preAddInformation(String informationId, String informationModuleId) {
		ModelAndView model = new ModelAndView();
		try {
			model.addObject("informationId", informationId);
			model.addObject("informationModuleId", informationModuleId);
			CcpInformationModule infoModule = ccpInformationModuleMapper.selectByPrimaryKey(informationModuleId);
			model.addObject("infoModule", infoModule);
			model.setViewName("admin/information/information");
		} catch (Exception e) {
			logger.error("preAddInformation error {}", e);
		}
		return model;
	}

	@RequestMapping("/preEditInformation")
	public ModelAndView preEditInformation(String informationId, String informationModuleId) {
		ModelAndView model = new ModelAndView();
		try {
			CcpInformation CcpInformation = ccpInformationService.getInformation(informationId);
			model.addObject("info", CcpInformation);
			model.addObject("informationModuleId", informationModuleId);
			CcpInformationModule infoModule = ccpInformationModuleMapper.selectByPrimaryKey(informationModuleId);
			model.addObject("infoModule", infoModule);
			model.setViewName("admin/information/information");
		} catch (Exception e) {
			logger.error("preAddInformation error {}", e);
		}
		return model;
	}

	/**
	 * 添加资讯
	 *
	 * @return
	 */
	@RequestMapping(value = "/saveInformation")
	@ResponseBody
	public String saveInformation(CcpInformation information) {
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			int i = 0;
			if (sysUser != null) {

				String infomationId = information.getInformationId();

				String informationTags = information.getInformationTags();

				if (StringUtils.isNotBlank(informationTags)) {

					String[] tagArray = informationTags.split(",");

					List<String> tagList = new ArrayList<String>();

					for (int j = 0; j < tagArray.length; j++) {

						String tag = tagArray[j];

						if (StringUtils.isNotBlank(tag)) {

							tagList.add(tag);
						}
					}

					information.setInformationTags(StringUtils.join(tagList.toArray(), ","));
				}

				if (StringUtils.isBlank(infomationId)) {

					information.setInformationId(UUIDUtils.createUUId());
					information.setInformationCreateTime(new Date());
					information.setInformationCreateUser(sysUser.getUserId());
					information.setInformationStatus(0);
					information.setInformationIsRecommend(0);

					i = ccpInformationService.addInformation(information);

				} else {

					information.setInformationUpdateTime(new Date());
					information.setInformationUpdateUser(sysUser.getUserId());

					i = ccpInformationService.updateInformation(information);
				}

				if (i > 0) {
					return Constant.RESULT_STR_SUCCESS;
				} else
					return Constant.RESULT_STR_FAILURE;

			} else {
				return "login";
			}
		} catch (Exception e) {
			logger.info("saveInformation error {}", e);
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
	}

	/**
	 * 根据id读取咨询
	 *
	 * @return
	 */
	@RequestMapping(value = "/getInformation")
	@ResponseBody
	public CcpInformation getInformation(String informationId) {
		try {
			return ccpInformationService.getInformation(informationId);
		} catch (Exception e) {
			logger.info("getInformation error {}", e);
		}
		return null;
	}

	@RequestMapping(value = "/deleteinformation")
	@ResponseBody
	public String deleteinformation(String informationId) {
		try {

			CcpInformation information = new CcpInformation();

			SysUser sysUser = (SysUser) session.getAttribute("user");
			int i = 0;
			if (sysUser != null) {

				information.setInformationId(informationId);
				information.setInformationStatus(1);
				information.setInformationUpdateTime(new Date());
				information.setInformationUpdateUser(sysUser.getUserId());
				
				i=ccpInformationService.updateInformation(information);
				
				if (i > 0) {
					return Constant.RESULT_STR_SUCCESS;
				} else
					return Constant.RESULT_STR_FAILURE;

			} else {
				return "login";
			}

		} catch (Exception e) {
			logger.info("deleteinformation error {}", e);
		}
		return Constant.RESULT_STR_SUCCESS;
	}

}
