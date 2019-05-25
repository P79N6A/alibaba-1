package com.sun3d.why.controller;


import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.pdfengcai.PdOfferWithBLOBs;
import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCulturalSquareService;
import com.sun3d.why.util.Pagination;

@Controller
@RequestMapping(value="/squareInform")
public class CmsCulturalSquareController {
	 private Logger logger = Logger.getLogger(CmsCulturalSquareController.class);
	  @Autowired
	  private HttpSession session;
	  @Autowired
	  private CmsCulturalSquareService squareInformService;
	  /**
	   * 跳转到添加广场通知页面
	   * @param request
	   * @return
	   */
	@RequestMapping(value="/preSquareInform",method=RequestMethod.GET)
	public String preSquareInform(HttpServletRequest request){
		 request.setAttribute("user", session.getAttribute("user"));
	   return "admin/squareInform/addSquareInform";
	}
	/**
	 * 新增广场通知
	 * @param cmsCulturalSquare
	 * @return
	 */
	@RequestMapping(value="/addSquareInform",method=RequestMethod.POST)
	@ResponseBody
	public String addSquareInform(CmsCulturalSquare cmsCulturalSquare ){
		try {
    		
	  		  SysUser user = (SysUser) session.getAttribute("user");
	            if(user==null){
	                return "login";
	            }
	      int count=squareInformService.addSquareInform(cmsCulturalSquare);
			} catch (Exception e) {
				e.printStackTrace();
				return "failure";
			}
		
		return "success";
	}
	/**
	 * 广场通知列表
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/squareInformList")
	public ModelAndView squareInformList( Pagination page,CmsCulturalSquare cmsCulturalSquare){
		ModelAndView model=new ModelAndView();
		List<CmsCulturalSquare> list=squareInformService.querySquareInformList(page,cmsCulturalSquare);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("squareInform", cmsCulturalSquare);
		model.setViewName("admin/squareInform/squareInformList");
	   return model;
	}
	/**
	 * 跳转编辑页面
	 * @param request
	 * @param squareId
	 * @return
	 */
	@RequestMapping(value="/editSquareInform",method=RequestMethod.GET)
	public String editSquareInform(HttpServletRequest request,@RequestParam String squareId){
		if (StringUtils.isNotBlank(squareId)) {
			CmsCulturalSquare squareInform=squareInformService.selectByPrimaryKey(squareId);
			request.setAttribute("squareInform", squareInform);
        }
      
	   return "admin/squareInform/editSquareInform";
	}
	/**
	 * 修改广场通知
	 * @param cmsCulturalSquare
	 * @param request
	 * @return
	 */
	@RequestMapping("/updateSquareInform")
	@ResponseBody
	public  String updateSquareInform(CmsCulturalSquare cmsCulturalSquare, HttpServletRequest request){
		
		 try {
			    SysUser user = (SysUser) session.getAttribute("user");
	            if(user==null){
	                return "login";
	            }
	            cmsCulturalSquare.setPublishTime(new Date());
	            return squareInformService.updateByPrimaryKeySelective(cmsCulturalSquare);
	        } catch (Exception e) {
	            this.logger.error("update error {}", e);
	            return "error" + e.toString();
	        }
	}
	/**
	 * 
	 * @param request
	 * @param squareId
	 */
	@RequestMapping("/deleteSquareInform")
	@ResponseBody 
	public String deleteSquareInform(HttpServletRequest request,@RequestParam String squareId){
		
		try{
			 int flag=squareInformService.deleteSquareInform(squareId);
			 if (flag!=1) {
				return "failure";
			}
		} catch (Exception e) {
			this.logger.error("update error {}", e);
			return "failure";
		}
		return "success";
	}
	
}
