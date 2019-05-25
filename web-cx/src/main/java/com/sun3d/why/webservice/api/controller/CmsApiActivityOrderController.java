package com.sun3d.why.webservice.api.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by yujinbing on 2016/3/7.
 */
@RequestMapping("/api/activityOrder")
@Controller
public class CmsApiActivityOrderController {

    private Logger logger = Logger.getLogger(getClass());

    @Autowired
    private CmsApiActivityOrderService cmsApiActivityOrderService;

    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;


    /**
     * 取消预定的子系统嘉定的预定订单
     * @param json
     * @return
     */
    @RequestMapping(value = "/deBookActivity.do")
    @ResponseBody
    public String  deBookActivity(@RequestBody String json,HttpServletRequest request) {
        try {
            System.out.println("==================json数据=================>"+json);
            JSONObject data= JSON.parseObject(json);//解析数据为json*/
            String sysNo = data.getString("sysno") == null ? "" : data.getString("sysno");
            String sysId =  data.getString("sysid") == null ? "" : data.getString("sysid");
            //type : 1 退订操作  2 入场操作 3 验票操作
            String type = data.getString("type") == null ? "1" : data.getString("type");
            if (StringUtils.isBlank(sysId) || StringUtils.isBlank(sysNo)) {
                return "请输入必要的参数数据";
            }

            String  orderLineStr = data.getString("orderLine");
            //根据子系统的主键查询 文化云中的主键
            String activityOrderId = cmsActivityOrderService.queryActivityIdBySysId(sysId);
            if (StringUtils.isBlank(activityOrderId)) {
                return "无对应的订单在文化云中";
            }
            return cmsApiActivityOrderService.updateActivityOrderState(activityOrderId,orderLineStr,type);
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error("CmsApiActivityOrderController deBookActivity error {}" , ex);
            return ex.toString();
        }
    }


}
