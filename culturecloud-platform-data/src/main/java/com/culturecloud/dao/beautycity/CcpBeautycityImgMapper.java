package com.culturecloud.dao.beautycity;

import java.util.List;

import com.culturecloud.model.bean.beautycity.CcpBeautycityImg;
import com.culturecloud.model.request.beautycity.CcpBeautycityImgReqVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityImgResVO;

public interface CcpBeautycityImgMapper {
    int deleteByPrimaryKey(String beautycityImgId);

    int insert(CcpBeautycityImgReqVO record);

    CcpBeautycityImg selectByPrimaryKey(String beautycityImgId);

    int update(CcpBeautycityImgReqVO record);
    
    List<CcpBeautycityImgResVO> selectBeautycityImgList(CcpBeautycityImgReqVO request);
    
    int selectBeautycityImgListCount(CcpBeautycityImgReqVO request);
    
    List<CcpBeautycityImgResVO> selectBeautycityImgRankingList(CcpBeautycityImgReqVO request);
    
    /**
     * 根据投票数获取排名
     * @param userId
     * @return
     */
    int selectRankingByVoteCount(CcpBeautycityImgResVO request);
}