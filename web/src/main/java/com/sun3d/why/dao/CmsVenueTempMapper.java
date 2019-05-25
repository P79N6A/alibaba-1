package com.sun3d.why.dao;


import com.sun3d.why.model.temp.CmsVenueTemp;

import java.util.List;
import java.util.Map;


public interface CmsVenueTempMapper {


    int countByCondition(Map<String,Object> params);

    List<CmsVenueTemp> queryByCondition(Map<String,Object> params);


}