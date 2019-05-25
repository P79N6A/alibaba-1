package com.culturecloud.service.local.association;

import com.culturecloud.dao.dto.activity.CmsActivityDto;
import com.culturecloud.model.response.activity.CmsActivityVO;
import com.culturecloud.model.response.association.CcpAssociationDetailVO;
import com.culturecloud.model.response.association.CcpAssociationVO;

import java.util.List;
import java.util.Map;

public interface CcpAssociationService {

	/**
	 * 获取所有社团
	 * @return
	 */
	public List<CcpAssociationVO> getAllAssociation(Map<String, Object> map);

	/**
	 * 获取PC所有社团
	 * @return
	 */
	public List<CcpAssociationVO> getAllAssociationPc(Map<String, Object> map);

	/**
	 * 获取社团详情
	 *
	 * @param associationId
	 * @param userId
	 * @return
	 */
	public CcpAssociationDetailVO getAssociationDetail(String associationId, String userId);

	/**
	 * 获取社团进行中活动
	 *
	 * @param associationId
	 * @return
	 */
	public List<CmsActivityVO> getAssociationActivity(String associationId);


	/**
	 * 获取社团历史活动
	 *
	 * @param associationId
	 * @return
	 */
	public List<CmsActivityVO> getAssociationHistoryActivity(String associationId);

	/**
	 * 获取社团历史活动PC
	 *
	 * @param associationId
	 * @return
	 */
	public List<CmsActivityDto> getAssociationHistoryActivityPC(Map<String, Object> map);
	public int getAssociationHistoryActivityCount(Map<String, Object> param);
}
