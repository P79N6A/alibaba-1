package com.sun3d.why.job;

import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsRoomBookService;
import com.sun3d.why.util.Constant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 *活动统计数据
 */
@Component("roomBookTaskJob")
public class RoomBookTaskJob {
	private Logger logger = Logger.getLogger(RoomBookTaskJob.class);

	@Autowired
	private CmsActivityRoomService cmsActivityRoomService;

	@Autowired
	private CmsRoomBookService cmsRoomBookService;

	@Autowired
	private CacheService cacheService;

	/**
	 * 生成当前日期七天后一天的活动室预定信息
	 * @throws Exception
	 */
	public void roomBookTaskJob() throws Exception {
		try {
			CmsActivityRoom cmsActivityRoom = new CmsActivityRoom();
			cmsActivityRoom.setRoomIsDel(Constant.NORMAL);
			cmsActivityRoom.setRoomState(Constant.PUBLISH);
			cmsActivityRoom.setRows(cmsActivityRoomService.queryCountByCmsActivityRoom(cmsActivityRoom));
			List<CmsActivityRoom> roomList = cmsActivityRoomService.queryByCmsActivityRoom(cmsActivityRoom);

			int result = cmsRoomBookService.generateOneDayBookInfo(roomList);
			if(result == 1){
				logger.info("生成活动室预定信息成功!");
			}
		} catch (Exception e) {
			logger.error("生成活动室预定信息时出错!!", e);
		}
	}

	/**
	 * 生成当前日期七天后一天的活动室预定信息
	 * @throws Exception
	 */
	public void setRoomBookToRedis() throws Exception {
		CmsActivityRoom cmsActivityRoom = new CmsActivityRoom();
		try {
			cmsActivityRoom.setRoomIsDel(Constant.NORMAL);
			cmsActivityRoom.setRoomState(Constant.PUBLISH);
			cmsActivityRoom.setRows(cmsActivityRoomService.queryCountByCmsActivityRoom(cmsActivityRoom));
			List<CmsActivityRoom> roomList = cmsActivityRoomService.queryByCmsActivityRoom(cmsActivityRoom);

			if(roomList != null && roomList.size() > 0){
				for (int i=0; i<roomList.size(); i++){
					cmsActivityRoom = roomList.get(i);

					List<String> roomBookList = cmsRoomBookService.queryRoomBookDataToRedis(cmsActivityRoom.getRoomId(),7);

					Calendar calendar = Calendar.getInstance();
					calendar.setTime(new Date());
					//设置过期时间为当前时间之后的24小时
					calendar.add(Calendar.HOUR_OF_DAY,24);
					//将活动室预定信息放入Redis
					cacheService.setRoomBookList(cmsActivityRoom.getRoomId(),roomBookList,calendar.getTime());
				}
			}
		} catch (Exception e) {
			logger.error("将预定信息放入Redis中失败!",e);
		}
	}
}
