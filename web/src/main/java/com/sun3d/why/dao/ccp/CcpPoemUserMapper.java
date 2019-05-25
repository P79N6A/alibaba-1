package com.sun3d.why.dao.ccp;

import java.util.List;

import com.sun3d.why.model.ccp.CcpPoemUser;

public interface CcpPoemUserMapper {
    int insert(CcpPoemUser record);
    
    List<CcpPoemUser> selectPoemUserList(CcpPoemUser vo);

}