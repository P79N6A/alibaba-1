package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpExhibitionPage;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpExhibitionPageService;
import com.sun3d.why.util.Pagination;

@Controller
@RequestMapping("/InsidePages")
public class CcpExhibitionInsidePagesController {
	
	private  Logger logger=LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private StaticServer staticService;
	
	@Autowired
	private CcpExhibitionPageService ccpExhibitionPageService;
	
	@Autowired
	private HttpSession session;
    /**
     * 内页主页
     * @param exhibitionId
     * @param page
     * @return
     */
	@RequestMapping("/managerExhibitionPage")
	public ModelAndView managerExhibitionPage(@RequestParam String exhibitionId,Pagination page){
		
		ModelAndView model=new ModelAndView();
		
		List<CcpExhibitionPage> exhibitionPageList=ccpExhibitionPageService.queryCcpExhibitionPage(exhibitionId, page);
		
		model.addObject("exhibitionPageList", exhibitionPageList);
		model.addObject("page", page);
		model.addObject("exhibitionId",exhibitionId);
		
		model.setViewName("admin/exhibition/managerExhibitionPage");
		
		return model;
	}
	
	@RequestMapping("/selectPageType")
	public ModelAndView selectPageType(@RequestParam String exhibitionId){
		
		ModelAndView model=new ModelAndView();
		model.addObject("exhibitionId",exhibitionId);
		
		model.setViewName("admin/exhibition/selectPageType");
		return model;
	}
	
    /**
     * 内页删除方法
     * @param pageId
     * @return
     */
	@RequestMapping("/deleteInsidePages")
	@ResponseBody
	public String DeleteInsidePages(@RequestParam String pageId){
		try {
			SysUser loginUser=(SysUser) session.getAttribute("user");
			if(loginUser == null){
             return "user";
			}
			int result=ccpExhibitionPageService.deleteExhibition(pageId,loginUser);
			return "success";
		} catch (Exception e) {
			this.logger.error("update error {}",e);
			return "error";
		}
	} 
	/**
	 * 内页添加方法
	 * @param exhibition
	 * @param user
	 * @return
	 */
	@RequestMapping("/addCcpExhibitionPage")
	@ResponseBody
	public String addCcpExhibitionPage(CcpExhibitionPage exhibition,@RequestParam String exhibitionId,SysUser user,@RequestParam Integer pageType){
		try {
			SysUser LoginUser=(SysUser) session.getAttribute("user");
			if(LoginUser==null){
				return "user";
			}
			if(StringUtils.isBlank(exhibition.getPageId())){
			   ccpExhibitionPageService.saveExhibitionPage(exhibition,exhibitionId,LoginUser,pageType);
			}else {
				ccpExhibitionPageService.updateExhibitionPage(exhibition,LoginUser);
			}
			
			return "success";
			
		} catch (Exception e) {
			logger.error("addCcpExhibitionPage action error {}",e);
			e.printStackTrace();
			return "error";
		}
	}
	
    /**
     * 模版页面跳转
     * @param pageType
     * @return
     */
	@RequestMapping("/InsidePagesSkip")
	public ModelAndView InsidePagesSkip(CcpExhibitionPage exhibition,@RequestParam String exhibitionId, @RequestParam Integer pageType){
		
		ModelAndView model=new ModelAndView();
		model.addObject("exhibitionId", exhibitionId);
		model.addObject("exhibition", exhibition);
		model.addObject("pageType", pageType);
		String ImgUrl=staticService.getAliImgUrl();
		model.addObject("ImgUrl", ImgUrl);
		model.setViewName("admin/exhibition/insidePagesTemplateSelect");
		
		return model;
		
	}
	
	/**
	 * 跳转编辑页面
	 * @param pageId
	 * @return
	 */
	@RequestMapping("/EditInsidePages")
	public ModelAndView EditInsidePages(@RequestParam String pageId){
		ModelAndView model=new ModelAndView();
		String ImgUrl=staticService.getAliImgUrl();
		model.addObject("ImgUrl", ImgUrl);
		CcpExhibitionPage ExhibitionPage=ccpExhibitionPageService.queryExhibitionPage(pageId);
		model.addObject("exhibitionId", ExhibitionPage.getExhibitionId());
		model.addObject("pageType", ExhibitionPage.getPageType());
		model.addObject("exhibitionPage", ExhibitionPage);
		model.setViewName("admin/exhibition/insidePagesTemplateSelect");
		return model;
	}
	
	@RequestMapping("/move")
	@ResponseBody
	public int move(@RequestParam String pageId,Integer moveType){
		
		return ccpExhibitionPageService.moveExhibition(pageId, moveType);
	}
}
