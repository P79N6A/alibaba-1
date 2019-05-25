package com.sun3d.why.dao;

import com.sun3d.why.model.CmsCollect;

import java.util.List;
import java.util.Map;

public interface CmsCollectMapper {
//    int countByExample(CmsCollectExample example);
//
//    int deleteByExample(CmsCollectExample example);

    int insert(CmsCollect record);

    int insertSelective(CmsCollect record);

     List<CmsCollect> queryByCmsCollect(CmsCollect record);

    int queryCountByCmsCollect(CmsCollect record);

//    int updateByExampleSelective(@Param("record") CmsCollect record, @Param("example") CmsCollectExample example);
//
//    int updateByExample(@Param("record") CmsCollect record, @Param("example") CmsCollectExample example);

	int checkCollect(CmsCollect cmsCollect);

    /**
     * 前端2.0 删除收藏
     * @param collect
     * @return
     */
	int deleteCollectByCondition(CmsCollect collect);

    public int getHotNum(CmsCollect cmsCollect);

    public int isHadCollect(Map map);

    /**
     * app添加收藏
     * @param map
     * @return
     */
     public int insertCollect(Map<String, Object> map);

    /**
     * app删除用户收藏
     * @param map
     * @return
     */
    public int deleteUserCollectByCondition(Map<String, Object> map);
}