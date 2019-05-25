package com.culturecloud.service.local.impl.advert;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.dao.advert.CcpAdvertRecommendMapper;
import com.culturecloud.dao.dto.advert.CcpAdvertRecommendDto;
import com.culturecloud.kafka.PpsConfig;
import com.culturecloud.model.bean.advert.CcpAdvertRecommend;
import com.culturecloud.model.response.advert.CcpAdvertVO;
import com.culturecloud.service.local.advert.CcpAdvertRecommendService;

@Service
public class CcpAdvertRecommendServiceImpl implements CcpAdvertRecommendService {
	
	@Resource
	private CcpAdvertRecommendMapper ccpAdvertRecommendMapper;

	private static String staticServerUrl=PpsConfig.getString("staticServerUrl");
	
	@Override
	public List<CcpAdvertVO> queryAdvertRecommend(CcpAdvertRecommend advertRecommend) {
		
		List<CcpAdvertRecommendDto> advertList=ccpAdvertRecommendMapper.queryAdvertRecommend(advertRecommend);
		
		 List<CcpAdvertVO> list=new ArrayList<CcpAdvertVO>();
		
		for (CcpAdvertRecommendDto ccpAdvertRecommendDto : advertList) {
			
			CcpAdvertVO vo=new CcpAdvertVO(ccpAdvertRecommendDto);
			
			String advertImgUrl=vo.getAdvertImgUrl();
			
			if(StringUtils.isNotBlank(advertImgUrl))
			{
				advertImgUrl=staticServerUrl+advertImgUrl;
				vo.setAdvertImgUrl(advertImgUrl);
			}
			
			list.add(vo);
		}
		
		return list;
	}

}
