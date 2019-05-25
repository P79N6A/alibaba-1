package com.sun3d.why.service.impl;

import java.text.SimpleDateFormat;
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
import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.dao.SquareWhiterMapper;
import com.sun3d.why.dao.ccp.CcpWalkImgMapper;
import com.sun3d.why.dao.ccp.CcpWalkUserMapper;
import com.sun3d.why.dao.ccp.CcpWalkVoteMapper;
import com.sun3d.why.dao.dto.CmsCulturalSquareDto;
import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.model.SquareWhiter;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.ccp.CcpWalkImg;
import com.sun3d.why.model.ccp.CcpWalkUser;
import com.sun3d.why.model.ccp.CcpWalkVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpWalkImgService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;

@Service
@Transactional
public class CcpWalkImgServiceImpl implements CcpWalkImgService{
    
    @Resource
    private CcpWalkImgMapper ccpWalkImgMapper;
    @Resource
    private CcpWalkUserMapper ccpWalkUserMapper;
    @Resource
    private CcpWalkVoteMapper ccpWalkVoteMapper;
    @Autowired
    private CmsTerminalUserService terminalUserService;
    @Autowired
    private SquareWhiterMapper squareWhiterMapper;
    @Autowired
    private CmsCulturalSquareMapper cmsCulturalSquareMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    
    
	@Override
	public List<CcpWalkImg> queryWalkImgList(CcpWalkImg vo) {
		List<CcpWalkImg> list = ccpWalkImgMapper.selectWalkImgList(vo);
		//本人最高排名
		if(vo.getIsMe() == 1 && vo.getIsVoteSort() == 1){
			if(list.size()>0){
				int ranking = ccpWalkUserMapper.selectRankingByVoteCount(list.get(0).getVoteCount(), list.get(0).getCreateTime());
				list.get(0).setRanking(ranking);
			}
		}
		return list;
	}
	
	@Override
	public List<CcpWalkImg> querySelectWalkImgList(CcpWalkImg vo) {
		List<CcpWalkImg> list = new ArrayList<CcpWalkImg>();
		if(vo.getWalkImgIds()!=null){
			for(String walkImgId:vo.getWalkImgIds().split(",")){
				CcpWalkImg walkImgDto = new CcpWalkImg();
				walkImgDto.setWalkImgId(walkImgId);
				walkImgDto.setWalkStatus(vo.getWalkStatus());
				walkImgDto.setUserId(vo.getUserId());
				list.add(ccpWalkImgMapper.selectWalkImgList(walkImgDto).get(0));
			}
		}
		return list;
	}
	
	@Override
	public List<CcpWalkUser> queryWalkUserRanking() {
		return ccpWalkUserMapper.queryWalkUserRanking();
	}

	@Override
	public String addWalkVote(CcpWalkVote vo) {
		int todayVoteCount = ccpWalkVoteMapper.queryTodayVoteCount(vo);
		if(todayVoteCount>0){
			return "repeat";
		}
		
		CcpWalkImg walkImgDto = ccpWalkImgMapper.selectByPrimaryKey(vo.getWalkImgId());
		
		if(walkImgDto.getWalkStatus() != 1){
			return "noPass";
		}
		
		vo.setWalkVoteId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = ccpWalkVoteMapper.insert(vo);
		if (count > 0) {
			//重新计算被投票用户的最高单作品投票
			String userId = walkImgDto.getUserId();
			walkImgDto = new CcpWalkImg();
			walkImgDto.setUserId(userId);
			walkImgDto.setIsMe(1);
			walkImgDto.setIsVoteSort(1);
			List<CcpWalkImg> list = ccpWalkImgMapper.selectWalkImgList(walkImgDto);
			if(list.size()>0){
				CcpWalkUser walkUserDto = new CcpWalkUser();
				walkUserDto.setUserId(userId);
				walkUserDto.setUserMaxVote(list.get(0).getVoteCount());
				walkUserDto.setUserMaxImg(list.get(0).getWalkImgId());
				ccpWalkUserMapper.update(walkUserDto);
			}
			return "200";
		}else{
			return "500";
		}
	}
	
	@Override
	public String addWalkImg(CcpWalkImg vo) {
		try {
			CcpWalkImg walkImgDto = new CcpWalkImg();
			walkImgDto.setUserId(vo.getUserId());
			walkImgDto.setIsMe(1);
			List<CcpWalkImg> walkImgList = ccpWalkImgMapper.selectWalkImgList(walkImgDto);
			
			if(walkImgList.size() == 0){
				//添加积分
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralChange(600);
				userIntegralDetail.setChangeType(0);
				userIntegralDetail.setIntegralFrom("行走故事首次参与");
				userIntegralDetail.setIntegralType(IntegralTypeEnum.WALK_USER.getIndex());
				userIntegralDetail.setUserId(vo.getUserId());
				userIntegralDetail.setUpdateType(1);
				HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			}
			
			vo.setWalkImgId(UUIDUtils.createUUId());
			vo.setCreateTime(new Date());
			//白名单审核直接通过
			List<SquareWhiter> squareWhiterList = squareWhiterMapper.selectSquareWhiterList(new SquareWhiter(vo.getUserId(),"1"));
			if(squareWhiterList.size()>0){
				vo.setWalkStatus(1);
			}
			int count = ccpWalkImgMapper.insert(vo);
			if (count > 0) {
				//白名单直接进广场
				if(squareWhiterList.size()>0){
					CmsCulturalSquareDto cmsCulturalSquare = new CmsCulturalSquareDto();
					cmsCulturalSquare.setSquareId(UUIDUtils.createUUId());
					cmsCulturalSquare.setHeadUrl(ccpWalkImgMapper.selectWalkImgList(new CcpWalkImg(vo.getWalkImgId())).get(0).getUserHeadImgUrl());
					cmsCulturalSquare.setUserName(ccpWalkImgMapper.selectWalkImgList(new CcpWalkImg(vo.getWalkImgId())).get(0).getUserName());
					cmsCulturalSquare.setContextDec("参与了一个<span style='color: #c49123;font-size: 24px;'># 活动 #</span>");
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					cmsCulturalSquare.setPublishTime(df.format(vo.getCreateTime()));
					cmsCulturalSquare.setOutId(vo.getWalkImgId());
					cmsCulturalSquare.setType(2);
					cmsCulturalSquare.setExt0(vo.getWalkImgUrl());
					cmsCulturalSquare.setExt1(vo.getWalkImgName());
					cmsCulturalSquare.setExt2("4");
					cmsCulturalSquareMapper.insert(cmsCulturalSquare);
				}
				
				if(walkImgList.size() == 0){
					return "100";
				}else{
					return "200";
				}
			}else{
				return "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "500";
		}
	}

	@Override
	public String addWalkUser(CcpWalkUser vo) {
		JSONObject json=new JSONObject();
		json.put("userId", vo.getUserId());
		json.put("userNickName", vo.getUserName());
		json.put("userTelephone", vo.getUserMobile());
		HttpClientConnection.post(staticServer.getChinaServerUrl() + "wechatUser/editTerminalUserByJson.do", json);
		
		vo.setCreateTime(new Date());
		int count = ccpWalkUserMapper.insert(vo);
		if (count > 0) {
			return "200";
		}else{
			return "500";
		}
	}
	
	@Override
	public CcpWalkUser queryWalkUser(String userId) {
		return ccpWalkUserMapper.selectByPrimaryKey(userId);
	}

}
