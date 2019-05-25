package com.sun3d.why.controller;

import com.sun3d.why.model.CmsAntiqueType;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsAntiqueTypeService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Administrator on 2015/7/20.
 * 藏品类型维护
 */
@RequestMapping("/antiqueType")
@Controller
public class CmsAntiqueTypeController  {

    private Logger logger = LoggerFactory.getLogger(CmsAntiqueTypeController.class);

    @Autowired
    private CmsAntiqueTypeService  cmsAntiqueTypeService;

    @Autowired
    private CmsVenueService cmsVenueService;

    @Autowired
    private HttpSession session;

    @RequestMapping("/index")
    public ModelAndView index(Pagination page,CmsAntiqueType record){
        ModelAndView model = new ModelAndView();
        model.setViewName("admin/antiqueType/antiqueTypeIndex");
        try{
            SysUser  user = (SysUser) session.getAttribute("user");
            if(null==user){
                return model;
            }
            List<CmsAntiqueType> dataList =  cmsAntiqueTypeService.queryByConditions(record, page,user);
            model.addObject("dataList",dataList);
        }catch (Exception e){
            e.printStackTrace();
        }
        model.addObject("page",page);
        return model;
    }

    @RequestMapping("/preAddAntiqueType")
    public ModelAndView preAddAntiqueType(String venueId){
        ModelAndView model = new ModelAndView();
        if(!StringUtils.isNotBlank(venueId)){
            return  model;
        }
        model.addObject("venueId",venueId);
        model.setViewName("admin/antiqueType/addAntiqueType");
        return  model;
    }


    @RequestMapping("/addAntiqueType")
    @ResponseBody
    public String addAntiqueType(CmsAntiqueType  record){
        SysUser user = (SysUser) session.getAttribute("user");
        if(user==null){
            return Constant.RESULT_STR_FAILURE;
        }
        try{
            String[] typeArr = record.getAntiqueTypeName().split(";");
            if(typeArr.length>1){
                List<CmsAntiqueType> typeList = new ArrayList<CmsAntiqueType>();
                CmsAntiqueType myRecord =  null;
                for (String name:typeArr){

                    if (StringUtils.isNotBlank(name)){
                        myRecord = new CmsAntiqueType();

                        myRecord.setAntiqueTypeId(UUIDUtils.createUUId());
                        myRecord.setAntiqueTypeName(name);
                        myRecord.setVenueId(record.getVenueId());
                        myRecord.setCreateTime(new Date());
                        myRecord.setCreateUser(user.getUserId());
                        myRecord.setUpdateTime(new Date());
                        myRecord.setUpdateUser(user.getUserId());

                        typeList.add(myRecord);
                    }else{
                        continue;
                    }
                }
                cmsAntiqueTypeService.addBatch(typeList);
            }else{
                record.setAntiqueTypeId(UUIDUtils.createUUId());
                record.setCreateTime(new Date());
                record.setCreateUser(user.getUserId());
                record.setUpdateTime(new Date());
                record.setUpdateUser(user.getUserId());
                cmsAntiqueTypeService.addAntiqueType(record);
            }
            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            e.printStackTrace();
            return  Constant.RESULT_STR_FAILURE;
        }

    }


    @RequestMapping("/preEditAntiqueType")
    public ModelAndView preEditAntiqueType(String antiqueTypeId){

        CmsAntiqueType EditRecord = cmsAntiqueTypeService.queryById(antiqueTypeId);
        CmsVenue cmsVenue = cmsVenueService.queryVenueById(EditRecord.getVenueId());

        ModelAndView model = new ModelAndView();
        model.addObject("EditRecord",EditRecord);
        model.addObject("cmsVenue",cmsVenue);
        model.setViewName("admin/antiqueType/editAntiqueType");
        return model;
    }

    @RequestMapping("/editAntiqueType")
    @ResponseBody
    public String updateAntiqueType(CmsAntiqueType record){
        SysUser user = (SysUser) session.getAttribute("user");
        if(user==null){
            return Constant.RESULT_STR_FAILURE;
        }
        try{
            record.setUpdateTime(new Date());
            record.setUpdateUser(user.getUserId());
            cmsAntiqueTypeService.updateById(record);
            return  Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            e.printStackTrace();
        }
        return Constant.RESULT_STR_FAILURE;

    }


    //根据场馆id查询藏品类型
    @RequestMapping("/getTypeList")
    @ResponseBody
    public List<CmsAntiqueType> getCmsAntiqueTypeList(String venueId){
        SysUser user = new SysUser();
        if(user == null || StringUtils.isBlank(venueId)){
            return new ArrayList<CmsAntiqueType>();
        }
        CmsAntiqueType type = new CmsAntiqueType();
        type.setVenueId(venueId);
        return cmsAntiqueTypeService.queryByVenueId(type,user);
    }



}
