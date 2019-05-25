package com.sun3d.why.dao;

import java.util.Map;

import com.sun3d.why.model.CmsActivityTemplateRel;

public interface CmsActivityTemplateRelMapper {
	
    int addActivityTemplateRel(CmsActivityTemplateRel record);
    
    int deleteById(Map<String, Object> map);
}