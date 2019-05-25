package com.culturecloud.service.local.room;

import java.util.List;
import java.util.Map;

import com.culturecloud.dao.dto.room.CmsActivityRoomDto;

public interface CmsActivityRoomService {

	/**
     * 根据活动室查询条件查询符合条件的活动室个数
     * @param record
     * @return
     */
    int queryCountByCmsActivityRoom(Map<String,Object> map);
    
    /**
     * 根据活动室查询条件查询符合条件的活动室列表
     * @param record
     * @return
     */
    List<CmsActivityRoomDto> queryByCmsActivityRoom(Map<String,Object> map);
    
    
    
}
