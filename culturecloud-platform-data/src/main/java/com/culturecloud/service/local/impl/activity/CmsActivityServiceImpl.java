package com.culturecloud.service.local.impl.activity;

import java.lang.reflect.Method;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.dao.activity.CmsActivityEventMapper;
import com.culturecloud.dao.activity.CmsActivityMapper;
import com.culturecloud.dao.analyse.SysUserAnalyseMapper;
import com.culturecloud.dao.common.CmsCollectMapper;
import com.culturecloud.dao.common.CmsTagSubMapper;
import com.culturecloud.dao.common.SysNearSynonymMapper;
import com.culturecloud.dao.common.SysUserIntegralMapper;
import com.culturecloud.dao.dto.activity.ActivityDTO;
import com.culturecloud.dao.dto.activity.ActivityVO;
import com.culturecloud.dao.dto.activity.CmsActivityDto;
import com.culturecloud.dao.dto.activity.CmsActivityEventDto;
import com.culturecloud.dao.dto.analyse.SysUserAnalyseDto;
import com.culturecloud.dao.dto.common.CmsTagSubDto;
import com.culturecloud.exception.BizException;
import com.culturecloud.kafka.PpsConfig;
import com.culturecloud.model.bean.common.CmsCollect;
import com.culturecloud.model.request.activity.ActivityWcDetailVO;
import com.culturecloud.model.request.activity.RecommendActivityVO;
import com.culturecloud.model.request.ticketmachine.GetActListVO;
import com.culturecloud.model.response.activity.CmsActivityDetailVO;
import com.culturecloud.model.response.activity.CmsActivityRecommendVO;
import com.culturecloud.model.response.activity.CmsActivityVO;
import com.culturecloud.model.response.common.CmsTagSubVO;
import com.culturecloud.open.req.ActivitysRequest;
import com.culturecloud.service.local.activity.CmsActivityService;
import com.culturecloud.service.local.common.SysUserIntegralService;
import com.culturecloud.util.JSONResponse;
import com.culturecloud.utils.CompareTime;
import com.culturecloud.utils.RemoveRepeatedChar;
@Service 
public class CmsActivityServiceImpl implements CmsActivityService {

	@Resource
	private CmsActivityMapper cmsActivityMapper;
	@Resource
	private SysUserAnalyseMapper sysUserAnalyseMapper;
	@Resource
	private CmsTagSubMapper cmsTagSubMapper;
	@Resource 
	private CmsCollectMapper cmsCollectMapper;
	@Resource
	private CmsActivityEventMapper cmsActivityEventMapper;
	@Resource
	private SysUserIntegralMapper sysUserIntegralMapper;
	@Resource
	private SysNearSynonymMapper sysNearSynonymMapper;
	
	@Resource
	private SysUserIntegralService sysUserIntegralService;
	
	private String chinaPlatformDataUrl=PpsConfig.getString("chinaPlatformDataUrl");
	
	private String staticServerUrl=PpsConfig.getString("staticServerUrl");
	
	private String shareUrl=PpsConfig.getString("shareUrl");
	
	@Override
	public List<CmsActivityRecommendVO> queryRecommendActivity(RecommendActivityVO request) {

		
		Integer resultIndex=request.getResultIndex();
		
		Integer resultSize=request.getResultSize();
		
		String userId=request.getUserId();

		Double lat=request.getLat();
		
		Double lon=request.getLon();

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userId", userId);
		
		List<CmsActivityDto> activityDtoList = new ArrayList<CmsActivityDto>();
		
		if(StringUtils.isNotBlank(userId))
		{
			List<SysUserAnalyseDto> sysUserAnalyseList=sysUserAnalyseMapper.queryUserSumType(userId);
			
			if(sysUserAnalyseList.size()>0)
			{
				for (SysUserAnalyseDto sysUserAnalyseDto : sysUserAnalyseList) {
					
					String tagId=sysUserAnalyseDto.getTagId();
					
					List<CmsActivityDto> aList= cmsActivityMapper.queryUserSoucreActivityList(tagId);
					
					activityDtoList.addAll(aList);
				}
			}
		}
		else if(lat!=null&&lon!=null)
		{
			map.put("lat", lat);
			map.put("lon", lon);
			
			// 查询附近三个活动
			List<CmsActivityDto> aList =cmsActivityMapper.queryNearActivityList(map);
			
			activityDtoList.addAll(aList);
		}

		List<CmsActivityDto> aList = cmsActivityMapper.queryRecommendActivityList(map);
		
		activityDtoList.addAll(aList);

		List<CmsActivityRecommendVO> resultList = new ArrayList<CmsActivityRecommendVO>();
		
		// 检查重复活动set
		Set<String> existActivityIdSet=new HashSet<String>();

		for (CmsActivityDto activity : activityDtoList) {
			
			String activityId=activity.getActivityId();
			
			if(existActivityIdSet.contains(activityId))
				continue;
			else
				existActivityIdSet.add(activityId);
			
			CmsActivityRecommendVO vo = new CmsActivityRecommendVO(activity);

			if (activity.getActivityIsReservation() == 2) {
				if (activity.getSpikeType() == 1) {
					vo.setActivitySubject((StringUtils.isNotBlank(activity.getActivitySubject())
							? activity.getActivitySubject() + "." : "") + "抢票秒杀");
				} else {
					vo.setActivitySubject((StringUtils.isNotBlank(activity.getActivitySubject())
							? activity.getActivitySubject() + "." : "") + "在线预定");
				} 
			} else {
				vo.setActivitySubject((StringUtils.isNotBlank(activity.getActivitySubject())
						? activity.getActivitySubject() + "." : "") + "直接前往");
			}

			if (StringUtils.isNotBlank(activity.getVenueName())) {

				vo.setActivityLocationName(
						(StringUtils.isNotBlank(activity.getDictName()) ? activity.getDictName() + "." : "")
								+ activity.getVenueName());
			} else {
				vo.setActivityLocationName(
						(StringUtils.isNotBlank(activity.getDictName()) ? activity.getDictName() + "." : "")
								+ activity.getActivityAddress());
			}

			  String activityIconUrl = "";
              if (StringUtils.isNotBlank(activity.getActivityIconUrl())) {
              	
              	if(activity.getActivityIconUrl().indexOf("http:")>-1)
              		
              		activityIconUrl=activity.getActivityIconUrl();
              	else
              		activityIconUrl = staticServerUrl + activity.getActivityIconUrl();
              }

			vo.setActivityIconUrl(activityIconUrl);

			// 获取活动经纬度
			double activityLon = 0d;
			if (activity.getActivityLon() != null) {
				activityLon = activity.getActivityLon();
			}
			double activityLat = 0d;
			if (activity.getActivityLat() != null) {
				activityLat = activity.getActivityLat();
			}
			double distance = 0d;
			if (activity.getDistance() != null) {
				distance = activity.getDistance();
			}

			vo.setActivityLon(activityLon);
			vo.setActivityLat(activityLat);
			if (StringUtils.isNotBlank(activity.getSysId()) && "1".equals(activity.getSysNo())) {
				distance = 20 + (int) (Math.random() * 10000) % 10;
				vo.setDistance(distance);
			} else {
				vo.setDistance(distance / 1000);
			}

			vo.setAvailableCount(activity.getAvailableCount() != null ? activity.getAvailableCount() : 0);
			// 是否可预订 1：否 2：是
			vo.setActivityIsReservation(
					activity.getActivityIsReservation() != null ? activity.getActivityIsReservation() : 1);
			vo.setActivityArea(activity.getActivityArea() != null ? activity.getActivityArea() : "");
			vo.setSysNo(activity.getSysNo() != null ? activity.getSysNo() : "");
			vo.setSysId(activity.getSysId() != null ? activity.getSysId() : "");
			// 判断是否是热
			vo.setActivityIsHot((activity.getYearBrowseCount() != null && activity.getYearBrowseCount() > 500) ? 1 : 0);
			vo.setActivityRecommend(StringUtils.isNotBlank(activity.getActivityRecommend())
					&& "Y".equals(activity.getActivityRecommend()) ? "Y" : "N");
			// vo.put("activityIsCollect", activity.getCollectNum() !=
			// null ? (activity.getCollectNum() > 0 ? 1 : 0) : 0);

			//vo.setPriceType(activity.getPriceType());
			//vo.setSpikeType(activity.getSpikeType());
			
			List<CmsTagSubDto> cmsTagSubList=cmsTagSubMapper.queryRelateTagSubList(activity.getActivityId());
			
			List<CmsTagSubVO> subList= new ArrayList<CmsTagSubVO>();
			
			for (CmsTagSubDto cmsTagSubDto : cmsTagSubList) {
				
				subList.add(new CmsTagSubVO(cmsTagSubDto));
			}
			
			//vo.setTagName(activity.getTagName());
			
			vo.setSubList(subList);
			
			resultList.add(vo);

		}

		return resultList;
	}

	@Override
	public List<CmsActivityVO> searchActivity(int limit,String keyword) {

		LinkedHashMap<String,CmsActivityDto> activityAllMap=new LinkedHashMap<String,CmsActivityDto>();
		
		activityAllMap= this.eachSearchActivity(activityAllMap, keyword, limit, 0);
		
		// 搜索为空时 查询是否有近义词继续查询
		if(activityAllMap.size()==0)
		{
			String nearSynonym=sysNearSynonymMapper.queryNearSynonym(keyword);
			
			if(StringUtils.isNotBlank(nearSynonym))
			{
				activityAllMap= this.eachSearchActivity(activityAllMap, nearSynonym, limit, 0);
			}
		}
		
		List<CmsActivityVO> result= new ArrayList<CmsActivityVO>();
		
		List<CmsActivityDto> list=new ArrayList<CmsActivityDto>(activityAllMap.values());
		
		activityAllMap=null;
		
		if(list.size()>0){
			
			Collections.sort(list,  new Comparator<CmsActivityDto>(){

				@Override
				public int compare(CmsActivityDto a1, CmsActivityDto a2) {
					
					String dictName1=a1.getRating();
					String dictName2=a2.getRating();
					
					if(StringUtils.isBlank(dictName1))
						dictName1="D";
					if(StringUtils.isBlank(dictName2))
						dictName2="D";
					
					return dictName1.compareTo(dictName2);
				}
				
			});
			
			for (CmsActivityDto cmsActivityDto : list) {
				
				CmsActivityVO vo=new CmsActivityVO(cmsActivityDto);
				
				String activityIconUrl = "";
	             if (StringUtils.isNotBlank(cmsActivityDto.getActivityIconUrl())) {
	                	
	               if(cmsActivityDto.getActivityIconUrl().indexOf("http:")>-1)
	                		
	                		activityIconUrl=cmsActivityDto.getActivityIconUrl();
	                	else
	                		activityIconUrl = staticServerUrl + cmsActivityDto.getActivityIconUrl();
	                }
				
				List<CmsTagSubDto> cmsTagSubList=cmsTagSubMapper.queryRelateTagSubList(cmsActivityDto.getActivityId());
				
				List<CmsTagSubVO> subList= new ArrayList<CmsTagSubVO>();
				
				for (CmsTagSubDto cmsTagSubDto : cmsTagSubList) {
					
					subList.add(new CmsTagSubVO(cmsTagSubDto));
				}
				
				vo.setSubList(subList);

				vo.setActivityIconUrl(activityIconUrl);
				
				if (StringUtils.isNotBlank(cmsActivityDto.getVenueName())) {

					vo.setActivityLocationName(
							(StringUtils.isNotBlank(cmsActivityDto.getDictName()) ? cmsActivityDto.getDictName() + "." : "")
									+ cmsActivityDto.getVenueName());
				} else {
					vo.setActivityLocationName(
							(StringUtils.isNotBlank(cmsActivityDto.getDictName()) ? cmsActivityDto.getDictName() + "." : "")
									+ cmsActivityDto.getActivityAddress());
				}

				vo.setAvailableCount(cmsActivityDto.getAvailableCount() != null ? cmsActivityDto.getAvailableCount() : 0);
				
				result.add(vo);
			}
		}
		
		
	
		
		return result;
	}

	@Override
	public List<String> searchAutomatedName(int limit, String keyword) {
		
		return cmsActivityMapper.searchAutomatedName(keyword, limit);
	}
	
	/**
	 * 依次条件查询
	 * 
	 * @param activityAllSet
	 * @param limit
	 * @param index
	 * @return
	 */
	private LinkedHashMap<String,CmsActivityDto> eachSearchActivity (LinkedHashMap<String,CmsActivityDto> activityAllMap,String keyword,int limit,int index) {
		String methodArray[]=new String[]{"searchByName","searchByType","searchByTag","searchByAddress","searchByVenue","searchByPerformed"};
		
		if(index>=methodArray.length){
			return activityAllMap;
		}
		else
		{
			List<CmsActivityDto> list=new ArrayList<CmsActivityDto>();
			
			Method m;
			try {
				m = CmsActivityMapper.class.getDeclaredMethod(methodArray[index], new Class[]{String.class,int.class});
				
				 list=(List<CmsActivityDto>) m.invoke(cmsActivityMapper, new Object[]{keyword,limit});
			} catch (Exception e) {
				e.printStackTrace();
				return activityAllMap;
			} 
				
			for (CmsActivityDto cmsActivityDto : list) {
				
				if(!activityAllMap.containsKey(cmsActivityDto.getActivityId()))
				{
					activityAllMap.put(cmsActivityDto.getActivityId(), cmsActivityDto);
					limit-=1;
				}
			}
			
			if(limit<=0)
				return activityAllMap;
			else
			{
				index++;
				this.eachSearchActivity(activityAllMap, keyword, limit, index);
			}
		}
		
		return activityAllMap;
	}

	@Override
	public CmsActivityDetailVO queryCmsActivityDetail(ActivityWcDetailVO request) {
		
		String userId=request.getUserId();
		String activityId=request.getActivityId();
		
		CmsActivityDetailVO vo=new CmsActivityDetailVO();
		
		  SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	  //      List<Map<String, Object>> mapTypeList = new ArrayList<Map<String, Object>>();
	        Map<String, Object> map = new HashMap<String, Object>();
	        if (StringUtils.isNotBlank(userId)) {
	            map.put("userId", userId);
	            // 活动
	            map.put("type", 2);
	        }
	        if (StringUtils.isNotBlank(activityId)) {
	            map.put("relatedId", activityId);
	        }
	        map.put("videoType", 1);
	        if (StringUtils.isNotBlank(request.getActivityIsDel())) {
	            map.put("activityIsDel", request.getActivityIsDel());
	        }
	        CmsActivityDto cmsActivity = cmsActivityMapper.queryCmsActivityDetailById(map);
	        if (StringUtils.isNotBlank(cmsActivity.getActivityId())) {
	          //  Map<String, Object> vo = new HashMap<String, Object>();
	        	
	        	 vo=new CmsActivityDetailVO(cmsActivity);
	        	 List<CmsTagSubDto> cmsTagSubList=cmsTagSubMapper.queryRelateTagSubList(cmsActivity.getActivityId());
					
					List<CmsTagSubVO> subList= new ArrayList<CmsTagSubVO>();
					
					for (CmsTagSubDto cmsTagSubDto : cmsTagSubList) {
						
						subList.add(new CmsTagSubVO(cmsTagSubDto));
					}
					
					vo.setSubList(subList);
	        	
	            String activityIconUrl = "";
                if (StringUtils.isNotBlank(cmsActivity.getActivityIconUrl())) {
                	
                	if(cmsActivity.getActivityIconUrl().indexOf("http:")>-1)
                		
                		activityIconUrl=cmsActivity.getActivityIconUrl();
                	else
                		activityIconUrl = staticServerUrl + cmsActivity.getActivityIconUrl();
                }
	            vo.setActivityIconUrl(activityIconUrl);
	            vo.setActivityIsCollect(cmsActivity.getCollectNum() > 0 ? 1 : 0);
	          	vo.setActivityFunName(cmsActivity.getFunName() != null ? cmsActivity.getFunName() : "");
	          
	            CmsCollect cmsCollect = new CmsCollect();
	    		cmsCollect.setRelateId(cmsActivity.getActivityId());
	    		cmsCollect.setType(2);
	            
	            //查询该活动收藏数量
	            int collectNum = cmsCollectMapper.getHotNum(cmsCollect);
	            vo.setCollectNum(collectNum != 0 ? collectNum : 0);
	            vo.setActivityName(cmsActivity.getActivityName() != null ? cmsActivity.getActivityName() : "");
	            vo.setActivitySite(cmsActivity.getActivitySite() != null ? cmsActivity.getActivitySite() : "");
	         //   if (StringUtils.isNotBlank(cmsActivity.getVenueName())) {
	          //     vo.setActivityAddress((StringUtils.isNotBlank(cmsActivity.getActivityAddress()) ? cmsActivity.getActivityAddress() + "." : "") + cmsActivity.getVenueName());
	          //  } else {
	                vo.setActivityAddress(StringUtils.isNotBlank(cmsActivity.getActivityAddress()) ?
	                        cmsActivity.getActivityAddress() + (StringUtils.isNotBlank(cmsActivity.getActivitySite()) ? "." +
	                                cmsActivity.getActivitySite() : "") : (StringUtils.isNotBlank(cmsActivity.getActivitySite()) ? cmsActivity.getActivitySite() : ""));
	          //  }
	            vo.setActivityStartTime(cmsActivity.getActivityStartTime() != null ? cmsActivity.getActivityStartTime() : "");
	            vo.setActivityEndTime(StringUtils.isNotBlank(cmsActivity.getActivityEndTime()) ?
	                    cmsActivity.getActivityEndTime() : vo.getActivityStartTime());
	            vo.setActivityTel(cmsActivity.getActivityTel() != null ? cmsActivity.getActivityTel() : "");

	            //子系统对接修改
	            vo.setActivityDateNums(cmsActivity.getDateNums());
	            //end
	            vo.setActivityTimeDes(cmsActivity.getActivityTimeDes() != null ? cmsActivity.getActivityTimeDes() : "");
	            vo.setActivityIsFree(cmsActivity.getActivityIsFree() != null ? cmsActivity.getActivityIsFree() : 1);
	            vo.setActivityPrice(cmsActivity.getActivityPrice() != null ? cmsActivity.getActivityPrice() : "");
	            vo.setPriceDescribe( cmsActivity.getPriceDescribe() != null ? cmsActivity.getPriceDescribe() : "");
	            // 嘉定数据
//	            if ("1".equals(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
//	                //为嘉定活动时
//	                Map map1 = this.getSubSystemTicketCount(cmsActivity);
//	                if (map1 != null && "Y".equals(map1.get("success").toString())) {
//	                    Integer ticketCount = Integer.valueOf(map1.get("ticketCount") == null ? "0" : map1.get("ticketCount").toString());
//	                    vo.put("activityAbleCount", ticketCount);
//	                } else {
//	                    vo.put("activityAbleCount", 0);
//	                }
//	            } else {
	            vo.setActivityAbleCount(cmsActivity.getAvailableCount() != null ? cmsActivity.getAvailableCount() : 0);
//	            }

	           vo.setActivityTime(cmsActivity.getActivityTime() != null ? cmsActivity.getActivityTime() : "");
	            //获取活动经纬度
	            double activityLon = 0d;
	            if (cmsActivity.getActivityLon() != null) {
	                activityLon = cmsActivity.getActivityLon();
	            }
	            double activityLat = 0d;
	            if (cmsActivity.getActivityLat() != null) {
	                activityLat = cmsActivity.getActivityLat();
	            }
	            vo.setActivityLon(activityLon);
	            vo.setActivityLat(activityLat);
	            vo.setActivityIsReservation(cmsActivity.getActivityIsReservation());
	            vo.setActivitySupplementType(cmsActivity.getActivitySupplementType()!=null?cmsActivity.getActivitySupplementType():1);
	            vo.setActivitySalesOnline(cmsActivity.getActivitySalesOnline() != null ? cmsActivity.getActivitySalesOnline() : "");
	            vo.setActivityId(cmsActivity.getActivityId() != null ? cmsActivity.getActivityId() : "");
	            vo.setActivityMemo(cmsActivity.getActivityMemo() != null ? cmsActivity.getActivityMemo() : "");
	            vo.setActivityHost( cmsActivity.getActivityHost() != null ? cmsActivity.getActivityHost() : "");
	            vo.setActivityOrganizer(cmsActivity.getActivityOrganizer() != null ? cmsActivity.getActivityOrganizer() : "");
	            vo.setActivityCoorganizer( cmsActivity.getActivityCoorganizer() != null ? cmsActivity.getActivityCoorganizer() : "");
	            vo.setActivityPerformed( cmsActivity.getActivityPerformed() != null ? cmsActivity.getActivityPerformed() : "");
	            vo.setActivitySpeaker( cmsActivity.getActivitySpeaker() != null ? cmsActivity.getActivitySpeaker() : "");
	            // 无收费（活动简介前加直接前往、无需预约、无需付费，有任何问题欢迎拨打电话咨询（电话号码？）），有收费（需要事先预定，请点击“活动预定”按钮进行票务预订。有任何问题欢迎拨打电话咨询（电话号码？））
	            if (cmsActivity.getActivityIsFree() == 1) {
	                if (cmsActivity.getActivityIsReservation() == 1) {
	                    vo.setActivityTips("<font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'> 温馨提示：</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>本活动无需在文化云平台预约，具体参与方式请以主办方公布为准，您可拨打电话" +
	                            "(" + vo.getActivityTel() + ")进行咨询</font>");
	                } else if (cmsActivity.getActivityIsReservation() == 2) {
	                	 vo.setActivityTips("<font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'> 温馨提示：</font>" +
	                            "<font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>需要事先预定，" +
	                            "请点击“</font><font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>" +
	                            "立即预约</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>”按钮进行票务预订。有任何问题欢迎拨打电话" +
	                            "咨询(" + vo.getActivityTel() + ")</font>");
	                }
	            } else if (cmsActivity.getActivityIsFree() == 2) {
	                if (cmsActivity.getActivityIsReservation() == 1) {
	                	 vo.setActivityTips("<font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>温馨提示：</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>本活动无需在文化云平台预约，需要收费，具体参与方式请以主办方公布为准，您可拨打电话" +
	                            "(" + vo.getActivityTel() + ")进行咨询</font>");
	                } else if (cmsActivity.getActivityIsReservation() == 2) {
	                	 vo.setActivityTips("<font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>温馨提示：</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>需要事先预定，需要付费，" +
	                            "请点击“</font><font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>立即预约</font><font color='#262626' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>”按钮进行票务预订。" +
	                            "有任何问题欢迎拨打电话咨询(" + vo.getActivityTel() + ")</font>");
	                }
	            } else if (cmsActivity.getActivityIsFree() == 3){
	            	
	            	 vo.setActivityTips("<font color='#FA8808' style='font-family:\"STYuanti-SC-Light\";font-size:\"26px\"'>温馨提示：</font>"
	            	 		+ "1.您需要在下单成功后15分钟内付款，逾期订单即被取消。<br>2.活动名额有限，付款视为占用名额，"
	            	 		+ "不接受任何形式的取消订单。付款后未实际到场参与，将视为放弃订单权利，不予退款。请您谨慎下单。"
	            	 		+ "<br>3.如您对订单有疑问，可咨询客服电话400-0182346，工作时间周一至周五，9:30-17:00</font>");
	            }
	            
	            //获取活动视频信息
//	            List<CmsVideo> videoList = cmsVideoMapper.queryVideoById(map);
//	            if (CollectionUtils.isNotEmpty(videoList)) {
//	                for (CmsVideo videos : videoList) {
//	                    Map<String, Object> mapVideo = new HashMap<String, Object>();
//	                    mapVideo.put("videoTitle", videos.getVideoTitle() != null ? videos.getVideoTitle() : "");
//	                    mapVideo.put("videoLink", videos.getVideoLink() != null ? videos.getVideoLink() : "");
//	                    String videoImgUrl = "";
//	                    if (StringUtils.isNotBlank(videos.getVideoImgUrl())) {
//	                        videoImgUrl = staticServer.getStaticServerUrl() + videos.getVideoImgUrl();
//	                    }
//	                    mapVideo.put("videoImgUrl", videoImgUrl);
//	                    mapVideo.put("videoCreateTime", DateUtils.formatDate(videos.getVideoCreateTime()));
//	                    listVideo.add(mapVideo);
//	                }
//	            }
	            List<CmsActivityEventDto> activityEventList = cmsActivityEventMapper.queryActivityEventById(map);
	            if (CollectionUtils.size(activityEventList)>0) {
	                StringBuffer eventIds = new StringBuffer(); // 封装活动场次id
	                StringBuffer statusSb = new StringBuffer(); //封装时间段是否有效
	                StringBuffer eventimes = new StringBuffer(); //封装活动具体时间
	                StringBuffer timeQuantums = new StringBuffer(); //封装活动时间段
	                StringBuffer eventCounts = new StringBuffer();//封装每个活动时间段场次票数
	                StringBuffer eventPrices = new StringBuffer();//封装每个活动时间段场次票价
	                StringBuffer spikeDifferences = new StringBuffer();//封装每个活动秒杀倒计时（时间戳）（如果非秒杀活动为0）
	                for (CmsActivityEventDto events : activityEventList) {
//	                    if ("1".equals(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
//	                        //为嘉定活动时
//	                        events.setCounts(Integer.parseInt(vo.get("activityAbleCount").toString()));
//	                    }

	                    Date date = new Date();
	                    String times = null ;
	                    int statusDate = 0;
	                    String nowDate2 = sdf2.format(date);
						System.out.println("=======================================nowDate2=" + nowDate2);
						if(cmsActivity.getCancelEndTime() != null){
	                    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	                    	times = sdf.format(cmsActivity.getCancelEndTime());
	                    	statusDate = CompareTime.timeCompare2(times, nowDate2);
							System.out.println("=======================================times=" + times);
	                    }else{
	                    	times = events.getEventDateTime().substring(0, events.getEventDateTime().lastIndexOf("-"));
	                    	statusDate = CompareTime.timeCompare1(times, nowDate2);
							System.out.println("=======================================times=" + times);
	                    }
	                    
	                    String eventId = events.getEventId() != null ? events.getEventId() : "";
	                    String timeQuantum = events.getEventTime() != null ? events.getEventTime() : "";
	                    String eventDateTimes = events.getEventDateTime() != null ? events.getEventDateTime() : "";
	                    String eventPrice = events.getOrderPrice() != null ? events.getOrderPrice() : "0";
	                    int eventCount = events.getCounts() > 0 ? events.getCounts() : 0;
	                    long spikeDifference = 0;
	                    if (events.getSpikeTime() != null) {
	                        spikeDifference = (events.getSpikeTime().getTime() - new Date().getTime()) / 1000;
	                    }
	                    //返回 0 表示时间日期相同
	                    //返回 1 表示日期1>日期2
	                    //返回 -1 表示日期1<日期2
	                    if (statusDate == -1 || events.getCounts() == 0) {
	                        statusSb.append("0" + ",");
	                    } else {
	                        statusSb.append("1" + ",");
	                    }
	                    eventIds.append(eventId + ",");
	                    timeQuantums.append(timeQuantum + ",");
	                    eventimes.append(eventDateTimes + ",");
	                    eventCounts.append(eventCount + ",");
	                    eventPrices.append(eventPrice + ",");
	                    spikeDifferences.append((spikeDifference >= 0 ? spikeDifference : 0) + ",");
	                }
	                //预定活动时使用id 
	                vo.setActivityEventIds(eventIds.toString());
	                //场次开始日期加时间段
	                vo.setActivityEventimes(eventimes.toString());
	                vo.setStatus( statusSb.toString());
	                vo.setTimeQuantum( RemoveRepeatedChar.removerepeatedchar(timeQuantums.toString()));
	                vo.setEventCounts( eventCounts.toString());
	                vo.setEventPrices( eventPrices.toString());
	                vo.setSpikeDifferences( spikeDifferences.toString());

	                String lastEventTime = vo.getActivityEndTime() + " " + activityEventList.get(activityEventList.size() - 1).getEventTime().split("-")[0];
	                try {
	                    vo.setActivityIsPast((sdf2.parse(lastEventTime).getTime() - new Date().getTime()) > 0 ? 0 : 1);
	                } catch (ParseException e) {
	                    
	                    new BizException(e, "activityIsPast判断出错");
	                }
	            } else {
	                String lastEventTime = vo.getActivityEndTime()  + " 00:00";
	                try {
	                    vo.setActivityIsPast((sdf2.parse(lastEventTime).getTime() - new Date().getTime()) > 0 ? 0 : 1);
	                } catch (ParseException e) {
	                    new BizException(e, "activityIsPast判断出错");
	                }
	            }

	            //添加分享的shareUrl
	            StringBuffer sb = new StringBuffer();
	            sb.append(shareUrl);
	            sb.append("wechatActivity/preActivityDetail.do?");
	            sb.append("activityId=" + cmsActivity.getActivityId());
	            vo.setShareUrl(sb.toString());
	            
	            //该用户是否已报名该活动 0.该用户未参加 1.参加
	            vo.setActivityIsWant(cmsActivity.getActivityIsWant() > 0 ? cmsActivity.getActivityIsWant() : 0);
	            vo.setActivityNotice(cmsActivity.getActivityNotice() != null ? cmsActivity.getActivityNotice() : "");
	               
	            vo.setTicketSettings(StringUtils.isNotBlank(cmsActivity.getTicketSettings()) ? cmsActivity.getTicketSettings() : "Y");

	            //积分判断
	            if (StringUtils.isNotBlank(userId)) {
	            	Integer integralNow = request.getIntegralNow();
	                if (integralNow != null) {
	                    if (cmsActivity.getLowestCredit() != null) {
	                        if (cmsActivity.getLowestCredit() > integralNow) {
	                            vo.setIntegralStatus("1");
	                        } else {
	                            if (cmsActivity.getCostCredit() != null) {
	                                if (cmsActivity.getCostCredit() > integralNow) {
	                                	vo.setIntegralStatus("2");
	                                } else {    //消耗积分未填
	                                	vo.setIntegralStatus("0");
	                                }
	                            } else {
	                            	vo.setIntegralStatus("0");
	                            }
	                        }
	                    } else {    //最低积分未填
	                        if (cmsActivity.getCostCredit() != null) {
	                            if (cmsActivity.getCostCredit() > integralNow) {
	                            	vo.setIntegralStatus("2");
	                            } else {
	                            	vo.setIntegralStatus("0");
	                            }
	                        } else {
	                        	vo.setIntegralStatus("0");
	                        }
	                    }
	                } else {
	                    if (vo.getLowestCredit() != null) {
	                    	vo.setIntegralStatus("1");
	                    } else {
	                        if (vo.getCostCredit() !=null) {
	                        	vo.setIntegralStatus("2");
	                        } else {
	                        	vo.setIntegralStatus("0");
	                        }
	                    }
	                }
	            }
	            
	            //社团
	            if(cmsActivity.getAssnId() != null){
	            	if(cmsActivity.getAssnId().equals("4498a594334544058d3985312f342c23")){
	            		vo.setAssnSub(new String[]{"亲子","演出","公司"});
	            	}else if(cmsActivity.getAssnId().equals("6e00d525b1b54120926cb2bbf576f9be")){
	            		vo.setAssnSub( new String[]{"歌手","爵士","老歌"});
	            	}else if(cmsActivity.getAssnId().equals("ed842f496651403488dee164da78ba17")){
	            		vo.setAssnSub( new String[]{"公益","音乐","美术"});
	            	}else if(cmsActivity.getAssnId().equals("816cf35a86554333873f1159f864d73b")){
	            		vo.setAssnSub(new String[]{"相声","民营"});
	            	}else if(cmsActivity.getAssnId().equals("0ead672fac2f4e65b0ec12cad960ad98")){
	            		vo.setAssnSub( new String[]{"昆曲","闺门旦","上戏"});
	            	}else if(cmsActivity.getAssnId().equals("1883b371dbd4403aba8e3aac9166d19c")){
	            		vo.setAssnSub( new String[]{"相声","快板"});
	            	}else if(cmsActivity.getAssnId().equals("ac7e0d5e691a44c2bb5808c8d29ff639")){
	            		vo.setAssnSub( new String[]{"话剧","白领","浦东"});
	            	}else if(cmsActivity.getAssnId().equals("97f9b201374a4078abfbf55ca8316d45")){
	            		vo.setAssnSub( new String[]{"人声","乐团"});
	            	}else if(cmsActivity.getAssnId().equals("632a0af23b3a4cf1ad77f9a04db65a4f")){
	            		vo.setAssnSub( new String[]{"古琴","非遗","市民文化协会"});
	            	}
	            }else{
	            	vo.setAssnId("");
	            }
	        }
		
		return vo;
	}

	/*@Override
	public ActivityDTO getActiviyList(ActivitysRequest open) {
		// TODO Auto-generated method stub
		ActivityDTO activityDTO = new ActivityDTO();
		List<ActivityVO> activityVOlist= new ArrayList<ActivityVO>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(open.getCreateUserId())) {
			map.put("activityCreateUser", open.getCreateUserId());
		}
		// 分页
		if (StringUtils.isNotBlank(open.getFirstResult())) {
			map.put("firstResult", open.getFirstResult());
			map.put("rows", open.getRows());
		}
		int total = cmsActivityMapper.getActiviyInfoCount(map);
		activityDTO.setTotal(total);
		activityVOlist = cmsActivityMapper.getActiviyInfoList(map);
		activityDTO.setActivitys(activityVOlist);
		
		return activityDTO;
	}*/
	
	@Override
	public JSONObject queryTicketActivityByCidition(GetActListVO request) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(request.getTagId())) {
            map.put("tagId", request.getTagId());
        }
		if (StringUtils.isNotBlank(request.getVenueId())) {
			map.put("venueId", request.getVenueId());
		}
		if (StringUtils.isNotBlank(request.getDeptId())) {
			map.put("deptId", request.getDeptId());
		}
		//取票机暂时不开放秒杀、积分、付费、在线选座、子区县对接活动 
		map.put("isTicketMachine", 1);
		map.put("firstResult", request.getFirstResult());
        map.put("rows", request.getRows());
		JSONArray array = new JSONArray();
		try {
			List<CmsActivityDto> actList = cmsActivityMapper.queryActivityByCidition(map);
			for(CmsActivityDto dto : actList){
				JSONObject jsonObj = new JSONObject();
				String activityIconUrl = "";
			    if (StringUtils.isNotBlank(dto.getActivityIconUrl())) {
			    	if(dto.getActivityIconUrl().indexOf("http:")>-1){
			    		activityIconUrl = dto.getActivityIconUrl();
			    	}else{
			    		activityIconUrl = staticServerUrl + dto.getActivityIconUrl();
			    	}
			    }
			    jsonObj.put("activityId", dto.getActivityId());
				jsonObj.put("activityName", dto.getActivityName());
				jsonObj.put("activityIconUrl", activityIconUrl);
				jsonObj.put("activityAddress", dto.getActivityAddress());
				jsonObj.put("activityStartTime", dto.getActivityStartTime());
				jsonObj.put("activityEndTime", dto.getActivityEndTime());
				jsonObj.put("tagName", dto.getTagName());
				array.add(jsonObj);
			}
			return JSONResponse.getResultFormat(200, array);
		} catch (Exception e) {
			e.printStackTrace();
			return JSONResponse.getResultFormat(500, e.getMessage());
		}
	}
}
