package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsSuperOrderActivity;

public interface CmsSuperOrderActivityMapper {
    int insert(CmsSuperOrderActivity record);

    List<CmsSuperOrderActivity> queryActivityListByCondition(Map<String,Object> map);
    
    List<CmsActivityOrder> queryActivityOrderListByCondition(Map<String,Object> map);
}