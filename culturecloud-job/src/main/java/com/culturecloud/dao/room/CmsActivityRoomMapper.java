package com.culturecloud.dao.room;

import java.util.List;
import java.util.Map;

import com.culturecloud.dao.dto.room.CmsActivityRoomDto;


public interface CmsActivityRoomMapper {
	
	int queryCmsActivityRoomCountByCondition(Map<String,Object> map);
  
	List<CmsActivityRoomDto> queryCmsActivityRoomByCondition(Map<String,Object> map);
}