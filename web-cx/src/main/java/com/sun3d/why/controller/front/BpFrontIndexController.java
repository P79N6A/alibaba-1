package com.sun3d.why.controller.front;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.dao.CmsActivityRoomMapper;
import com.sun3d.why.model.BpInfo;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.ccp.CcpAdvertRecommend;
import com.sun3d.why.service.BpInfoService;
import com.sun3d.why.service.CcpAdvertRecommendService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.CmsAdvertService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping("/bpFrontIndex")
@Controller
public class BpFrontIndexController {
	private Logger logger = LoggerFactory.getLogger(BpFrontIndexController.class);
	@Autowired
	BpInfoService bpInfoService;
	@Autowired
	private CmsVenueService cmsVenueService;
	@Autowired
	private CmsActivityService activityService;
	@Autowired
	private CmsAdvertService cmsAdvertService;
	@Autowired
	private CcpAdvertRecommendService ccpAdvertRecommendService;
	@Autowired
    private CmsActivityRoomMapper cmsActivityRoomMapper;
	@Autowired
    private CmsActivityMapper activityMapper;

	/**
	 * 前台首页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/index.do")
	public String index(HttpServletRequest request) {
		return "index/index/index";
	}

	/**
	 * 首页人文洪山推荐
	 * 
	 * @param tag
	 * @param request
	 * @return
	 */
	@RequestMapping("/infoRecommend")
	public String infoRecommend(String type, HttpServletRequest request) {
		List<BpInfo> infoList = null;
		if (StringUtils.isNotBlank(type)) {
			infoList = bpInfoService.queryRecommendInfo(type);
		}
		request.setAttribute("infoList", infoList);
		return "index/index/bpFrontIndexLoad";
	}

	/**
	 * 首页推荐
	 * 
	 * @return
	 */
	@RequestMapping("/advertIndex")
	public String hotelRecommendAdvert(HttpServletRequest request) {
		CcpAdvertRecommend advert = new CcpAdvertRecommend();
		advert.setAdvertType(request.getParameter("type"));
		advert.setAdvertPostion(1);
		advert.setAdvertState(1);
		List<CcpAdvertRecommend> advList = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
		//场馆
		if (request.getParameter("type").equals("D")) {
			List<CmsVenue> advertList = new ArrayList<CmsVenue>();
			for (CcpAdvertRecommend adv : advList) {
				CmsVenue act = cmsVenueService.queryVenueById(adv.getAdvertUrl());
				if (StringUtils.isNotBlank(act.getVenueMemo())) {
					Document doc = Jsoup.parse(act.getVenueMemo());
					act.setVenueMemo(doc.text());
				}

				advertList.add(act);
			}
			if(advertList.size()<5){
				List<CmsVenue> list = cmsVenueService.pcnewVenue(5-advertList.size());
				advertList.addAll(list);
			}
			for(CmsVenue venue:advertList){
				Map<String,Object> map = new HashMap<String, Object>();
		        map.put("activityIsDel", Constant.NORMAL);
		        map.put("activityState", Constant.PUBLISH);
		        map.put("roomIsDel", Constant.NORMAL);
		        map.put("venueId", venue.getVenueId());
		        int actCount = activityMapper.queryAppActivityCountById(map);
		        int roomCount = cmsActivityRoomMapper.queryAppActivityRoomCountById(map);
		        venue.setActCount(actCount);
		        venue.setRoomCount(roomCount);
		        
			}
			request.setAttribute("advertList", advertList);
			return "index/index/bpFrontIndexVenueLoad";
		//活动
		} else if(request.getParameter("type").equals("L")){
			List<CmsActivity> advertList = new ArrayList<CmsActivity>();
			for (CcpAdvertRecommend adv : advList) {
				CmsActivity act = activityService.queryFrontActivityByActivityId(adv.getAdvertUrl());
				advertList.add(act);
			}
			if(advertList.size()<4){
				List<CmsActivity> list = activityService.pcnewActivity(null,4-advertList.size());
				advertList.addAll(list);
			}
			List<String> ids = new ArrayList<String>();
			if(advertList!=null&&advertList.size()>0){
				for(CmsActivity activity:advertList){
					ids.add(activity.getActivityId());
				}
			}
			advertList = activityService.getPctuijianActivity(ids);
			request.setAttribute("advertList", advertList);
			return "index/index/bpFrontIndexLoad";
		//资讯
		}else if(request.getParameter("type").equals("K")){
			List<BpInfo> advertList = new ArrayList<BpInfo>();
			for (CcpAdvertRecommend adv : advList) {
				BpInfo act = bpInfoService.queryBpInfo(adv.getAdvertUrl());
				advertList.add(act);
			}
			if(advertList.size()<6){
				List<BpInfo> list = bpInfoService.pcnewInfo(5-advertList.size());
				advertList.addAll(list);
			}

			request.setAttribute("advertList", advertList);
			return "index/index/bpFrontIndexInfoLoad";
		}
		return "index/index/bpFrontIndexLoad";
	}
	
	/**
	 * pc首页活动	
	 * 
	 * @return
	 */	
	@RequestMapping("/pcnewActivityIndex")
	public String pcnewActivityIndex(HttpServletRequest request) {
		String activityType = request.getParameter("activityType");
		List<CmsActivity> activityList = activityService.pcnewActivity(activityType,4);
		request.setAttribute("activityList", activityList);
		return "index/index/bpFrontIndexLoad";
	}
}