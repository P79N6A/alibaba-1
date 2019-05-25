package com.sun3d.why.webservice.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.dao.CmsActivityOrderMapper;
import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.UserIntegralDetail;
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
import com.sun3d.why.webservice.api.util.HttpResponseText;
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
    private CmsActivityMapper activityMapper;
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    @Autowired
    private CmsActivityOrderMapper cmsActivityOrderMapper;
    
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
        map.put("commentState", 1);
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
	                        if(!imgUrls.contains("http://")){
                                sb.append(staticServer.getStaticServerUrl()+imgUrls);
                            }else {
                                sb.append(imgUrls);
                            }
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
    @Transactional(isolation=Isolation.SERIALIZABLE)
    public String addComment(CmsComment comment) {
        int flag=0;
        String imgUrl="";
        if(comment!=null && StringUtils.isBlank(comment.getCommentUserId())){
        	return  JSONResponse.commonResultFormat(1, "信息添加失败", null);
        }
        if(comment!=null && StringUtils.isNotBlank(comment.getCommentImgUrl())){
            String[] commentImgUrls=comment.getCommentImgUrl().split(";");
            for(String imgUrls:commentImgUrls){
                int index=imgUrls.indexOf("front");
                imgUrl += imgUrls.substring(index,imgUrls.length())+ ";";
            }
            imgUrl=imgUrl.substring(0,imgUrl.length() - 1);
            comment.setCommentImgUrl(imgUrl);
        }
        comment.setCommentRemark(EmojiFilter.filterEmoji(comment.getCommentRemark()));
        if (comment!=null && StringUtils.isNotBlank(comment.getCommentRemark())){
             if(CmsSensitive.sensitiveWords(comment,cmsSensitiveWordsMapper).equals(Constant.SensitiveWords_EXIST)){
                 return JSONResponse.commonResultFormat(10108, "该评论中存在着敏感词,请重新评论!", null);
             }else {
                 comment.setCommentRemark(comment.getCommentRemark());
             }
        }else{
        	return JSONResponse.commonResultFormat(10109, "该评论中存在非法字符,请重新评论!", null);
        }
        comment.setCommentType(Integer.valueOf(comment.getCommentType()));
        int count  = queryCommentCount(comment);
        if(count >= 1){
            return JSONResponse.commonResultFormat(10107, "每天仅能评论1次，请明天再来！", null);
        }
        comment.setCommentId(UUIDUtils.createUUId());
        comment.setCommentTime(new Date());
        flag=commentMapper.addComment(comment);
        if(flag>0){
        	//评论积分
    		userIntegralDetailService.commentAddIntegral(comment.getCommentUserId(), comment.getCommentId());
        	
    		if(comment.getCommentType() == 2 && StringUtils.isNotBlank(comment.getCommentImgUrl())){
    			CmsActivity cmsActivity = activityMapper.queryCmsActivityByActivityId(comment.getCommentRkId());
    			//群艺馆、长宁区文化艺术中心、上海东方艺术中心、中华艺术馆、三山会馆、上海博物馆
    			String []venueId = new String[]{"5e8739f0511b4caeb05c974273b83b96","561d99fbd51f44bba25b287843c8d023","beefece0d02642a0b81509474049e49c","2f579b2d7acd497f9ded78df0542d182","23dc8d7b046a40e2abf0ee398f5b85b4","05f6b63b4e5e4b2e95139099a8c08ce1"};
				if(Arrays.asList(venueId).contains(cmsActivity.getVenueId())){
        			Map<String, Object> map = new HashMap<String, Object>();
        			map.put("activityId", comment.getCommentRkId());
        			map.put("userId", comment.getCommentUserId());
        			map.put("sortType", 1);
        			List<CmsActivityOrder> list = cmsActivityOrderMapper.queryNoCancelActivityOrder(map);
        			if(list.size()>0){
        				String startStr = list.get(0).getEventDate() + " " + list.get(0).getEventTime().substring(0, 5);
        				map.put("sortType", 2);
            			list = cmsActivityOrderMapper.queryNoCancelActivityOrder(map);
        				String endStr = (list.get(0).getEventEndDate()!=null?list.get(0).getEventEndDate():list.get(0).getEventDate()) + " " + list.get(0).getEventTime().substring(6);
        				
        				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    					Date startDate = null;
    					Date endDate = null;
						try {
							//活动开始前1小时
							startDate = df.parse(startStr);
							startDate = new Date(startDate.getTime() - 60*60*1000);
	    					//活动结束后三天
	    					endDate = df.parse(endStr);
	    					endDate = new Date(endDate.getTime() + 3*24*60*60*1000);
						} catch (ParseException e) {
							e.printStackTrace();
						}
    					
    					if(startDate.before(new Date()) && endDate.after(new Date())) {
    						UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
    		        		userIntegralDetail.setIntegralChange(100);
    		        		userIntegralDetail.setChangeType(0);
    		        		userIntegralDetail.setIntegralFrom("群艺馆、长宁文化艺术中心活动评论:"+comment.getCommentRkId());
    		        		userIntegralDetail.setIntegralType(IntegralTypeEnum.COMMENT_SPECIAL.getIndex());
    		        		userIntegralDetail.setUserId(comment.getCommentUserId());
    		        		userIntegralDetail.setUpdateType(1);

    		        		userIntegralDetailService.updateIntegralByVo(userIntegralDetail);
    					}
        			}
        		}
    		}
    		
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
    public String deleteAppCommentById(String commentId){
    	
    	CmsComment comment=commentMapper.queryCommentById(commentId);
    	
    	String userId=comment.getCommentUserId();
    	
        int r=commentMapper.deleteCommentById(commentId);
        
        if(r>0)
        {
        	userIntegralDetailService.commentDeleteIntegral(userId, commentId);
           return JSONResponse.toAppResultFormat(1, "删除评论成功");
        }
        return JSONResponse.toAppResultFormat(0, "删除评论失败");
    }
}
