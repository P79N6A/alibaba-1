package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.model.CcpAssociationRecruitApply;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.model.CcpAssociationRes;
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
	 * 社团申请列表
	 * @param ccpAssociation
	 * @param page
	 * @return
	 */
	List<CcpAssociation> queryAssociationApplyByCondition(CcpAssociation ccpAssociation, Pagination page);
	
	/**
	 * 申请社团
	 * @param ccpAssociationApply
	 * @return
	 */
	boolean saveAssnApply(CcpAssociationApply ccpAssociationApply);
	
	/**
	 * 根据ID查社团信息
	 * @param assnId
	 * @return
	 */
	CcpAssociation queryAssnByPrimaryKey(String assnId);
	
	/**
	 * 保存或更新社团
	 * @param ccpAssociation
	 * @return
	 */
	String saveOrUpdateAssn(CcpAssociation ccpAssociation);
	
	/**
	 * 删除社团
	 * @param assnId
	 * @return
	 */
	String deleteAssn(String assnId);
	
	/**
	 * 查询社团资源
	 * @param assnId
	 * @return
	 */
	List<CcpAssociationRes> queryAssnResByAssnId(String assnId);

    List<CcpAssociationRecruitApply> queryRecruitApplyByCondition(CcpAssociationRecruitApply recruitApply, Pagination page);

	List<CcpAssociation> selectAllAssn();
}
