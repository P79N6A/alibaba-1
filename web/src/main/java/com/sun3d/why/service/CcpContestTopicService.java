package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.contest.CcpContestTemplate;
import com.culturecloud.model.bean.contest.CcpContestTopic;
import com.culturecloud.model.bean.contest.CcpContestTopicPass;
import com.sun3d.why.dao.dto.CcpContestTopicDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CcpContestTopicService {

	 List<CcpContestTopicDto> queryCcpContestTopic(CcpContestTopic contestTopic, Pagination page);
	  
	 public int saveContestTopic(CcpContestTopic contestTopic,Integer[] passNumber,String []passName,SysUser user);

	 public int saveContestQuiz(CcpContestTopic contestTopic,CcpContestTemplate template,SysUser user);
	 
	 public int topicStatusChange(String topicId,SysUser user);
	 
	 CcpContestTopic queryCcpContestTopicById(String topicId);
	 
	 List<CcpContestTopicPass> queryCcpContestTopicPassByTopicId(String topicId);
}
