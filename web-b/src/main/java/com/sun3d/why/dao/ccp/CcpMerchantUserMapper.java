package com.sun3d.why.dao.ccp;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.ccp.CcpMerchantUser;

public interface CcpMerchantUserMapper {
    int deleteByPrimaryKey(String merchantUserId);

    int insert(CcpMerchantUser record);

    CcpMerchantUser selectByPrimaryKey(String merchantUserId);

    int update(CcpMerchantUser record);
    
    int queryMerchantUserCountByCondition(Map<String, Object> map);
    
    List<CcpMerchantUser> queryMerchantUserByCondition(Map<String, Object> map);

}