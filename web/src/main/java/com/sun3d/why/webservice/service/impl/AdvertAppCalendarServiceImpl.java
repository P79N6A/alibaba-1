package com.sun3d.why.webservice.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.AppAdvertCalendarMapper;
import com.sun3d.why.model.AppAdvertCalendar;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.webservice.service.AdvertAppCalendarService;

@Transactional
@Service
public class AdvertAppCalendarServiceImpl implements AdvertAppCalendarService {
    private Logger logger = Logger.getLogger(AdvertAppCalendarServiceImpl.class);
    @Autowired
    protected AppAdvertCalendarMapper appAdvertCalendarMapper;
    @Autowired
    private StaticServer staticServer;

    /**
     * 根据日期查询广告位
     * @param date
     * @return
     */
	@Override
	public String queryCalendarAdvert(String date) {
		Map<String, Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(date)){
            map.put("date", date);
        }
        Map<String, Object> mapAdvert = new HashMap<String, Object>();
        try {
			AppAdvertCalendar appAdvertCalendar = appAdvertCalendarMapper.queryCalendarAdvertByDate(map);
			if(appAdvertCalendar!=null){
				mapAdvert.put("advertName", appAdvertCalendar.getAdvertName()!= null ? appAdvertCalendar.getAdvertName() : "");
				mapAdvert.put("advLink", appAdvertCalendar.getAdvLink()!= null ? appAdvertCalendar.getAdvLink() : "");
				if(appAdvertCalendar.getAdvLink()==0){
					mapAdvert.put("advLinkType", appAdvertCalendar.getAdvLinkType()!= null ? appAdvertCalendar.getAdvLinkType() : "");
				}
				mapAdvert.put("advUrl", appAdvertCalendar.getAdvUrl()!= null ? appAdvertCalendar.getAdvUrl() : "");
				String advImgUrl = "";
			    if(StringUtils.isNotBlank(appAdvertCalendar.getAdvImgUrl())){
			    	advImgUrl = staticServer.getStaticServerUrl() + appAdvertCalendar.getAdvImgUrl();
			    }
			    mapAdvert.put("advImgUrl", advImgUrl);
			}else{
				return JSONResponse.toAppResultFormat(500, "未查到相关信息");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return JSONResponse.toAppResultFormat(500, "服务器响应失败");
		}
		return JSONResponse.toAppResultFormat(200, mapAdvert);
	}
}