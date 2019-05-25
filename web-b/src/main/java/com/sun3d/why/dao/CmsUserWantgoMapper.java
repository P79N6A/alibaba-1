package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsUserWantgo;
import com.sun3d.why.model.ccp.CcpWalkVote;


public interface CmsUserWantgoMapper {

	/**
     * 添加我想去数据
     * @param activityUserWantgo　用户想去活动对象
     * @return 
     */
    int addUserWantgo(CmsUserWantgo activityUserWantgo);
	
    /**
     * 根据活动Id查询我想去总数目
     * @param map
     * @return 活动数目
     */
    int queryUserWantgoCount(Map<String, Object> map);
    
    /**
     * 根据活动Id查询我想去列表
     * @param map
     * @return
     */
    List<CmsUserWantgo> queryAppUserWantgoList(Map<String, Object> map);

    /**
     * app查询该用户是否已参加该活动
     * @param activityUserWantgo 用户报名参加活动对象
     * @return
     */
    public  int queryAppUserWantCountById(CmsUserWantgo activityUserWantgo);

    /**
     * app取消用户报名活动
     * @param activityUserWantgo
     * @return
     */
    int deleteUserWantgo(CmsUserWantgo activityUserWantgo);
    
    /**
     * 刷票
     * @param wantgolist
     * @return
     */
    int brushWantgo(List<CmsUserWantgo> wantgolist);
}