package com.sun3d.why.dao;

import com.sun3d.why.model.BpCarousel;
import com.sun3d.why.model.BpInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BpCarouselMapper {

	List<BpCarousel> queryListByNumber(@Param("carouselType") Integer carouselType);

	BpInfo queryBpInfoById(String infoId);
	
}