package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivity;

import java.util.List;

public interface CmsSpecialService {

    /**
     * 主题页面
     *
     * @param activity 活动对象
     * @return 列表信息
     */
    List<CmsActivity> querySpecialOneList(CmsActivity activity);

    /**
     * 主题页面
     *
     * @param activity 活动对象
     * @return 列表信息
     */
    List<CmsActivity> querySpecialTwoList(CmsActivity activity);
}

