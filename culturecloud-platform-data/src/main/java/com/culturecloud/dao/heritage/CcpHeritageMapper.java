package com.culturecloud.dao.heritage;

import java.util.List;

import com.culturecloud.model.bean.heritage.CcpHeritage;
import com.culturecloud.model.request.heritage.CcpHeritageReqVO;
import com.culturecloud.model.response.heritage.CcpHeritageResVO;

public interface CcpHeritageMapper {
	
    int deleteByPrimaryKey(String heritageId);

    int insert(CcpHeritageReqVO record);

    CcpHeritage selectByPrimaryKey(String heritageId);

    int update(CcpHeritageReqVO record);

    List<CcpHeritageResVO> selectCcpHeritageList(CcpHeritageReqVO request);
    
    CcpHeritageResVO selectCcpHeritageById(CcpHeritageReqVO request);
    
    /**
     * 用户后台编辑，未关联查出相关name
     * @param request
     * @return
     */
    CcpHeritageResVO selectHeritageById(CcpHeritageReqVO request);
}