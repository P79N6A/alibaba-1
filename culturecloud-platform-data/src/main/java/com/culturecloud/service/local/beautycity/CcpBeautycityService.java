package com.culturecloud.service.local.beautycity;

import java.util.List;

import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityImgReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityVenueReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityVoteReqVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityImgResVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityResVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityVenueResVO;


public interface CcpBeautycityService {

	BasePageResultListVO<CcpBeautycityImgResVO> getBeautycityImgList(CcpBeautycityImgReqVO request);
	
	List<CcpBeautycityImgResVO> getBeautycityImgRankingList(CcpBeautycityImgReqVO request);
	
	void saveBeautycity(CcpBeautycityReqVO request);
	
	void saveBeautycityImg(CcpBeautycityImgReqVO request);
	
	void voteBeautycityImg(CcpBeautycityVoteReqVO request);
	
	List<CcpBeautycityVenueResVO> getBeautycityVenueList(CcpBeautycityVenueReqVO request);
	
	BasePageResultListVO<CcpBeautycityResVO> getBeautycityList(CcpBeautycityReqVO request);
	
	void deleteBeautycityImg(CcpBeautycityImgReqVO request);
}
