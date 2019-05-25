package com.sun3d.why.dao;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.DcReview;

public interface DcReviewMapper {
    int deleteByPrimaryKey(String reviewId);

    int insert(DcReview record);

    DcReview selectByPrimaryKey(String reviewId);

    int update(DcReview record);
    
    int queryReviewCount(@Param("videoId")String videoId, @Param("reviewResult")Integer reviewResult);

}