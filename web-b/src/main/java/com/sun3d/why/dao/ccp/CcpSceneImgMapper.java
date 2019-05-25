package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.ccp.CcpSceneImg;

public interface CcpSceneImgMapper {
    int deleteByPrimaryKey(String sceneImgId);

    int insert(CcpSceneImg record);

    CcpSceneImg selectByPrimaryKey(String sceneImgId);

    int update(CcpSceneImg record);

    List<CcpSceneImg> selectSceneImgList(CcpSceneImg record);
    
    int querySceneImgCountByCondition(Map<String, Object> map);
    
    List<CcpSceneImg> querySceneImgByCondition(Map<String, Object> map);
}