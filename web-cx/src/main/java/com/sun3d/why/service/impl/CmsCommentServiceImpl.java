package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.dao.ccp.CcpCityImgMapper;
import com.sun3d.why.dao.ccp.CcpSceneImgMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.model.ccp.CcpCityImg;
import com.sun3d.why.model.ccp.CcpSceneImg;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@Transactional
public class CmsCommentServiceImpl implements CmsCommentService {

    @Autowired
    private CmsCommentMapper commentMapper;

    @Autowired
    private CmsVenueService venueService;

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private CmsAntiqueService antiqueService;

    @Autowired
    private CmsTeamUserService teamUserService;

    @Autowired
    private CmsActivityRoomService activityRoomService;

    @Autowired
    private CmsCultureService cultureService;

    @Autowired
    private SysShareDeptService sysShareDeptService;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    
    @Autowired
    private CcpCityImgMapper ccpCityImgMapper;
    
    @Autowired
    private CcpSceneImgMapper ccpSceneImgMapper;
    @Autowired
    CmsCommentMapper cmsCommentMapper;


    private Logger logger = Logger.getLogger(CmsCommentServiceImpl.class);

    /**
     * 新增评论
     * @param comment 评论对象
     * @return success:成功  failure:失败
     */
    @Override
    @Transactional(isolation=Isolation.SERIALIZABLE)
    public String addComment(CmsComment comment) {
        try{
            if(comment != null){
                int count  = queryCommentCount(comment);
                if(count >= 1){
                    return Constant.RESULT_STR_EXCEED_NUMBER;
                }
                comment.setCommentId(UUIDUtils.createUUId());
                comment.setCommentTime(new Date());
                commentMapper.addComment(comment);
                return Constant.RESULT_STR_SUCCESS;
            }
        }catch (Exception e){
            logger.info("addComment error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 根据id删除评论
     * @param commentId  评论id
     * @return false 失败, true成功
     */
    @Override
    public boolean deleteCommentById(String commentId) {
        try{
        	
        	CmsComment comment=commentMapper.queryCommentById(commentId);
        	
        	String userId=comment.getCommentUserId();
        	
            int r=commentMapper.deleteCommentById(commentId);
            
            if(r>0)
            {
            	  userIntegralDetailService.commentDeleteIntegral(userId, commentId);
            }
            
        }catch (Exception e){
            logger.info("deleteComment error"+e);
            return false;
        }
        return true;
    }

    /**
     * 查询列表页面
     * @param comment 评论对象
     * @param page 分页对象
     * @param  sysUser 用户对象
     * @return 评论集合
     */
    @Override
    public List<CmsComment> queryCommentByCondition(CmsComment comment, Pagination page, SysUser sysUser) {
        Map<String, Object> map = new HashMap<String, Object>();
        if(comment != null){
            if(comment.getCommentType() != null){
                map.put("commentType", comment.getCommentType());
            }
            if(comment.getCommentRkId() != null){
                map.put("commentRkId", comment.getCommentRkId());
            }
        }
        //权限验证
        if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserDeptPath())) {
            if (StringUtils.isNotBlank(sysUser.getUserDeptPath())) {
                map.put("venueDept", sysUser.getUserDeptPath());
            }

            List<SysShareDept> sysShareDepts = new ArrayList<SysShareDept>();
            //判断用户在部门分享表中是否有共享的信息
            sysShareDepts = sysShareDeptService.queryShareDeptByTargetDeptId(sysUser.getUserDeptId());
            SysShareDept sysShareDept = new SysShareDept();
            sysShareDept.setShareDepthPath(sysUser.getUserDeptPath());
            sysShareDepts.add(sysShareDept);
            map.put("activityDepts", sysShareDepts);
        }

        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(commentMapper.queryCommentCountByCondition(map));
        }
        List<CmsComment> commentList =  commentMapper.queryCommentByCondition(map);

        if(CollectionUtils.isNotEmpty(commentList)){
            for(CmsComment cmsComment:commentList){
                if(cmsComment.getCommentType() != null){
                    if(cmsComment.getCommentType() == Constant.TYPE_VENUE){
                        CmsVenue venue = venueService.queryVenueById(cmsComment.getCommentRkId());
                        if(venue != null && StringUtils.isNotBlank(venue.getVenueName())){
                            cmsComment.setCommentRkName(venue.getVenueName());
                        }
                    }else if(cmsComment.getCommentType() == Constant.TYPE_ACTIVITY){
                        CmsActivity activity = activityService.queryCmsActivityByActivityId(cmsComment.getCommentRkId());
                        if(activity != null && StringUtils.isNotBlank(activity.getActivityName())){
                            cmsComment.setCommentRkName(activity.getActivityName());
                        }
                    }else if(cmsComment.getCommentType() == Constant.TYPE_SUBJECT){
                    	CcpCityImg ccpCityImg = ccpCityImgMapper.selectByPrimaryKey(cmsComment.getCommentRkId());
                    	CcpSceneImg ccpSceneImg = ccpSceneImgMapper.selectByPrimaryKey(cmsComment.getCommentRkId());
                        if(ccpCityImg != null && StringUtils.isNotBlank(ccpCityImg.getCityImgUrl())){	//城市名片
                            cmsComment.setCommentRkName(ccpCityImg.getCityImgUrl());
                        }else if(ccpSceneImg != null && StringUtils.isNotBlank(ccpSceneImg.getSceneImgUrl())){		//我在现场
                            cmsComment.setCommentRkName(ccpSceneImg.getSceneImgUrl());
                        }
                    } else if(cmsComment.getCommentType() == Constant.TYPE_ANTIQUE){
                        CmsAntique antique = antiqueService.queryCmsAntiqueById(cmsComment.getCommentRkId());
                        if(antique != null && StringUtils.isNotBlank(antique.getAntiqueName())){
                            cmsComment.setCommentRkName(antique.getAntiqueName());
                        }
                    } else if(cmsComment.getCommentType() == Constant.TYPE_TEAM_USER){
                        CmsTeamUser teamUser = teamUserService.queryTeamUserById(cmsComment.getCommentRkId());
                        if(teamUser != null && StringUtils.isNotBlank(teamUser.getTuserName())){
                            cmsComment.setCommentRkName(teamUser.getTuserName());
                        }
                    }else if(cmsComment.getCommentType() == Constant.TYPE_ACTIVITY_ROOM){
                        CmsActivityRoom activityRoom = activityRoomService.queryCmsActivityRoomById(cmsComment.getCommentRkId());
                        if(activityRoom != null && StringUtils.isNotBlank(activityRoom.getRoomName())){
                            cmsComment.setCommentRkName(activityRoom.getRoomName());
                        }
                    }else if(cmsComment.getCommentType() == Constant.TYPE_CULTURE){
                        CmsCulture culture = cultureService.queryById(cmsComment.getCommentRkId());
                        if(culture != null && StringUtils.isNotBlank(culture.getCultureName())){
                            cmsComment.setCommentRkName(culture.getCultureName());
                        }
                    }
                }
            }
        }
        return commentList;
    }

    /**
     * 评论列表条数
     * @param comment 评论对象
     * @return 评论个数
     */
    @Override
    public int queryCommentCountByCondition(CmsComment comment){
        Map<String, Object> map = new HashMap<String, Object>();
        if(comment.getCommentType() != null){
            map.put("commentType", comment.getCommentType());
        }
        if(StringUtils.isNotBlank(comment.getCommentRkId())){
            map.put("commentRkId", comment.getCommentRkId());
        }
        return commentMapper.queryCommentCountByCondition(map);
    }

    /**
     * 前端2.0判断用户评论数小于等于五
     * @param comment 评论对象
     * @return
     */
    @Override
    public int queryCommentCount(CmsComment comment){
        Map<String, Object> map = new HashMap<String, Object>();
        try{
            map.put("startDate", DateUtils.getCurrentDateFirst());
            map.put("endDate", DateUtils.getCurrentDateLast());
            if(comment.getCommentType() != null){
                map.put("commentType", comment.getCommentType());
            }
            if(StringUtils.isNotBlank(comment.getCommentRkId())){
                map.put("commentRkId", comment.getCommentRkId());
            }
            if(StringUtils.isNotBlank(comment.getCommentUserId())){
                map.put("commentUserId", comment.getCommentUserId());
            }
        }catch (Exception e){
            logger.info("queryCommentCount error", e);
        }
        return commentMapper.queryCommentCount(map);
    }

    /**
     * 评论3.0列表
     * @param comment
     * @param page
     * @return
     * @throws ParseException 
     */
    @Override
    public List<CmsComment> queryCmsCommentByCondition(CmsComment comment, Pagination page){
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if(comment != null){
            if(comment.getCommentType()!=null) {
                map.put("commentType", comment.getCommentType());
            }
            if(StringUtils.isNoneBlank(comment.getCommentRkId())){
                map.put("commentRkId", comment.getCommentRkId());
            }
            if(StringUtils.isNoneBlank(comment.getCommentRemark())){
                map.put("commentRemark", "%"+comment.getCommentRemark()+"%");
            }
            if(comment.getCommentIsTop()!=null){
                map.put("commentIsTop",comment.getCommentIsTop());
            }
            if(StringUtils.isNotBlank(comment.getCommentStartTime())){
                try {
					map.put("commentStartTime",df.parse(comment.getCommentStartTime() + " 00:00:00"));
				} catch (ParseException e) {
					e.printStackTrace();
				}
            }
            if(StringUtils.isNotBlank(comment.getCommentEndTime())){
                try {
					map.put("commentEndTime",df.parse(comment.getCommentEndTime() + " 23:59:59"));
				} catch (ParseException e) {
					e.printStackTrace();
				}
            }
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = commentMapper.queryCmsCommentCountByCondition(map);
            page.setTotal(total);
        }
        return commentMapper.queryCmsCommentByCondition(map);
    }

    /**
     * 评论3.0 更新置顶状态
     * @param comment
     * @return
     */
    @Override
    public int editCommentTopState(CmsComment comment){
        return commentMapper.editCommentTopState(comment);
    }

    /**
     * 评论3.0 查看详情
     * @param commentId
     * @return
     */
    @Override
    public CmsComment queryCommentById(String commentId){
        CmsComment comment = commentMapper.queryCommentById(commentId);
        if(comment != null){
            if(comment.getCommentType() == Constant.TYPE_VENUE){
                CmsVenue venue = venueService.queryVenueById(comment.getCommentRkId());
                if(venue != null && StringUtils.isNotBlank(venue.getVenueName())){
                    comment.setCommentRkName(venue.getVenueName());
                }
            }else if(comment.getCommentType() == Constant.TYPE_ACTIVITY){
                CmsActivity activity = activityService.queryCmsActivityByActivityId(comment.getCommentRkId());
                if(activity != null && StringUtils.isNotBlank(activity.getActivityName())){
                    comment.setCommentRkName(activity.getActivityName());
                }
            } else if(comment.getCommentType() == Constant.TYPE_ANTIQUE){
                CmsAntique antique = antiqueService.queryCmsAntiqueById(comment.getCommentRkId());
                if(antique != null && StringUtils.isNotBlank(antique.getAntiqueName())){
                    comment.setCommentRkName(antique.getAntiqueName());
                }
            } else if(comment.getCommentType() == Constant.TYPE_TEAM_USER){
                CmsTeamUser teamUser = teamUserService.queryTeamUserById(comment.getCommentRkId());
                if(teamUser != null && StringUtils.isNotBlank(teamUser.getTuserName())){
                    comment.setCommentRkName(teamUser.getTuserName());
                }
            }else if(comment.getCommentType() == Constant.TYPE_ACTIVITY_ROOM){
                CmsActivityRoom activityRoom = activityRoomService.queryCmsActivityRoomById(comment.getCommentRkId());
                if(activityRoom != null && StringUtils.isNotBlank(activityRoom.getRoomName())){
                    comment.setCommentRkName(activityRoom.getRoomName());
                }
            }else if(comment.getCommentType() == Constant.TYPE_CULTURE){
                CmsCulture culture = cultureService.queryById(comment.getCommentRkId());
                if(culture != null && StringUtils.isNotBlank(culture.getCultureName())){
                    comment.setCommentRkName(culture.getCultureName());
                }
            }
        }
        return comment;
    }


    @Override
    public List<CmsComment> queryMemberComment(String memberId,Integer pageIndex) {
        return cmsCommentMapper.queryMemberComment(memberId,pageIndex);
    }
}
