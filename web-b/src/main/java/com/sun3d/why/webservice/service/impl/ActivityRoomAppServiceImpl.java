package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.CmsActivityRoomMapper;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsRoomBookService;
import com.sun3d.why.util.CompareTime;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.ActivityRoomAppService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.*;

@Service
@Transactional
public class ActivityRoomAppServiceImpl implements ActivityRoomAppService{
	private Logger logger = Logger.getLogger(ActivityRoomAppServiceImpl.class);
	@Autowired
	private CmsActivityRoomMapper cmsActivityRoomMapper;
	@Autowired
	private StaticServer staticServer;
	@Autowired
    private CmsRoomBookService cmsRoomBookService;


	public String queryAppActivityRoomListById(String venueId,PaginationApp pageApp){
        Map<String,Object> map = new HashMap<String, Object>();
		map.put("venueId", venueId);
		map.put("roomIsDel", Constant.NORMAL);
		if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
			map.put("firstResult", pageApp.getFirstResult());
			map.put("rows", pageApp.getRows());
		}
		int count = 0;
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        try{
			 count = cmsActivityRoomMapper.queryAppActivityRoomCountById(map);
			 List<CmsActivityRoom> roomList=cmsActivityRoomMapper.queryAppActivityRoomById(map);
            if (CollectionUtils.isNotEmpty(roomList)) {
            	String staticUrl = staticServer.getStaticServerUrl();
                for (CmsActivityRoom activityRoom : roomList) {
                    Map<String, Object> mapActivityRoom = new HashMap<String, Object>();
					mapActivityRoom.put("sysNo",activityRoom.getSysNo()!=null?activityRoom.getSysNo():"");
					mapActivityRoom.put("roomName", activityRoom.getRoomName());//活动室名称
					mapActivityRoom.put("roomCapacity", activityRoom.getRoomCapacity());//活动室客容量
					mapActivityRoom.put("roomIsFree", activityRoom.getRoomIsFree() != null ? activityRoom.getRoomIsFree() : "");//活动室是否收费
					mapActivityRoom.put("roomFee", activityRoom.getRoomFee() != null ? activityRoom.getRoomFee() : "");//活动室价格
					mapActivityRoom.put("roomArea", activityRoom.getRoomArea());//活动室面积
					mapActivityRoom.put("roomPicUrl",staticUrl + activityRoom.getRoomPicUrl());//活动室图片
					mapActivityRoom.put("roomTagName",activityRoom.getRoomTagName()!=null?activityRoom.getRoomTagName():""); //活动室标签名称
					mapActivityRoom.put("roomIsReserve",activityRoom.getRoomCount()); //该活动室是否可预订 0-否 大于0 -是
					mapActivityRoom.put("roomId", activityRoom.getRoomId()!=null?activityRoom.getRoomId():"");//活动室id
                    listMap.add(mapActivityRoom);
                }
            }
        }catch(Exception e){
			e.printStackTrace();
        	logger.error("query activityRoomList error!"+e.getMessage());
        }
        return JSONResponse.toAppActivityResultFormat(0, listMap, count);
	}

/*	public CmsActivityRoom queryAppActivityRoomByRoomId(String roomId) {
		return cmsActivityRoomMapper.queryCmsActivityRoomById(roomId);
	}*/

	/**
	 * 根据活动室id获取活动室详情
	 * @param roomId 活动室id
	 * @return
	 */
	public String queryAppActivityRoomByRoomId(String roomId) {
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		List<Map<String, Object>> timeMap = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();        
		try{
			CmsActivityRoom cmsActivityRoom=cmsActivityRoomMapper.queryAppActivityRoomByRoomId(roomId);
	        if(cmsActivityRoom!=null){
				Map<String, Object> map = new HashMap<String, Object>();
				//子系统对接修改 0.文化云系统
				map.put("sysNo",cmsActivityRoom.getSysNo()!=null?cmsActivityRoom.getSysNo():"");
				map.put("roomId",cmsActivityRoom.getRoomId()!=null?cmsActivityRoom.getRoomId():"");
				map.put("roomName",cmsActivityRoom.getRoomName()!=null?cmsActivityRoom.getRoomName():"");
				String roomPicUrl = "";
				if(StringUtils.isNotBlank(cmsActivityRoom.getRoomPicUrl())){
					roomPicUrl=staticServer.getStaticServerUrl()+cmsActivityRoom.getRoomPicUrl();
				}
				map.put("roomPicUrl",roomPicUrl);
				map.put("roomTagName",cmsActivityRoom.getRoomTagName()!=null?cmsActivityRoom.getRoomTagName():"");
				map.put("roomConsultTel",cmsActivityRoom.getRoomConsultTel()!=null?cmsActivityRoom.getRoomConsultTel():"");
				map.put("roomFee",cmsActivityRoom.getRoomFee()!=null?cmsActivityRoom.getRoomFee():"");
				map.put("roomIsFree",cmsActivityRoom.getRoomIsFree()!=null?cmsActivityRoom.getRoomIsFree():"");
				map.put("roomCapacity",cmsActivityRoom.getRoomCapacity()!=null?cmsActivityRoom.getRoomCapacity():"");
				map.put("roomArea",cmsActivityRoom.getRoomArea()!=null?cmsActivityRoom.getRoomArea():"");
				map.put("facility",cmsActivityRoom.getDictName()!=null?cmsActivityRoom.getDictName():"");
				map.put("venueName",cmsActivityRoom.getVenueName()!=null?cmsActivityRoom.getVenueName():"");
				map.put("venueAddress",cmsActivityRoom.getVenueAddress()!=null?cmsActivityRoom.getVenueAddress():"");
				map.put("roomRemark",cmsActivityRoom.getRoomRemark()!=null?cmsActivityRoom.getRoomRemark():"");
				map.put("roomTel",cmsActivityRoom.getRoomConsultTel()!=null?cmsActivityRoom.getRoomConsultTel():"");
				//活动室开放时间段
				List<CmsRoomBook> roomBookList=cmsRoomBookService.queryAppRoomBookTableByDays(roomId, 5);
				if(CollectionUtils.isNotEmpty(roomBookList)){
					for(CmsRoomBook rooms:roomBookList){
						StringBuffer dateSb=new StringBuffer(); // 封装开放时间段
						StringBuffer statusSb=new StringBuffer(); //封装时间段是否有效
						StringBuffer bookSb=new StringBuffer(); //封装活动室预订id
						
						// 活动室预定状态 (1-可选 2-已选 3-不可选)
						StringBuffer bookStatusSb=new StringBuffer();
						
						Map<String,Object> tmap=new HashMap<String, Object>();
						String curDate=sdf.format(rooms.getCurDate());
						
						//开放日期
						tmap.put("curDate",curDate);
						if(rooms.getTimes()!=null && StringUtils.isNotBlank(rooms.getTimes())){
							String[] times=rooms.getTimes().split(",");
							for(int i=0;i<times.length;i++){
								Date date=new Date();
								StringBuffer time=new StringBuffer();
								time.append(curDate);
								int index = times[i].toString().indexOf("-");
								if(index < 0){
									continue;
								}
								String openPeriod = times[i].toString().substring(0, index);
								time.append(" "+openPeriod);
								String nowDate2=sdf2.format(date);
								int statusDate= CompareTime.timeCompare2(time.toString(), nowDate2);
								String bookId=rooms.getBookIds()!=null?StringUtils.split(rooms.getBookIds(),",")[i]:"";
								String bookStatus=rooms.getBookStatuStr()!=null?StringUtils.split(rooms.getBookStatuStr(),",")[i]:"";
								bookSb.append(bookId+",");
								dateSb.append(times[i].toString()+",");
								//返回 0 表示时间日期相同
								//返回 1 表示日期1>日期2
								//返回 -1 表示日期1<日期2
								if (statusDate==-1){
									statusSb.append("0"+",");
									
									// 时间过期 预定状态 显示 不开放
									bookStatusSb.append("3"+",");
								}else {
									statusSb.append("1"+",");
									
									if(StringUtils.isNotBlank(bookStatus))
									{
										bookStatusSb.append(bookStatus+",");
									}
									else
									{
										bookStatusSb.append("3"+",");
									}
									
								}
							}
						}
						tmap.put("openPeriod",dateSb.toString());
						tmap.put("status",statusSb.toString());
						tmap.put("bookStatus", bookStatusSb.toString());
						tmap.put("bookId",bookSb.toString());
						timeMap.add(tmap);
						/*Map<String,Object> tmap=new HashMap<String, Object>();
						long curDate = rooms.getCurDate().getTime();
						tmap.put("curDate",curDate/1000);
						tmap.put("openPeriod",rooms.getTimes()!=null?rooms.getTimes():"");
						timeMap.add(tmap);*/
					}
				}
				   listMap.add(map);
			}
		}catch(Exception e){
			logger.error("app根据活动室id的活动室时出错!", e);
		}            
		return JSONResponse.toAppResultObject(0, listMap, timeMap);
	}

}
