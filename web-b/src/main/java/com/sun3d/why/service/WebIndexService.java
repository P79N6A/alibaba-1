package com.sun3d.why.service;


import java.util.List;

public interface WebIndexService {


    /**
     * 传入id和key，查出活动详情并保存到Redis
     * @param dataList
     *
     * @return
     */
    String activityList(List<String> dataList,String key);
}
