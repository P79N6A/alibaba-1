package com.culturecloud.dao.beautycity;

import java.util.List;

import com.culturecloud.model.bean.beautycity.CcpBeautycity;
import com.culturecloud.model.request.beautycity.CcpBeautycityReqVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityResVO;

public interface CcpBeautycityMapper {
    int deleteByPrimaryKey(String beautycityId);

    int insert(CcpBeautycityReqVO record);

    CcpBeautycity selectByPrimaryKey(String beautycityId);

    int update(CcpBeautycityReqVO record);
    
    List<CcpBeautycityResVO> selectBeautycityList(CcpBeautycityReqVO request);
    
    int selectBeautycityListCount(CcpBeautycityReqVO request);
    
    int selectMaxFinishVenueRanking();
}