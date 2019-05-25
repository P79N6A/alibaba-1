package com.sun3d.why.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.dao.ccp.CcpPoemLectorMapper;
import com.sun3d.why.dao.ccp.CcpPoemMapper;
import com.sun3d.why.model.ccp.CcpPoem;
import com.sun3d.why.model.ccp.CcpPoemLector;
import com.sun3d.why.model.ccp.CcpPoemUser;
import com.sun3d.why.service.CcpPoemService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/poem")
@Controller
public class CcpPoemController {

	@Autowired
	private CcpPoemService ccpPoemService;
	@Resource
    private CcpPoemLectorMapper ccpPoemLectorMapper;
	@Resource
	private CcpPoemMapper ccpPoemMapper;
	
	@Autowired
	private HttpSession session;
	

	/**********************************************讲师管理**********************************************************/
	
	/**
     * 跳转到讲师页面
     * @return
     */
	@RequestMapping("/poemLectorIndex")
	public ModelAndView poemLectorIndex(CcpPoemLector ccpPoemLector, Pagination page) {
		ModelAndView model = new ModelAndView();
		List<CcpPoemLector> list = ccpPoemService.queryPoemLectorByCondition(ccpPoemLector, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", ccpPoemLector);
		model.setViewName("admin/poem/poemLectorIndex");
		return model;
	}

	/**
     * 跳转到讲师添加页面
     * @return
     */
    @RequestMapping("/preAddPoemLector")
    public String preAddPoemLector() {
        return "admin/poem/addPoemLector";
    }
    
    /**
     * 跳转到讲师编辑页面
     * @return
     */
    @RequestMapping("/preEditPoemLector")
    public String preEditPoemLector(HttpServletRequest request, String lectorId) {
    	if (StringUtils.isNotBlank(lectorId)) {
    		CcpPoemLector ccpPoemLector = ccpPoemLectorMapper.selectByPrimaryKey(lectorId);
            request.setAttribute("poemLector", ccpPoemLector);
        }
    	return "admin/poem/editPoemLector";
    }
    
    /**
     * 保存或更新讲师信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveOrUpdatePoemLector")
    @ResponseBody
    public String saveOrUpdatePoemLector(HttpServletRequest request,CcpPoemLector ccpPoemLector) {
        return ccpPoemService.saveOrUpdatePoemLector(ccpPoemLector);
    }
    
    /**
     * 删除讲师
     * @param request
     * @return
     */
    @RequestMapping(value = "/deletePoemLector")
    @ResponseBody
    public String deletePoemLector(HttpServletRequest request,String lectorId) {
        return ccpPoemService.deletePoemLector(lectorId);
    }
    
    /**********************************************每日一诗管理**********************************************************/
    
    /**
     * 跳转到每日一诗页面
     * @return
     */
	@RequestMapping("/poemIndex")
	public ModelAndView poemIndex(CcpPoem ccpPoem, Pagination page) {
		ModelAndView model = new ModelAndView();
		List<CcpPoem> list = ccpPoemService.queryPoemByCondition(ccpPoem, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", ccpPoem);
		model.setViewName("admin/poem/poemIndex");
		return model;
	}
	
	/**
     * 跳转到每日一诗添加页面
     * @return
     */
    @RequestMapping("/preAddPoem")
    public String preAddPoem() {
        return "admin/poem/addPoem";
    }
    
    /**
     * 跳转到每日一诗编辑页面
     * @return
     */
    @RequestMapping("/preEditPoem")
    public String preEditPoem(HttpServletRequest request, String poemId) {
    	if (StringUtils.isNotBlank(poemId)) {
    		CcpPoem ccpPoem = ccpPoemMapper.selectByPrimaryKey(poemId);
            request.setAttribute("poem", ccpPoem);
        }
    	return "admin/poem/editPoem";
    }
    
    /**
     * 保存或更新每日一诗信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveOrUpdatePoem")
    @ResponseBody
    public String saveOrUpdatePoem(HttpServletRequest request,CcpPoem ccpPoem) {
        return ccpPoemService.saveOrUpdatePoem(ccpPoem);
    }
    
    /**
     * 删除每日一诗
     * @param request
     * @return
     */
    @RequestMapping(value = "/deletePoem")
    @ResponseBody
    public String deletePoem(HttpServletRequest request,String poemId) {
        return ccpPoemService.deletePoem(poemId);
    }
    
    /**
     * 跳转到讲师选择页面
     * @return
     */
	@RequestMapping("/selectLectorIndex")
	public ModelAndView selectLectorIndex(CcpPoemLector ccpPoemLector, Pagination page) {
		ModelAndView model = new ModelAndView();
		List<CcpPoemLector> list = ccpPoemService.queryPoemLectorByCondition(ccpPoemLector, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", ccpPoemLector);
		model.setViewName("admin/poem/selectLectorIndex");
		return model;
	}
	
	/**
     * 刷票
     * @param request
     * @return
     */
    @RequestMapping(value = "/brushWantGo")
    @ResponseBody
    public String brushWantGo(String poemId, Integer count) {
    	return ccpPoemService.brushWantGo(poemId, count);
    }
	
	/**********************************************参与用户管理**********************************************************/
	
	/**
     * 跳转到参与用户页面
     * @return
     */
	@RequestMapping("/poemUserIndex")
	public ModelAndView poemUserIndex(CcpPoemUser ccpPoemUser, Pagination page) {
		ModelAndView model = new ModelAndView();
		List<CcpPoemUser> list = ccpPoemService.queryPoemUserByCondition(ccpPoemUser, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", ccpPoemUser);
		model.setViewName("admin/poem/poemUserIndex");
		return model;
	}
	
}
