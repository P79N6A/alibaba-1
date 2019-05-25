package com.sun3d.why.dao.train;

import com.sun3d.why.model.train.CmsTrain;
import com.sun3d.why.model.train.CmsTrainBean;

import java.util.List;
import java.util.Map;

public interface CmsTrainMapper {
    int deleteByPrimaryKey(String id);

    int insert(CmsTrain record);

    int insertSelective(CmsTrain record);

    CmsTrainBean selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsTrain record);

    int updateByPrimaryKey(CmsTrain record);

    int queryTrainListCount(Map<String, Object> map);

    List<CmsTrainBean> queryTrainList(Map<String, Object> map);

    List<CmsTrainBean> queryTrainListPc(Map<String, Object> map);

    int queryTrainListCountPc(Map<String, Object> map);
}