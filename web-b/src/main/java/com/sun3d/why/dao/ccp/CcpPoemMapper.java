package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.ccp.CcpPoem;

public interface CcpPoemMapper {
    int deleteByPrimaryKey(String poemId);

    int insert(CcpPoem record);

    CcpPoem selectByPrimaryKey(String poemId);

    int update(CcpPoem record);
    
    int queryPoemCountByCondition(Map<String, Object> map);
    
    List<CcpPoem> queryPoemByCondition(Map<String, Object> map);

}