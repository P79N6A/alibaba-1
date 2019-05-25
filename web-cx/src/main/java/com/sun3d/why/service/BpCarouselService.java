package com.sun3d.why.service;

import com.sun3d.why.model.BpCarousel;

import java.util.List;

public interface BpCarouselService {

	//轮播图列表
	List<BpCarousel> queryBpCarouselList(Integer carouselType);

}
