/**
 * 
 */
package com.culturecloud.servicek;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.stereotype.Service;

import com.culturecloud.dao.dto.CmsCulturalSquareActivityDTO;
import com.culturecloud.dao.dto.CmsCulturalSquareCityImgDTO;
import com.culturecloud.dao.dto.CmsCulturalSquareLiveImgDTO;
import com.culturecloud.dao.dto.CmsCulturalSquareNyImgDTO;
import com.culturecloud.dao.dto.CmsCulturalSquareSceneImgDTO;
import com.culturecloud.dao.square.CmsCulturalSquareMapper;
import com.culturecloud.model.bean.square.CmsCulturalSquare;
import com.culturecloud.model.bean.square.SquareWhiter;
import com.culturecloud.service.BaseService;
import com.culturecloud.utils.SpecAccount;

/**************************************
 * @Description：监听日志Service
 * @author Zhangchenxi
 * @since 2015年11月23日
 * @version 1.0
 **************************************/
@Service
public class AreaService {

	@Resource
	private BaseService baseService;
	@Resource
	private CmsCulturalSquareMapper cmsCulturalSquareMapper;

	@ServiceActivator
	public void processLog(HashMap<Object, Object> msg) throws Exception {
		for (Entry<Object, Object> entry : msg.entrySet()) {
			ConcurrentHashMap<Integer, List<byte[]>> messages = (ConcurrentHashMap<Integer, List<byte[]>>) entry
					.getValue();
			Collection<List<byte[]>> values = messages.values();
			for (Iterator<List<byte[]>> iterator = values.iterator(); iterator.hasNext();) {
				List<byte[]> list = iterator.next();
				for (byte[] object : list) {
					String message = new String(object);
					// System.out.println("message=========="+message);

					if (message.indexOf("whyhdfb") != -1)// 活动发布/上架广场
					{//&& message.indexOf("ratingsInfo") == -1
						if (message.indexOf("activityId") != -1 && message.indexOf("ratingsInfo") != -1) {
							String[] contents = message.split(",");
							for (int i = 0; i < contents.length; i++) {
								String activityId = null;
								if (contents[i].indexOf("activityId") != -1) {
									String[] activityIds = contents[i].toString().split(":");
									activityId = activityIds[1].toString();
								}
								if (activityId != null) {
									List<CmsCulturalSquareActivityDTO> ss = cmsCulturalSquareMapper
											.getActivity(activityId);
									if (ss != null && ss.size() > 0) {
										addCmsCulturalSquare(ss,"1");
									}
								}
							}

						} else {
							String[] contents = message.split(",");
							for (int i = 0; i < contents.length; i++) {
								String activityImg = null;
								if (contents[i].indexOf("activityIconUrl:") != -1) {
									String[] activityImgs = contents[i].toString().split(":");
									activityImg = activityImgs[1].toString();
								}
								if (activityImg != null) {
									List<CmsCulturalSquareActivityDTO> ss = cmsCulturalSquareMapper
											.getActivityByImg(activityImg);
									if (ss != null && ss.size() > 0) {
										addCmsCulturalSquare(ss,"0");
									}
								}
							}
						}

					}

					if (message.indexOf("whycsmp") != -1)// 城市名片
					{
						String[] contents = message.split(",");
						for (int i = 0; i < contents.length; i++) {
							String cityImgUrl = null;
							if (contents[i].indexOf("cityImgUrl") != -1) {
								String cityImgUrls = contents[i].toString().substring(11,contents[i].length());
//								String aa=cityImgUrls[2].toString().replace(";", ",");
								cityImgUrl = cityImgUrls;
							}
							if (cityImgUrl != null) {
								List<CmsCulturalSquareCityImgDTO> ss = cmsCulturalSquareMapper.getCityImg(cityImgUrl);
								if (ss != null && ss.size() > 0) {
									CmsCulturalSquare ccs = new CmsCulturalSquare();
									ccs.setSquareId(com.culturecloud.utils.StringUtils.getUUID());
									if(this.isWhiteList(ss.get(0).getUserId(),"1").equals("SUCCESS"))//特殊账号处理
									{
										ccs.setStatus(1);
										ccs.setWhiteList(1);
									}
									ccs.setType(2);
									ccs.setContextDec(
											"参与了一个<span style=\"color: #c49123;font-size: 24px;\"># 活动  #</span>");
									ccs.setOutId(ss.get(0).getCityImgId());
									ccs.setExt1(ss.get(0).getCityContent());
									ccs.setExt0(ss.get(0).getCityUrl());
									ccs.setExt2("1");
									SimpleDateFormat myFmt2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
									Date s=myFmt2.parse(ss.get(0).getCreateTime());
									ccs.setPublishTime(myFmt2.format(s));
									if (ss.get(0).getUserNickName() != null) {
										ccs.setUserName(ss.get(0).getUserNickName());
									}
									if (ss.get(0).getHeadUrl() != null) {
										ccs.setHeadUrl(ss.get(0).getHeadUrl());
									}
									baseService.create(ccs);
								}
							}
						}
					}

					if (message.indexOf("whywzxc") != -1)// 我在现场
					{
						String[] contents = message.split(",");
						for (int i = 0; i < contents.length; i++) {
							String sceneImgUrl = null;
							if (contents[i].indexOf("sceneImgUrl") != -1) {
								String[] sceneImgUrls = contents[i].toString().split(":");
								sceneImgUrl = "http:" + sceneImgUrls[2].toString();
							}
							if (sceneImgUrl != null) {
								List<CmsCulturalSquareSceneImgDTO> ss = cmsCulturalSquareMapper
										.getSceneImg(sceneImgUrl);
								if (ss != null && ss.size() > 0) {
									CmsCulturalSquare ccs = new CmsCulturalSquare();
									ccs.setSquareId(com.culturecloud.utils.StringUtils.getUUID());
									ccs.setType(2);
									if(this.isWhiteList(ss.get(0).getUserId(),"1").equals("SUCCESS"))//特殊账号处理
									{
										ccs.setStatus(1);
										ccs.setWhiteList(1);
									}
									ccs.setContextDec(
											"参与了一个<span style=\"color: #c49123;font-size: 24px;\"># 活动  #</span>");
									ccs.setOutId(ss.get(0).getSceneImgId());
									ccs.setExt1(ss.get(0).getSceneContent());
									ccs.setExt0(ss.get(0).getSceneUrl());
									ccs.setExt2("2");
									SimpleDateFormat myFmt2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
									Date s=myFmt2.parse(ss.get(0).getCreateTime());
									ccs.setPublishTime(myFmt2.format(s));
									if (ss.get(0).getUserNickName() != null) {
										ccs.setUserName(ss.get(0).getUserNickName());
									}
									if (ss.get(0).getHeadUrl() != null) {
										ccs.setHeadUrl(ss.get(0).getHeadUrl());
									}
									baseService.create(ccs);
								}
							}
						}
					}
					
					if(message.indexOf("whyny") != -1)// 文化过新年
					{
						String[] contents = message.split(",");
						
						for (int i = 0; i < contents.length; i++) {
							String nyImgUrl = null;
							if (contents[i].indexOf("nyImgUrl") != -1) {
								String[] nyImgUrls = contents[i].toString().split(":");
								nyImgUrl = "http:" + nyImgUrls[2].toString();
							}
							if (nyImgUrl != null) {
								List<CmsCulturalSquareNyImgDTO> ss = cmsCulturalSquareMapper
										.getNyImg(nyImgUrl);
								if (ss != null && ss.size() > 0) {
									CmsCulturalSquare ccs = new CmsCulturalSquare();
									ccs.setSquareId(com.culturecloud.utils.StringUtils.getUUID());
									ccs.setType(2);
									if(this.isWhiteList(ss.get(0).getUserId(),"1").equals("SUCCESS"))//特殊账号处理
									{
										ccs.setStatus(1);
										ccs.setWhiteList(1);
									}
									ccs.setContextDec(
											"参与了一个<span style=\"color: #c49123;font-size: 24px;\"># 活动  #</span>");
									ccs.setOutId(ss.get(0).getNyImgId());
									ccs.setExt1(ss.get(0).getNyContent());
									ccs.setExt0(ss.get(0).getNyUrl());
									ccs.setExt2("3");
									SimpleDateFormat myFmt2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
									Date s=myFmt2.parse(ss.get(0).getCreateTime());
									ccs.setPublishTime(myFmt2.format(s));
									if (ss.get(0).getUserNickName() != null) {
										ccs.setUserName(ss.get(0).getUserNickName());
									}
									if (ss.get(0).getHeadUrl() != null) {
										ccs.setHeadUrl(ss.get(0).getHeadUrl());
									}
									baseService.create(ccs);
								}
							}
						}
					}
					
					if(message.indexOf("whylive") != -1)//文化直播
					{
						String[] contents = message.split(",");
						for (int i = 0; i < contents.length; i++) {
							String liveActivityId = null;
							if (contents[i].indexOf("liveActivityId") != -1) {
								String[] liveActivityIds = contents[i].toString().split(":");
								liveActivityId = liveActivityIds[1].toString();
							}
							if(liveActivityId!=null)
							{
								List<CmsCulturalSquareLiveImgDTO> ss = cmsCulturalSquareMapper.getLive(liveActivityId);
								if (ss != null && ss.size() > 0) {
									CmsCulturalSquare ccs = new CmsCulturalSquare();
									ccs.setSquareId(com.culturecloud.utils.StringUtils.getUUID());
									ccs.setType(6);
									ccs.setContextDec(
											"发布了一个<span style=\"color: #c49123;font-size: 24px;\"># 直播  #</span>");
									ccs.setOutId(ss.get(0).getLiveImgId());
									ccs.setExt1(ss.get(0).getLiveContent());
									ccs.setExt0(ss.get(0).getLiveUrl());
									SimpleDateFormat myFmt3=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
									Date sa=myFmt3.parse(ss.get(0).getStartTime());
								//	ccs.setPublishTime(myFmt2.format(s));
									ccs.setExt2(myFmt3.format(sa));
									SimpleDateFormat myFmt2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
									Date s=myFmt2.parse(ss.get(0).getCreateTime());
									ccs.setPublishTime(myFmt2.format(s));
									if (ss.get(0).getUserNickName() != null) {
										ccs.setUserName(ss.get(0).getUserNickName());
									}
									if (ss.get(0).getHeadUrl() != null) {
										ccs.setHeadUrl(ss.get(0).getHeadUrl());
									}
									baseService.create(ccs);
								}
							}
							
						}
					}
					

				}

			}

		}
	}
	
	/** 判断是否白名单*/
	private String isWhiteList(String userId,String type)
	{
		List<SquareWhiter> list=baseService.find(SquareWhiter.class," where white_user_id='"+userId+"' and type='"+type+"'");
		if(list!=null&&list.size()>0)
		{
			return "SUCCESS";
		}
		return "FALSE";
	}
	
	
	

	private String addCmsCulturalSquare(List<CmsCulturalSquareActivityDTO> ss,String type) throws ParseException {
		CmsCulturalSquare ccs = new CmsCulturalSquare();
		ccs.setSquareId(com.culturecloud.utils.StringUtils.getUUID());
		ccs.setType(1);
		ccs.setContextDec("发布了一个<span style=\"color: #c49123;font-size: 24px;\"># 活动  #</span>");
		ccs.setExt0(ss.get(0).getActivityIcon());
		ccs.setExt1(ss.get(0).getActivityName());
		if(type.equals("1"))//评级
		{
			ccs.setStatus(1);
			if (StringUtils.isNotBlank(ss.get(0).getVenueName())) {
				ccs.setExt2((StringUtils.isNotBlank(ss.get(0).getDictName()) ? ss.get(0).getDictName() + "." : "")
						+ ss.get(0).getVenueName());
			} else {
				ccs.setExt2((StringUtils.isNotBlank(ss.get(0).getDictName()) ? ss.get(0).getDictName() + "." : "")
						+ ss.get(0).getActivityAddress());
			}
			String start = ss.get(0).getActivityStart().substring(5, ss.get(0).getActivityStart().length()).replaceAll("-",
					".");
			String end = ss.get(0).getActivityEnd().substring(5, ss.get(0).getActivityStart().length()).replaceAll("-",
					".");
			ccs.setExt3(start + "-" + end);
			
			SimpleDateFormat myFmt2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date s=myFmt2.parse(ss.get(0).getActivityTime());
			ccs.setPublishTime(myFmt2.format(s));
			
			ccs.setOutId(ss.get(0).getActivityId());

			if (StringUtils.isNotBlank(ss.get(0).getVenueName())) {
				ccs.setUserName(ss.get(0).getVenueName());
			} else {
				ccs.setUserName("文化云");
			}
			List<CmsCulturalSquare> result=baseService.find(CmsCulturalSquare.class, " where out_id='"+ss.get(0).getActivityId()+"'");
			if(result!=null&&result.size()>0)
			{
				return "";
			}
			else
			{
				baseService.create(ccs);
			}
		}
		else
		{
			if(this.isWhiteList(ss.get(0).getVenueId(),"2").equals("SUCCESS"))//场馆白名单
			{
				ccs.setStatus(1);
				if (StringUtils.isNotBlank(ss.get(0).getVenueName())) {
					ccs.setExt2((StringUtils.isNotBlank(ss.get(0).getDictName()) ? ss.get(0).getDictName() + "." : "")
							+ ss.get(0).getVenueName());
				} else {
					ccs.setExt2((StringUtils.isNotBlank(ss.get(0).getDictName()) ? ss.get(0).getDictName() + "." : "")
							+ ss.get(0).getActivityAddress());
				}
				String start = ss.get(0).getActivityStart().substring(5, ss.get(0).getActivityStart().length()).replaceAll("-",
						".");
				String end = ss.get(0).getActivityEnd().substring(5, ss.get(0).getActivityStart().length()).replaceAll("-",
						".");
				ccs.setExt3(start + "-" + end);

				SimpleDateFormat myFmt2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date s=myFmt2.parse(ss.get(0).getActivityTime());
				ccs.setPublishTime(myFmt2.format(s));
				
				ccs.setOutId(ss.get(0).getActivityId());

				if (StringUtils.isNotBlank(ss.get(0).getVenueName())) {
					ccs.setUserName(ss.get(0).getVenueName());
				} else {
					ccs.setUserName("文化云");
				}
				List<CmsCulturalSquare> result=baseService.find(CmsCulturalSquare.class, " where out_id='"+ss.get(0).getActivityId()+"'");
				if(result!=null&&result.size()>0)
				{
					return "";
				}
				else
				{
					baseService.create(ccs);
				}
			}
		}
		return null;
	}

}
