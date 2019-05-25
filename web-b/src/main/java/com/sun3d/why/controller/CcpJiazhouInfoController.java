package com.sun3d.why.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.CcpJiazhouInfo;
import com.sun3d.why.service.CcpJiazhouInfoService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping(value = "/jiazhouInfo")
@Controller
public class CcpJiazhouInfoController {
	private Logger logger = LoggerFactory
			.getLogger(CcpJiazhouInfoController.class);
	@Autowired
	private CcpJiazhouInfoService jiazhouInfoService;
	@Autowired
	private HttpSession session;

	/**
	 * 加载列表页面
	 * 
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/jiazhouInfoList")
	public ModelAndView jiazhouInfoList(CcpJiazhouInfo jiazhouInfo, Pagination page) {
		ModelAndView model = new ModelAndView();
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			List<CcpJiazhouInfo> jiazhouInfoLists = jiazhouInfoService.jiazhouInfoList(jiazhouInfo, page, sysUser);
			model.addObject("jiazhouInfo", jiazhouInfo);
			model.addObject("jiazhouInfoLists", jiazhouInfoLists);
            model.addObject("page", page);
			model.setViewName("admin/jiazhouInfo/jiazhouInfoList");
		} catch (Exception e) {
			logger.error("jiazhouInfoList error {}", e);
		}
		return model;
	}

	/**
	 * 跳转到添加资讯页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/add")
	public ModelAndView add() {
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/jiazhouInfo/addjiazhouInfo");
		return model;
	}

	/**
	 * 添加资讯
	 * 
	 * @param CcpJiazhouInfo
	 * @return
	 */
	@RequestMapping(value = "/addJiazhouInfo")
	@ResponseBody
	public String addJiazhouInfo(CcpJiazhouInfo jiazhouInfo) {
	    try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            String result;
            if(sysUser!=null){
                result=jiazhouInfoService.addJiazhouInfo(jiazhouInfo, sysUser);
                return result;
            }else{
                result="noLogin";
                return result;
            }
        } catch (Exception e) {
            logger.info("addActivityEditorial error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
	}

	/**
	 * 编辑资讯跳转页面
	 * 
	 * @param recruitId
	 * @return
	 */
	   @RequestMapping("/preAddjiazhouInfo")
	    public ModelAndView preAddjiazhouInfo(String jiazhouInfoId) {
	        ModelAndView model = new ModelAndView();
	        try {
	            model.addObject("jiazhouInfoId", jiazhouInfoId);
	            model.setViewName("admin/jiazhouInfo/addjiazhouInfo");
	        } catch (Exception e) {
	            logger.error("preAddjiazhouInfo error {}", e);
	        }
	        return model;
	    }
	   
	    /**
	     * 根据id读取咨询
	     *
	     * @return
	     */
	    @RequestMapping(value = "/getJiazhouInfo")
	    @ResponseBody
	    public CcpJiazhouInfo getJiazhouInfo(String jiazhouInfoId) {
	        try {
	            return jiazhouInfoService.getJiazhouInfo(jiazhouInfoId);
	        } catch (Exception e) {
	            logger.info("getJiazhouInfo error {}", e);
	        }
	        return null;
	    }
	    
	    /**
	     * 根据编码读取分类
	     *
	     * @return
	     */
	    @RequestMapping(value = "/getJiazhouInfoSortList")
	    @ResponseBody
	    public Map<String, Object> getJiazhouInfoSortList(String dictCode) {
	    	Map<String, Object> result = new HashMap<String, Object>();
	        try {
	        	List<Map<String, Object>> dataList=jiazhouInfoService.getJiazhouInfoSortList(dictCode);
	            result.put("data", dataList);
				return result;
	        } catch (Exception e) {
	        	e.printStackTrace();
				result.put("data", e.getMessage());
	        }
	        return result;
	    }
	    
		/**
		 * 编辑资讯跳转页面
		 * 
		 * @param recruitId
		 * @return
		 */
		   @RequestMapping("/delJiazhouInfo")
		   @ResponseBody
		    public String delJiazhouInfo(String jiazhouInfoId) {
		    try {
		         SysUser sysUser = (SysUser) session.getAttribute("user");
		             if(sysUser!=null){
		            	 jiazhouInfoService.delJiazhouInfo(jiazhouInfoId);
		                 return Constant.RESULT_STR_SUCCESS;
		             }else{
		            	 return "noLogin";		               
		             }		        		        	
		        } catch (Exception e) {
		            logger.error("delJiazhouInfo error {}", e);
		            return Constant.RESULT_STR_FAILURE;
		        }		        
		    }
		   
}
