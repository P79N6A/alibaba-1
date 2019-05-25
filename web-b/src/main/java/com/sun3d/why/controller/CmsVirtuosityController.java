package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsVirtuosityService;
import com.sun3d.why.util.Pagination;

@RequestMapping(value = "/virtuosity")
@Controller
public class CmsVirtuosityController {
	
	@Autowired
	private CmsVirtuosityService virtuosityService;
	
	@Autowired
	private HttpSession Session;
	
	/**
	 *列表页 
	 * @param antique
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/virtuosityIndex")
	public ModelAndView virtuosityIndex(CmsAntique antique,Pagination page,HttpServletRequest request){
		
		ModelAndView model = new ModelAndView();
		List<CmsAntique> list = virtuosityService.queryAntiqueByCondition(antique,page);
		if(StringUtils.isNotBlank(antique.getDictName())){
			request.setAttribute("dictName", antique.getDictName());
		}
		if(StringUtils.isNotBlank(antique.getAntiqueTypeName())){
			request.setAttribute("antiqueTypeName", antique.getAntiqueTypeName());
		}
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("antique", antique);
		model.setViewName("admin/virtuosity/virtuosityIndex");
		return model;
	}
	
    /**
     * 删除
     * @param antiqueId
     * @return
     */
	@RequestMapping(value = "/deleteVirtuosity")
	@ResponseBody
	public String deleteVirtuosity(String antiqueId){
		
		SysUser user = (SysUser) Session.getAttribute("user");
		if(user != null){
			CmsAntique antique = virtuosityService.queryAntiqueById(antiqueId);
			if(antique != null){
				int rs = virtuosityService.deleteVirtuosity(antique,user);
				if(rs > 0){
					return "success";
				}else{
					return "failure";
				}
			}else{
				return "failure";
			}
		}else{
			return "login";
		}
		
	}
	
	/**
	 * 跳转到添加页面
	 * @return
	 */
	@RequestMapping(value = "/add")
	public ModelAndView add(){
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/virtuosity/addVirtuosity");
		return model;
	}
	
	/**
	 * 跳转到编辑页
	 * @param antiqueId
	 * @return
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit(String antiqueId){
		ModelAndView model = new ModelAndView();
		CmsAntique antique = virtuosityService.queryAntiqueById(antiqueId);
		model.addObject("antique", antique);
		model.addObject("antiqueId", antiqueId);
		model.setViewName("admin/virtuosity/addVirtuosity");
		return model;
	}
	
	/**
	 * 添加方法
	 * @param antique
	 * @return
	 */
	@RequestMapping(value = "/saveVirtuosity")
	@ResponseBody
	public String saveVirtuosity(CmsAntique antique){
		SysUser user = (SysUser) Session.getAttribute("user");
		int rs = 0;
		if(user != null){
			if(StringUtils.isNotBlank(antique.getAntiqueId())){
				rs = virtuosityService.updateAntique(antique,user);
			}else{
				rs = virtuosityService.saveVirtuosity(antique,user);
			}
		}else {
			return "login";
		}
		if(rs > 0){
			return "success";
		}
		return "failure";
		
		
	}
	
}
