package com.sun3d.why.controller;


import com.alibaba.fastjson.JSONArray;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by yujinbing on 2015/4/29.
 */
@RequestMapping("/dept")
@Controller
public class CmsDeptController {

    private Logger logger = LoggerFactory.getLogger(CmsUserController.class);

    @Autowired
    private CmsDeptService cmsDeptService;
    @Autowired
    private CmsUserService cmsUserService;
    @Autowired
    private CmsVenueService cmsVenueService;
    @Autowired
    private CmsAntiqueService cmsAntiqueService;
    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;
    @Autowired
    private HttpSession session;
    @Autowired
    private SysDeptService sysDeptService;

    /**
     * 进入部门页面
     * @param request
     * @return
     */
    @RequestMapping(value = "/deptIndex",  method = {RequestMethod.GET})
    public String deptIndex(HttpServletRequest request){
        return "admin/dept/deptIndex";
    }

    /**
     *页面异步获取部门信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/getDeptList",  method = {RequestMethod.POST})
    @ResponseBody
    public String getDeptList(HttpServletRequest request){
        SysUser user = (SysUser)session.getAttribute("user");
        Map map = new HashMap();
        map.put("deptState", 1);
        map.put("deptPath", user.getUserDeptPath() + "%");
        List<SysDept> list = this.cmsDeptService.querySysDeptByMap(map);
        JSONArray jsonArray = new JSONArray();
        jsonArray.add(list);
        String rs = jsonArray.toJSONString();
        this.logger.debug("jsonArray value {}", jsonArray.toString() );
        rs =  rs.substring(1,rs.length() - 1);
        return  rs;
    }
    
    /**
     *页面异步获取部门信息(包括同级)
     * @param request
     * @return
     */
    @RequestMapping(value = "/getBroDeptList",  method = {RequestMethod.POST})
    @ResponseBody
    public String getBroDeptList(HttpServletRequest request){
        SysUser user = (SysUser)session.getAttribute("user");
        Map map = new HashMap();
        map.put("deptState", 1);
        if(!user.getUserDeptPath().contains(".")){
        	map.put("deptPath", user.getUserDeptPath() + "%");
        }else{
        	int i=user.getUserDeptPath().lastIndexOf(".");
        	map.put("deptPath", user.getUserDeptPath().substring(0,i) + "%");
        }
        List<SysDept> list = this.cmsDeptService.querySysDeptByMap(map);
        JSONArray jsonArray = new JSONArray();
        jsonArray.add(list);
        String rs = jsonArray.toJSONString();
        this.logger.debug("jsonArray value {}", jsonArray.toString() );
        rs =  rs.substring(1,rs.length() - 1);
        return  rs;
    }

    /**
     * 部门修改保存以及新建
     * @param request
     * @param id
     * @param name
     * @param pId
     * @return
     */
    @RequestMapping(value = "/updateDept",  method = {RequestMethod.GET})
    @ResponseBody
    public Map updateDept( HttpServletRequest request,String id, String  name,String pId){
        SysUser loginUser = (SysUser)session.getAttribute("user");
        try {
           return  this.cmsDeptService.updateSysDept(id,name,pId,loginUser);
        } catch (Exception e) {
            e.printStackTrace();

            return null;
        }
    }

//    /**
//     * 部门保存
//     * @param id
//     * @param name
//     * @param pId
//     * @return
//     */
//    @RequestMapping(value = "/saveDept",  method = {RequestMethod.GET})
//    @ResponseBody
//    public String saveDept( String id, String  name,String pId){
//        String uId = UUIDUtils.createUUId();
//        SysDept sysDept = new SysDept();
//        sysDept.setDeptState(1);
//        sysDept.setDeptName(name);
//        sysDept.setDeptParentId(pId);
//        sysDept.setDeptCreateTime(new Date());
//        sysDept.setDeptId(uId);
//        sysDept.setDeptUpdateTime(new Date());
//        sysDept.setDeptUpdateUser("sys");
//        sysDept.setDeptCreateUser("sys");
//        sysDept.setDeptShortName(name);
//        int count = this.cmsDeptService.addSysDept(sysDept);
//        if (count == 1) {
//            return  "success";
//        } else {
//            return  "error";
//        }
//    }

    /**
     * 修改部门排序
     * @param id
     * @param type
     * @param pId
     * @return
     */
    @RequestMapping(value = "/updateDeptSort",  method = {RequestMethod.GET})
    @ResponseBody
    public String updateDeptSort( String id, String  type,String pId){
        SysDept sysDept = this.cmsDeptService.querySysDeptByDeptId(id);
        SysDept sysDept2 = this.cmsDeptService.querySysDeptByDeptId(pId);
        int currentSort = sysDept.getDeptSort() == null ? 0 :sysDept.getDeptSort();
        int changeSort = sysDept2.getDeptSort() == null ? 0 : sysDept2.getDeptSort();
        // type = -1 代表上下移   1 代表像上移
        if ("1".equals(type)) {
            sysDept.setDeptSort(changeSort);
            sysDept2.setDeptSort(currentSort);
        } else {
            sysDept.setDeptSort(changeSort);
            sysDept2.setDeptSort(currentSort);
        }
        int count = this.cmsDeptService.editSysDept(sysDept);
        count = this.cmsDeptService.editSysDept(sysDept2);
        if (count == 1) {
            return  "success";
        } else {
            return  "error";
        }
    }


    /**
     * 删除部门
     * @param id
     * @param name
     * @return
     */
    @RequestMapping(value = "/deleteDept",  method = {RequestMethod.GET})
    @ResponseBody
    public String deleteDept( String id, String  name){
        SysDept dept = this.cmsDeptService.querySysDeptByDeptId(id);
        SysUser sysUser = new SysUser();
        sysUser.setUserDeptId(id);
        //查询这个部门下面是否存在用户  如果存在进行提示不能进行删除
        List<SysUser> userList = this.cmsUserService.querySysUserByCondition(sysUser);
        if (userList != null && userList.size() > 0) {
            return "部门下存在用户,不能进行删除";
        }

        int count = 0;
        CmsVenue cmsVenue = cmsVenueService.queryVenueByVenueDeptId(id);
        Map<String,Object> map = new HashMap<String,Object>();
        if(cmsVenue!=null){
            //场馆下有效的活动数
            map.put("activityState", Constant.PUBLISH);
            map.put("activityIsDel", Constant.NORMAL);
            map.put("venueId", cmsVenue.getVenueId());
            count =  cmsVenueService.queryVenueOfActivityCountByVenueId(map);
            if(count>0){
                return "该部门对应的场馆下存在活动，不能删除";
            }
            //场馆下的藏品数
            map.put("antiqueState", Constant.PUBLISH);
            map.put("antiqueIsDel", Constant.NORMAL);
            map.put("venueId", cmsVenue.getVenueId());
            count = cmsAntiqueService.countAntique(map);
            if(count>0){
                return "该部门对应的场馆下存在藏品，不能删除";
            }
            map.put("bookStatus", Constant.DELETE);
            map.put("venueId", cmsVenue.getVenueId());
            count = cmsActivityOrderService.queryCountRoomOrderOfVenue(map);
            if(count>0){
                return "该部门对应的场馆下有活动室已被预订，不能删除";
            }
            //删除至回收站
            cmsVenueService.updateStateByVenueIds(cmsVenue.getVenueId(), "");
        }
        dept.setDeptState(2);
        int editCount = this.cmsDeptService.editSysDept(dept);
        if (editCount == 1) {
            return  "success";
        } else {
            return  "error";
        }
    }

    /**
     * 获取列表信息
     *
     * @return
     */
    @RequestMapping(value = "/queryAreaList")
    @ResponseBody
    public List<SysDept> queryAreaList(String pid,String grade) {
        List<SysDept> list = new ArrayList<SysDept>();
        list = sysDeptService.queryAreaList(pid,grade);
        return list;
    }

}
