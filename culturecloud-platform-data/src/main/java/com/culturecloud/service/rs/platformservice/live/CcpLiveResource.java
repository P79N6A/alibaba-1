package com.culturecloud.service.rs.platformservice.live;

import java.util.Date;
import java.util.List;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.aliyuncs.exceptions.ClientException;
import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.bean.BaseRequest;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.culturecloud.model.request.live.CcpLiveActivityDetailVO;
import com.culturecloud.model.request.live.CcpLiveMessagePageVO;
import com.culturecloud.model.request.live.CcpLiveUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveUserImgPageVO;
import com.culturecloud.model.request.live.LiveVersionNoCheckVO;
import com.culturecloud.model.request.live.SaveCcpLiveMessageVO;
import com.culturecloud.model.request.live.SaveLiveUserVO;
import com.culturecloud.model.request.live.UpdateCcpLiveMessageVO;
import com.culturecloud.model.response.live.CcpLiveMessageVO;
import com.culturecloud.model.response.live.CcpLiveUserVO;
import com.culturecloud.model.response.live.LiveVersionNoInfoVO;
import com.culturecloud.model.response.live.PageCcpLiveMessageVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.live.CcpLiveMessageService;
import com.culturecloud.service.local.live.CcpLiveUserService;
import com.culturecloud.utils.ali.video.AliOssVideo;

@Component
@Path("/live")
public class CcpLiveResource {

	@Autowired
	private CcpLiveMessageService ccpLiveMessageService;

	@Autowired
	private CcpLiveUserService ccpLiveUserService;
	@Autowired
	private BaseService baseService;
	
	// ios版本号
	private String iosVersion="1.0.0";
	//0-普通更新  1-强制更新 	
	private Integer iosUpdateType=0;
	private String iosUpdateDescription="IOS直播版本更新内容……";
	private String iosUpdateLink="https://itunes.apple.com/cn/app/%E6%96%87%E5%8C%96%E7%9B%B4%E6%92%AD/id1193943103?mt=8";
	
	
	// 安卓版本号
	private String androidVersion="1.2.0";
	//0-普通更新  1-强制更新 
	private Integer androidUpdateType=0;
	private String androidUpdateDescription="安卓直播版本更新内容……";
	private String androidUpdateLink;
	
	
	
	@POST
	@Path("/versionNoCheck")
	@SysBusinessLog(remark = "")
	@Produces(MediaType.APPLICATION_JSON)
	public LiveVersionNoInfoVO versionNoCheck(LiveVersionNoCheckVO request){
		
		LiveVersionNoInfoVO vo = null;
		
		String versionNo=request.getVersionNo();
		
		Integer version =Integer.valueOf(versionNo.replaceAll("\\.",""));
		
		Integer mobileType= request.getMobileType();
		
		//1-ios 2-android
		if(mobileType==1){
			
			Integer nowVersion =Integer.valueOf(iosVersion.replaceAll("\\.",""));
			
			if(nowVersion>version){
				vo=new LiveVersionNoInfoVO();
				
				vo.setUpdateType(iosUpdateType);
				vo.setUpdateVersion(iosVersion);
				vo.setUpdateDescription(iosUpdateDescription);
				vo.setUpdateLink(iosUpdateLink);
			}
			
		}
		else if (mobileType==2){
			
			Integer nowVersion =Integer.valueOf(androidVersion.replaceAll("\\.",""));
			
			//if(nowVersion>version){
				vo=new LiveVersionNoInfoVO();
				
				vo.setUpdateType(androidUpdateType);
				vo.setUpdateVersion(androidVersion);
				vo.setUpdateDescription(androidUpdateDescription);
				vo.setUpdateLink(androidUpdateLink);
			//}
		}
		
		return vo;
	}

	@POST
	@Path("/createMessage")
	@SysBusinessLog(remark = "创建直播内容")
	@Produces(MediaType.APPLICATION_JSON)
	public String createMessage(SaveCcpLiveMessageVO request) {

		String messageContent = request.getMessageContent();

		String messageImg = request.getMessageImg();

		String messageVideo = request.getMessageVideo();

		String messageActivity = request.getMessageActivity();

		String messageCreateUser = request.getMessageCreateUser();

		Integer messageIsInteraction = request.getMessageIsInteraction();
		
		String messageVideoImg =request.getMessageVideoImg();

		CcpLiveMessage message = new CcpLiveMessage();
		
		Date now=new Date();

		message.setMessageActivity(messageActivity);
		message.setMessageContent(messageContent);
		message.setMessageCreateTime(now);
		message.setMessageCreateUser(messageCreateUser);
		message.setMessageId(UUIDUtils.createUUId());
		message.setMessageImg(messageImg);
		message.setMessageIsDel(1);
		message.setMessageIsInteraction(messageIsInteraction);
		message.setSortTime(now.getTime());
		message.setMessageVideoImg(messageVideoImg);

		// 互动直播信息 0.否 1.是
		// 是互动直播
		if (messageIsInteraction != null && messageIsInteraction == 1) {
			message.setMessageIsRecommend(0);
		}
		
		if(StringUtils.isNotBlank(messageVideo)){
			
			final String videoNewName=AliOssVideo.getVideoNewName(messageVideo);
			
			int index=messageVideo.lastIndexOf("/");
			final String videoUrl=messageVideo.substring(0, index+1);
			final String videoName=messageVideo.substring(index+1, messageVideo.length());
			
			 //删除缓存
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                	
                	try {
                		AliOssVideo.transvideo("video", videoName, videoNewName);
        			} catch (ClientException e) {
        				e.printStackTrace();
        			}
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();
			
        	message.setMessageVideo(videoUrl+videoNewName);
        	message.setMessageVideoImg(messageVideoImg);
		}

		baseService.create(message);
		
		return message.getMessageId();
	}

	@POST
	@Path("/updateMessage")
	@SysBusinessLog(remark = "更新直播内容")
	@Produces(MediaType.APPLICATION_JSON)
	public int updateMessage(UpdateCcpLiveMessageVO request) {

		String messageId = request.getMessageId();

		String messageContent = request.getMessageContent();

		Integer messageIsTop = request.getMessageIsTop();

		Integer messageIsDel = request.getMessageIsDel();

		String messageImg = request.getMessageImg();

		String messageVideo = request.getMessageVideo();

		Integer messageIsInteraction = request.getMessageIsInteraction();

		Integer messageIsRecommend = request.getMessageIsRecommend();
		
		String messageVideoImg = request.getMessageVideoImg();
		
		Date now=new Date();
		
		CcpLiveMessage message = new CcpLiveMessage();
		
		message.setMessageId(messageId);
		message.setMessageIsTop(messageIsTop);
		message.setMessageUpdateTime(new Date());
		message.setMessageContent(messageContent);
		message.setMessageImg(messageImg);
		message.setMessageIsDel(messageIsDel);
		message.setMessageIsInteraction(messageIsInteraction);
		message.setMessageIsRecommend(messageIsRecommend);
		message.setMessageVideoImg(messageVideoImg);
		
		if(StringUtils.isNotBlank(messageVideo)){
			
			final String videoNewName=AliOssVideo.getVideoNewName(messageVideo);
			
			int index=messageVideo.lastIndexOf("/");
			final String videoUrl=messageVideo.substring(0, index+1);
			final String videoName=messageVideo.substring(index+1, messageVideo.length());
			
			 //删除缓存
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                	
                	try {
                		AliOssVideo.transvideo("video", videoName, videoNewName);
        			} catch (ClientException e) {
        				e.printStackTrace();
        			}
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();
			
        	message.setMessageVideo(videoUrl+videoNewName);
		}
		
		//互动信息是否推荐 0.否 1.是
		// 是推荐
		if(messageIsRecommend!=null&&messageIsRecommend==1){
			message.setMessageRecommendTime(now);
			
			message.setSortTime(now.getTime());
		}
		
		baseService.update(message, " where message_id='"+messageId+"'");

		return 1;
	}

	@POST
	@Path("/liveMessageList")
	@SysBusinessLog(remark = "直播列表")
	@Produces(MediaType.APPLICATION_JSON)
	public PageCcpLiveMessageVO liveMessageList(CcpLiveMessagePageVO request) {

		return ccpLiveMessageService.getLiveMessageList(request);

	}
	
	@POST
	@Path("/liveHistoryVideoList")
	@SysBusinessLog(remark = "直播精彩视频列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpLiveMessageVO> liveHistoryVideoList(CcpLiveActivityDetailVO vo){
		
		String liveActivityId=vo.getLiveActivityId();
		
		return ccpLiveMessageService.getLiveHistoryVideoList(liveActivityId);
	}
	
	@POST
	@Path("/notice")
	@SysBusinessLog(remark = "获取直播公共")
	@Produces(MediaType.APPLICATION_JSON)
	public String notice(BaseRequest request){
		
		return "欢迎使用文化云直播系统！";
	}

	@POST
	@Path("/saveLiveUserInfo")
	@SysBusinessLog(remark = "保存直播用户信息")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpLiveUserVO saveLiveUserInfo(SaveLiveUserVO vo) {

		String liveUserId = vo.getLiveUserId();

		CcpLiveUserVO result = new CcpLiveUserVO();

		if (StringUtils.isBlank(liveUserId)) {

			String userId = vo.getUserId();

			if (StringUtils.isNotBlank(userId)) {
				result = ccpLiveUserService.createLiveUserInfo(vo);
			}
		} else {
			result = ccpLiveUserService.updateLiveUserInfo(vo);
		}

		int isLikeSum = ccpLiveUserService.selectIsLikeSum(vo.getLiveActivity());

		result.setIsLikeSum(isLikeSum);

		return result;

	}

	@POST
	@Path("/liveUserImgList")
	@SysBusinessLog(remark = "直播用户图片列表")
	@Produces(MediaType.APPLICATION_JSON)
	public BasePageResultListVO<CcpLiveUserVO> liveUserImgList(CcpLiveUserImgPageVO request) {

		return ccpLiveUserService.selectLiveUserImgList(request);
	}

	@POST
	@Path("/liveUserDetail")
	@SysBusinessLog(remark = "直播用户详情")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpLiveUserVO liveUserDetail(CcpLiveUserDetailVO request) {

		return ccpLiveUserService.queryCcpLiveUserDetail(request);
	}
	
}
