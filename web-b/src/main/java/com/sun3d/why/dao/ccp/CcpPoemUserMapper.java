package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.ccp.CcpPoemUser;

public interface CcpPoemUserMapper {
    int insert(CcpPoemUser record);

    int queryPoemUserCountByCondition(Map<String, Object> map);
    
    List<CcpPoemUser> queryPoemUserByCondition(Map<String, Object> map);
}