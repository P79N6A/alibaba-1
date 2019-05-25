package com.sun3d.why.dao.train;

import com.sun3d.why.model.train.CmsTrain;
import com.sun3d.why.model.train.CmsTrainOrder;
import com.sun3d.why.model.train.CmsTrainOrderBean;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface CmsTrainOrderMapper {
    int deleteByPrimaryKey(String id);

    int insert(CmsTrainOrder record);

    int insertSelective(CmsTrainOrder record);

    CmsTrainOrder selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsTrainOrder record);

    int updateByPrimaryKey(CmsTrainOrder record);

    int queryTrainOrderListCount(Map<String, Object> map);

    List<CmsTrainOrderBean> queryTrainOrderList(Map<String, Object> map);

    List<CmsTrainOrderBean> queryTrainOrderListByTrain(@Param("train") CmsTrain train);

    List<CmsTrainOrderBean> selectAllOrder();
}