package com.sun3d.why.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.bean.yket.YketFavoriteExample;
import com.sun3d.why.model.bean.yket.YketFavoriteKey;
import com.sun3d.why.model.vo.yket.MyFavoriteInfoVo;

public interface YketFavoriteMapper {
    int countByExample(YketFavoriteExample example);

    int deleteByExample(YketFavoriteExample example);

    int deleteByPrimaryKey(YketFavoriteKey key);

    int insert(YketFavoriteKey record);

    int insertSelective(YketFavoriteKey record);

    int updateByExampleSelective(@Param("record") YketFavoriteKey record, @Param("example") YketFavoriteExample example);

    int updateByExample(@Param("record") YketFavoriteKey record, @Param("example") YketFavoriteExample example);
    
    YketFavoriteKey selectById(@Param("record") YketFavoriteKey record);
    
    List<MyFavoriteInfoVo> listFavoriteByUserId(String userId);
}