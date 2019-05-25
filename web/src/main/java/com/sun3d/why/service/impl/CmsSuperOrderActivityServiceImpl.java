package com.sun3d.why.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsActivityEventMapper;
import com.sun3d.why.dao.CmsSuperOrderActivityMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityEvent;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsSuperOrderActivity;
import com.sun3d.why.service.CmsSuperOrderActivityService;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;

@Service
@Transactional
public class CmsSuperOrderActivityServiceImpl implements CmsSuperOrderActivityService {

	private Logger logger = Logger.getLogger(CmsSuperOrderActivityServiceImpl.class);
    @Autowired
    private CmsSuperOrderActivityMapper cmsSuperOrderActivityMapper;
    @Resource
	private CmsActivityEventMapper cmsActivityEventMapper;
    @Autowired
    private HttpSession session;
    
	@Override
	public String getActivityList(PaginationApp pageApp,String searchKey,String userId) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		Map<String,Object> map=new HashMap<String, Object>();
		if(StringUtils.isNotBlank(searchKey)){
			map.put("searchKey", searchKey);
		}
		if(StringUtils.isNotBlank(userId)){
			map.put("userId", userId);
		}
		if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsSuperOrderActivity> list = cmsSuperOrderActivityMapper.queryActivityListByCondition(map);
        //判断活动是否结束
        for(CmsSuperOrderActivity dto : list){
        	if (StringUtils.isNotBlank(dto.getActivityId())) {
	            map.put("relatedId", dto.getActivityId());
	        }
        	List<CmsActivityEvent> activityEventList = cmsActivityEventMapper.queryAppActivityEventById(map);
        	try {
        		if (CollectionUtils.size(activityEventList)>0) {
            		String lastEventTime = dto.getActivityEndTime() + " " + activityEventList.get(activityEventList.size() - 1).getEventTime().split("-")[0];
            		dto.setActivityIsPast((sdf.parse(lastEventTime).getTime() - new Date().getTime()) > 0 ? 0 : 1);
            	}else{
            		String lastEventTime = dto.getActivityEndTime()  + " 00:00";
            		dto.setActivityIsPast((sdf.parse(lastEventTime).getTime() - new Date().getTime()) > 0 ? 0 : 1);
            	}
			} catch (ParseException e) {
				e.printStackTrace();
			}
        }
        return JSONResponse.toAppResultFormat(200, list);
	}

	@Override
	public String getActivityOrderList(PaginationApp pageApp, String userId) {
		Map<String,Object> map=new HashMap<String, Object>();
		if(StringUtils.isNotBlank(userId)){
			map.put("userId", userId);
		}
		if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsActivityOrder> list = cmsSuperOrderActivityMapper.queryActivityOrderListByCondition(map);
        return JSONResponse.toAppResultFormat(200, list);
	}

}
