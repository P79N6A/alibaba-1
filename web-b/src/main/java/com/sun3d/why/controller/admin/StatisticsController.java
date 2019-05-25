package com.sun3d.why.controller.admin;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.StatisticsSearchParamter;
import com.sun3d.why.service.StatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ct on 2017/4/20.
 */
@Controller
@RequestMapping("/statistics")
public class StatisticsController
{

    @Autowired
    StatisticsService statSrv;

    @RequestMapping(value="/{stattype}Statistic")
    public String pageStatistic(@PathVariable String stattype)
    {
        return "admin/statistics/"+stattype+"Statistic";
    }

    @RequestMapping("getActivityStatisticData")
    @ResponseBody
    public String getActivityStatisticData(StatisticsSearchParamter sp)
    {
        try
        {
            List<Map<String,String>> result = statSrv.getActivityStatic(sp);
            return JSONObject.toJSON(result).toString();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return "";
    }

    @RequestMapping("getVenueStatisticData")
    @ResponseBody
    public String getVenueStatisticData(StatisticsSearchParamter sp)
    {
        try
        {
            List<Map<String,String>> result = statSrv.getVenueStatic(sp);
            return JSONObject.toJSON(result).toString();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return "";
    }


    @RequestMapping("getUserStatisticData")
    @ResponseBody
    public String getUserStatisticData(StatisticsSearchParamter sp)
    {
        try
        {
            List<Map<String,String>> result = statSrv.getUserStatic(sp);
            return JSONObject.toJSON(result).toString();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return "";
    }


    @RequestMapping("venueStatistic")
    public String venueStatistic()
    {
        return "admin/statistics/venueStatistic";
    }

    @RequestMapping("browseStatistic")
    public String browseStatistic()
    {
        return "admin/statistics/browseStatistic";
    }


    @RequestMapping("getVenueBySearchkey")
    @ResponseBody
    public String getVenueBySearchkey(@RequestParam(defaultValue = "",required = false) String searchkey,
                                      @RequestParam(defaultValue = "",required = false) String area)
    {
        if(area.length() >= 0)
        {
            HashMap<String,String> map = new HashMap<String,String>();
            map.put("searchkey",searchkey);
            map.put("area",area);
            try
            {
                List<Map<String,String>> result = statSrv.getVenueListBySearchKey(map);
                return JSONObject.toJSON(result).toString();
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }

        }

        return "";

    }


}
