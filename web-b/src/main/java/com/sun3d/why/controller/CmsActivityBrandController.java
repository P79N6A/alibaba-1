package com.sun3d.why.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.culturecloud.model.bean.brandact.CmsActivityBrand;
import com.culturecloud.model.bean.culture.CcpCultureContestQuestion;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsActivityBrandService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;


@RequestMapping("/activityBrand")
@Controller
public class CmsActivityBrandController {
	
	@Autowired
	private CmsActivityBrandService  cmsActivityBrandService;
	@Autowired
	private HttpSession session;
	@Autowired
	private StaticServer staticServer;
	/**
	 * 大活动列表
	 * @param ccpMusicessayArticle
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/cmsActivityBrandIndex")
	public ModelAndView queryActivityBrandIndex(CmsActivityBrand cmsActivityBrand,Pagination page){
		ModelAndView model = new ModelAndView();
		List<CmsActivityBrand> list = this.cmsActivityBrandService.queryActivityBrand(cmsActivityBrand, page);
		model.addObject("cmsActivityBrand", cmsActivityBrand);
		model.addObject("list", list);
		model.addObject("page", page);
		//返回结果集
		model.setViewName("admin/brandAct/brandActIndex");
		return model;
	}
	
	
	
	
	/**
	 * 大活动下架和上架以及删除
	 * @param id,actFlag,session
	 * @return map
	 */
	@RequestMapping(value="/cmsActivityBrandDownOrUp")
	@ResponseBody
	public Map<String, Object> editActivityBrandDownOrUp(String id,int actFlag){
		Map<String,Object> map= this.cmsActivityBrandService.updateActivityBrandFlagById(id,actFlag,session);
		return map;
	}
	
	
	
	
	
	/**
	 * 跳转到新增编辑活动页面
	 * 
	 * @return ModelAndView 页面及参数
	 */
	@RequestMapping(value = "/cmsActivityBrandAddFrame")
	public ModelAndView convertToAdd(String id,Integer actType) {
		ModelAndView model = new ModelAndView();
		CmsActivityBrand entity = new CmsActivityBrand();
		if(actType==0){
			if(!StringUtils.isEmpty(id)){
				entity = cmsActivityBrandService.selectByPrimaryKey(id);
				String imgSrc = entity.getImgSrc();
				String[] imgSrcs = imgSrc.split(","); 
				model.addObject("imgSrcs", imgSrcs);
				
				String actUrl = entity.getActUrl();
				String[] actUrls = actUrl.split(","); 
				model.addObject("actUrls", actUrls);
			}
			String aliImgUrl=staticServer.getAliImgUrl();
			model.addObject("aliImgUrl", aliImgUrl);
			model.addObject("entity", entity);
			
			model.setViewName("admin/brandAct/brandActAdd");
		}else{
			if(!StringUtils.isEmpty(id)){
				entity = cmsActivityBrandService.selectByPrimaryKey(id);
			}
			String aliImgUrl=staticServer.getAliImgUrl();
			model.addObject("aliImgUrl", aliImgUrl);
			model.addObject("entity", entity);
			model.setViewName("admin/brandAct/brandActQxAdd");
		}
		return model;
	}
	
	
	
	
	/**
	 * 大活动新增
	 * @param ccpMusicessayArticle
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/cmsActivityBrandAdd")
	@ResponseBody
	public Map<String, Object> addActivityBrand(CmsActivityBrand cmsActivityBrand){

		SysUser user = (SysUser) session.getAttribute("user");
		if(user!=null){
			String name = user.getUserId();
			if(!StringUtils.isEmpty(name)){
				cmsActivityBrand.setOperator(name);
			}
			Map<String,Object> map= cmsActivityBrandService.saveActivityBrand(cmsActivityBrand);
			return map;
		}else{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("msg", "login");
			return map;
		}
	}
	
	
	
	
	/**
	 * 大活动内容查看
	 * @param id
	 * @return 
	 */
	@RequestMapping(value="/cmsActivityBrandLook")
	public ModelAndView selectActivityBrandByKey(String id,int flag){
		ModelAndView model = new ModelAndView();
		CmsActivityBrand cmsActivityBrand= this.cmsActivityBrandService.selectByPrimaryKey(id);
		model.addObject("cmsActivityBrand", cmsActivityBrand);
		model.addObject("flag", flag);
		model.setViewName("admin/brandAct/lookText");
		return model;
	}

	
	
	
	/**
	 * 大活动删除
	 * @param id
	 * @return 
	 */
	@RequestMapping(value="/cmsActivityBrandDel")
	@ResponseBody
	public Map<String, Object> cmsActivityBrandDel(String id){
		int actFlag = -1;
		return this.cmsActivityBrandService.updateActivityBrandFlagById(id,actFlag,session);
	}
	
	
	
	
	/**
	 * 活动的上下移动
	 * @param 
	 * @return 
	 */
	@RequestMapping(value="/changeOrder")
	@ResponseBody
	public String cmsActivityBrandOrder(CmsActivityBrand cmsActivityBrand,Integer flag, Pagination page){
		String result = this.cmsActivityBrandService.cmsActivityBrandOrder(cmsActivityBrand,flag,page);
		return result;
	}
	
}
