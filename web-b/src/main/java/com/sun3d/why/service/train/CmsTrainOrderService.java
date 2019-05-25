package com.sun3d.why.service.train;

import com.sun3d.why.model.train.CmsTrainOrder;

/**
 * Created by ct on 16/9/27.
 */
public interface CmsTrainOrderService
{
    int deleteByPrimaryKey(String id);

    int insert(CmsTrainOrder record);

    int insertSelective(CmsTrainOrder record);

    CmsTrainOrder selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsTrainOrder record);

    int updateByPrimaryKey(CmsTrainOrder record);
}
