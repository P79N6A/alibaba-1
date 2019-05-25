package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.model.bean.special.CcpSpecialCustomer;
import com.sun3d.why.dao.CcpSpecialCustomerMapper;
import com.sun3d.why.dao.CcpSpecialYcodeMapper;
import com.sun3d.why.dao.dto.CcpSpecialCustomerDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpSpecialCustomerService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class CcpSpecialCustomerServiceImpl implements CcpSpecialCustomerService {
	
	@Autowired
	private CcpSpecialCustomerMapper ccpSpecialCustomerMapper;
	

	@Override
	public List<CcpSpecialCustomerDto> queryByCondition(CcpSpecialCustomer customer, Pagination page) {

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("customerIsDel", Constant.NORMAL);
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			
			int total = ccpSpecialCustomerMapper.queryCustomerCountByCondition(map);

			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}

		List<CcpSpecialCustomerDto> list = null;
		
		list = ccpSpecialCustomerMapper.queryCustomerByCondition(map);

		return list;
		
	}

	@Override
	public CcpSpecialCustomer findById(String customerId) {
		return ccpSpecialCustomerMapper.selectByPrimaryKey(customerId);
	}

	@Override
	public int saveCustomer(CcpSpecialCustomer customer, SysUser user) {

		String customerId=customer.getCustomerId();
		
		int result=0;
		
		if(StringUtils.isBlank(customerId))
		{
			customer.setCustomerUpdateUser(user.getUserId());
			customer.setCustomerCreateUser(user.getUserId());
			customer.setCustomerId(UUIDUtils.createUUId());
			customer.setCustomerCreateTime(new Date());
			customer.setCustomerUpdateTime(new Date());
			customer.setCustomerIsDel(Constant.NORMAL);
			result=ccpSpecialCustomerMapper.insertSelective(customer);
		}else
		{
			customer.setCustomerUpdateUser(user.getUserId());
			customer.setCustomerUpdateTime(new Date());
			
			result=ccpSpecialCustomerMapper.updateByPrimaryKeySelective(customer);
		}
		
		return result;
	}

	@Override
	public int codeSum(String customerId) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("customerId", customerId);
		
		return ccpSpecialCustomerMapper.querySumYCodeCount(map);
	}

}
