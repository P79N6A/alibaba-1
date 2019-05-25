package com.sun3d.why.controller.wechat;

import com.culturecloud.model.bean.common.CcpInformation;
import com.culturecloud.model.bean.common.CcpInformationModule;
import com.culturecloud.model.bean.common.CcpInformationType;
import com.sun3d.why.dao.CcpInformationModuleMapper;
import com.sun3d.why.dao.CcpInformationTypeMapper;
import com.sun3d.why.dao.SysUserMapper;
import com.sun3d.why.dao.dto.CcpInformationDto;
import com.sun3d.why.dao.dto.CcpInformationDto1;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpInformationService;
import com.sun3d.why.service.CcpInformationTypeService;
import com.sun3d.why.util.BindWS;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/wechatInformation")
public class WechatInformationController {

	@Autowired
	private CacheService cacheService;
	@Autowired
	private HttpSession session;
	@Autowired
	private CcpInformationTypeService informationTypeService;
	@Autowired
	private CcpInformationModuleMapper ccpInformationModuleMapper;
	@Autowired
	private CcpInformationService informationService;
	@Autowired
	private CcpInformationTypeMapper ccpInformationTypeMapper;
	@Autowired
	 private StaticServer staticServer;
	@Autowired
	private SysUserMapper sysUserMapper ;

	@RequestMapping(value = "/index")
	public String index(HttpServletRequest request) {

		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);

		request.setAttribute("sign", sign);

		return "wechat/information/index";
	}


	@RequestMapping(value = "/list")
	public String list(HttpServletRequest request,String informationModuleId, String shopPath) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);

		List<CcpInformationType> typeList = informationTypeService.queryAllInformationType(informationModuleId, shopPath);
		request.setAttribute("typeList", typeList);
		
		CcpInformationModule ccpInformationModule = ccpInformationModuleMapper.selectByPrimaryKey(informationModuleId);
		request.setAttribute("ccpInformationModule", ccpInformationModule);
		request.setAttribute("sign", sign);
		request.setAttribute("toDay", new Date().getTime());
		return "wechat/information/list";
	}

	@RequestMapping(value = "/listByType")
	public String listByType(HttpServletRequest request,String informationTypeId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);

		CcpInformationType informationType = ccpInformationTypeMapper.selectByPrimaryKey(informationTypeId);
		request.setAttribute("informationType", informationType);
		request.setAttribute("sign", sign);
		request.setAttribute("toDay", new Date().getTime());
		return "wechat/information/listByType";
	}

	@ResponseBody
	@RequestMapping(value = "/queryInformationList")
	public List<CcpInformationDto1> queryInformationList(CcpInformation information, String userId, Integer pageIndex,
														 Integer pageNum) {
		/*CmsCitySwitch cityInfo = (CmsCitySwitch) session.getAttribute("dwcityInfo");
		Map<String,Object> params = new HashMap<String, Object>() ;
		if(cityInfo!=null && cityInfo.getGrade() != 1) {
			params.put("cityId",cityInfo.getCityId()+"%") ;
			params.put("grade",cityInfo.getGrade()) ;
		}
		List<SysUser> userList = sysUserMapper.queryUserByCityId(params) ;
		List list = new ArrayList() ;
		if(userList!=null && userList.size() > 0) {
			for (int i = 0 ; i < userList.size() ; i++) {
				list.add(userList.get(i).getUserId()) ;
			}
		}
		System.out.println(list.toArray().toString());*/
		return informationService.informationList(information, userId, pageIndex, pageNum,null);
	}

	@RequestMapping(value = "/informationDetail")
	public String informationDetail(@RequestParam String informationId, String type, HttpServletRequest request) {

		//微信权限验证配置
	    String url = BindWS.getUrl(request);
	    Map<String, String> sign = BindWS.sign(url, cacheService);
	    request.setAttribute("sign", sign);
		CcpInformationDto information = informationService.getInformation(informationId, null);

		information.setInformationModuleId(Optional.ofNullable((String)request.getAttribute("informationModuleId")).orElse(""));
		Integer informationSort = information.getInformationSort();

		request.setAttribute("info", information);
		request.setAttribute("type", type);

		return "wechat/information/informationDetail" + informationSort;
	}
	
	
	@RequestMapping(value = "/queryInformationUserInfo")
	@ResponseBody
	public CcpInformationDto queryInformationUserInfo(@RequestParam String informationId, @RequestParam String userId){
		
		CcpInformationDto information = informationService.queryInformationUserInfo(informationId, userId);
		
		return information;
		
	}

	@RequestMapping("/digitVenue")
	public String digitVenue(HttpServletRequest request){
		//微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		return "wechat/information/digitVenue";
	}
}
