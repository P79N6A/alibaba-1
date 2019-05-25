package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.ccp.CcpCityImgMapper;
import com.sun3d.why.dao.ccp.CcpCityUserMapper;
import com.sun3d.why.dao.ccp.CcpCityVoteMapper;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpCityImg;
import com.sun3d.why.model.ccp.CcpCityUser;
import com.sun3d.why.model.ccp.CcpCityVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpCityImgService;
import com.sun3d.why.service.CmsTerminalUserService;
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
    private CmsTerminalUserService terminalUserService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    
    
	@Override
	public List<CcpCityImg> queryCityImgList(CcpCityImg vo) {
		List<CcpCityImg> list = ccpCityImgMapper.selectCityImgList(vo);
		//本人最高排名
		if(vo.getIsMe() == 1 && vo.getIsVoteSort() == 1){
			if(list.size()>0){
				int ranking = ccpCityUserMapper.selectRankingByVoteCount(list.get(0).getVoteCount(), list.get(0).getCreateTime(), list.get(0).getCityType());
				list.get(0).setRanking(ranking);
			}
		}
		return list;
	}
	
	@Override
	public List<CcpCityImg> querySelectCityImgList(CcpCityImg vo) {
		List<CcpCityImg> list = new ArrayList<CcpCityImg>();
		if(vo.getCityImgIds()!=null){
			for(String cityImgId:vo.getCityImgIds().split(",")){
				CcpCityImg cityImgDto = new CcpCityImg();
				cityImgDto.setCityImgId(cityImgId);
				cityImgDto.setCityType(vo.getCityType());
				cityImgDto.setCityStatus(vo.getCityStatus());
				cityImgDto.setUserId(vo.getUserId());
				list.add(ccpCityImgMapper.selectCityImgList(cityImgDto).get(0));
			}
		}
		return list;
	}
	
	@Override
	public List<CcpCityUser> queryCityUserRanking(Integer cityType) {
		return ccpCityUserMapper.queryCityUserRanking(cityType);
	}

	@Override
	public String addCityVote(CcpCityVote vo) {
		int todayVoteCount = ccpCityVoteMapper.queryTodayVoteCount(vo);
		if(todayVoteCount>0){
			return "repeat";
		}
		
		//添加积分
		CcpCityImg cityImgDto = ccpCityImgMapper.selectByPrimaryKey(vo.getCityImgId());
		
		UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
		userIntegralDetail.setIntegralChange(5);
		userIntegralDetail.setChangeType(0);
		userIntegralDetail.setIntegralFrom("城市名片作品被投票:"+vo.getCityImgId());
		userIntegralDetail.setIntegralType(IntegralTypeEnum.CITY_VOTE.getIndex());
		userIntegralDetail.setUserId(cityImgDto.getUserId());
		userIntegralDetail.setUpdateType(0);
		HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
		JSONObject jsonObject = JSON.parseObject(res.getData());
		String status = jsonObject.get("status").toString();
		if(!status.equals("200")){
			return "500";
		}
		
		vo.setCityVoteId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = ccpCityVoteMapper.insert(vo);
		if (count > 0) {
			//重新计算被投票用户的最高单作品投票
			String userId = cityImgDto.getUserId();
			cityImgDto = new CcpCityImg();
			cityImgDto.setUserId(userId);
			cityImgDto.setIsMe(1);
			cityImgDto.setIsVoteSort(1);
			cityImgDto.setCityType(vo.getCityType());
			List<CcpCityImg> list = ccpCityImgMapper.selectCityImgList(cityImgDto);
			if(list.size()>0){
				CcpCityUser cityUserDto = new CcpCityUser();
				cityUserDto.setUserId(userId);
				cityUserDto.setUserMaxVote(list.get(0).getVoteCount());
				cityUserDto.setUserMaxImg(list.get(0).getCityImgId());
				ccpCityUserMapper.update(cityUserDto);
			}
			return "200";
		}else{
			return "500";
		}
	}
	
	@Override
	public String addCityImg(CcpCityImg vo) {
		//添加积分
		CcpCityImg cityImgDto = new CcpCityImg();
		cityImgDto.setUserId(vo.getUserId());
		cityImgDto.setCityType(vo.getCityType());
		cityImgDto.setIsMe(1);
		List<CcpCityImg> cityImgList = ccpCityImgMapper.selectCityImgList(cityImgDto);
		int cityImgCount = 0;
		for(CcpCityImg ccpCityImg : cityImgList){
			cityImgCount += ccpCityImg.getCityImgUrl().split(";").length;
		}
		if(cityImgCount==0){
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralChange(500);
			userIntegralDetail.setChangeType(0);
			userIntegralDetail.setIntegralFrom("城市名片首次参与:"+vo.getCityType());
			userIntegralDetail.setIntegralType(IntegralTypeEnum.CITY_USER.getIndex());
			userIntegralDetail.setUserId(vo.getUserId());
			userIntegralDetail.setUpdateType(1);
			HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			JSONObject jsonObject = JSON.parseObject(res.getData());
			String status = jsonObject.get("status").toString();
			if(!status.equals("200")){
				return "500";
			}else{
				if(vo.getCityImgUrl().split(";").length==9){
					userIntegralDetail = new UserIntegralDetail();
					userIntegralDetail.setIntegralChange(200);
					userIntegralDetail.setChangeType(0);
					userIntegralDetail.setIntegralFrom("城市名片发布超过9张照片:"+vo.getCityType());
					userIntegralDetail.setIntegralType(IntegralTypeEnum.CITY_IMG.getIndex());
					userIntegralDetail.setUserId(vo.getUserId());
					userIntegralDetail.setUpdateType(1);
					res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
					jsonObject = JSON.parseObject(res.getData());
					status = jsonObject.get("status").toString();
					if(!status.equals("200")){
						return "500";
					}
				}
			}
		}else if(cityImgCount<=8 && cityImgCount+vo.getCityImgUrl().split(";").length>=9){
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralChange(200);
			userIntegralDetail.setChangeType(0);
			userIntegralDetail.setIntegralFrom("城市名片发布超过9张照片:"+vo.getCityType());
			userIntegralDetail.setIntegralType(IntegralTypeEnum.CITY_IMG.getIndex());
			userIntegralDetail.setUserId(vo.getUserId());
			userIntegralDetail.setUpdateType(1);
			HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			JSONObject jsonObject = JSON.parseObject(res.getData());
			String status = jsonObject.get("status").toString();
			if(!status.equals("200")){
				return "500";
			}
		}
		
		vo.setCityImgId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = ccpCityImgMapper.insert(vo);
		if (count > 0) {
			if(cityImgCount==0){
				if(vo.getCityImgUrl().split(";").length==9){
					return "2";
				}else{
					return "1";
				}
			}else if(cityImgCount<=8 && cityImgCount+vo.getCityImgUrl().split(";").length>=9){
				return "10";
			}else{
				return "200";
			}
		}else{
			return "500";
		}
	}

	@Override
	public String addCityUser(CcpCityUser vo) {
		JSONObject json=new JSONObject();
		json.put("userId", vo.getUserId());
		json.put("userNickName", vo.getUserName());
		json.put("userTelephone", vo.getUserMobile());
		HttpClientConnection.post(staticServer.getChinaServerUrl() + "wechatUser/editTerminalUserByJson.do", json);
		
		vo.setCreateTime(new Date());
		int count = ccpCityUserMapper.insert(vo);
		if (count > 0) {
			return "200";
		}else{
			return "500";
		}
	}
	
	@Override
	public CcpCityUser queryCityUser(String userId) {
		return ccpCityUserMapper.selectByPrimaryKey(userId);
	}

}
