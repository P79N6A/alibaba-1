package com.sun3d.why.service;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.model.CcpAssociationRecruit;
import com.sun3d.why.model.CcpAssociationRecruitApply;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.List;

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
	/**
	 * 得到社团招募信息
	 * @param assnId
	 * @return
	 */
	CcpAssociationRecruit getAssnRecruitByAssnId(String assnId);
	/**
	 * 报名社团
	 * @param ccpAssociationRecruitApply
	 * @return
	 */
	String saveRecruitApplyPc(CcpAssociationRecruitApply ccpAssociationRecruitApply);


	boolean saveRecruitApply(CcpAssociationRecruitApply recruitApply);

    CcpAssociation queryAssociationFromIndex(String ids);
    
    CcpAssociation queryFrontAssnByAssnId(String assnId);

    String queryAppCmsAssnListByCondition(String name, PaginationApp pageApp);
}
