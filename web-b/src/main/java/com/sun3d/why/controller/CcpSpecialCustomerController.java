package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.special.CcpSpecialCustomer;
import com.sun3d.why.dao.dto.CcpSpecialCustomerDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpSpecialCustomerService;
import com.sun3d.why.service.CcpSpecialYcodeService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping("/specialCustomer")
@Controller
public class CcpSpecialCustomerController {

	 @Autowired
	 private HttpSession session;
	 
	 @Autowired
	 private CcpSpecialCustomerService ccpSpecialCustomerService;
	 @Autowired
	 private CcpSpecialYcodeService ccpSpecialYcodeService;
	
   @RequestMapping("/index")
   public ModelAndView index( CcpSpecialCustomer entity, Pagination page) {
       ModelAndView model = new ModelAndView();
       
       List<CcpSpecialCustomerDto> list = ccpSpecialCustomerService.queryByCondition(entity, page);
       model.addObject("list", list);
       model.addObject("page", page);
       model.addObject("entity", entity);
       model.setViewName("admin/special/customerIndex");
     
       return model;
   }
   
   @RequestMapping(value = "/preSaveCustomer")
   public String preSaveCustomer(String customerId,HttpServletRequest request) {
   	
   	CcpSpecialCustomer entity=new CcpSpecialCustomer();
   	
   	if(StringUtils.isNotBlank(customerId)){
   		
   		entity=ccpSpecialCustomerService.findById(customerId);
   	}
   	
   	request.setAttribute("entity", entity);
   	
       return "admin/special/customerEntity";
   }
   
   
   @RequestMapping(value = "/preSaveYCode")
   public String preSaveYCode(@RequestParam String customerId,HttpServletRequest request) {
	   
	   CcpSpecialCustomer entity=ccpSpecialCustomerService.findById(customerId);
   	
	  int codeSum= ccpSpecialCustomerService.codeSum(customerId);
	  
	  int createdCode = ccpSpecialYcodeService.queryCountByCondition(customerId);
	  
	  int surpluCode=codeSum-createdCode;
	  
	  if(surpluCode<0)
		  surpluCode=0;
	  
	  request.setAttribute("codeSum", codeSum); 
	  request.setAttribute("createdCode", createdCode); 
	  request.setAttribute("surpluCode", surpluCode); 
	  request.setAttribute("customer", entity); 
   	
      return "admin/special/preSaveYCode";
   }

   @RequestMapping("/saveCustomer")
   @ResponseBody
   public String saveCustomer(CcpSpecialCustomerDto entity) {
   	
       try {
           SysUser sysUser = (SysUser) session.getAttribute("user");
           if(sysUser!=null){
           	int result = ccpSpecialCustomerService.saveCustomer(entity, sysUser);
           	if(result>0){
           		return Constant.RESULT_STR_SUCCESS;
           	}else{
           		return Constant.RESULT_STR_FAILURE;
           	}
           }else{
           	return "login";
           }
       } catch (Exception e) {
           return Constant.RESULT_STR_FAILURE;
       }
   }
 
}
