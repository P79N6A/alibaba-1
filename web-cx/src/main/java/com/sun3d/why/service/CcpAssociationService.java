package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.util.Pagination;

public interface CcpAssociationService {

	/**
	 * 社团列表
	 * @param ccpAssociation
	 * @param page
	 * @return
	 */
	List<CcpAssociation> queryAssociationByCondition(CcpAssociation ccpAssociation, Pagination page);
	
	/**
	 * 申请社团
	 * @param ccpAssociationApply
	 * @return
	 */
	boolean saveAssnApply(CcpAssociationApply ccpAssociationApply);
}
