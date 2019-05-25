package com.sun3d.why.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.dao.SysDeptMapper;
import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysShareDept;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.SysShareDeptService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@RequestMapping(value = "/shareDept")
@Controller
public class SysShareDeptController {

    private Logger logger = Logger.getLogger(SysShareDeptController.class);
    
    @Autowired
    private HttpSession session;
    
    @Autowired
    private SysShareDeptService sysShareDeptService;
    
    @Autowired
    private SysDeptMapper sysDeptMapper;
    
    /**
     * 信息共享列表页
     *
     * @param page
     * @return
     */
    @RequestMapping("/shareDeptIndex")
    public ModelAndView shareDeptIndex(Pagination page) {
        ModelAndView model = new ModelAndView();
        List<SysShareDept> list = null;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                list = sysShareDeptService.queryShareDeptBySourceDeptId(sysUser.getUserDeptId(),page);
        	}
            model.addObject("page", page);
            model.addObject("list", list);
            model.addObject("page", page);
            model.setViewName("admin/shareDept/shareDeptIndex");
        } catch (Exception e) {
            logger.error("shareDeptIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 跳转至互动添加页面
     * @param request
     * @return
     */
    @RequestMapping(value = "/preAddShareDept")
    public String preAddShareDept(HttpServletRequest request) {
        return "admin/shareDept/addShareDept";
    }
    
    /**
     * 添加共享信息
     * @param targetDeptid     
     * return 是否添加成功 (成功：1；失败：-1)
     */
    @RequestMapping(value = "/addShareDept")
    @ResponseBody
    public int addShareDept(String targetDeptid) throws Exception {
    	int result = 0;
    	try {
    		SysUser sysUser = (SysUser) session.getAttribute("user");
	    	if(sysUser != null){
	    		SysShareDept sysShareDept = new SysShareDept();
	    		SysDept sysDept = null;
	    		if(targetDeptid!=null){
	    			sysShareDept.setTargetDeptid(targetDeptid);
	    			sysDept = sysDeptMapper.querySysDeptByDeptId(sysUser.getUserDeptId());
	    		}
    			sysShareDept.setSourceDeptid(sysUser.getUserDeptId());
    			List<SysShareDept> list = sysShareDeptService.queryShareDeptByCondition(sysShareDept);
    			if(list.size()>0){
    				sysShareDept.setShareId(list.get(0).getShareId());
    				sysShareDept.setShareDepthPath(sysDept.getDeptPath());
    				sysShareDept.setIsShare(1);
    				sysShareDept.setUpdateUserId(sysUser.getUserId());
        			sysShareDept.setUpdateTime(new Date());
        			result = sysShareDeptService.editBySysShareDept(sysShareDept);
    			}else{
    				sysShareDept.setShareId(UUIDUtils.createUUId());
    				sysShareDept.setShareDepthPath(sysDept.getDeptPath());
        			sysShareDept.setIsShare(1);
        			sysShareDept.setUpdateUserId(sysUser.getUserId());
        			sysShareDept.setUpdateTime(new Date());
        			result = sysShareDeptService.addSysShareDept(sysShareDept);
    			}
    		}
    	} catch (Exception e) {
            logger.error("cancelShareDept error {}", e);
        }
        return result;
    }
    
    /**
     * 取消共享信息
     * @param shareId     
     * return 是否取消成功 (成功：1；失败：-1)
     */
    @RequestMapping(value = "/cancelShareDept")
    @ResponseBody
    public int cancelShareDept(String shareId) throws Exception {
    	int result = 0;
    	try {
    		SysShareDept sysShareDept = new SysShareDept();
    		if(shareId!=null){
    			sysShareDept.setShareId(shareId);
    			sysShareDept.setIsShare(2);
    		}
    		result = sysShareDeptService.editBySysShareDept(sysShareDept);
    	} catch (Exception e) {
            logger.error("cancelShareDept error {}", e);
        }
        return result;
    }
    
}
