package com.sun3d.why.webservice.service;

import com.sun3d.why.model.AppAdvertRecommend;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.util.PaginationApp;

import java.text.ParseException;
import java.util.List;

/**
 * Created by Administrator on 2015/7/2.
 */
public interface AdvertAppRecommendService {

    /**
     * why3.5 app查询广告位列表
     * @param advPostion
     * @return
     */
    String queryAppAdvertRecommendList(String advPostion);
}
