package com.sun3d.why.dao.region.cd;

import java.util.List;
import java.util.Map;

import com.sun3d.why.region.cd.model.CdTrainingSign;

public interface CdTrainingSignMapper {
    int deleteByPrimaryKey(String signId);

    int insert(CdTrainingSign record);

    CdTrainingSign selectByPrimaryKey(String signId);

    int update(CdTrainingSign record);
    
    List<CdTrainingSign> queryTrainingSignList(Map<String,Object> map);

}