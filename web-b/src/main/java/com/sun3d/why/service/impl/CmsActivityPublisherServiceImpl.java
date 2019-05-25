package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityPublisherMapper;
import com.sun3d.why.model.CmsActivityPublisher;
import com.sun3d.why.service.CmsActivityPublisherService;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;


@Transactional(rollbackFor = Exception.class)
@Service
public class CmsActivityPublisherServiceImpl implements CmsActivityPublisherService {

    private Logger logger = Logger.getLogger(CmsActivityPublisherServiceImpl.class);

    @Autowired
    private CmsActivityPublisherMapper cmsActivityPublisherMapper;

    @Override
    public Map<String, Object> saveOrUpdateActivityPublisher(CmsActivityPublisher vo) {
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("code", 500);
    	int result = 0;
    	try {
	    	if(StringUtils.isNotBlank(vo.getPublisherId())){
                vo.setTemplateCreateTime(new Date());
                result = cmsActivityPublisherMapper.update(vo);
	    	}else{
	    		vo.setPublisherId(UUIDUtils.createUUId());
                vo.setTemplateCreateTime(new Date());
                result = cmsActivityPublisherMapper.insert(vo);
	    	}
	    	if (result > 0) {
	    		map.put("code", 200);
	    		CmsActivityPublisher cmsActivityPublisher = queryActivityPublisherByActivityId(vo.getActivityId());
	    		map.put("publisherId", cmsActivityPublisher.getPublisherId());
	            return map;
	        }
    	} catch (Exception e) {
    		return map;
        }
    	return map;
    }

    @Override
    public CmsActivityPublisher queryActivityPublisherByActivityId(String activityId) {
        return cmsActivityPublisherMapper.queryActivityPublisherByActivityId(activityId);
    }
}
