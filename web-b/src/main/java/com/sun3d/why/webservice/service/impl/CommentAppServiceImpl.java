package com.sun3d.why.webservice.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.CmsSensitive;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.service.CommentAppService;

/**
 * 某一类型评论
 */
@Service
@Transactional
public class CommentAppServiceImpl implements CommentAppService {
    private Logger logger = Logger.getLogger(AdvertServiceImpl.class);
    @Autowired
    private CmsCommentMapper commentMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    
    @Override
    public String queryAppCommentByCondition(String moldId, String type,PaginationApp pageApp) {
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy.MM.dd HH:mm");
        Map<String,Object> map=new HashMap<String, Object>();
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        if(moldId!=null && StringUtils.isNotBlank(moldId)){
            map.put("commentRkId", moldId);
        }
        if(type != null && StringUtils.isNotBlank(type)){
            map.put("commentType", type);
        }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }

        int count = commentMapper.queryCmsCommentCount(map);
        
        List<CmsComment> commentList= commentMapper.queryCommentByCondition(map);
        if(CollectionUtils.isNotEmpty(commentList)){
            for (CmsComment commentActivityList : commentList) {
                if(StringUtils.isNotBlank(commentActivityList.getCommentRemark()) || StringUtils.isNotBlank(commentActivityList.getCommentImgUrl())){
	                Map<String, Object> commentMap = new HashMap<String, Object>();
	                commentMap.put("commentId", commentActivityList.getCommentId() != null ? commentActivityList.getCommentId() : "");
	                commentMap.put("commentRemark", commentActivityList.getCommentRemark() != null ? commentActivityList.getCommentRemark() : "");
	            //   long commentTime = commentActivityList.getCommentTime().getTime() / 1000;
	                commentMap.put("commentTime",  commentActivityList.getCommentTime()!=null? sdf.format(commentActivityList.getCommentTime()):"");
	                //评论人昵称
	                commentMap.put("commentUserNickName",commentActivityList.getCommentUserName()!=null?commentActivityList.getCommentUserName():"");
	                //评论人头像
	                String userHeadImgUrl = "";
	                if (StringUtils.isNotBlank(commentActivityList.getUserHeadImgUrl()) &&  commentActivityList.getUserHeadImgUrl().contains("http://")) {
	                    userHeadImgUrl = commentActivityList.getUserHeadImgUrl();
	                }else if(StringUtils.isNotBlank(commentActivityList.getUserHeadImgUrl())){
	                    userHeadImgUrl = staticServer.getStaticServerUrl() +commentActivityList.getUserHeadImgUrl();
	                }
	                commentMap.put("userHeadImgUrl",userHeadImgUrl);
	                StringBuffer sb=new StringBuffer();
	                if(commentActivityList.getCommentImgUrl()!=null && StringUtils.isNotBlank(commentActivityList.getCommentImgUrl())){
	                    String[] commentImgUrls=commentActivityList.getCommentImgUrl().split(";");
	                    for(String imgUrls:commentImgUrls){
	                         sb.append(staticServer.getStaticServerUrl()+imgUrls);
	                         sb.append(",");
	                    }
	                }
	                commentMap.put("commentImgUrl",sb.toString());
	                //评论星级
	                commentMap.put("commentStar",commentActivityList.getCommentStar() != null ? commentActivityList.getCommentStar() : "");
	                commentMap.put("commentUserSex",commentActivityList.getUserSex());
	                listMap.add(commentMap);
              }
            }
        }
        return JSONResponse.toAppActivityResultFormat(0,listMap, count);
    }

    /**
     * app添加评论
     * @param comment 评论对象
     * @return
     */
    @Override
    public String addComment(CmsComment comment) {
        int flag=0;
        String imgUrl="";
        if(comment!=null && StringUtils.isNotBlank(comment.getCommentImgUrl())){
            String[] commentImgUrls=comment.getCommentImgUrl().split(";");
            for(String imgUrls:commentImgUrls){
                int index=imgUrls.indexOf("front");
                imgUrl += imgUrls.substring(index,imgUrls.length())+ ";";
            }
            imgUrl=imgUrl.substring(0,imgUrl.length() - 1);
            comment.setCommentImgUrl(imgUrl);
        }
         if (comment!=null && StringUtils.isNotBlank(comment.getCommentRemark())){
             if(CmsSensitive.sensitiveWords(comment,cmsSensitiveWordsMapper).equals(Constant.SensitiveWords_EXIST)){
                 return JSONResponse.commonResultFormat(10108, "该评论中存在着敏感词,请重新评论!", null);
             }else {
                 comment.setCommentRemark(EmojiFilter.filterEmoji(comment.getCommentRemark()));
             }
         }
         comment.setCommentType(Integer.valueOf(comment.getCommentType()));
        int count  = queryCommentCount(comment);
        if(count >= 5){
            return JSONResponse.commonResultFormat(10107, "评论次数超过5次", null);
        }
        comment.setCommentId(UUIDUtils.createUUId());
        comment.setCommentTime(new Date());
        flag=commentMapper.addComment(comment);
        if(flag>0){
        	
        	userIntegralDetailService.commentAddIntegral(comment.getCommentUserId(), comment.getCommentId());
        	
            return  JSONResponse.commonResultFormat(0, "信息添加成功", null);
        }else {
            return  JSONResponse.commonResultFormat(1, "信息添加失败", null);
        }
    }
    /**
     * 前端2.0判断用户评论数小于等于五
     * @param comment 评论对象
     * @return
     */
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
     * why3.5 查询个人用户下所有活动评论
     * @param pageApp
     * @param userId
     * @return
     */
    @Override
    public String queryAppActivityCommentByUserId(PaginationApp pageApp, String userId){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("commentType", Constant.TYPE_ACTIVITY);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsComment> commentList = commentMapper.queryAppActivityCommentByUserId(map);
        List<Map<String, Object>> listMap = this.getAppCmsCommentListResult(commentList, staticServer);
        if(CollectionUtils.isEmpty(listMap)){
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(1, listMap);
    }

    /**
     * why3.5 查询个人用户下所有场馆评论
     * @param pageApp
     * @param userId
     * @return
     */
    @Override
    public String queryAppVenueCommentByUserId(PaginationApp pageApp, String userId){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("commentType", Constant.TYPE_VENUE);
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsComment> commentList = commentMapper.queryAppVenueCommentByUserId(map);
        List<Map<String, Object>> listMap = this.getAppCmsCommentListResult(commentList, staticServer);
        if(CollectionUtils.isEmpty(listMap)){
            listMap = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(1, listMap);
    }

    /**
     * why3.5 app所有评论(活动、场馆)列表返回数据业务处理
     */
    private List<Map<String, Object>> getAppCmsCommentListResult(List<CmsComment> commentList, StaticServer staticServer) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        try {
            if (CollectionUtils.isNotEmpty(commentList)) {
                for (CmsComment comment : commentList) {
                    Map<String, Object> mapComment = new HashMap<String, Object>();
                    mapComment.put("commentId", comment.getCommentId() != null ? comment.getCommentId() : "");
                    mapComment.put("activityId", comment.getActivityId() != null ? comment.getActivityId() : "");
                    mapComment.put("activityName", StringUtils.isNotBlank(comment.getActivityName()) ?
                            comment.getActivityName() : (StringUtils.isNotBlank(comment.getActivitySite()) ? comment.getActivitySite() : ""));
                    mapComment.put("venueId", comment.getVenueId() != null ? comment.getVenueId() : "");
                    mapComment.put("venueName", StringUtils.isNotBlank(comment.getVenueName()) ?
                            comment.getVenueName() : (StringUtils.isNoneBlank(comment.getActivitySite())?comment.getActivitySite():""));
                    mapComment.put("commentRemark", comment.getCommentRemark() != null ? comment.getCommentRemark() : "");
                    mapComment.put("commentTime", comment.getCommentTime() != null ? format.format(comment.getCommentTime()) : "");
                    String commentImgUrl = "";
                    if (StringUtils.isNotBlank(comment.getCommentImgUrl())) {
                        String[] imgUrls = comment.getCommentImgUrl().split(";");
                        for(String url:imgUrls){
                            if(StringUtils.isNotBlank(commentImgUrl)){
                                commentImgUrl = commentImgUrl + "," + staticServer.getStaticServerUrl() + url;
                            }else{
                                commentImgUrl = commentImgUrl + staticServer.getStaticServerUrl() + url;
                            }
                        }
                    }
                    mapComment.put("commentImgUrl", commentImgUrl);
                    listMap.add(mapComment);
                }
            }
            return listMap;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listMap;
    }

    /**
     * why3.5 根据id删除评论
     * @param commentId
     * @return
     */
    @Override
    public String deleteAppCommentById(final String commentId){
    	
    	CmsComment comment=commentMapper.queryCommentById(commentId);
    	
    	final String userId=comment.getCommentUserId();
    	
        int r=commentMapper.deleteCommentById(commentId);
        
        if(r>0)
        {
        	Runnable runnable = new Runnable() {
                @Override
                public void run() {
                	JSONObject json=new JSONObject();
              		json.put("commentUserId", userId);
              		json.put("commentId", commentId);
              		HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/commentDeleteIntegralByJson.do", json);
                }
        	};
        	new Thread(runnable).start();
        	
           return JSONResponse.toAppResultFormat(1, "删除评论成功");
        }
        return JSONResponse.toAppResultFormat(0, "删除评论失败");
    }
}
