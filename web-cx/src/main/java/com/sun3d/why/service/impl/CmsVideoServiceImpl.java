package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsVideoMapper;
import com.sun3d.why.model.CmsVideo;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsVideoService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by niubiao on 2015/12/31.
 */
@Service
@Transactional(rollbackFor=Exception.class)
public class CmsVideoServiceImpl implements CmsVideoService {

    @Autowired
    private CmsVideoMapper cmsVideoMapper;
    /**
     * 根据id查询McNews
     * @param videoId
     * @return
     */
    @Override
    public CmsVideo queryVideoByVideoId(String videoId) {
        return cmsVideoMapper.queryVideoByVideoId(videoId);
    }

    /**
     * 后台显示列表
     * @param videos     活动对象
     * @param page     分页对象
     * @return     列表信息
     */
    @Override
    public List<CmsVideo> cmsVideoList(CmsVideo videos,Pagination page){
        Map<String,Object>map=new HashMap<String, Object>();

        if(StringUtils.isNotBlank(videos.getReferId())){
            map.put("referId",videos.getReferId() );
        }
        if(StringUtils.isNotBlank(videos.getVideoId())){
            map.put("videoId",videos.getVideoId() );
        }
        if(StringUtils.isNotBlank(String.valueOf(videos.getVideoType()))){
            map.put("videoType",videos.getVideoType() );
        }
        if(StringUtils.isNotBlank(String.valueOf(videos.getVideoTitle()))){
            map.put("videoTitle",videos.getVideoTitle() );
        }
        if(StringUtils.isNotBlank(String.valueOf(videos.getStartTime()))){
            map.put("startTime",videos.getStartTime() );
        }if(StringUtils.isNotBlank(String.valueOf(videos.getEndTime()))){
            map.put("endTime",videos.getEndTime() );
        }
        //分页
        if(page!=null && page.getFirstResult() != null && page.getRows() != null){
            map.put("firstResult",page.getFirstResult());
            map.put("rows",page.getRows());
            int total=cmsVideoMapper.selectVideoIndexCount(map);
            page.setTotal(total);
        }
        return cmsVideoMapper.selectVideoIndex(map);
    }
    /**
     * 后台新增
     * @param videos     活动对象
     * @param  sysUser
     * @return     addVideo
     */
    @Override
    public String addVideo(CmsVideo videos, SysUser sysUser){
        try {
            // 验证视频标题不重复
            int count = cmsVideoMapper.queryVideoCountByTitle(videos.getVideoTitle());
            if(count > 0){
                return Constant.RESULT_STR_REPEAT;
            }

            videos.setVideoId(UUIDUtils.createUUId());
            videos.setVideoCreateTime(new Date());
            videos.setVideoUpdateTime(new Date());
            videos.setVideoState(1);
            videos.setVideoUpdateUser(sysUser.getUserNickName());
            int result = cmsVideoMapper.addVideo(videos);
            if(result > 0){
                return Constant.RESULT_STR_SUCCESS;
            }
            return Constant.RESULT_STR_FAILURE;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 后台编辑
     * @param videos     活动对象
     * @param  sysUser
     * @return     editVideo
     */
    @Override
    public String editVideo(CmsVideo videos, SysUser sysUser){
        try {
            // 验证视频标题不重复
            /*int count = cmsVideoMapper.queryVideoCountByName(videos.getVideoTitle());
            if(count > 0){
                CmsVideo video = cmsVideoMapper.queryVideoByVideoId(videos.getVideoId());
                if(!videos.getVideoTitle().equals(video.getVideoTitle())){

                }
            }*/
            CmsVideo video = cmsVideoMapper.queryVideoByVideoId(videos.getVideoId());
            if(!videos.getVideoTitle().equals(video.getVideoTitle())){
                int count = cmsVideoMapper.queryVideoCountByTitle(videos.getVideoTitle());
                if(count > 0){
                    return Constant.RESULT_STR_REPEAT;
                }
            }

            videos.setVideoUpdateTime(new Date());
            videos.setVideoState(1);
            videos.setVideoUpdateUser(sysUser.getUserNickName());
            int result = cmsVideoMapper.editVideo(videos);
            if(result > 0){
                return Constant.RESULT_STR_SUCCESS;
            }
            return Constant.RESULT_STR_FAILURE;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 后台删除
     * @param videos     活动对象
     * @param  sysUser
     * @return     deleteVideo
     */
    @Override
    public String deleteVideo(CmsVideo videos, SysUser sysUser){
        try {
            videos.setVideoUpdateTime(new Date());
            videos.setVideoState(2);
            videos.setVideoUpdateUser(sysUser.getUserNickName());
            int result = cmsVideoMapper.editVideo(videos);
            if(result > 0){
                return Constant.RESULT_STR_SUCCESS;
            }
            return Constant.RESULT_STR_FAILURE;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 主题下视频列表
     * @param videos 视频对象
     * @param page    分页对象
     * @return
     */
    @Override
    public List<CmsVideo> queryMcVideoListByCondition(CmsVideo videos, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("videoType", Constant.ACTIVITY_VIDEO_TYPE);
        map.put("videoState",Constant.VIDEO_STATE);
        if(StringUtils.isNotBlank(videos.getActivityName())){
            map.put("activityName", "%"+videos.getActivityName()+"%");
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        int total = cmsVideoMapper.queryMcVideoCountByCondition(map);
        //设置分页的总条数来获取总页数
        page.setTotal(total);
        return cmsVideoMapper.queryMcVideoListByCondition(map);
    }

    /**
     * 根据关联ID获取该活动下的有效视频数量
     *
     * @param referId
     * @return
     */
    @Override
    public Integer getVideoCount(String referId) {

        return  cmsVideoMapper.getVideoCount(referId);
    }
}
