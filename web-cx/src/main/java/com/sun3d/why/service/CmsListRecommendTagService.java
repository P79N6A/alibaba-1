package com.sun3d.why.service;

import com.sun3d.why.model.*;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface CmsListRecommendTagService {



    /**
     *
     * 保存活动列表页推荐
     *
     *
     */
    int addCmsListRecommendTag(String activityType, SysUser sysUser);




    /**
     * 删除
     *
     *
     *
     */
    int deleteCmsListRecommendTagId(String listRecommendId);


    /**
     * 查询List
     *
     * @return
     */
    List<CmsListRecommendTag> queryCmsListRecommendTagList();


}

