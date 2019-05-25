package com.culturecloud.dao.heritage;

import com.culturecloud.model.bean.heritage.CcpHeritageImg;

public interface CcpHeritageImgMapper {
	
    int deleteByPrimaryKey(String heritageImgId);
    
    int deleteByHerigateId(String heritageId);

    int insert(CcpHeritageImg record);

    CcpHeritageImg selectByPrimaryKey(String heritageImgId);

    int update(CcpHeritageImg record);
}