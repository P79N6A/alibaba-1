package com.sun3d.why.dao;

import com.sun3d.why.model.CmsActivity;

import java.util.List;
import java.util.Map;

public interface CmsSpecialMapper {

    public List<CmsActivity> querySpecialOneList(Map<String, Object> map);

    public List<CmsActivity> querySpecialTwoList(Map<String, Object> map);

}