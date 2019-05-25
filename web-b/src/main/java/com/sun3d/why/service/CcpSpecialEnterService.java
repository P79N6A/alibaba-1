package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.special.CcpSpecialEnter;
import com.sun3d.why.dao.dto.CcpSpecialEnterDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CcpSpecialEnterService {

	List<CcpSpecialEnterDto> queryByCondition(CcpSpecialEnter enter, Pagination page);
	
	CcpSpecialEnter findById(String enterId);
	
	int saveEnter(CcpSpecialEnter enter,SysUser user);
}
