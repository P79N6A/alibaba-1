package com.sun3d.why.dao;


import com.sun3d.why.model.ccp.CcpAdvertRecommend;

import java.util.List;

public interface CcpAdvertRecommendMapper {

    int insertAdvert(CcpAdvertRecommend record);

    int updateAdvert(CcpAdvertRecommend record);

    int deleteAdvertByModel(CcpAdvertRecommend record);

    List<CcpAdvertRecommend> selectAdvertByModel(CcpAdvertRecommend record);
}