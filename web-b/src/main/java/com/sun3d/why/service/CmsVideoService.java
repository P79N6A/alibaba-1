package com.sun3d.why.service;

import com.sun3d.why.model.CmsVideo;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;
public interface CmsVideoService {


    /**
     * 根据id查询Video
     * @param videoId
     * @return
     */
    CmsVideo queryVideoByVideoId(String videoId);

    /**
     * 视频列表
     * @param  videos     分页对象
     * @param  page     活动对象
     * @return    视频列表信息
     */
    List<CmsVideo> cmsVideoList(CmsVideo videos, Pagination page);

    /**
     * 添加Video
     * @param videos
     * @param  sysUser
     * return 是否添加成功 (成功：success；失败：false)
     */
    String addVideo(CmsVideo videos,SysUser sysUser);
    /**
     * editVideo
     * @param videos
     * @param  sysUser
     * @return
     */
    String editVideo(CmsVideo videos,SysUser sysUser);
    /**
     * 删除Video
     * @param videos
     * @param  sysUser
     * return 是否删除成功 (成功：success；失败：false)
     */
    String deleteVideo(CmsVideo videos,SysUser sysUser);

    /**
     * 查询主题下视频列表
     * @param videos 视频对象
     * @param page    分页对象
     * @return
     */
    public List<CmsVideo> queryMcVideoListByCondition(CmsVideo videos, Pagination page);

    /**
     * 根据关联ID获取该活动下的有效视频数量
     * @param referId
     * @return
     */
    public Integer getVideoCount(String referId);
}
