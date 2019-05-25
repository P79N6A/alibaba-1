package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.special.CcpSpecialProject;
import com.sun3d.why.util.Pagination;

public interface CcpSpecialProjectService {

	List<CcpSpecialProject> queryByCondition(CcpSpecialProject project, Pagination page);
	
	CcpSpecialProject findById(String projectId);
	
	int saveProject(CcpSpecialProject project);
}
