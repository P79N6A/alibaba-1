package com.sun3d.why.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.DcScore;

public interface DcScoreMapper {
    int deleteByPrimaryKey(String scoreId);

    int insert(DcScore record);

    DcScore selectByPrimaryKey(String scoreId);

    int update(DcScore record);
    
    DcScore queryScoreByCondition(@Param("userId")String userId,@Param("videoId")String videoId);

    List <DcScore> queryScoreListByCondition(DcScore record);
}