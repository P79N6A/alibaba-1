package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.peopleTrain.TrainTerminalUser;
import com.sun3d.why.util.Pagination;

public interface PeopleTrainService {

	List<TrainTerminalUser> queryPeopleTrainByCondition(String searchKey,TrainTerminalUser trainTerminalUser, Pagination page,SysUser sysUser);
	
	String addTrainTerminalUser(TrainTerminalUser user,CmsTerminalUser terminalUser); 
	
	TrainTerminalUser queryTrainUserByUserId(String userId);
	
	String updateTrainTerminalUser(TrainTerminalUser trainTerminalUser);
	
	List<TrainTerminalUser> queryPeopleTrainByExprot();

	TrainTerminalUser queryPeopleTrainById(String Id);
	
}
