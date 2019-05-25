package com.sun3d.why.service;

import com.sun3d.why.model.CmsAntiqueType;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/7/18.
 */
public interface CmsAntiqueTypeService {


    int deleteByPrimaryKey(String antiqueTypeId);

    int insert(CmsAntiqueType record);

    int addAntiqueType(CmsAntiqueType record);

    CmsAntiqueType queryById(String antiqueTypeId);

    int updateById(CmsAntiqueType record);

    int queryCount(Map<String,Object> params);

    List<CmsAntiqueType> queryByVenueId(CmsAntiqueType cmsAntiqueType,SysUser user);

    List<CmsAntiqueType> queryByConditions(CmsAntiqueType cmsAntiqueType,Pagination page,SysUser user);

    Integer addBatch(List<CmsAntiqueType> typeList);




    /**
     * app根据展馆id查询藏品类型
     * @param venueId
     * @return
     */
    List<CmsAntiqueType> queryAppAntiqueType(String venueId);

	List<String> queryAntiqueType();
}
