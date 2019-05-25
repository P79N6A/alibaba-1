package com.sun3d.why.dao.ccp;

import java.util.List;

import com.sun3d.why.model.ccp.CcpCityImg;

public interface CcpCityImgMapper {
    int deleteByPrimaryKey(String cityImgId);

    int insert(CcpCityImg record);

    CcpCityImg selectByPrimaryKey(String cityImgId);

    int update(CcpCityImg record);

    List<CcpCityImg> selectCityImgList(CcpCityImg record);
}