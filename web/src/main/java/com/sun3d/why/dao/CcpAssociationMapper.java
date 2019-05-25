package com.sun3d.why.dao;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.model.CcpAssociation;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

public interface CcpAssociationMapper {

	int queryAssociationCountByCondition(Map<String, Object> map);
	
	List<CcpAssociation> queryAssociationByCondition(Map<String, Object> map);
	
	int saveAssnApply(CcpAssociationApply ccpAssociationApply);

	//获取首页推荐社团
	@Select("SELECT ASSN_ID assnId,ASSN_NAME assnName,ASSN_IMG_URL assnImgUrl,ASSN_INTRODUCE assnIntroduce" +
			" FROM ccp_association ass WHERE  ass.ASSN_ID = #{id}")
    CcpAssociation queryAssociationFromIndex(@Param("id") String id);
	
	CcpAssociation queryAssnById(String assnId);
}