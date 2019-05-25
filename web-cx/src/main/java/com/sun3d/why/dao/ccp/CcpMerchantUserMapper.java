package com.sun3d.why.dao.ccp;

import java.util.List;

import com.sun3d.why.model.ccp.CcpMerchantUser;

public interface CcpMerchantUserMapper {
    int deleteByPrimaryKey(String merchantUserId);

    int insert(CcpMerchantUser record);

    CcpMerchantUser selectByPrimaryKey(String merchantUserId);

    int update(CcpMerchantUser record);
    
    List<CcpMerchantUser> queryMerchantUserByCondition(CcpMerchantUser record);

}