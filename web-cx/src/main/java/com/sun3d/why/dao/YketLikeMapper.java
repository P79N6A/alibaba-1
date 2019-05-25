package com.sun3d.why.dao;

import com.sun3d.why.model.bean.yket.YketLikeExample;
import com.sun3d.why.model.bean.yket.YketLikeKey;
import com.sun3d.why.model.vo.yket.RecommandCourseVo;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface YketLikeMapper {
    int countByExample(YketLikeExample example);

    int deleteByExample(YketLikeExample example);

    int deleteByPrimaryKey(YketLikeKey key);

    int insert(YketLikeKey record);

    int insertSelective(YketLikeKey record);

    int updateByExampleSelective(@Param("record") YketLikeKey record, @Param("example") YketLikeExample example);

    int updateByExample(@Param("record") YketLikeKey record, @Param("example") YketLikeExample example);
    
    YketLikeKey selectById(@Param("record") YketLikeKey record);
    
    
    List<RecommandCourseVo> recommandCourse();
    
    
}