package com.sun3d.why.dao.ccp;

import java.util.List;

import com.sun3d.why.model.ccp.CcpWalkImg;

public interface CcpWalkImgMapper {
    int deleteByPrimaryKey(String walkImgId);

    int insert(CcpWalkImg record);

    CcpWalkImg selectByPrimaryKey(String walkImgId);

    int update(CcpWalkImg record);

    List<CcpWalkImg> selectWalkImgList(CcpWalkImg record);
}