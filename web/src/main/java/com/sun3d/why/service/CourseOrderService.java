package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.peopleTrain.Course;
import com.sun3d.why.model.peopleTrain.CourseOrder;
import com.sun3d.why.model.peopleTrain.CourseOrderTemp;
import com.sun3d.why.util.Pagination;


public interface CourseOrderService {
	
	String checkCourseOrder(String [] courseId,String [] courseType,String [] courseTitle,String userId);
	
	int queryCourseOrderCount(Map<String,Object> map);
	
	void courseOrder(CourseOrderTemp temp);
	
	void addCourseOrder(CourseOrder courseOrder);
	
	List<CourseOrder> queryCourseOrderByUserId(Map<String,Object> map);
	
	int queryCourseOrderCountByUserId(Map<String,Object> map);
	
	List<CourseOrder> queryUserOrderList(String userId,Pagination page);
	
	List<CourseOrder> queryCourseOrderByCondition(String searchKey,CourseOrder courseOrder, Pagination page,SysUser sysUser);
	
	List<CourseOrder> queryCourseViewByCondition(String courseId,Pagination page, SysUser sysUser,String searchKey,String status);

	CourseOrder queryCourseOrderByorderId(String orderId);

	int deleteOrder(CourseOrder courseOrder, String state, SysUser sysUser);

	int editAttendState(CourseOrder courseOrder, String state);

	List<CourseOrder> queryCourseOrderExport(SysUser sysUser, String searchKey);

	List<CourseOrder> queryExportByCourseIdExcel(String courseId,SysUser sysUser,String searchKey);
	
	String sendMessage(String orderId,String state);
	
	String sendMessagesAll(String orderIds,String state);
	
	public String sendMessageForAll(String orderId,final String allState);
	
	public String sendMessageForCancel(String orderId,final String state);

	String checkOrder(String courseId, String userId);
	
	int updateOrder(CourseOrder courseOrder);
	
	String cancelOrder(CourseOrder courseOrder, CmsTerminalUser terminalUser);
	
}
