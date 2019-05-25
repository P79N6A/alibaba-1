package com.culturecloud.service.local.room;

import java.util.List;

import com.culturecloud.dao.dto.room.CmsActivityRoomDto;

public interface CmsRoomBookService {

	 /**
     * 生成七天后新一天的活动室预定信息
     * @return
     */
    int generateOneDayBookInfo(List<CmsActivityRoomDto> roomList);
    
}
