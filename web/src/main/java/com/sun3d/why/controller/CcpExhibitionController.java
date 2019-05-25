package com.sun3d.why.controller;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpExhibition;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpExhibitionPageService;
import com.sun3d.why.service.CcpExhibitionService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/exhibition")
@Controller
public class CcpExhibitionController {
	
	private  Logger logger=LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private HttpSession session;
	
	@Autowired
	private StaticServer staticService;
	
	@Autowired
	private CcpExhibitionService exhibitionService;
	
	@Autowired
	private CcpExhibitionPageService exhibitionPageService;
	
	/**
	 * 展览主页面
	 * @param exhibition
	 * @param page
	 * @return
	 */
	@RequestMapping("/exhibitionIndex")
	public ModelAndView exhibitionIndex(CcpExhibition exhibition,Pagination page){
		ModelAndView model=new ModelAndView();
		try {
            SysUser loginUser=(SysUser) session.getAttribute("user");
			if(loginUser != null){
				if(loginUser.getUserIsManger()==null||loginUser.getUserIsManger()!=1){
					exhibition.setCreateUser(loginUser.getUserId());
				}
				List<CcpExhibition> exhibitionList=exhibitionService.queryCcpExhibition(exhibition, page);
				model.addObject("exhibitionList",exhibitionList );
				model.addObject("page", page);
				model.addObject("exhibition", exhibition);
				model.setViewName("admin/exhibition/exhibitionIndex");
			}else{
				model.setViewName("admin/main");
			}
		} catch (Exception e) {
			logger.error("exhibitionIndex error {}",e);
		}
		return model;
	}
	/**
	 * 跳转展览添加页面
	 * @return
	 */
	@RequestMapping("/addExhibition")
	public ModelAndView addExhibition(){
		
		ModelAndView model=new ModelAndView();
		String ImgUrl=staticService.getAliImgUrl();
		model.addObject("ImgUrl", ImgUrl);
		model.setViewName("admin/exhibition/addExhibition");
		return model;
	}
	
	/**
	 * 编辑页面
	 * @param exhibitionId
	 * @return
	 */
    @RequestMapping("/EditExhibition")
	public ModelAndView EditExhibition(@RequestParam String exhibitionId){
		ModelAndView model=new ModelAndView();
		
		CcpExhibition exhibition=exhibitionService.queryCcpExhibitionById(exhibitionId);
		model.addObject("exhibition", exhibition);
		
		String ImgUrl=staticService.getAliImgUrl();
	    	
		model.addObject("ImgUrl", ImgUrl);
	    model.setViewName("admin/exhibition/addExhibition");
	    return model;
	  
	}
	/**
	 * 添加展览
	 * @param exhibition
	 * @param user
	 * @return
	 */
	@RequestMapping("/addCcpExhibition")
	@ResponseBody
	public String addCcpExhibition(CcpExhibition exhibition,SysUser user,@RequestParam String exhibitionId){
		
		try {
			SysUser LoginUser=(SysUser) session.getAttribute("user");
			if(LoginUser==null){
				return "user";
			}
			if(StringUtils.isBlank(exhibitionId)){
				exhibitionService.saveExhibition(exhibition,LoginUser);
			}else{
				exhibitionService.update(exhibition,LoginUser);
			}
			return "success";
			
		} catch (Exception e) {
			logger.error("addCcpExhibition action error {}",e);
			e.printStackTrace();
			return "error";
		}
	}
	/**
	 * 删除展览
	 * @param exhibitionId
	 * @return
	 */
	@RequestMapping("/deleteExhibition")
	@ResponseBody
	public String DeleteExhibition(@RequestParam String exhibitionId){
		try {
			SysUser loginUser=(SysUser) session.getAttribute("user");
			if(loginUser == null){
				return "user";
			}
			
			int result=exhibitionService.deleteExhibition(exhibitionId,loginUser);
			return "success";
		} catch (Exception e) {
			this.logger.error("update error {}",e);
			return "error";
		}
	} 

}
