package com.culturecloud.service.local.impl.room;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.dao.dto.room.CmsActivityRoomDto;
import com.culturecloud.dao.room.CmsActivityRoomMapper;
import com.culturecloud.service.local.room.CmsActivityRoomService;

@Service
@Transactional
public class CmsActivityRoomServiceImpl implements CmsActivityRoomService {

	@Autowired
	private CmsActivityRoomMapper cmsActivityRoomMapper;

	@Override
	public int queryCountByCmsActivityRoom(Map<String, Object> map) {

		int count = 0;

		count = cmsActivityRoomMapper.queryCmsActivityRoomCountByCondition(map);
		return count;
	}
 
	@Override
	public List<CmsActivityRoomDto> queryByCmsActivityRoom(Map<String, Object> map) {
		
		List<CmsActivityRoomDto> list = null;

		list = cmsActivityRoomMapper.queryCmsActivityRoomByCondition(map);
		 
		return list;
	}

}
