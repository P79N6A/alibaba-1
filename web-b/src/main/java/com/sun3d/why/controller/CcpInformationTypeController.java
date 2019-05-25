package com.sun3d.why.controller;

import com.culturecloud.model.bean.common.CcpInformationModule;
import com.culturecloud.model.bean.common.CcpInformationType;
import com.sun3d.why.dao.CcpInformationModuleMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpInformationTypeService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@RequestMapping("/ccpInformationType")
@Controller
public class CcpInformationTypeController {

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private CcpInformationTypeService informationTypeService;

	@Autowired
	private CcpInformationModuleMapper ccpInformationModuleMapper;


	@Autowired
	private HttpSession session;

	/**
	 * @param informationType
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/informationTypeIndex")
	public ModelAndView informationTypeIndex(CcpInformationType informationType, Pagination page) {
		ModelAndView model = new ModelAndView();
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			List<CcpInformationType> informationTypeList = informationTypeService
					.queryInformationTypeByCondition(sysUser, informationType, page);
			model.setViewName("admin/informationType/informationTypeIndex");
			model.addObject("informationTypeList", informationTypeList);
			model.addObject("page", page);
			model.addObject("InformationType", informationType);
			CcpInformationModule infoModule = ccpInformationModuleMapper.selectByPrimaryKey(informationType.getInformationModuleId());
			model.addObject("infoModule", infoModule);
		} catch (Exception e) {
			logger.info("informationTypeIndex error" + e);
		}
		return model;
	}

	/**
	 * 去新增页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/preAddInformationType")
	public String preAddInformationType(String informationModuleId, HttpServletRequest request) {
		request.setAttribute("informationModuleId", informationModuleId);
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser == null) {
            return "redirect:/login.do";
        }
		List<CcpInformationType> parentInformationTypeList = informationTypeService.queryInformationTypeInParentShop(sysUser, informationModuleId);
		request.setAttribute("parentInformationTypeList", parentInformationTypeList);
		return "admin/informationType/type";
	}

	/**
	 *
	 * @param informationType
	 * @return
	 */
	@RequestMapping(value = "/saveInformationType", method = RequestMethod.POST)
	@ResponseBody
	public String saveInformationType(CcpInformationType informationType) {
		try {
			
			SysUser sysUser = (SysUser) session.getAttribute("user");
			
			if (sysUser != null) {
				
				String informationTypeId=informationType.getInformationTypeId();
				
				int i=0;
				
				if(StringUtils.isNotBlank(informationTypeId)){
					
					 informationType.setTypeUpdateTime(new Date());
					 informationType.setTypeUpdateUser(sysUser.getUserId());
				
					i= informationTypeService.updateInformationType(informationType);
				}
				else{
					
					informationType.setInformationTypeId(UUIDUtils.createUUId());
					informationType.setTypeCreateTime(new Date());
					informationType.setTypeCreateUser(sysUser.getUserId());
					
					i=informationTypeService.createInformationType(informationType);
				}
				if(i>0)
					return Constant.RESULT_STR_SUCCESS;
				
			}else{
				
				return "login";
			}
		} catch (Exception e) {
			logger.info("saveInformationType error" + e.getMessage());
			return Constant.RESULT_STR_FAILURE;
		}
		return Constant.RESULT_STR_FAILURE;
	}

	/**
	 *
	 * @param informationTypeId
	 * @return
	 */
	@RequestMapping(value = "/deleteInformationType", method = RequestMethod.POST)
	@ResponseBody
	public String deleteInformationType(@RequestParam String informationTypeId) {
		try {
			
			
			SysUser sysUser = (SysUser) session.getAttribute("user");
			
			if (sysUser != null) {
				
				int useCount=informationTypeService.queryTypeUseCount(informationTypeId);
				
				if(useCount>0)
					return "used";
				
				informationTypeService.delInformationType(informationTypeId);
				
				return Constant.RESULT_STR_SUCCESS;
			}
			else
			{
				return "login";
			}
			
		} catch (Exception e) {
			logger.info("deleteInformationType error" + e);
			return Constant.RESULT_STR_FAILURE;
		}
	}

	@RequestMapping(value = "/preEditInformationType")
	public String preEditInformationType(@RequestParam String informationTypeId, @RequestParam String informationModuleId, HttpServletRequest request) {
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser == null) {
            return "redirect:/login.do";
        }
		CcpInformationType CcpInformationType = informationTypeService.queryInformationTypeById(informationTypeId);
		request.setAttribute("informationType", CcpInformationType);
		request.setAttribute("informationModuleId", informationModuleId);
		List<com.culturecloud.model.bean.common.CcpInformationType> parentInformationTypeList = informationTypeService.queryInformationTypeInParentShop(sysUser, informationModuleId);
		request.setAttribute("parentInformationTypeList", parentInformationTypeList);
		return "admin/informationType/type";
	}

	
	   @RequestMapping(value = "/queryAllInformationType")
	   @ResponseBody
	   public List<CcpInformationType> queryAllInformationType(String informationModuleId, String informationCreateUser){
		   SysUser sysUser = new SysUser();
		   if(StringUtils.isBlank(informationCreateUser)){// 新增
			   sysUser = (SysUser) session.getAttribute("user");
		   }else{// 编辑
			   sysUser.setUserId(informationCreateUser);
		   }
		   List<CcpInformationType> list =informationTypeService.queryAllInformationType(sysUser, informationModuleId);
		   return list;
	   } 


}
