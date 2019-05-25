package com.sun3d.why.service.impl;

import com.sun3d.why.dao.BpCarouselMapper;
import com.sun3d.why.model.BpCarousel;
import com.sun3d.why.service.BpCarouselService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BpCarouselServiceImpl implements BpCarouselService {

	@Autowired
	private BpCarouselMapper bpCarouselMapper;

	@Override
	public List<BpCarousel> queryBpCarouselList(Integer carouselType) {

		return bpCarouselMapper.queryListByNumber(carouselType);

	}

}
