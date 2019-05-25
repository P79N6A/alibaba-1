package com.sun3d.why.dao.train;

import com.sun3d.why.model.train.CmsTrainField;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CmsTrainFieldMapper {
    int deleteByPrimaryKey(String id);

    int insert(CmsTrainField record);

    int insertSelective(CmsTrainField record);

    CmsTrainField selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsTrainField record);

    int updateByPrimaryKey(CmsTrainField record);

    void deleteByTrainId(String trainId);

    void insertTrainTimes(List<CmsTrainField> list);

    List<CmsTrainField> queryTrainFieldListByTrainId(@Param("trainId") String trainId);
}