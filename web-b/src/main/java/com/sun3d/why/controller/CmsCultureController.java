package com.sun3d.why.controller;

import com.sun3d.why.model.CmsCulture;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.service.CmsCultureService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * Created by Administrator on 2015/8/15.  非遗后台
 */
@RequestMapping("/culture")
@Controller
public class CmsCultureController {

    @Autowired
    private CmsCultureService  cmsCultureService;

    @Autowired
    private HttpSession session;

    /**
     * 列表页面
     * @param culture
     * @param page
     * @param areaData
     * @return
     */
    @RequestMapping("/getList")
    public ModelAndView getList(CmsCulture culture, Pagination page,String areaData){

        ModelAndView model = new ModelAndView();
        /**
         * 根据状态返回列表页面
         */
        if(culture.getCultureState().equals(1)){
            model.setViewName("admin/culture/cultureIndex");
        }else if(culture.getCultureState().equals(2)){
            model.setViewName("admin/culture/cultureDraft");
        }else if(culture.getCultureState().equals(3)){
            model.setViewName("admin/culture/cultureRecycle");
        }else{
            culture.setCultureState(1);
            model.setViewName("admin/culture/cultureIndex");
        }
        SysUser sysUser = (SysUser) session.getAttribute("user");
        if(sysUser==null){
            return  model;
        }
        List<CmsCulture> cultureList = cmsCultureService.queryByConditions(culture, page, sysUser,areaData, null);
        model.addObject("areaData",areaData);
        model.addObject("dataList", cultureList);
        model.addObject("page", page);
        model.addObject("c", culture);
        return model;
    }

    @RequestMapping("/toAdd")
    public String toAdd(){
            return "admin/culture/cultureAdd";
    }

    @RequestMapping("/addCulture")
    @ResponseBody
    public String addCulture(CmsCulture culture){
       try{
           SysUser user = (SysUser) session.getAttribute("user");
           if(user==null){
               return  Constant.RESULT_STR_FAILURE;
           }
           culture.setCultureId(UUIDUtils.createUUId());
           culture.setCreateTime(new Date());
           culture.setCreateUser(user.getUserId());
           culture.setUpdateUser(user.getUserId());
           culture.setUpdateTime(new Date());
           cmsCultureService.addCmsCulture(culture);
           return Constant.RESULT_STR_SUCCESS;
       }catch (Exception e){
            e.printStackTrace();
       }
       return Constant.RESULT_STR_FAILURE;
    }


    @RequestMapping("/toEdit")
    public ModelAndView toEdit(String id){
        ModelAndView model  = new ModelAndView();
        CmsCulture culture = cmsCultureService.queryById(id);
        model.addObject("c",culture);
        model.setViewName("admin/culture/cultureEdit");
        return model;
    }


    @RequestMapping(value = "/editCulture",method = RequestMethod.POST)
    @ResponseBody
    public String editCulture(CmsCulture culture){
        try{
            SysUser user = (SysUser) session.getAttribute("user");
            if(user==null){
                return Constant.RESULT_STR_FAILURE;
            }
            culture.setUpdateUser(user.getUserId());
            culture.setUpdateTime(new Date());
            cmsCultureService.updateCmsCulture(culture);
            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            e.printStackTrace();
        }
        return Constant.RESULT_STR_FAILURE;
    }


    //删除
    @RequestMapping("/updateState")
    @ResponseBody
    public String updateState(String id,String state){
        try{
            SysUser user = (SysUser) session.getAttribute("user");
            if(user==null){
                return Constant.RESULT_STR_FAILURE;
            }
            CmsCulture c = new CmsCulture();
            c.setCultureId(id);
            c.setCultureState(Integer.parseInt(state));
            c.setUpdateUser(user.getUserId());
            c.setUpdateTime(new Date());
            cmsCultureService.updateCmsCulture(c);
            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            e.printStackTrace();
        }
        return Constant.RESULT_STR_FAILURE;
    }


    //删除
    @RequestMapping("/delete")
    @ResponseBody
    public String delete(String id){
        try{
            SysUser user = (SysUser) session.getAttribute("user");
            if(user==null){
                return Constant.RESULT_STR_FAILURE;
            }
            cmsCultureService.delete(id);
            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            e.printStackTrace();
        }
        return Constant.RESULT_STR_FAILURE;

    }


    //获取现有数据列表的所有区县
    @RequestMapping("/getArea")
    @ResponseBody
    public List<Object> getArea(){
        List<Object> datas = new ArrayList<Object>();
        try{
            List<CmsCulture> dataList = cmsCultureService.queryArea(new HashMap<String, Object>());
            AreaData area = null;
            String [] arr=null;
            for(CmsCulture c:dataList){
                arr = c.getCultureArea().split(",");
                area = new AreaData();
                area.setId(arr[0]);
                area.setText(arr[1]);
                datas.add(area);
            }
            return datas;
        }catch (Exception e){
            e.printStackTrace();
        }
        return datas;
    }



}
