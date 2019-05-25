package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.dao.ccp.CcpCityImgMapper;
import com.sun3d.why.dao.ccp.CcpCityUserMapper;
import com.sun3d.why.dao.ccp.CcpCityVoteMapper;
import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpCityImg;
import com.sun3d.why.model.ccp.CcpCityUser;
import com.sun3d.why.model.ccp.CcpCityVote;
import com.sun3d.why.model.ccp.CcpSceneImg;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpCityImgService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Service
@Transactional
public class CcpCityImgServiceImpl implements CcpCityImgService{
    
    @Resource
    private CcpCityImgMapper ccpCityImgMapper;
    @Resource
    private CcpCityUserMapper ccpCityUserMapper;
    @Resource
    private CcpCityVoteMapper ccpCityVoteMapper;
    @Autowired
	private CmsCulturalSquareMapper cmsCulturalSquareMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    
    
    @Override
	public List<CcpCityImg> queryCityImgByCondition(CcpCityImg ccpCityImg, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (ccpCityImg.getCityType()!=null) {
			map.put("cityType", ccpCityImg.getCityType());
		}
		if (StringUtils.isNotBlank(ccpCityImg.getCityImgId())) {
			map.put("cityImgId", ccpCityImg.getCityImgId());
		}
		if (StringUtils.isNotBlank(ccpCityImg.getUserName())) {
			map.put("userName", "%"+ccpCityImg.getUserName()+"%");
		}
		if (StringUtils.isNotBlank(ccpCityImg.getCityImgContent())) {
			map.put("cityImgContent", "%"+ccpCityImg.getCityImgContent()+"%");
		}
		if (StringUtils.isNotBlank(ccpCityImg.getUserMobile())){
			map.put("userMobile", "%"+ccpCityImg.getUserMobile()+"%");
		}
		if (ccpCityImg.getCityStatus()!=null){
			map.put("cityStatus",ccpCityImg.getCityStatus());
		}
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpCityImgMapper.queryCityImgCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		return ccpCityImgMapper.queryCityImgByCondition(map);
	}


	@Override
	public String deleteCityImg(String cityImgId, String cityImgUrls) {
		CcpCityImg ccpCityImg = ccpCityImgMapper.selectByPrimaryKey(cityImgId);
		
		//计算删除前图片数
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cityType", ccpCityImg.getCityType());
		map.put("userId", ccpCityImg.getUserId());
		List<CcpCityImg> cityImgList = ccpCityImgMapper.queryCityImgByCondition(map);
		int oldCityImgCount = 0;
		for(CcpCityImg img : cityImgList){
			oldCityImgCount += img.getCityImgUrl().split(";").length;
		}
		
		int count = 0;
		if(cityImgUrls.equals("")){	//删除作品
			count = ccpCityImgMapper.deleteByPrimaryKey(cityImgId);
			//删除广场信息
        	cmsCulturalSquareMapper.deleteByOutId(cityImgId);
		}else{		//修改作品
			ccpCityImg.setCityImgUrl(cityImgUrls);
			count = ccpCityImgMapper.update(ccpCityImg);
			
			//修改广场信息
			Map<String, Object> culturalSquareMap=new HashMap<String, Object>();
			culturalSquareMap.put("outId", cityImgId);
			List<CmsCulturalSquare> CulturalSquareList = cmsCulturalSquareMapper.queryCulturalSquareByCondition(culturalSquareMap);
			if(CulturalSquareList.size()>0){
				CmsCulturalSquare cmsCulturalSquare = CulturalSquareList.get(0);
				cmsCulturalSquare.setExt0(cityImgUrls);
				cmsCulturalSquareMapper.update(cmsCulturalSquare);
			}
		}
		
		if (count > 0) {
			//扣除积分
			cityImgList = ccpCityImgMapper.queryCityImgByCondition(map);
			int cityImgCount = 0;
			for(CcpCityImg img : cityImgList){
				cityImgCount += img.getCityImgUrl().split(";").length;
			}
			if(cityImgCount==0){
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralChange(500);
				userIntegralDetail.setIntegralFrom("城市名片首次参与:"+ccpCityImg.getCityType());
				userIntegralDetail.setIntegralType(IntegralTypeEnum.CITY_USER.getIndex());
				userIntegralDetail.setUserId(ccpCityImg.getUserId());
				userIntegralDetail.setUpdateType(1);
				HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/deteleIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			}
			if(cityImgCount<9 && oldCityImgCount>=9){
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralChange(200);
				userIntegralDetail.setIntegralFrom("城市名片发布超过9张照片:"+ccpCityImg.getCityType());
				userIntegralDetail.setIntegralType(IntegralTypeEnum.CITY_IMG.getIndex());
				userIntegralDetail.setUserId(ccpCityImg.getUserId());
				userIntegralDetail.setUpdateType(1);
				HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/deteleIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			}
			
			if(cityImgUrls.equals("")){
				//删除投票
				CcpCityVote cityVoteDto = new CcpCityVote();
				cityVoteDto.setCityImgId(cityImgId);
				cityVoteDto.setCityType(ccpCityImg.getCityType());
				int count2 = ccpCityVoteMapper.deleteByCondition(cityVoteDto);
				if (count2 > 0) {
					UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
					userIntegralDetail.setIntegralChange(5*count2);
					userIntegralDetail.setIntegralFrom("城市名片作品被投票:"+ccpCityImg.getCityImgId());
					userIntegralDetail.setIntegralType(IntegralTypeEnum.CITY_VOTE.getIndex());
					userIntegralDetail.setUserId(ccpCityImg.getUserId());
					userIntegralDetail.setUpdateType(0);
					HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/deteleIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
				}
				
				//重新计算被投票用户的最高单作品投票
				CcpCityImg cityImgDto = new CcpCityImg();
				cityImgDto.setUserId(ccpCityImg.getUserId());
				cityImgDto.setIsMe(1);
				cityImgDto.setIsVoteSort(1);
				cityImgDto.setCityType(ccpCityImg.getCityType());
				List<CcpCityImg> list = ccpCityImgMapper.selectCityImgList(cityImgDto);
				if(list.size()>0){
					CcpCityUser cityUserDto = new CcpCityUser();
					cityUserDto.setUserId(ccpCityImg.getUserId());
					cityUserDto.setUserMaxVote(list.get(0).getVoteCount());
					cityUserDto.setUserMaxImg(list.get(0).getCityImgId());
					ccpCityUserMapper.update(cityUserDto);
				}else{
					//清空
					CcpCityUser cityUserDto = new CcpCityUser();
					cityUserDto.setUserId(ccpCityImg.getUserId());
					cityUserDto.setUserMaxVote(0);
					cityUserDto.setUserMaxImg("0");
					ccpCityUserMapper.update(cityUserDto);
				}
			}
			
			return "200";
		}else{
			return "500";
		}
	}


	@Override
	public CcpCityImg queryCityImgById(String id) {
		return ccpCityImgMapper.selectByPrimaryKey(id);
	}

	@Override
	public int update(CcpCityImg ccpCityImg) {
		return ccpCityImgMapper.update(ccpCityImg);
	}

}
