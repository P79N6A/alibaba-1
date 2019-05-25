package com.sun3d.why.dao;

import com.sun3d.why.model.bean.yket.YketCarousel;

public interface YketCarouselMapper {
    int deleteByPrimaryKey(String carouselId);

    int insert(YketCarousel record);

    int insertSelective(YketCarousel record);

    YketCarousel selectByPrimaryKey(String carouselId);

    int updateByPrimaryKeySelective(YketCarousel record);

    int updateByPrimaryKey(YketCarousel record);
}