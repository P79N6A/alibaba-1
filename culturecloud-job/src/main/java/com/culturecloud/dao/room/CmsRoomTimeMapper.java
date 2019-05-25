package com.culturecloud.dao.room;

import java.util.List;

import com.culturecloud.dao.dto.room.CmsRoomTimeDto;
import com.culturecloud.model.bean.room.CmsRoomTime;


public interface CmsRoomTimeMapper {
  
	   /**
     * 根据活动室场次信息查询满足条件的活动室场次列表
     * @param cmsRoomTime 活动室场次信息数据
     * @return
     */
    List<CmsRoomTimeDto> queryRoomTimeByCondition(CmsRoomTime cmsRoomTime);
}