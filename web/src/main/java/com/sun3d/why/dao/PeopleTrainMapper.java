package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.peopleTrain.TrainTerminalUser;
import com.sun3d.why.util.Pagination;

public interface PeopleTrainMapper {

	int queryTrainTerminalUserCountByCondition(Map<String, Object> map);

	List<TrainTerminalUser> queryTrainTerminalUserByCondition(Map<String, Object> map);
	
	void addTrainTerminalUser(TrainTerminalUser user);
	
	void updateTrainTerminalUser(TrainTerminalUser user);
	
	TrainTerminalUser queryTrainUserByUserId(String userId);
	
	List<TrainTerminalUser> queryPeopleTrainByCondition(String searchKey,TrainTerminalUser trainTerminalUser, Pagination page,SysUser sysUser);

	List<TrainTerminalUser> queryPeopleTrainByExprot();

	TrainTerminalUser queryPeopleTrainById(String Id);
	
	TrainTerminalUser queryPeopleTrainById(Map<String, Object> map);
	
}