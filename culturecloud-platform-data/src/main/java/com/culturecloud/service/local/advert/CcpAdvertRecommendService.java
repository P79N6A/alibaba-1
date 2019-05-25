package com.culturecloud.service.local.advert;

import java.util.List;

import com.culturecloud.model.bean.advert.CcpAdvertRecommend;
import com.culturecloud.model.response.advert.CcpAdvertVO;

public interface CcpAdvertRecommendService {

	public List<CcpAdvertVO> queryAdvertRecommend(CcpAdvertRecommend advertRecommend);	
}
