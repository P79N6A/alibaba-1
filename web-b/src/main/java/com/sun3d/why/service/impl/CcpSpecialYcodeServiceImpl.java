package com.sun3d.why.service.impl;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.special.CcpSpecialCustomer;
import com.culturecloud.model.bean.special.CcpSpecialEnter;
import com.culturecloud.model.bean.special.CcpSpecialYcode;
import com.sun3d.why.dao.CcpSpecialCustomerMapper;
import com.sun3d.why.dao.CcpSpecialEnterMapper;
import com.sun3d.why.dao.CcpSpecialYcodeMapper;
import com.sun3d.why.dao.dto.CcpSpecialYcodeDto;
import com.sun3d.why.service.CcpSpecialYcodeService;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class CcpSpecialYcodeServiceImpl implements CcpSpecialYcodeService{
	
	@Autowired
	private CcpSpecialYcodeMapper ccpSpecialYcodeMapper;
	
	@Autowired
	private CcpSpecialCustomerMapper ccpSpecialCustomerMapper;
	
	@Autowired
	private CcpSpecialEnterMapper ccpSpecialEnterMapper;
	
	@Override
	public int queryCountByCondition(String customerId) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("customerId", customerId);
		
		return ccpSpecialYcodeMapper.queryCodeCountByCondition(map);
	}


	@Override
	public List<CcpSpecialYcodeDto> queryByCondition(CcpSpecialYcode code, Pagination page) {
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("customerId", code.getCustomerId());
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpSpecialYcodeMapper.queryCodeCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}
		
		return ccpSpecialYcodeMapper.queryCodeByCondition(map);
	}


	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public int saveCode(String customerId, Integer number) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("customerId", customerId);
		
		int surpluCode= ccpSpecialCustomerMapper.querySumYCodeCount(map);
		 
		if(number>surpluCode)
			return -1;
		
		CcpSpecialCustomer customer=ccpSpecialCustomerMapper.selectByPrimaryKey(customerId);
		String enterId=customer.getEnterId();
		
		CcpSpecialEnter enter=ccpSpecialEnterMapper.selectByPrimaryKey(enterId);
		
		String parame=enter.getEnterParamePath();
		
		Date date=DateUtils.getCurrentDate();

		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		
		String strDate=df.format(date);
		
		int result=0;
		
		for (int i = 0; i < number; i++) {
			
			String ycode=this.checkYcode(parame, strDate);
			
			CcpSpecialYcode code=new CcpSpecialYcode();
			code.setCodeId(UUIDUtils.createUUId());
			code.setCustomerId(customerId);
			code.setYcode(ycode);
			code.setCodeStatus(0);
			code.setYcodeCreateTime(new Date());
			
			result+=ccpSpecialYcodeMapper.insert(code);
			
		}

		return result;
	}
	
	private String checkYcode(String parame,String strDate){
		
		String ycode=parame+strDate+UUIDUtils.createUUId().substring(0, 6);
		
		int count=ccpSpecialYcodeMapper.queryCodeCountByYcode(ycode);
		
		if(count>0)
			return this.checkYcode(parame, strDate);
		else 
			return ycode;
			
	}


	@Override
	public int sendCode(String[] codeIds) {
		
		int result=0;

		for (String codeId : codeIds) {
			
			CcpSpecialYcode c=ccpSpecialYcodeMapper.selectByPrimaryKey(codeId);
			
			if(c.getCodeStatus()==0)
			{
				CcpSpecialYcode code=new CcpSpecialYcode();
				
				code.setCodeId(codeId);
				code.setCodeStatus(1);
				
				result+=ccpSpecialYcodeMapper.updateByPrimaryKeySelective(code);
			}
		}
		
		return result;
	}


}
