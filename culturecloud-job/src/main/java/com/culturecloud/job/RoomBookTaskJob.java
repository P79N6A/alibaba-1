//package com.culturecloud.job;
//
//
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//import org.apache.log4j.Logger;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import com.culturecloud.dao.dto.room.CmsActivityRoomDto;
//import com.culturecloud.model.bean.room.CmsActivityRoom;
//import com.culturecloud.service.local.room.CmsActivityRoomService;
//import com.culturecloud.service.local.room.CmsRoomBookService;
//import com.culturecloud.utils.Constant;
//
///**
// *活动统计数据
// */
//@Component("roomBookTaskJob")
//public class RoomBookTaskJob {
//	private Logger logger = Logger.getLogger(RoomBookTaskJob.class);
//
//	@Autowired
//	private CmsActivityRoomService cmsActivityRoomService;
//
//	@Autowired
//	private CmsRoomBookService cmsRoomBookService;
//
//	/**
//	 * 生成当前日期七天后一天的活动室预定信息
//	 * @throws Exception
//	 */
//	public void roomBookTaskJob() throws Exception {
//		try {
//			
//			Map<String,Object>map=new HashMap<String,Object>();
//			
//			map.put("roomIsDel", Constant.NORMAL);
//			map.put("roomState", Constant.PUBLISH);
//			
//			List<CmsActivityRoomDto> roomList = cmsActivityRoomService.queryByCmsActivityRoom(map);
//
//			int result = cmsRoomBookService.generateOneDayBookInfo(roomList);
//			if(result == 1){
//				logger.info("生成活动室预定信息成功!");
//			}
//		} catch (Exception e) {
//			logger.error("生成活动室预定信息时出错!!", e);
//		}
//	}
//
//	
//}
