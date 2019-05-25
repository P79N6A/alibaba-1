package com.sun3d.why.controller;

import com.sun3d.why.model.BpCarousel;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.BpCarouselService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("beipiaoCarousel")
public class BpCarouselController {

	private Logger logger = LoggerFactory.getLogger(BpInfoController.class);

	@Autowired
	private HttpSession session;

	@Autowired
	private BpCarouselService bpCarouselService;

	// 轮播图列表显示
	@RequestMapping(value = "carouselList")
	public ModelAndView carouselList(BpCarousel carousel,Pagination page) {
		List<BpCarousel> list = null;
		ModelAndView mv = new ModelAndView();
		SysUser loginUser = (SysUser) session.getAttribute("user");
		if (loginUser == null) {
			// 判断管理员是否登录
			mv.setViewName("admin/user/userLogin");
		} else {
			// 查询条件——分页条件+筛选条件
			list = bpCarouselService.queryCarouselListByCondition(carousel,page);
			mv.addObject("list", list);
			mv.addObject("carousel", carousel);
			mv.addObject("page", page);
			mv.setViewName("admin/beipiaoCarousel/carouselList");
		}

		return mv;
	}

	// 添加首页轮播图页面跳转
	@RequestMapping(value = "addPage")
	public String addCarousel() {
		return "admin/beipiaoCarousel/carouselAdd";
	}

	// 添加首页轮播图
	@RequestMapping("addCarousel")
	@ResponseBody
	public String addCarousel(BpCarousel bpCarousel) {

		String result = null;
		SysUser user = null;
		try {
			user = (SysUser) session.getAttribute("user");
			if (user == null) {
				// 判断管理员是否登录
				result = "nologin";
			} else {
				result = bpCarouselService.addCarousel(bpCarousel, user);
			}
		} catch (Exception e) {
			logger.info("addCarousel error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}

	// 删除轮播图
	@RequestMapping("delCarousel")
	@ResponseBody
	public String delCarousel(String carouselId) {
		String result = null;
		try {
			if (((SysUser) session.getAttribute("user")) == null) {
				// 判断管理员是否登录
				result = "nologin";
			} else {
				bpCarouselService.delCarousel(carouselId);
				result = "success";
			}
		} catch (Exception e) {
			logger.info("delCarousel error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}
	
	//上线轮播图
	@RequestMapping("changeCarouselStatusAndNumber")
	@ResponseBody
	public String changeCarouselStatusAndNumber(String carouselId,String carouselStatus){
		String result = null;
		SysUser loginUser= (SysUser) session.getAttribute("user");
		try {
			if (loginUser== null) {
				// 判断管理员是否登录
				result = "nologin";
			} else {
				bpCarouselService.sortCarousel(carouselId,carouselStatus,loginUser);
				result = "success";
			}
		} catch (Exception e) {
			logger.info("changeCarouselStatusAndNumber error {}", e);
			return Constant.RESULT_STR_FAILURE;
		}
		return result;
	}
	
	//编辑前的数据回显
	@RequestMapping("preEditCarousel")
	public ModelAndView preEditCarousel(String carouselId){
		ModelAndView mv = new ModelAndView();
		BpCarousel bpCarousel = bpCarouselService.selectCarouselById(carouselId);
		mv.addObject("bpCarousel", bpCarousel);
		mv.setViewName("admin/beipiaoCarousel/carouselEdit");
		return mv;
	}
	
}
