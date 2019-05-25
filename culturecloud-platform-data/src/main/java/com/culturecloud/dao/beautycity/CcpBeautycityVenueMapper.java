package com.culturecloud.dao.beautycity;

import java.util.List;

import com.culturecloud.model.bean.beautycity.CcpBeautycityVenue;
import com.culturecloud.model.request.beautycity.CcpBeautycityVenueReqVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityVenueResVO;

public interface CcpBeautycityVenueMapper {
    int deleteByPrimaryKey(String beautycityVenueId);

    int insert(CcpBeautycityVenueReqVO record);

    CcpBeautycityVenue selectByPrimaryKey(String beautycityVenueId);

    int update(CcpBeautycityVenueReqVO record);
    
    List<CcpBeautycityVenueResVO> selectBeautycityVenueList(CcpBeautycityVenueReqVO request);

}