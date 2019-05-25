package com.sun3d.why.dao.train;

import com.sun3d.why.model.train.CmsTrainEnrolment;

public interface CmsTrainEnrolmentMapper {
    int deleteByPrimaryKey(String id);

    int insert(CmsTrainEnrolment record);

    int insertSelective(CmsTrainEnrolment record);

    CmsTrainEnrolment selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsTrainEnrolment record);

    int updateByPrimaryKey(CmsTrainEnrolment record);

    CmsTrainEnrolment selectAll();
}