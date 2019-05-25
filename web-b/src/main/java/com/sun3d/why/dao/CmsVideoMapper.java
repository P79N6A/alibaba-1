package com.sun3d.why.dao;

import com.sun3d.why.model.CmsVideo;

import java.util.List;
import java.util.Map;

public interface CmsVideoMapper {

    /**
     * 查询视频列表 孙岱 20160109
     * @param map  查询条件
     * @return 活动列表信息
     */
    public List<CmsVideo> selectVideoIndex(Map<String, Object> map);
    //查询视频列表总数
    int selectVideoIndexCount(Map<String, Object> map);
    /**
     * 后台新增
     * @return     addVideo
     */
    int addVideo(CmsVideo record);

    /**
     * 后台编辑
     * @return     editVideo
     */
    int editVideo(CmsVideo record);
    /**
     * 根据id查询Video
     * @param videoId
     * @return
     */
    CmsVideo queryVideoByVideoId(String videoId);
    /**
     * app查询活动或展馆视频列表
     * @param map
     * @return
     */
    List<CmsVideo> queryVideoById(Map<String, Object> map);

    /**
     * 主题下视频列表
     * @param map
     * @return
     */
    List<CmsVideo> queryMcVideoListByCondition(Map<String, Object> map);

    /**
     * 主题下视频数目
     * @param map
     * @return
     */
    int queryMcVideoCountByCondition(Map<String, Object> map);

    /**
     * 根据名称查询数目
     * @param videoTitle
     * @return
     */
    int queryVideoCountByTitle(String videoTitle);

    /**
     * 根据关联ID获取该活动下的有效视频数量
     * @param referId
     * @return
     */
    public Integer getVideoCount(String referId);
}