package com.sun3d.why.controller;

import com.github.pagehelper.PageInfo;
import com.sun3d.why.model.app.AppImageOfOpen;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.AppSetImageWithStartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;

/**
 * Created by ct on 2017/3/6.
 */
//
//insert into sys_module(module_id,module_name,module_url,module_parent_id,module_state,module_sort)
//        values('34ed6a2fc69830a1603e4220eb222bff','app开机画面','${path}/app/picWithOpen.do','d3b1fb632c9248b1a69d814778f9e3da',1,121)
//
//        insert into sys_role_module(role_id,module_id)
//        values('340156d716bc49f58105a8ed626ebd75','34ed6a2fc69830a1603e4220eb222bff')

@Controller
@RequestMapping("/app")
public class AppStartImageController
{

    @Autowired
    AppSetImageWithStartService imageService;

    @Autowired
    private StaticServer staticServer;

    @RequestMapping("picWithOpen.do")
    public String templateIndex(@RequestParam(defaultValue = "1",required = false) Integer page,
                                @RequestParam(defaultValue = "",required = false) String city,
                                ModelMap model)
    {
        try
        {
            if(city.equals(""))
            {
                city = staticServer.getCityInfo().split(",")[3]+","+staticServer.getCityInfo().split(",")[1];
            }
            else
            {
                city = new String(city.getBytes("iso-8859-1"), "utf-8");
            }
            HashMap<String, String> map = new HashMap<>();
            map.put("city", city);
            map.put("page", page + "");
            List<AppImageOfOpen> imageList = imageService.selectAppImageList(map);
            model.put("OpenImageList", imageList);
            //model.put("IMGURL",imageService.getStaticServerUrl());
            PageInfo p = new PageInfo(imageList);
            model.put("Page", p);
            model.put("city", city);
            model.put("IMGHOST",staticServer.getStaticServerUrl());
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return "admin/app/picWithOpen";
    }


    @RequestMapping("delImage.do")
    @ResponseBody
    public String delImage(@RequestParam(required = true) Integer imageid)
    {

        try
        {
            imageService.delAppImage(imageid);
            return "1";
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return "0";
        }

    }

    @RequestMapping("setDefaultImage.do")
    @ResponseBody
    public String setDefaultImage( @RequestParam(defaultValue = "",required = false) String city,
            @RequestParam(required = true) Integer imageid)
    {

        try
        {
            city = new String(city.getBytes("iso-8859-1"), "utf-8");
            HashMap<String, String> map = new HashMap<>();
            map.put("city", city);
            map.put("imageid", imageid + "");
            imageService.setDefaultOpenImage(map);
            return "1";
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return "0";
        }

    }



    @RequestMapping("imagedetail.do")
    public String imagedetail(@RequestParam(defaultValue = "0",required = false) String imageid,
                              ModelMap model)
    {

        int id = Integer.parseInt(imageid);
        AppImageOfOpen image = null;
        if(id >0)
        {
            image = imageService.selectAppImage(id);

        }else
        {
            image = new AppImageOfOpen();
        }
        model.put("OpenImage",image);
        return "admin/app/imagedetail";

    }


//    imageid:
//    city:45,上海市
//    headImgUrl_retina:
//    uploadType_retina:Img
//    headImgUrl_normal:
//    uploadType_normal:Img
//    startDate:
//    endDate:
//    isDefaultImage:on

    @RequestMapping("updateImage")
    @ResponseBody
    public String updateActivityTopic(@RequestParam(defaultValue = "",required = false) String imageid,
                                      @RequestParam(defaultValue = "",required = false) String city,
                                      @RequestParam(defaultValue = "",required = false) String startDate,
                                      @RequestParam(defaultValue = "",required = false) String endDate,
                                      @RequestParam(defaultValue = "0",required = false) String isDefaultImage,
                                      @RequestParam(defaultValue = "",required = false) String headImgUrl_retina,
                                      @RequestParam(defaultValue = "",required = false) String headImgUrl_normal
                                     )
    {
        int id = 0;
        if(imageid!=null && !imageid.equals(""))
        {
            id = Integer.parseInt(imageid);
        }

        AppImageOfOpen image = new AppImageOfOpen();
        image.setCity(city);
        image.setImageurl_normal(headImgUrl_normal);
        image.setImageurl_retina(headImgUrl_retina);
        if(startDate != null && !startDate.equals(""))
            image.setStartDate(Date.valueOf(startDate));
        if(endDate != null && !endDate.equals(""))
            image.setEndDate( Date.valueOf(endDate));
        image.setStatus(1);
        image.setIsDefaultImage(0);
        if(isDefaultImage.equals("on"))
        {
            image.setIsDefaultImage(1);
        }
        try
        {
            if (id == 0)
            {
                imageService.insertAppImage(image);
            } else
            {
                image.setImageid(id);
                imageService.updateAppImage(image);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return "-1";
        }
        return ""+image.getImageid();
    }
}
