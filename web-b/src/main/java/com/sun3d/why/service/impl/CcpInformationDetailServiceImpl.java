package com.sun3d.why.service.impl;

import com.culturecloud.model.bean.common.CcpInformationDetail;
import com.sun3d.why.dao.CcpInformationDetailMapper;
import com.sun3d.why.service.CcpInformationDetailService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Transactional
@Service
public class CcpInformationDetailServiceImpl implements CcpInformationDetailService{
	
	@Autowired
	private CcpInformationDetailMapper ccpInformationDetailMapper;

	@Override
	public List<CcpInformationDetail> detailList(String informationId, Pagination page) {
		
		Map<String, Object> map = new HashMap<>();
		
		if(StringUtils.isNotBlank(informationId)){
			
			map.put("informationId", informationId);
		}
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			
			int total =ccpInformationDetailMapper.queryInformationDetailByConditionCount(map);

			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}
		List<CcpInformationDetail>  list=	ccpInformationDetailMapper.queryInformationDetailByCondition(map);
		
		
		return list;
	}

	@Override
	public CcpInformationDetail selectByPrimaryKey(String informationDetailId) {
		return ccpInformationDetailMapper.selectByPrimaryKey(informationDetailId);
	}

	@Override
	public int addInformationDetail(CcpInformationDetail record) {
		return ccpInformationDetailMapper.insert(record);
	}

	@Override
	public int updateInformationDetail(CcpInformationDetail record) {
		return ccpInformationDetailMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int delInformationDetail(String informationDetailId) {
		return ccpInformationDetailMapper.deleteByPrimaryKey(informationDetailId);
	}

}
