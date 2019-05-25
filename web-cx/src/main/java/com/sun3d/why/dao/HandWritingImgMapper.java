package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.publicWebservice.model.HandWritingImg;

public interface HandWritingImgMapper {
    int deleteByPrimaryKey(String id);

    int insert(HandWritingImg record);

    int insertSelective(HandWritingImg record);

    List<HandWritingImg> selectByUserId(Map<String, Object> map);

    int updateByPrimaryKeySelective(HandWritingImg record);

    int updateByPrimaryKey(HandWritingImg record);
    
    List<HandWritingImg> querySeriesImgList(Map<String, Object> map);
    
    int seriesImgDelByUserId(String userId);
}