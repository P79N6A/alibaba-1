package com.sun3d.why.controller.activity;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.model.request.activity.ActivityOrderVO;
import com.culturecloud.model.request.activity.ActivityWcDetailVO;
import com.culturecloud.model.request.activity.RecommendActivityVO;
import com.culturecloud.model.request.common.AddOrderIntegralReqVO;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.redis.RedisDAO;
import com.sun3d.why.service.*;
import com.sun3d.why.statistics.service.StatisticActivityUserService;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.*;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

@RequestMapping("/pcActivity")
@Controller
public class PcActivityController {
	private Logger logger = LoggerFactory.getLogger(PcActivityController.class);

	@Autowired
	private CmsActivityService activityService;

	/**
	 * pc首页文化日历
	 * @param
	 * @return
	 */
	@RequestMapping("/queryCalendarAdvert")
	public String queryCalendarAdvert( String TIME,HttpServletRequest request) {
		List<CmsActivity> cmsActivities = activityService.queryCalendarAdvert(TIME);
		request.setAttribute("cmsActivities", cmsActivities);
		return "index/index/dayNew";
	}
}
