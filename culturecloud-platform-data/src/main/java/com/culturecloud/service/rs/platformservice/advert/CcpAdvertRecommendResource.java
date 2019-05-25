package com.culturecloud.service.rs.platformservice.advert;

import java.util.List;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.bean.advert.CcpAdvertRecommend;
import com.culturecloud.model.request.advert.GetAdvertVO;
import com.culturecloud.model.response.advert.CcpAdvertVO;
import com.culturecloud.service.local.advert.CcpAdvertRecommendService;

@Component
@Path("/advertRecommend")
public class CcpAdvertRecommendResource {

	@Autowired
	private CcpAdvertRecommendService advertRecommendService;
	
	
	
	@POST
	@Path("/pageAdvertRecommend")
	@SysBusinessLog(remark="加载页面运营位")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpAdvertVO> pageAdvertRecommend(GetAdvertVO request){
		
	
		
		 Integer advertPostion=request.getAdvertPostion();

	     String advertType=request.getAdvertType();

	     Integer advertSort=request.getAdvertSort();
	     
	     CcpAdvertRecommend model=new CcpAdvertRecommend();
	     model.setAdvertPostion(advertPostion);
	     model.setAdvertType(advertType);
	     model.setAdvertSort(advertSort);
	     
	     List<CcpAdvertVO> list= advertRecommendService.queryAdvertRecommend(model);
	     
		
		return list;
	}
}
