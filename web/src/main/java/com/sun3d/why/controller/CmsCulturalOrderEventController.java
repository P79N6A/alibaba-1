package com.sun3d.why.controller;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.CmsCulturalOrderEvent;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsCulturalOrderEventService;
import com.sun3d.why.util.Constant;

@RequestMapping("/culturalOrderEvent")
@Controller
public class CmsCulturalOrderEventController {
    private Logger logger = LoggerFactory.getLogger(CmsCulturalOrderEventController.class);


    @Autowired
    private CmsCulturalOrderEventService cmsCulturalOrderEventService;
    
    
    /**
     * 文化云3.4前端   首页活动列表查询
     *
     * @return
     */
    @RequestMapping("/culturalOrderEventList")
    @ResponseBody
    public String culturalOrderEventList(HttpServletRequest request, String culturalOrderId) {
        JSONObject jsonObject = new JSONObject();
        try {
        	String userId = "";
        	CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
        	if(user != null && StringUtils.isNotBlank(user.getUserId())){
        		userId = user.getUserId();
        	}
        	List<CmsCulturalOrderEvent> culturalOrderEventList = cmsCulturalOrderEventService.queryCulturalOrderEventByCulturalOrderId(culturalOrderId, userId);
        	Set<String> periods = new HashSet<String>();
        	for(CmsCulturalOrderEvent event : culturalOrderEventList){
        		periods.add(event.getCulturalOrderEventTime().trim());
        	}
        	String periodStr = "";
        	if(periods.size() > 1){
        		periodStr = "多时段";
        	}else{
        		for (String value : periods) {
        			periodStr = value;
        		 } 
        	}
        	jsonObject.put("list", culturalOrderEventList);
        	jsonObject.put("periodStr", periodStr);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return jsonObject.toString();
    }

}
