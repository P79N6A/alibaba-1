package com.sun3d.why.dao.train;

import com.sun3d.why.model.train.CmsTrain;
import com.sun3d.why.model.train.CmsTrainBean;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface CmsTrainMapper {
    int deleteByPrimaryKey(String id);

    int insert(CmsTrain record);

    int insertSelective(CmsTrain record);

    CmsTrainBean selectByPrimaryKey(@Param("id") String id, @Param("userId") String userId);

    int updateByPrimaryKeySelective(CmsTrain record);

    int updateByPrimaryKey(CmsTrain record);

    int queryTrainListCount(Map<String, Object> map);

    List<CmsTrainBean> queryTrainList(Map<String, Object> map);

    Integer queryMinSubCountByRegsitTime(Map<String,Object> regMap);

    int queryTrainCount(Map<String, Object> map);

    List<CmsTrainBean> queryTrainList1();

    CmsTrainBean queryTrainById(String advertUrl);

    List<CmsTrainBean> pcnewVenue(Map map);

    int queryTrainListCount2(Map<String, Object> map);

    List<CmsTrainBean> queryTrainList2(Map<String, Object> map);
}