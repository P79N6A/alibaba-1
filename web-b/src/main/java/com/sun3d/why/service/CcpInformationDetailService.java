package com.sun3d.why.service;

import com.culturecloud.model.bean.common.CcpInformationDetail;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface CcpInformationDetailService {
	
	List<CcpInformationDetail> detailList(String informationId, Pagination page);

	CcpInformationDetail selectByPrimaryKey(String informationDetailId);
	
	int addInformationDetail(CcpInformationDetail record);
	  
	int updateInformationDetail(CcpInformationDetail record);
	
	int delInformationDetail(String informationDetailId);
	
	
}
