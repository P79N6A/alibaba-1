package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.special.CcpSpecialYcode;
import com.sun3d.why.dao.dto.CcpSpecialYcodeDto;
import com.sun3d.why.util.Pagination;

public interface CcpSpecialYcodeService {
	
	int queryCountByCondition(String customerId);

	List<CcpSpecialYcodeDto> queryByCondition(CcpSpecialYcode code, Pagination page);
	
	int saveCode(String customerId,Integer number);
	
	int sendCode(String []codeIds);
}
