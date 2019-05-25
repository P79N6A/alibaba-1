package com.sun3d.why.webservice.service;

import com.sun3d.why.model.CmsAdvert;

public interface AdvertService {
    /**
     * app获取轮播图
     */
    public   String queryAppAdvertBySite(int type);



    /**
     * 根据advertId查询广告信息
     * @prama String advertId
     * @prama HttpServletRequest request
     * @return CmsAdvert
     * @authours hucheng
     * @date 2016/3/11
     * @content add
     *
     * */
     CmsAdvert queryWcCmsAdvertById(String advertId);
 }
