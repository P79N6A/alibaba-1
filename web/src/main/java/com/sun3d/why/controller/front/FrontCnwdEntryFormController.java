package com.sun3d.why.controller.front;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.wrpx.WrpxUser;
import com.sun3d.why.model.cnwd.CnwdEntryForm;
import com.sun3d.why.model.cnwd.CnwdEntryformCheck;
import com.sun3d.why.service.CnwdEntryFormService;
import com.sun3d.why.service.CnwdEntryformCheckService;

@RequestMapping("/cnwdEntry")
@Controller
public class FrontCnwdEntryFormController {
	
	 @Autowired
	 private  CnwdEntryFormService cnwdEntryFormService;
	 @Autowired
	 private CnwdEntryformCheckService cnwdEntryformCheckService;
	 
	 @Autowired
	 private HttpSession session;
	
	 @RequestMapping(value="/registerOne",method=RequestMethod.GET)
	 public ModelAndView registerOne(String userId,String entryId,Integer editStatus ){
		 ModelAndView model = new ModelAndView();
		 CnwdEntryForm cnwdEntryForm = null;
		 if(userId==null){
			 
		 }else{
			  cnwdEntryForm= cnwdEntryFormService.queryEntryFormBycreateUser(userId);
			  if(cnwdEntryForm==null){
				  int rs = this.cnwdEntryFormService.addCnwdEntryForm(userId);
				  cnwdEntryForm= cnwdEntryFormService.queryEntryFormBycreateUser(userId);
			  }
		 }
		 if(!StringUtils.isEmpty(entryId)){
			 cnwdEntryForm = this.cnwdEntryFormService.queryCnwdEntryFormById(entryId); 
		 }
		 if(null!=cnwdEntryForm&&cnwdEntryForm.getCheckStatus()==3){
			 CnwdEntryformCheck cnwdEntryformCheck= cnwdEntryformCheckService.queryEntryformCheckById(cnwdEntryForm.getEntryId());
			 if(null!=cnwdEntryformCheck){
				 cnwdEntryForm.setRefusalReason(cnwdEntryformCheck.getRefusalReason());
			 }
		 }
		 model.addObject("cnwdEntryForm", cnwdEntryForm);
		 model.addObject("userId", userId);
		 model.addObject("entryId", cnwdEntryForm.getEntryId());
		 if(null!=editStatus&&editStatus==1){
				 model.setViewName("index/cnwd/registerOne");
		 }else{
			 if(null==cnwdEntryForm){
				 model.setViewName("index/cnwd/registerOne");
			 }else if(cnwdEntryForm!=null&&cnwdEntryForm.getCheckStatus()==0){
				 model.setViewName("index/cnwd/registerOne");
			 }else{
				 model.setViewName("index/cnwd/registerThree");
			 }
		 }
		 return model;
	 }
     
	 @RequestMapping(value="/registerOneSave",method=RequestMethod.POST)
     @ResponseBody
 	 public Map<String, Object> registerOneSave(CnwdEntryForm cnwdEntryForm,String entryId){
 		 return this.cnwdEntryFormService.addCnwdEntryFormOne(cnwdEntryForm,entryId);
 	 }
	 
	 
	 @RequestMapping(value="/registerTwo",method=RequestMethod.GET)
	 public ModelAndView registerTwo(String entryId){
		 ModelAndView model = new ModelAndView();
		 CnwdEntryForm cnwdEntryForm = this.cnwdEntryFormService.queryCnwdEntryFormById(entryId);
		 model.addObject("entryId", entryId);
		 model.addObject("cnwdEntryForm", cnwdEntryForm);
		 model.setViewName("index/cnwd/registerTwo");
		 return model;
	 }
	 
	 @RequestMapping(value="/registerTwoSave",method=RequestMethod.POST)
	 @ResponseBody
	 public Map<String, Object> registerTwoSave(CnwdEntryForm cnwdEntryForm,String entryId){
 		return this.cnwdEntryFormService.addCnwdEntryFormTwo(cnwdEntryForm,entryId);
	 }
	 
	 
	 @RequestMapping(value="/registerThree",method=RequestMethod.GET)
	 public ModelAndView registerThree(String entryId){
		 ModelAndView model = new ModelAndView();
		 CnwdEntryForm cnwdEntryForm = this.cnwdEntryFormService.queryCnwdEntryFormById(entryId);
		 if(null!=cnwdEntryForm&&cnwdEntryForm.getCheckStatus()==3){
			 CnwdEntryformCheck cnwdEntryformCheck= cnwdEntryformCheckService.queryEntryformCheckById(cnwdEntryForm.getEntryId());
			 if(null!=cnwdEntryformCheck){
				 cnwdEntryForm.setRefusalReason(cnwdEntryformCheck.getRefusalReason());
			 }
		 }
		 model.addObject("cnwdEntryForm", cnwdEntryForm);
		 model.addObject("entryId", entryId);
		 model.setViewName("index/cnwd/registerThree");
		 return model;
	 }
	 
	    /*
		 * 登出
		 */
		@RequestMapping("/outLogin")
		@ResponseBody
		public String outLogin() {
			WrpxUser user = null;
			if (user != null) {
				/*session.removeAttribute();*/
			}
			return "ok";
		}
	 
}
