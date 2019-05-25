package com.sun3d.why.dao;

import com.sun3d.why.model.CmsAntiqueType;

import java.util.List;
import java.util.Map;

public interface CmsAntiqueTypeMapper {


/*    int countByExample(CmsAntinueTypeExample example);

    int deleteByExample(CmsAntinueTypeExample example);

    List<CmsAntinueType> selectByExample(CmsAntinueTypeExample example);*/

    int deleteByPrimaryKey(String antiqueTypeId);

    int insert(CmsAntiqueType record);

    int addAntiqueType(CmsAntiqueType record);

    CmsAntiqueType queryById(String antiqueTypeId);

    int updateByPrimaryKey(CmsAntiqueType record);

    int updateById(CmsAntiqueType record);

    int queryCount(Map<String,Object> params);

    List<CmsAntiqueType> queryByVenueId(Map<String,Object> params);

    List<CmsAntiqueType> queryByConditions(Map<String,Object> params);

    Integer addBatch(List<CmsAntiqueType> typeList);



    List<CmsAntiqueType> queryAppAntiqueType(Map<String, Object> map);

	List<String> queryAntiqueType();

	CmsAntiqueType queryAntiqueTypeByName(String antiqueTypeName);
}