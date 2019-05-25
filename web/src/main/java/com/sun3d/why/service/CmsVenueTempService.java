package com.sun3d.why.service;

import com.sun3d.why.model.temp.CmsVenueTemp;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/7/27.
 */
public interface CmsVenueTempService  {


    int countByCondition(Map<String,Object> params);

    List<CmsVenueTemp> queryByCondition(Pagination page,String areaCode);
}
