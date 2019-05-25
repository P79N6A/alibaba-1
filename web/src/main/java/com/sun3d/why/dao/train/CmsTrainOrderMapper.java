package com.sun3d.why.dao.train;

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

    //查询用户未结束单场培训订单数
    Integer selectUserOrderCountBySingle(@Param("userId") String userId);

    //按类型查询当年参加的培训订单数
    Integer selectUserOrderCountByMulti(@Param("userId") String userId, @Param("trainType") String trainType);

    CmsTrainOrder findOrderByUserId(String userId);

    List<CmsTrainOrderBean> queryCenterTrainOrderList(Map<String, Object> map);

    List<CmsTrainOrderBean> queryTrainOrderListByCreateUser(String userId);

    int queryCenterTrainOrderListCount(Map<String, Object> map);

    Integer queryUserSubCountByRegsitTime(Map<String,Object> regMap);
}