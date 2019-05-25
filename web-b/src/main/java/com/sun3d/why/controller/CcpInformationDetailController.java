package com.sun3d.why.controller;

import com.culturecloud.model.bean.common.CcpInformation;
import com.culturecloud.model.bean.common.CcpInformationDetail;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpInformationDetailService;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@RequestMapping("/ccpInformationDetail")
@Controller
public class CcpInformationDetailController {

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private HttpSession session;

	@Autowired
	private CcpInformationDetailService ccpInformationDetailService;
	
	@Autowired
	private CcpInformationService ccpInformationService;

	@RequestMapping("/ccpInformationDetailIndex")
	public ModelAndView ccpInformationDetailIndex(@RequestParam String informationId, Pagination page) {
		ModelAndView model = new ModelAndView();
		try {

			List<CcpInformationDetail> detailList = ccpInformationDetailService.detailList(informationId, page);
			model.addObject("detailList", detailList);
			model.addObject("informationId", informationId);
			model.addObject("page", page);
			model.setViewName("admin/informationDetail/detailList");
		} catch (Exception e) {
			logger.error("ccpInformationDetailIndex error {}", e);
		}
		return model;

	}
	

	/**
	 * 去新增页面
	 *
	 * @return
	 */
	@RequestMapping(value = "/preAddInformationDetail")
	public String preAddInformationDetail(@RequestParam String informationId, HttpServletRequest request) {
		
		CcpInformationDetail CcpInformationDetail = new CcpInformationDetail();
		
		CcpInformationDetail.setInformationId(informationId);
		request.setAttribute("info", CcpInformationDetail);
		
		CcpInformation ccpInformation=ccpInformationService.getInformation(informationId);
    	
    	Integer informationSort=ccpInformation.getInformationSort();
    	request.setAttribute("informationSort", informationSort);
		
		if (informationSort == 4) {  //直播或回放
			return "admin/informationDetail/detail2";
		}
		return "admin/informationDetail/detail";
	}

	/**
	 *
	 * @param InformationDetail
	 * @return
	 */
	@RequestMapping(value = "/saveInformationDetail", method = RequestMethod.POST)
	@ResponseBody
	public String saveInformationDetail(CcpInformationDetail informationDetail) {
		try {
			
			SysUser sysUser = (SysUser) session.getAttribute("user");
			
			if (sysUser != null) {
				
				String informationDetailId=informationDetail.getInformationDetailId();
				
				int i=0;
				
				if(StringUtils.isNotBlank(informationDetailId)){
					
					informationDetail.setDetailUpdateTime(new Date());
					informationDetail.setDetailUpdateUser(sysUser.getUserId());
				
					i= ccpInformationDetailService.updateInformationDetail(informationDetail);
				}
				else{
					
					informationDetail.setInformationDetailId(UUIDUtils.createUUId());
					informationDetail.setDetailCreateTime(new Date());
					informationDetail.setDetailCreateUser(sysUser.getUserId());
					
					i=ccpInformationDetailService.addInformationDetail(informationDetail);
				}
				if(i>0)
					return Constant.RESULT_STR_SUCCESS;
				
			}else{
				
				return "login";
			}
		} catch (Exception e) {
			logger.info("saveInformationDetail error" + e.getMessage());
			return Constant.RESULT_STR_FAILURE;
		}
		return Constant.RESULT_STR_FAILURE;
	}

	/**
	 *
	 * @param informationDetailId
	 * @return
	 */
	@RequestMapping(value = "/deleteInformationDetail", method = RequestMethod.POST)
	@ResponseBody
	public String deleteInformationDetail(@RequestParam String informationDetailId) {
		try {
			
			
			SysUser sysUser = (SysUser) session.getAttribute("user");
			
			if (sysUser != null) {
				
				ccpInformationDetailService.delInformationDetail(informationDetailId);
				
				return Constant.RESULT_STR_SUCCESS;
			}
			else
			{
				return "login";
			}
			
		} catch (Exception e) {
			logger.info("deleteInformationDetail error" + e);
			return Constant.RESULT_STR_FAILURE;
		}
	}

	@RequestMapping(value = "/preEditInformationDetail")
	public String preEditInformationDetail(@RequestParam String informationDetailId, HttpServletRequest request) {
		
		CcpInformationDetail CcpInformationDetail = ccpInformationDetailService.selectByPrimaryKey(informationDetailId);
	
		CcpInformation ccpInformation=ccpInformationService.getInformation(CcpInformationDetail.getInformationId());
    	
    	Integer informationSort=ccpInformation.getInformationSort();
    	request.setAttribute("informationSort", informationSort);
		
		request.setAttribute("info", CcpInformationDetail);
		if(informationSort == 4) {
			return "admin/informationDetail/detail2";
		}
		return "admin/informationDetail/detail";
	}

}
