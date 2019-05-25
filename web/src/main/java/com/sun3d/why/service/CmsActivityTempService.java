package com.sun3d.why.service;

import com.sun3d.why.model.temp.CmsActivityTemp;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/7/27.
 */
public interface CmsActivityTempService {

    int countByCondition(Map<String,Object> params);

    List<CmsActivityTemp> queryByCondition(Pagination page,String areaCode);
}
