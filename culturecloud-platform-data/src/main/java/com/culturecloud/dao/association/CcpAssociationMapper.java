package com.culturecloud.dao.association;

import com.culturecloud.dao.dto.assonciation.CcpAssociationDto;
import com.culturecloud.model.bean.association.CcpAssociation;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface CcpAssociationMapper {
	
	List<CcpAssociationDto> getAllAssociation(Map<String, Object> map);

	List<CcpAssociationDto> getAllAssociationPc(Map<String, Object> map);

	/**
	 * 查询社团详情
	 * @param associationId
	 * @return
	 */
	CcpAssociationDto getAssociationDetail(String associationId);

	/**
	 * 查询粉丝数
	 * @param association
	 * @return
	 */
	Integer countAssociationFans(String associationId);

	/**
	 * 查询 用户在某团体下是否有关注
	 *
	 * @param associationMember
	 * @return
	 */
	Integer queryUserFollowAssociation(@Param("associationId") String associationId, @Param("userId") String userId);
	
	CcpAssociation selectByPrimaryKey(String assnId);

    int update(CcpAssociation record);
	
	int deleteByPrimaryKey(String assnId);

    int insert(CcpAssociation record);

	int getAllAssociationCount(Map<String, Object> param);
}