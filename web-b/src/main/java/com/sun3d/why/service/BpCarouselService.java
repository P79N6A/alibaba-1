package com.sun3d.why.service;

import com.sun3d.why.model.BpCarousel;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface BpCarouselService {

	/**
	 * 添加首页轮播图+更新首页轮播图
	 * @param bpCarousel
	 * @param user 
	 * @return 
	 */
	String addCarousel(BpCarousel bpCarousel, SysUser user);

	/**
	 * 根据分页条件查找列表
	 * @param page
	 * @return
	 */
	List<BpCarousel> queryCarouselListByCondition(BpCarousel carousel,Pagination page);

	/**
	 * 删除轮播图s
	 * @param carouselId
	 */
	void delCarousel(String carouselId);

	/**
	 * 轮播图上线，排序
	 * @param carouselId
	 * @param carouselStatus 
	 * @param loginUser 
	 */
	void sortCarousel(String carouselId, String carouselStatus, SysUser loginUser);

	/**
	 * 编辑前的数据回显
	 * @param carouselId
	 * @return
	 */
	BpCarousel selectCarouselById(String carouselId);

}
