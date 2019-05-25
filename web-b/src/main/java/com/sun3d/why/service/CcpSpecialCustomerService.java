package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.special.CcpSpecialCustomer;
import com.sun3d.why.dao.dto.CcpSpecialCustomerDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CcpSpecialCustomerService {

	List<CcpSpecialCustomerDto> queryByCondition(CcpSpecialCustomer customer, Pagination page);
	
	CcpSpecialCustomer findById(String customerId);
	
	int saveCustomer(CcpSpecialCustomer customer,SysUser user);
	
	/**
	 * 生成Y码总数
	 * @param customerId
	 * @return
	 */
	int codeSum(String customerId);
	
}
