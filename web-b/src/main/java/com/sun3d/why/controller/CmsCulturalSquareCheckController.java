package com.sun3d.why.controller;

import java.text.ParseException;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.square.CmsCulturalSquare;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCulturalSquareCheckService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping("/culturalSquare")
@Controller
public class CmsCulturalSquareCheckController {
	
	@Autowired
	private CmsCulturalSquareCheckService cmsCulturalSquareCheckService;
	
	@Autowired
	private HttpSession session;
	
	/**
	 * 广场审核列表首页
	 * @param page
	 * @param cmsCulturalSquare
	 * @return
	 * @throws ParseException 
	 */
    @RequestMapping("/culturalSquareIndex")
	public ModelAndView culturalSquareIndex(Pagination page,CmsCulturalSquare cmsCulturalSquare) throws ParseException{
		
		ModelAndView model = new ModelAndView();
		List<CmsCulturalSquare> list = cmsCulturalSquareCheckService.querySquareList(page,cmsCulturalSquare);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("squareInform", cmsCulturalSquare);
		model.setViewName("admin/culturalSquareCheckList/culturalSquareIndex");
	    return model;
	}
	
    /**
     * 置顶/取消置顶
     * @param cmsCulturalSquare
     * @return
     */
    @RequestMapping("/stick")
    @ResponseBody
    public String stick(CmsCulturalSquare cmsCulturalSquare){
    	try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {
				int result = cmsCulturalSquareCheckService.setMessageTop(cmsCulturalSquare, sysUser);
				if (result > 0) {
					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.RESULT_STR_FAILURE;
				}
			} else
				return "login";
		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}
    }
    
    /**
     * 审核通过
     * @param squareId
     * @return
     */
    @RequestMapping("/checkPass")
    @ResponseBody
    public String checkPass(String squareId){
    	try {
			String[] ImgId = squareId.split(",");
			int rs=0;
			for (String id : ImgId) {
				CmsCulturalSquare cmsCulturalSquare = cmsCulturalSquareCheckService.queryCulturalSquareById(id);
				if(cmsCulturalSquare.getStatus() == 0 || cmsCulturalSquare.getStatus() == 2){
					cmsCulturalSquare.setStatus(1);;
					rs=cmsCulturalSquareCheckService.update(cmsCulturalSquare);
				}
			}
			return Constant.RESULT_STR_SUCCESS;
		} catch (Exception e) {
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
    }
    
    /**
     * 审核不通过
     * @param squareId
     * @return
     */
    @RequestMapping("/checkNoPass")
    @ResponseBody
    public String checkNoPass(String squareId){
    	try {
			String[] ImgId = squareId.split(",");
			for (String id : ImgId) {
				CmsCulturalSquare cmsCulturalSquare = cmsCulturalSquareCheckService.queryCulturalSquareById(id);
				cmsCulturalSquare.setStatus(2);
				cmsCulturalSquareCheckService.update(cmsCulturalSquare);
			}
			return Constant.RESULT_STR_SUCCESS;
		} catch (Exception e) {
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
    }
    
	
}
