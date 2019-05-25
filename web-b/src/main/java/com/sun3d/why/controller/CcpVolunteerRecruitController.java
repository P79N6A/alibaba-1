package com.sun3d.why.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.volunteer.CcpVolunteerRecruit;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpVolunteerRecruitService;
import com.sun3d.why.util.Pagination;

@RequestMapping(value = "/volunteerVenueManage")
@Controller
public class CcpVolunteerRecruitController {
	
	@Autowired
	private CcpVolunteerRecruitService ccpVolunteerRecruitService;
	
	@Autowired
	private HttpSession Session;
	
	/**
	 * 加载列表页面
	 * @param volunteerRecruit
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/volunteerVenueManageIndex")
	public ModelAndView volunteerVenueManageIndex(CcpVolunteerRecruit volunteerRecruit,Pagination page){
		ModelAndView model = new ModelAndView();
		List<CcpVolunteerRecruit> list = ccpVolunteerRecruitService.queryVolunteerRecruitByCondition(volunteerRecruit,page);
		model.addObject("list", list);
		model.addObject("volunteerRecruit",volunteerRecruit);
		model.addObject("page", page);
		model.setViewName("admin/volunteerVenueManage/volunteerVenueManageIndex");
		return model;
	}
	
	/**
	 * 跳转到添加志愿者页面
	 * @return
	 */
	@RequestMapping(value = "/add")
	public ModelAndView add(){
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/volunteerVenueManage/addVolunteer");
		return model;
	}
	
	/**
	 * 添加自愿者
	 * @param volunteerRecruit
	 * @return
	 */
	@RequestMapping(value = "/saveVolunteer")
	@ResponseBody
	public String saveVolunteer(CcpVolunteerRecruit volunteerRecruit,String recruitId){
		int rs = 0 ;
		try {
			SysUser sysUser = (SysUser) Session.getAttribute("user");
			if(sysUser != null){
				 if(StringUtils.isNotBlank(recruitId)){
					  rs = ccpVolunteerRecruitService.editVolunteer(volunteerRecruit,recruitId);
				 }else {
					  rs = ccpVolunteerRecruitService.save(volunteerRecruit);
				 }
				if(rs > 0){
					return "success";
				}else {
					return "failure";
				}
			}else{
				return "login";
			}
			
		} catch (Exception e) {
           e.printStackTrace();
           return "failure";
		}
		
	}
	
	/**
	 * 删除志愿者
	 * @param recruitId
	 * @return
	 */
	@RequestMapping(value = "/deleteVolunteer")
	@ResponseBody
	public String deleteVolunteer(String recruitId){
		
		CcpVolunteerRecruit volunteerRecruit = ccpVolunteerRecruitService.queryVolunteerRecruitById(recruitId);
		int rs = ccpVolunteerRecruitService.deleteVolunteer(volunteerRecruit);
		if(rs > 0){
			return "success";
		}else {
			return "failure";
		}
	}
	
	/**
	 * 编辑跳转页面
	 * @param recruitId
	 * @return
	 */
	@RequestMapping(value = "/editVolunteer")
	public ModelAndView editVolunteer(String recruitId){
		ModelAndView model = new ModelAndView();
		CcpVolunteerRecruit volunteerRecruit = ccpVolunteerRecruitService.queryVolunteerRecruitById(recruitId);
		model.addObject("volunteerRecruit", volunteerRecruit);
		model.addObject("recruitId", recruitId);
		model.setViewName("admin/volunteerVenueManage/addVolunteer");
		return model;
	}
}
