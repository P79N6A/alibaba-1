package com.sun3d.why.controller.front;

import com.culturecloud.model.bean.common.CcpInformation;
import com.culturecloud.model.bean.common.CcpInformationModule;
import com.culturecloud.model.bean.common.CcpInformationType;
import com.sun3d.why.dao.CcpInformationMapper;
import com.sun3d.why.dao.CcpInformationModuleMapper;
import com.sun3d.why.dao.CcpInformationTypeMapper;
import com.sun3d.why.dao.SysUserMapper;
import com.sun3d.why.dao.dto.CcpInformationDto;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.BpInfoService;
import com.sun3d.why.service.CcpInformationService;
import com.sun3d.why.service.CcpInformationTypeService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/zxInformation")
public class InformationController {

	@Autowired
	private HttpSession session;
	@Autowired
	private BpInfoService bpInfoService;
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
	@Autowired
	private CcpInformationMapper ccpInformationMapper;

	@RequestMapping(value = "/listIndex")
	public String listIndex(HttpServletRequest request,String informationModuleId, String shopPath, Pagination page) {
		List<CcpInformationType> typeList = informationTypeService.queryAllInformationType(informationModuleId, shopPath);
		request.setAttribute("typeList", typeList);
		
		CcpInformationModule ccpInformationModule = ccpInformationModuleMapper.selectByPrimaryKey(informationModuleId);
		request.setAttribute("ccpInformationModule", ccpInformationModule);
		request.setAttribute("toDay", new Date().getTime());

		CcpInformation information = new CcpInformation();
		information.setInformationModuleId(informationModuleId);
		List<CcpInformationDto> infoList = informationService.informationListWithDetail(information, null, page,null);
		request.setAttribute("infoList", infoList);
		request.setAttribute("page", page);
		request.setAttribute("module", informationModuleId);
		return "index/chuanzhou/zxlistload";
	}
	@RequestMapping(value = "/sfListIndex")
	public String sfListIndex(HttpServletRequest request,String informationModuleId, String shopPath, Pagination page) {
		List<CcpInformationType> typeList = informationTypeService.queryAllInformationType(informationModuleId, shopPath);
		request.setAttribute("typeList", typeList);

		CcpInformationModule ccpInformationModule = ccpInformationModuleMapper.selectByPrimaryKey(informationModuleId);
		request.setAttribute("ccpInformationModule", ccpInformationModule);
		request.setAttribute("toDay", new Date().getTime());

		CcpInformation information = new CcpInformation();
		information.setInformationModuleId(informationModuleId);
		List<CcpInformationDto> infoList = informationService.informationListWithDetail(information, null, page,null);
		request.setAttribute("infoList", infoList);
		request.setAttribute("page", page);
		request.setAttribute("module", informationModuleId);
		return "index/chuanzhou/sflistload";
	}
	@RequestMapping(value = "/listByType")
	public String listByType(HttpServletRequest request,String informationTypeId,String informationModuleId, Pagination page) {

		CcpInformationType informationType = ccpInformationTypeMapper.selectByPrimaryKey(informationTypeId);
		request.setAttribute("informationType", informationType);
		request.setAttribute("toDay", new Date().getTime());

		CcpInformation information = new CcpInformation();
		information.setInformationType(informationTypeId);
		List<CcpInformationDto> infoList = informationService.informationListWithDetail(information, null, page,null);

		request.setAttribute("infoList", infoList);
		request.setAttribute("page", page);
		request.setAttribute("module", informationModuleId);
		return "index/chuanzhou/zxlistload";
	}

	@RequestMapping(value = "/zblistIndex")
	public String zblistIndex(HttpServletRequest request,String informationType,String informationModuleId, String shopPath, Pagination page) {
		List<CcpInformationType> typeList = informationTypeService.queryAllInformationType(informationModuleId, shopPath);//shopPath nothing to used
		request.setAttribute("typeList", typeList);

		CcpInformationModule ccpInformationModule = ccpInformationModuleMapper.selectByPrimaryKey(informationModuleId);
		request.setAttribute("ccpInformationModule", ccpInformationModule);
		request.setAttribute("toDay", new Date().getTime());

		CcpInformation information = new CcpInformation();
		information.setInformationModuleId(informationModuleId);
		information.setInformationType(informationType);
		List<CcpInformationDto> infoList = informationService.informationListWithDetail(information, null, page,null);
		request.setAttribute("infoList", infoList);
		request.setAttribute("page", page);
		request.setAttribute("module", informationModuleId);
		return "index/chuanzhou/zblistload";
	}

	/*@RequestMapping(value = "/zblistByType")
	public String zblistByType(HttpServletRequest request,String informationTypeId,String informationModuleId, Pagination page) {

		CcpInformationType informationType = ccpInformationTypeMapper.selectByPrimaryKey(informationTypeId);
		request.setAttribute("informationType", informationType);
		request.setAttribute("toDay", new Date().getTime());

		CcpInformation information = new CcpInformation();
		information.setInformationType(informationTypeId);
		List<CcpInformationDto> infoList = informationService.informationListWithDetail(information, null, page,null);

		request.setAttribute("infoList", infoList);
		request.setAttribute("page", page);
		request.setAttribute("module", informationModuleId);
		return "index/chuanzhou/zblistload";
	}*/

	/**
	 * 获取zx类型
	 *
	 * @return
	 */
	@RequestMapping(value = "/zxtypelist")
	@ResponseBody
	public List<CcpInformationType> queryAreaList(HttpServletRequest request,String informationModuleId, String shopPath, Pagination page) {
		List<CcpInformationType> list = new ArrayList<CcpInformationType>();
		list = informationTypeService.queryAllInformationType(informationModuleId, shopPath);
		return list;
	}
	/**
	 * 列表
	 *
	 * @return
	 */
	@RequestMapping("/zxfrontindex")
	public ModelAndView zxfrontindex(HttpServletRequest request, String module, String keyword) {
		ModelAndView model = new ModelAndView();
		if(StringUtils.isNotBlank(module)){
			model.addObject("module",module);
		}
		if(StringUtils.isNotBlank(module)){
			model.addObject("keyword",keyword);
		}
		model.setViewName("index/chuanzhou/zxfrontindex");
		return model;
	}
	/**
	 * 网上书房页面
	 */
	/**
	 * 列表
	 *
	 * @return
	 */
	@RequestMapping("/sffrontindex")
	public ModelAndView sffrontindex(HttpServletRequest request, String module, String keyword) {
		ModelAndView model = new ModelAndView();
		if(StringUtils.isNotBlank(module)){
			model.addObject("module",module);
		}
		if(StringUtils.isNotBlank(module)){
			model.addObject("keyword",keyword);
		}
		model.setViewName("index/chuanzhou/sffrontindex");
		return model;
	}
	/**
	 * 列表
	 * module moduleId
	 * @return
	 */
	@RequestMapping("/zbfrontindex.do")
	public ModelAndView zbfrontindex(String module, String keyword) {
		ModelAndView model = new ModelAndView();
		if(StringUtils.isNotBlank(module)){
			CcpInformationModule ccpInformationModule = ccpInformationModuleMapper.selectByPrimaryKey(module);
			model.addObject("moduleName",ccpInformationModule != null?ccpInformationModule.getInformationModuleName():"");
			model.addObject("module",module);
		}
		if(StringUtils.isNotBlank(module)){
			model.addObject("keyword",keyword);
		}
		model.setViewName("index/chuanzhou/zbfrontindex");
		return model;
	}


	@RequestMapping(value = "/listByTypeJson")
	@ResponseBody
	public List<CcpInformationDto> listByTypeJson(HttpServletRequest request,String informationTypeId, Pagination page) {

		CcpInformationType informationType = ccpInformationTypeMapper.selectByPrimaryKey(informationTypeId);
		request.setAttribute("informationType", informationType);
		request.setAttribute("toDay", new Date().getTime());

		CcpInformation information = new CcpInformation();
		information.setInformationType(informationTypeId);
		List<CcpInformationDto> infoList = informationService.informationListWithDetail(information, null, page,null);

		request.setAttribute("infoList", infoList);
		request.setAttribute("page", page);
		return infoList;
	}

	@ResponseBody
	@RequestMapping(value = "/queryInformationList")
	public List<CcpInformationDto> queryInformationList(CcpInformation information, String userId, Pagination page) {
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
		return informationService.informationListWithDetail(information, null, page,null);
	}

	@RequestMapping(value = "/informationDetail")
	public ModelAndView informationDetail(ModelAndView mv, String informationId,String module,HttpServletRequest request,Pagination page) {
		//获取用户信息
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		//获取资讯信息
		CcpInformationDto information = informationService.getInformation(informationId, terminalUser != null?terminalUser.getUserId():null );
		// 若处于登录状态，根据用户Id，资讯Id查找是否点赞
		if (terminalUser != null) {
			Integer userIsWant = bpInfoService.queryCountUserIsWant(terminalUser.getUserId(), information.getInformationId());
			mv.addObject("userIsWant", userIsWant);
		}
		//获取模块信息
		CcpInformationModule ccpInformationModule = ccpInformationModuleMapper.selectByPrimaryKey(information.getInformationModuleId());
		mv.addObject("module",ccpInformationModule) ;
		mv.addObject("info", information);
		//获取精彩推荐内容
		CcpInformation information1 = new CcpInformation();
		information1.setInformationIsRecommend(1);
		information1.setInformationModuleId(ccpInformationModule.getInformationModuleId());
		information1.setInformationSort(information.getInformationSort());
		List<CcpInformationDto> infoList = ccpInformationMapper.queryExsitingInformationList(information1);
		mv.addObject("recommendList",infoList);
		//判断资讯类型1.图文版 2.大图版 3.视频版 4. 直播或者回放（4类型填目睹的播放地址）5. 列表跳转
		switch (information.getInformationSort()){
			case 1 : mv.setViewName("index/information/informationForTextDetail");
				break;
			case 2 : mv.setViewName("index/information/informationForBigImgDetail");
				break;
			case 3 : mv.setViewName("index/information/informationForVideoDetail");
				break;
			case 4 : mv.setViewName("index/information/informationForLiveOrPlaybackDetail");
				break;
			default:
				throw new IllegalStateException("Unexpected value: " + information.getInformationSort());
		}


		return mv;
	}
	
	@RequestMapping(value = "/queryInformationUserInfo")
	@ResponseBody
	public CcpInformationDto queryInformationUserInfo(@RequestParam String informationId, @RequestParam String userId){
		
		CcpInformationDto information = informationService.queryInformationUserInfo(informationId, userId);
		
		return information;
		
	}
}
