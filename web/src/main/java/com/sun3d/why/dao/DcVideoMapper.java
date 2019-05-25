package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.DcVideo;

public interface DcVideoMapper {
    int deleteByPrimaryKey(String videoId);

    int insert(DcVideo record);

    DcVideo selectByPrimaryKey(String videoId);

    int update(DcVideo record);
    
    int queryDcVideoByCount(Map<String, Object> map);
    
    List<DcVideo> queryDcVideoByContent(Map<String, Object> map);
    
    /**
     * 检查唯一
     * @param map
     * @return
     */
  	int checkDcVideo(Map<String, Object> map);
  	
  	List<String> queryStatistics(@Param("area")String area);
  	
  	List<DcVideo> queryWcDcVideoByContent(DcVideo dcVideo);
}